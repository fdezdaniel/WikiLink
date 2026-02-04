//WikiLink - Cypher script for ETL
//Subcategories import
match (c:Category:RootCategory{subcatsFetched:false, readyToProcess: 0}) 
with c limit 1
merge (sc:Category:RootCategory{catName:c.catName}) 
on match set sc.readyToProcess = 1;

MATCH (c:Category {subcatsFetched: false, level: 0, readyToProcess: 1}) 
WITH c
CALL apoc.load.json('https://' + apoc.text.urlencode(c.language) + '.wikipedia.org/w/api.php?format=json&action=query&list=categorymembers&cmtype=subcat&cmtitle=Category:' + apoc.text.urlencode(c.catName) + '&cmprop=ids%7Ctitle&cmlimit=5000') 
YIELD value as results 
UNWIND results.query.categorymembers AS subcat 
WITH subcat, c 
MERGE (sc:Category {catID: subcat.pageid}) 
ON CREATE SET sc.catName = substring(subcat.title,9), 
              sc.subcatsFetched = false, 
              sc.pagesFetched = false, 
			  sc.language = c.language, 
			  sc.dateCreated = TIMESTAMP(),  
			  sc.dateLastProcessed = TIMESTAMP(), 
              sc.level = (c.level + 1), 
			  sc.countSubCat = 0, 
			  sc.countParentCat = 0, 
			  sc.countPages = 0, 
			  c.countPages = coalesce(c.countPages, 0), 
			  c.countSubCat = coalesce(c.countSubCat, 0) + 1 
ON MATCH SET  sc.dateLastProcessed = TIMESTAMP(), 
              sc.levelSubCat = case when coalesce(sc.levelSubCat, 0) < (c.level + 1) then (c.level + 1) else sc.levelSubCat end, 
			  c.countSubCat = coalesce(c.countSubCat, 0) + 1 
WITH sc, c 
CALL apoc.create.addLabels(sc,['Level ' + (sc.level)]) YIELD node 
MERGE (sc)-[r:SUBCAT_OF]->(c) 
ON CREATE SET r.levelSubCat = sc.level, r.levelParentCat = c.level,  
			  sc.countParentCat = coalesce(sc.countParentCat, 0) + 1 
WITH DISTINCT c SET c.subcatsFetched = true; 

MATCH (c:Category {subcatsFetched: false, level: 1}) 
WITH c
CALL apoc.load.json('https://' + apoc.text.urlencode(c.language) + '.wikipedia.org/w/api.php?format=json&action=query&list=categorymembers&cmtype=subcat&cmtitle=Category:' + apoc.text.urlencode(c.catName) + '&cmprop=ids%7Ctitle&cmlimit=5000') 
YIELD value as results 
UNWIND results.query.categorymembers AS subcat 
WITH subcat, c 
MERGE (sc:Category {catID: subcat.pageid}) 
ON CREATE SET sc.catName = substring(subcat.title,9), 
              sc.subcatsFetched = false, 
              sc.pagesFetched = false, 
			  sc.language = c.language, 
			  sc.dateCreated = TIMESTAMP(),  
			  sc.dateLastProcessed = TIMESTAMP(), 
              sc.level = (c.level + 1), 
			  sc.countSubCat = 0, 
			  sc.countParentCat = 0, 
			  sc.countPages = 0, 		  
			  c.countPages = coalesce(c.countPages, 0), 
			  c.countSubCat = coalesce(c.countSubCat, 0) + 1 
ON MATCH SET  sc.dateLastProcessed = TIMESTAMP(), 
              sc.levelSubCat = case when coalesce(sc.levelSubCat, 0) < (c.level + 1) then (c.level + 1) else sc.levelSubCat end, 
			  c.countSubCat = coalesce(c.countSubCat, 0) + 1 
WITH sc, c 
CALL apoc.create.addLabels(sc,['Level ' + (sc.level)]) YIELD node 
MERGE (sc)-[r:SUBCAT_OF]->(c) 
ON CREATE SET r.levelSubCat = sc.level, r.levelParentCat = c.level,  
			  sc.countParentCat = coalesce(sc.countParentCat, 0) + 1 
