MATCH (c:Category)
CALL apoc.load.json('https://' + apoc.text.urlencode(c.language) + '.wikipedia.org/w/api.php?format=json&action=query&prop=pageimages&pithumbsize=100&titles=' + apoc.text.urlencode(c.catName))
YIELD value as results 
UNWIND results.query.pages AS page
return page;