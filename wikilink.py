#!/usr/bin/env python
from json import dumps
from flask import Flask, g, Response, request, render_template
from flask_mail import Mail, Message
from flask_autodoc import Autodoc
from neo4j.v1 import GraphDatabase as neoGDB
from neo4j.v1 import basic_auth
from neo4jrestclient.client import GraphDatabase, Node

app = Flask(__name__, static_url_path='')
auto = Autodoc(app)

#neo4jrestclient
gdb = GraphDatabase("http://localhost:7474")

#neo4j.v1
#import os
#password = os.getenv("NEO4J_PASSWORD")
password = "<neo4j_password>" 
driver = neoGDB.driver('bolt://localhost',auth=basic_auth("<neo4j_user>", password))

#last_url = "HappenWillNot"
last_url_subcat = "HappenWillNot"
language_session = "en"

# add mail server config
#app.secret_key = 'YourSuperSecreteKey'

app.config['MAIL_SERVER'] = 'smtp.gmail.com'
app.config['MAIL_PORT'] = 465
app.config['MAIL_USE_SSL'] = True
app.config['MAIL_USERNAME'] = 'YourUser@NameHere'
app.config['MAIL_PASSWORD'] = 'yourMailPassword'

mail = Mail(app)

@auto.doc()
def get_db():
    if not hasattr(g, 'neo4j_db'):
        g.neo4j_db = driver.session()
    return g.neo4j_db

@app.teardown_appcontext
@auto.doc()
def close_db(error):
    if hasattr(g, 'neo4j_db'):
        g.neo4j_db.close()

#in your case it is 'static' directory.
@app.route("/")
@auto.doc()
def get_index():
	return render_template('index.html')

@app.errorhandler(404)
@auto.doc()
def page_not_found(e):
    return render_template('404.html'), 404	

#mail method
@app.route('/contact', methods=('GET', 'POST'))
@auto.doc()
def contact():
    if request.method == 'POST':
        if request.form['name'] is None or request.form['email'] is None or request.form['message'] is None:
#            return 'Please fill in all fields <p><a href="/contact">Try Again!!!</a></p>'
	         return render_template('contact.html')	
        else:
            msg = Message("Message from your visitor" + str(form.getvalue('name')),
                          sender= 'xxx@mail.com',
                          recipients=['xxx@mail.com', 'yyyy@mail.com'])						  
            msg.body = """
            From: %s <%s>,
			
            %s
            """ % (request.form['name'], request.form['email'], request.form['message'])
            mail.send(msg)
            return render_template('contact-ok.html')	
    else:
#    elif request.method == 'GET': #no need to test GET
         return render_template('contact.html')	

@app.route("/background")
@auto.doc()
def get_background():
    db = get_db()
    results = db.run("MATCH (c:Category)<-[:SUBCAT_OF]-(a:Category) "
             "RETURN c.catName as cTitle, collect(a.catName) as cSubTitles "
             "ORDER BY rand() "
             "LIMIT {limit}", {"limit": request.args.get("limit", 25)})	
    nodes = []
    rels = []
    i = 0
    for record in results:
        nodes.append({"title": record["cTitle"], "label": "wiki"})
        target = i
        i += 1
        for name in record["cSubTitles"]:
            category = {"title": name, "label": "category"}
            try:
                source = nodes.index(category)
            except ValueError:
                nodes.append(category)
                source = i
                i += 1
            rels.append({"source": source, "target": target})
    return Response(dumps({"nodes": nodes, "links": rels}),
                    mimetype="application/json")
					
@app.route("/search")
@auto.doc()
def get_search():
	return render_template('search.html')		
					
@app.route("/explore")
@auto.doc()
def get_explore():
    return render_template('explore.html')

@app.route("/graph")
@auto.doc()
def get_graph():
    return render_template('graph.html')	

@app.route("/explore-path")
@auto.doc()
def get_graph_search():
    return render_template('explore-path.html')	

@app.route("/tos")
@auto.doc()
def get_tos():
    return render_template('tos.html')	
	