WITH DISTINCT c SET c.subcatsFetched = true; 

MATCH (c:Category {subcatsFetched: false, level: 2}) 
WITH c
CALL apoc.load.json('https://' + apoc.text.urlencode(c.language) + '.wikipedia.org/w/api.php?format=json&action=query&list=categorymembers&cmtype=subcat&cmtitle=Category:' + apoc.text.urlencode(c.catName) + '&cmprop=ids%7Ctitle&cmlimit=5000') 
YIELD value as results 
UNWIND results.query.categorymembers AS subcat 
WITH subcat, c 
MERGE (sc:Category {catID: subcat.pageid}) 
ON CREATE SET sc.catName = substring(subcat.title,9), 
              sc.subcatsFetched = false, 
              sc.pagesFetched = false, 
			  sc.language = c.language, 
			  sc.dateCreated = TIMESTAMP(),  
			  sc.dateLastProcessed = TIMESTAMP(), 
              sc.level = (c.level + 1), 
			  sc.countSubCat = 0, 
			  sc.countParentCat = 0, 
			  sc.countPages = 0, 		  
			  c.countPages = coalesce(c.countPages, 0), 
			  c.countSubCat = coalesce(c.countSubCat, 0) + 1 
ON MATCH SET  sc.dateLastProcessed = TIMESTAMP(), 
              sc.levelSubCat = case when coalesce(sc.levelSubCat, 0) < (c.level + 1) then (c.level + 1) else sc.levelSubCat end, 
			  c.countSubCat = coalesce(c.countSubCat, 0) + 1 
WITH sc, c 
CALL apoc.create.addLabels(sc,['Level ' + (sc.level)]) YIELD node 
MERGE (sc)-[r:SUBCAT_OF]->(c) 
ON CREATE SET r.levelSubCat = sc.level, r.levelParentCat = c.level,  
			  sc.countParentCat = coalesce(sc.countParentCat, 0) + 1 
WITH DISTINCT c SET c.subcatsFetched = true; 

MATCH (c:Category {subcatsFetched: false, level: 3}) 
WITH c
CALL apoc.load.json('https://' + apoc.text.urlencode(c.language) + '.wikipedia.org/w/api.php?format=json&action=query&list=categorymembers&cmtype=subcat&cmtitle=Category:' + apoc.text.urlencode(c.catName) + '&cmprop=ids%7Ctitle&cmlimit=5000') 
YIELD value as results 
UNWIND results.query.categorymembers AS subcat 
WITH subcat, c 
MERGE (sc:Category {catID: subcat.pageid}) 
ON CREATE SET sc.catName = substring(subcat.title,9), 
              sc.subcatsFetched = false, 
              sc.pagesFetched = false, 
			  sc.language = c.language, 
			  sc.dateCreated = TIMESTAMP(),  
			  sc.dateLastProcessed = TIMESTAMP(), 
              sc.level = (c.level + 1), 
			  sc.countSubCat = 0, 
			  sc.countParentCat = 0, 
			  sc.countPages = 0, 		  
			  c.countPages = coalesce(c.countPages, 0), 
			  c.countSubCat = coalesce(c.countSubCat, 0) + 1 
ON MATCH SET  sc.dateLastProcessed = TIMESTAMP(), 
              sc.levelSubCat = case when coalesce(sc.levelSubCat, 0) < (c.level + 1) then (c.level + 1) else sc.levelSubCat end, 
			  c.countSubCat = coalesce(c.countSubCat, 0) + 1 
WITH sc, c 
CALL apoc.create.addLabels(sc,['Level ' + (sc.level)]) YIELD node 
MERGE (sc)-[r:SUBCAT_OF]->(c) 
ON CREATE SET r.levelSubCat = sc.level, r.levelParentCat = c.level,  
			  sc.countParentCat = coalesce(sc.countParentCat, 0) + 1 
WITH DISTINCT c SET c.subcatsFetched = true; 

