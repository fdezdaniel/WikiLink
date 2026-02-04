CREATE (l:Language {name: 'Español', abbrev:'es', lang_es: 'Español', lang_en: 'Spanish', dateCreated: TIMESTAMP(), dateLastProcessed: TIMESTAMP(), enabled: 0});
CREATE (l:Language {name: 'English', abbrev:'en', lang_es: 'Inglés', lang_en: 'English', dateCreated: TIMESTAMP(), dateLastProcessed: TIMESTAMP(), enabled: 1});

CREATE INDEX ON :Category(catID);
CREATE INDEX ON :Category(catName);
CREATE INDEX ON :Category(level);
CREATE INDEX ON :Page(pageID);
CREATE INDEX ON :Page(pageTitle);

CREATE (c:Category:RootCategory {catID: 0, catName: 'Databases', language:'en', subcatsFetched : false, pagesFetched : false, level: 0, dateCreated: TIMESTAMP(), dateLastProcessed: TIMESTAMP(), countSubCat: 0, countParentCat: 0, countPages: 0, readyToProcess: 0});
CREATE (c:Category:RootCategory {catID: 0, catName: 'Germany', language:'en', subcatsFetched : false, pagesFetched : false, level: 0, dateCreated: TIMESTAMP(), dateLastProcessed: TIMESTAMP(), countSubCat: 0, countParentCat: 0, countPages: 0, readyToProcess: 0});
//CREATE (c:Category:RootCategory {catID: 0, catName: 'Spain', language:'en', subcatsFetched : false, pagesFetched : false, level: 0, dateCreated: TIMESTAMP(), dateLastProcessed: TIMESTAMP(), countSubCat: 0, countParentCat: 0, countPages: 0, readyToProcess: 0});
//CREATE (c:Category:RootCategory {catID: 0, catName: 'Portugal', language:'en', subcatsFetched : false, pagesFetched : false, level: 0, dateCreated: TIMESTAMP(), dateLastProcessed: TIMESTAMP(), countSubCat: 0, countParentCat: 0, countPages: 0, readyToProcess: 0});
//CREATE (c:Category:RootCategory {catID: 0, catName: 'Egypt', language:'en', subcatsFetched : false, pagesFetched : false, level: 0, dateCreated: TIMESTAMP(), dateLastProcessed: TIMESTAMP(), countSubCat: 0, countParentCat: 0, countPages: 0, readyToProcess: 0});
//CREATE (c:Category:RootCategory {catID: 0, catName: 'History', language:'en', subcatsFetched : false, pagesFetched : false, level: 0, dateCreated: TIMESTAMP(), dateLastProcessed: TIMESTAMP(), countSubCat: 0, countParentCat: 0, countPages: 0, readyToProcess: 0});
//CREATE (c:Category:RootCategory {catID: 0, catName: 'Italy', language:'en', subcatsFetched : false, pagesFetched : false, level: 0, dateCreated: TIMESTAMP(), dateLastProcessed: TIMESTAMP(), countSubCat: 0, countParentCat: 0, countPages: 0, readyToProcess: 0});
//CREATE (c:Category:RootCategory {catID: 0, catName: 'France', language:'en', subcatsFetched : false, pagesFetched : false, level: 0, dateCreated: TIMESTAMP(), dateLastProcessed: TIMESTAMP(), countSubCat: 0, countParentCat: 0, countPages: 0, readyToProcess: 0});
//CREATE (c:Category:RootCategory {catID: 0, catName: 'Quixote', language:'en', subcatsFetched : false, pagesFetched : false, level: 0, dateCreated: TIMESTAMP(), dateLastProcessed: TIMESTAMP(), countSubCat: 0, countParentCat: 0, countPages: 0, readyToProcess: 0});
//CREATE (c:Category:RootCategory {catID: 0, catName: 'Categories by type', language:'en', subcatsFetched : false, pagesFetched : false, level: 0, dateCreated: TIMESTAMP(), dateLastProcessed: TIMESTAMP(), countSubCat: 0, countParentCat: 0, countPages: 0, readyToProcess: 0});