@app.route("/explore-world", methods=('GET', 'POST'))
@auto.doc()
def explore_world():
    if request.method == 'POST':
        return render_template('explore.html')	
    else:
        try:
            q = str(request.args["q"])
            l = int(request.args["l"])
        except:
            q = ""
            l = 5

        if l is None: l = 10
        if l < 1: l = 10
        if l > 500: l = 500

        global language_session		
        q.replace(" ", ".*")
		
        db = get_db()
        results = db.run("MATCH (c:Category)<-[:SUBCAT_OF]-(a:Category) "
             "WHERE c.catName =~ {title} AND c.language = {lang} "
             "RETURN c.catName as cTitle, collect(a.catName) as cSubTitles "
             "ORDER BY rand() "
			 "LIMIT {limit}"				 
             "UNION MATCH (c2:Category)<-[:IN_CATEGORY]-(p:Page) WHERE p.pageTitle =~ {title} AND p.language = {lang} "
             "RETURN c2.catName as cTitle, collect(p.pageTitle) as cSubTitles "
             "ORDER BY rand() "
			 "LIMIT {limit} "			 
			 "UNION "
			 "MATCH (c3:Category)<-[:SUBCAT_OF]-(a:Category) WHERE c3.catName =~ {title} AND c3.language = {lang} "
			 "WITH a "
			 "MATCH (c4:Category{catName:a.catName})<-[:SUBCAT_OF]-(c5:Category) WHERE c4.language = {lang} "
			 "             RETURN c4.catName as cTitle, collect(c5.catName) as cSubTitles ORDER BY rand()  "
			 "			 LIMIT {limit} "
			 "UNION "
			 "MATCH (c3:Category)<-[:SUBCAT_OF]-(a:Category) WHERE c3.catName =~ {title} AND c3.language = {lang} "
			 "WITH a "
			 "MATCH (c4:Category)<-[:SUBCAT_OF]-(c5:Category{catName:a.catName}) WHERE c4.language = {lang} "
			 "             RETURN c4.catName as cTitle, collect(c5.catName) as cSubTitles ORDER BY rand()  "
			 "			 LIMIT {limit} "
			 "UNION "
			 "MATCH (c6:Category)<-[:SUBCAT_OF]-(b:Category) WHERE c6.catName =~ {title} AND c6.language = {lang} "
			 "WITH b MATCH (c7:Category{catName:b.catName})<-[:IN_CATEGORY]-(p2:Page) WHERE p2.language = {lang} "
             "RETURN c7.catName as cTitle, collect(p2.pageTitle) as cSubTitles "
             "ORDER BY rand() LIMIT {limit} ",
             {"title": "(?i).*" + q + ".*", "lang": language_session, "limit": l})	

        nodes = []
        rels = []
        i = 0
        for record in results:
            nodes.append({"title": record["cTitle"], "label": "wiki"})
            target = i
            i += 1
            for name in record["cSubTitles"]:
                category = {"title": name, "label": "category"}
                try:
                    source = nodes.index(category)
                except ValueError:
                    nodes.append(category)
                    source = i
                    i += 1
                rels.append({"source": source, "target": target})
        return Response(dumps({"nodes": nodes, "links": rels}),
                    mimetype="application/json")			

@app.route("/explore-shortest-path", methods=('GET', 'POST'))
@auto.doc()
def explore_path():
    if request.method == 'POST':
        return render_template('explore-path.html')	
    else:
        try:
            qfrom = str(request.args["from"])
            qto = str(request.args["to"])
        except:
            qfrom = "SQL"
            qto = "Google"

        global language_session	
        db = get_db()
        results = db.run(
	         "MATCH shortestPath = shortestPath((g:Page {pageTitle: {qfrom},language: {lang}})<-[*]->(root:Page {pageTitle: {qto},language: {lang}})) "
             "WITH EXTRACT(p in NODES(shortestPath) | CASE WHEN p.pageTitle IS NULL THEN p.catName ELSE p.pageTitle END) AS s "
             "UNWIND s AS cTitle RETURN cTitle "
             , {"qfrom": qfrom, "qto": qto, "lang": language_session})	
			 			 
        nodes = []
        rels = []
        i = 0
        for record in results:
                if i % 2 == 0:
                    nodes.append({"title": record["cTitle"], "label": "wiki"})
                else:
                    nodes.append({"title": record["cTitle"], "label": "category"})

                target = i
                i += 1
                if target >= 1:
                    rels.append({"source": (target - 1), "target": target})
				
        return Response(dumps({"nodes": nodes, "links": rels}),
                    mimetype="application/json")						
				