MATCH (c:Category {subcatsFetched: false, level: 4}) 
WITH c
CALL apoc.load.json('https://' + apoc.text.urlencode(c.language) + '.wikipedia.org/w/api.php?format=json&action=query&list=categorymembers&cmtype=subcat&cmtitle=Category:' + apoc.text.urlencode(c.catName) + '&cmprop=ids%7Ctitle&cmlimit=5000') 
YIELD value as results 
UNWIND results.query.categorymembers AS subcat 
WITH subcat, c 
MERGE (sc:Category {catID: subcat.pageid}) 
ON CREATE SET sc.catName = substring(subcat.title,9), 
              sc.subcatsFetched = false, 
              sc.pagesFetched = false, 
			  sc.language = c.language, 
			  sc.dateCreated = TIMESTAMP(),  
			  sc.dateLastProcessed = TIMESTAMP(), 
              sc.level = (c.level + 1), 
			  sc.countSubCat = 0, 
			  sc.countParentCat = 0, 
			  sc.countPages = 0, 	  
			  c.countPages = coalesce(c.countPages, 0), 
			  c.countSubCat = coalesce(c.countSubCat, 0) + 1 
ON MATCH SET  sc.dateLastProcessed = TIMESTAMP(), 
              sc.levelSubCat = case when coalesce(sc.levelSubCat, 0) < (c.level + 1) then (c.level + 1) else sc.levelSubCat end, 
			  c.countSubCat = coalesce(c.countSubCat, 0) + 1 
WITH sc, c 
CALL apoc.create.addLabels(sc,['Level ' + (sc.level)]) YIELD node 
MERGE (sc)-[r:SUBCAT_OF]->(c) 
ON CREATE SET r.levelSubCat = sc.level, r.levelParentCat = c.level,  
			  sc.countParentCat = coalesce(sc.countParentCat, 0) + 1 
WITH DISTINCT c SET c.subcatsFetched = true; 

//Update flags
MATCH (c:Category) WHERE c.pageUrl is null
SET c.pageUrl = 'http://' + c.language + '.wikipedia.org/wiki/Category:' + replace(c.catName, ' ', '_');

MATCH (c:Category) WHERE c.imgFetched is null
SET c.imgFetched = false;

MATCH (c:Category) WHERE c.balanceIndex is null AND (c.countSubCat > 0 OR c.countParentCat > 0)
SET c.balanceIndex =  ABS(toFloat(c.countParentCat - c.countSubCat)/(c.countParentCat + c.countSubCat));

MATCH (c:Category) WHERE c.balanceIndex is null AND (c.countSubCat = 0 OR c.countParentCat = 0)
SET c.balanceIndex =  0;

//Pages
MATCH (c:Category { pagesFetched: false, level: 0, subcatsFetched: true})
CALL apoc.load.json('https://' + apoc.text.urlencode(c.language) + '.wikipedia.org/w/api.php?format=json&action=query&list=categorymembers&cmtype=page&cmtitle=Category:' + apoc.text.urlencode(c.catName) + '&cmprop=ids%7Ctitle&cmlimit=500')
YIELD value as results
UNWIND results.query.categorymembers AS page
WITH page, c
MERGE (p:Page {pageID: page.pageid})
ON CREATE SET p.pageTitle = page.title, 
			  p.pageID = page.pageid,
			  p.pageUrl = 'http://en.wikipedia.org/wiki/' + apoc.text.urlencode(replace(page.title, ' ', '_')),
			  p.countParentCat = 0,
			  p.language = c.language,
			  p.imgFetched = false,			  
			  c.countPages = coalesce(c.countPages, 0) + 1
ON MATCH SET c.countPages = coalesce(c.countPages, 0) + 1			  
WITH p, c
MERGE (p)-[:IN_CATEGORY]->(c)
ON CREATE SET p.countParentCat = coalesce(p.countParentCat, 0) + 1
WITH DISTINCT c
SET c.pagesFetched = true;

