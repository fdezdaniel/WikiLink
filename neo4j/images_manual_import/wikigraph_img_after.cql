LOAD CSV WITH HEADERS
FROM "file:///output.csv" AS line FIELDTERMINATOR '|'
CREATE (:CategoryImg  {pageID: line.PageID, title: line.Title, imgSrc: line.Source});

MERGE (c:Category {catName:line.Title}) 
ON CREATE SET c.imgFetched = true, 
	c.pageID = case when line.PageID > 0 then line.PageID else c.pageID end,
    c.imgSrc = line.Source;
	
MATCH (i:CategoryImg) WITH i
MERGE (c:Category {catName:i.title}) 
ON MATCH SET c.imgFetched = true, 
	c.pageID = i.pageID,
    c.imgSrc = i.imgSrc;

MATCH (i:CategoryImg) DETACH DELETE i;