@app.route("/search-world")
@auto.doc()
def search_world():
    try:
        q = str(request.args["q"])
    except KeyError:
        return []
    else:
        query = ("MATCH (c:Category) WHERE c.catName =~ {title} AND c.language = {lang} RETURN c AS catName ORDER BY c.countSubCat DESC, c.balanceIndex DESC, c.countPages LIMIT {limit} "
                 "UNION  "
                 "MATCH (p:Page) WHERE p.pageTitle =~ {title} AND p.language = {lang} RETURN p AS catName ORDER BY p.countParentCat DESC, p.pageTitle LIMIT {limit}")	

        l = int(request.args["l"])
        if l is None: l = 10
        if l < 1: l = 10
        if l > 500: l = 500
        global last_url
		#commented avoid dupe search because 2nd click cause "null" value on results html table
        #if last_url == q: 
        #    return Response(dumps([{"wikigraph": 'null'}]),mimetype="application/json")

        global language_session
        q.replace(" ", ".*")
        #last_url = q
        results = gdb.query(
            query,
            returns=Node,
            params={"title": "(?i).*" + q + ".*", "limit": l, "lang": language_session }
        )
        return Response(dumps([{"wikigraph": row.properties}
                               for [row] in results]),
                        mimetype="application/json")

@app.route("/categorify/<title>")
@auto.doc()
def get_wikicategories(title):
    global last_url_subcat
    if last_url_subcat == title:
        return Response(
            dumps({"title": 'null',"imgScr": 'null',"wiki": 'null'})
			,mimetype="application/json")	
			
    last_url_subcat = title
    global language_session
    query = ("MATCH (c:Category {catName:{title}, language:{lang}}) "
             "OPTIONAL MATCH (c)<-[r]-(c2:Category) "
             "RETURN c.catName as title, c.imgSrc,"
             "collect([c2.catName, "
             "         head(split(lower(type(r)), '_')), c2.pageUrl]) as wiki "
             "LIMIT 1")
    results = gdb.query(query, params={"title": title, "lang": language_session})
    try:	
        title, imgSrc, wiki = results[0]
        return Response(
            dumps({"title": title,"imgSrc": imgSrc,"wiki": [dict(zip(("subtitle", "reltype", "pageurl"), member))
            for member in wiki]}),mimetype="application/json")
    except:
        return Response(
            dumps({"title": 'null',"imgScr": 'null',"wiki": 'null'})
			,mimetype="application/json")
			
@app.route("/pagify/<title>")
@auto.doc()
def get_wikipages(title):
    query = ("MATCH (c:Category {catName:{title}, language:{lang}}) "
             "OPTIONAL MATCH (c)<-[r]-(p:Page) "
             "RETURN c.catName as title, "
             "collect([p.pageTitle, head(split(lower(type(r)), '_')), p.pageUrl]) as wiki "
             "LIMIT 1")	
    if title is None: return None
    global language_session		
    results = gdb.query(query, params={"title": title, "lang": language_session})
    try:	
        title, wiki = results[0]
        return Response(
            dumps({"title": title,"wiki": [dict(zip(("subtitle", "reltype", "pageurl"), member))
            for member in wiki]}),mimetype="application/json")
    except:
        return Response(
            dumps({"title": 'null',"wiki": 'null'})
			,mimetype="application/json")

@app.route('/documentation')
@auto.doc()
def documentation():
    return auto.html()			
		
if __name__ == '__main__':
    app.run(port=8080)