MATCH (c:Category { pagesFetched: false, level: 1})
CALL apoc.load.json('https://' + apoc.text.urlencode(c.language) + '.wikipedia.org/w/api.php?format=json&action=query&list=categorymembers&cmtype=page&cmtitle=Category:' + apoc.text.urlencode(c.catName) + '&cmprop=ids%7Ctitle&cmlimit=500')
YIELD value as results
UNWIND results.query.categorymembers AS page
WITH page, c
MERGE (p:Page {pageID: page.pageid})
ON CREATE SET p.pageTitle = page.title, 
			  p.pageID = page.pageid,
			  p.pageUrl = 'http://en.wikipedia.org/wiki/' + apoc.text.urlencode(replace(page.title, ' ', '_')),
			  p.countParentCat = 0,
			  p.language = c.language,
			  p.imgFetched = false,			  
			  c.countPages = coalesce(c.countPages, 0) + 1
ON MATCH SET c.countPages = coalesce(c.countPages, 0) + 1			  
WITH p, c
MERGE (p)-[:IN_CATEGORY]->(c)
ON CREATE SET p.countParentCat = coalesce(p.countParentCat, 0) + 1
WITH DISTINCT c
SET c.pagesFetched = true;	

MATCH (c:Category { pagesFetched: false, level: 2})
CALL apoc.load.json('https://' + apoc.text.urlencode(c.language) + '.wikipedia.org/w/api.php?format=json&action=query&list=categorymembers&cmtype=page&cmtitle=Category:' + apoc.text.urlencode(c.catName) + '&cmprop=ids%7Ctitle&cmlimit=500')
YIELD value as results
UNWIND results.query.categorymembers AS page
WITH page, c
MERGE (p:Page {pageID: page.pageid})
ON CREATE SET p.pageTitle = page.title, 
			  p.pageID = page.pageid,
			  p.pageUrl = 'http://en.wikipedia.org/wiki/' + apoc.text.urlencode(replace(page.title, ' ', '_')),
			  p.countParentCat = 0,
			  p.language = c.language,
			  p.imgFetched = false,			  
			  c.countPages = coalesce(c.countPages, 0) + 1
ON MATCH SET c.countPages = coalesce(c.countPages, 0) + 1			  
WITH p, c
MERGE (p)-[:IN_CATEGORY]->(c)
ON CREATE SET p.countParentCat = coalesce(p.countParentCat, 0) + 1
WITH DISTINCT c
SET c.pagesFetched = true;

MATCH (c:Category { pagesFetched: false, level: 3})
CALL apoc.load.json('https://' + apoc.text.urlencode(c.language) + '.wikipedia.org/w/api.php?format=json&action=query&list=categorymembers&cmtype=page&cmtitle=Category:' + apoc.text.urlencode(c.catName) + '&cmprop=ids%7Ctitle&cmlimit=500')
YIELD value as results
UNWIND results.query.categorymembers AS page
WITH page, c
MERGE (p:Page {pageID: page.pageid})
ON CREATE SET p.pageTitle = page.title, 
			  p.pageID = page.pageid,
			  p.pageUrl = 'http://en.wikipedia.org/wiki/' + apoc.text.urlencode(replace(page.title, ' ', '_')),
			  p.countParentCat = 0,
			  p.language = c.language,
			  p.imgFetched = false,			  
			  c.countPages = coalesce(c.countPages, 0) + 1
ON MATCH SET c.countPages = coalesce(c.countPages, 0) + 1	  
WITH p, c
MERGE (p)-[:IN_CATEGORY]->(c)
ON CREATE SET p.countParentCat = coalesce(p.countParentCat, 0) + 1
WITH DISTINCT c
SET c.pagesFetched = true;

MATCH (c:Category { pagesFetched: false, level: 4})
CALL apoc.load.json('https://' + apoc.text.urlencode(c.language) + '.wikipedia.org/w/api.php?format=json&action=query&list=categorymembers&cmtype=page&cmtitle=Category:' + apoc.text.urlencode(c.catName) + '&cmprop=ids%7Ctitle&cmlimit=500')
YIELD value as results
UNWIND results.query.categorymembers AS page
WITH page, c
MERGE (p:Page {pageID: page.pageid})
ON CREATE SET p.pageTitle = page.title, 
			  p.pageID = page.pageid,
			  p.pageUrl = 'http://en.wikipedia.org/wiki/' + apoc.text.urlencode(replace(page.title, ' ', '_')),
			  p.countParentCat = 0,
			  p.language = c.language,
			  p.imgFetched = false,
			  c.countPages = coalesce(c.countPages, 0) + 1
ON MATCH SET c.countPages = coalesce(c.countPages, 0) + 1			  
WITH p, c
MERGE (p)-[:IN_CATEGORY]->(c)
ON CREATE SET p.countParentCat = coalesce(p.countParentCat, 0) + 1
WITH DISTINCT c
SET c.pagesFetched = true;

MATCH (c:Category {level: 0, imgFetched: false})
CALL apoc.load.json('https://' + apoc.text.urlencode(c.language)  + '.wikipedia.org/w/api.php?format=json&action=query&titles=' + apoc.text.urlencode(c.catName) + '&prop=pageimages&pithumbsize=100')
YIELD value as results 
UNWIND results.query.pages AS s 
WITH c, s[keys(s)[0]].title as imgTitle, s[keys(s)[0]].thumbnail.source as imgSource, 
	s[keys(s)[0]].thumbnail.width as imgWidth, s[keys(s)[0]].thumbnail.height as imgHeigth,
	s[keys(s)[0]].pageid as pageID
MERGE (c2:Category {catName: c.catName, imgFetched: false})
ON MATCH SET c2.imgFetched = true, 
	c2.pageID = pageID,
    c2.imgSrc = imgSource,
	c2.imgHeigth = imgHeigth,
	c2.imgWidth = imgWidth
WITH DISTINCT c SET c.imgFetched = true; 	

MATCH (c:Category {level: 1, imgFetched: false})
CALL apoc.load.json('https://' + apoc.text.urlencode(c.language)  + '.wikipedia.org/w/api.php?format=json&action=query&titles=' + apoc.text.urlencode(c.catName) + '&prop=pageimages&pithumbsize=100')
YIELD value as results 
UNWIND results.query.pages AS s 
WITH c, s[keys(s)[0]].title as imgTitle, s[keys(s)[0]].thumbnail.source as imgSource, 
	s[keys(s)[0]].thumbnail.width as imgWidth, s[keys(s)[0]].thumbnail.height as imgHeigth,
	s[keys(s)[0]].pageid as pageID
MERGE (c2:Category {catName: c.catName, imgFetched: false})
ON MATCH SET c2.imgFetched = true, 
	c2.pageID = pageID,
    c2.imgSrc = imgSource,
	c2.imgHeigth = imgHeigth,
	c2.imgWidth = imgWidth
WITH DISTINCT c SET c.imgFetched = true; 	
	
MATCH (c:Category {level: 2, imgFetched: false})
CALL apoc.load.json('https://' + apoc.text.urlencode(c.language)  + '.wikipedia.org/w/api.php?format=json&action=query&titles=' + apoc.text.urlencode(c.catName) + '&prop=pageimages&pithumbsize=100')
YIELD value as results 
UNWIND results.query.pages AS s 
WITH c, s[keys(s)[0]].title as imgTitle, s[keys(s)[0]].thumbnail.source as imgSource, 
	s[keys(s)[0]].thumbnail.width as imgWidth, s[keys(s)[0]].thumbnail.height as imgHeigth,
	s[keys(s)[0]].pageid as pageID
MERGE (c2:Category {catName: c.catName, imgFetched: false})
ON MATCH SET c2.imgFetched = true, 
	c2.pageID = pageID,
    c2.imgSrc = imgSource,
	c2.imgHeigth = imgHeigth,
	c2.imgWidth = imgWidth
WITH DISTINCT c SET c.imgFetched = true; 	
	
MATCH (c:Category {level: 3, imgFetched: false})
CALL apoc.load.json('https://' + apoc.text.urlencode(c.language)  + '.wikipedia.org/w/api.php?format=json&action=query&titles=' + apoc.text.urlencode(c.catName) + '&prop=pageimages&pithumbsize=100')
YIELD value as results 
UNWIND results.query.pages AS s 
WITH c, s[keys(s)[0]].title as imgTitle, s[keys(s)[0]].thumbnail.source as imgSource, 
	s[keys(s)[0]].thumbnail.width as imgWidth, s[keys(s)[0]].thumbnail.height as imgHeigth,
	s[keys(s)[0]].pageid as pageID
MERGE (c2:Category {catName: c.catName, imgFetched: false})
ON MATCH SET c2.imgFetched = true, 
	c2.pageID = pageID,
    c2.imgSrc = imgSource,
	c2.imgHeigth = imgHeigth,
	c2.imgWidth = imgWidth
WITH DISTINCT c SET c.imgFetched = true; 
	
MATCH (c:Category {level: 4, imgFetched: false})
CALL apoc.load.json('https://' + apoc.text.urlencode(c.language)  + '.wikipedia.org/w/api.php?format=json&action=query&titles=' + apoc.text.urlencode(c.catName) + '&prop=pageimages&pithumbsize=100')
YIELD value as results 
UNWIND results.query.pages AS s 
WITH c, s[keys(s)[0]].title as imgTitle, s[keys(s)[0]].thumbnail.source as imgSource, 
	s[keys(s)[0]].thumbnail.width as imgWidth, s[keys(s)[0]].thumbnail.height as imgHeigth,
	s[keys(s)[0]].pageid as pageID
MERGE (c2:Category {catName: c.catName, imgFetched: false})
ON MATCH SET c2.imgFetched = true, 
	c2.pageID = pageID,
    c2.imgSrc = imgSource,
	c2.imgHeigth = imgHeigth,
	c2.imgWidth = imgWidth
WITH DISTINCT c SET c.imgFetched = true; 	

MATCH (c:Category) WHERE c.imgFetched = false and c.level > 0 and c.level < 5 SET c.imgFetched = true;	

match (c:Category), (p:Page) 
where c.pageID = p.pageID and c.pageID > 0 and p.imgFetched = false
with c
merge (p2:Page {pageID: c.pageID})-[:IN_CATEGORY]->(c)
on match set p2.imgFetched = true, 
	p2.pageID = c.pageID,
    p2.imgSrc = c.imgSrc,
	p2.imgHeigth = c.imgHeigth,
	p2.imgWidth = c.imgWidth;

MATCH (c:Category) WHERE c.pagesFetched = false and c.level >= 0 and c.level < 5 SET c.pagesFetched = true;

//Commented due could take long time on big categories, it works	
//MATCH (c:Page {imgFetched: false})
//CALL apoc.load.json('https://' + apoc.text.urlencode(c.language)  + '.wikipedia.org/w/api.php?format=json&action=query&titles=' + apoc.text.urlencode(c.pageTitle) + '&prop=pageimages&pithumbsize=100')
//YIELD value as results 
//UNWIND results.query.pages AS s 
//WITH c, 
//	s[keys(s)[0]].title as imgTitle, 
//	s[keys(s)[0]].thumbnail.source as imgSource, 
//	s[keys(s)[0]].thumbnail.width as imgWidth, 
//	s[keys(s)[0]].thumbnail.height as imgHeigth,
//	s[keys(s)[0]].pageid as spageID
//	MERGE (c2:Page {pageID: c.pageID})
//ON CREATE SET c2.imgFetched = true,
//	c2.pageID = spageID,
//	c2.imgSrc = imgSource,
//	c2.imgHeigth = imgHeigth,
//	c2.imgWidth = imgWidth
//ON MATCH SET c2.imgFetched = true, 
//	c2.pageID = spageID,
//	c2.imgSrc = imgSource,
//	c2.imgHeigth = imgHeigth,
//	c2.imgWidth = imgWidth;