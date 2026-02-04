//WikiLink
/**
 * URL used to access Neo4j REST API to execute queries.
 * Update this parameter to your running server instance.
 *
 * For more information on Neo4J REST API the documentation is available here: http://neo4j.com/docs/stable/rest-api-cypher.html
 */
//popoto.rest.CYPHER_URL = "http://localhost:7474/db/data/";
popoto.rest.CYPHER_URL = "http://localhost:7474/db/data/transaction/commit";

/**
 * Add this authorization property if your Neo4j server uses basic HTTP authentication.
 * The value of this property must be "Basic <payload>", where "payload" is a base64 encoded string of "username:password".
 *
 * "btoa" is a JavaScript function that can be used to encode the user and password value in base64 but it is recommended to directly use the Base64 value.
 *
 *  For example Base64 encoded value of "neo4j:password" is "bmVvNGo6cGFzc3dvcmQ="
popoto.rest.AUTHORIZATION = "Basic bmVvNGo6Z3JhcGhpcGVkaWE=";    
*/
popoto.rest.AUTHORIZATION = "Basic " + btoa(<Neo4j-password>);

/**
 * Define the Label provider you need for your application.
 * This configuration is mandatory and should contain at least all the labels you could find in your graph model.
 *
 * In this version only nodes with a label are supported.
 *
 * By default If no attributes are specified Neo4j internal ID will be used.
 * These label provider configuration can be used to customize the node display in the graph.
 * See www.popotojs.com or example for more details on available configuration options.
 */
popoto.provider.nodeProviders = {
	"Page":{
		returnAttributes:["countParentCat", "pageTitle", "pageUrl", "pageID", "language"],
		constraintAttribute:"pageID",
		"getTextValue": function (node) {
			var text;
			if (node.type === popoto.graph.node.NodeTypes.VALUE) {
				text = "" + node.attributes["pageTitle"];
			} else {
				if (node.value === undefined) {
					text = node.label;
				} else {
					text = "" + node.value.attributes["pageTitle"];
				}
			}
			// Text is truncated to avoid node overflow
			// return text.substring(0, 12);
			return text.substring(0, 40);
		},
	},
	"Level 3":{
		returnAttributes:["catID", "countParentCat", "pageUrl", "pageID", "pagesFetched", "countPages", "countSubCat", "dateLastProcessed", "catName", "levelSubCat", "dateCreated", "language", "subcatsFetched", "imgFetched", "balanceIndex", "level", "imgSrc"],
		constraintAttribute:"catID",
		"getTextValue": function (node) {
			var text;
			if (node.type === popoto.graph.node.NodeTypes.VALUE) {
				text = "" + node.attributes["catName"];
			} else {
				if (node.value === undefined) {
					text = node.label;
				} else {
					text = "" + node.value.attributes["catName"];
				}
			}
			// Text is truncated to avoid node overflow
			return text.substring(0, 40);
		},
	},
	"Level 5":{
		returnAttributes:["catID", "countParentCat", "pageUrl", "pageID", "pagesFetched", "countSubCat", "dateLastProcessed", "catName", "dateCreated", "language", "subcatsFetched", "imgFetched", "imgSrc", "balanceIndex", "level", "levelSubCat"],
		constraintAttribute:"catID",
		"getTextValue": function (node) {
			var text;
			if (node.type === popoto.graph.node.NodeTypes.VALUE) {
				text = "" + node.attributes["catName"];
			} else {
				if (node.value === undefined) {
					text = node.label;
				} else {
					text = "" + node.value.attributes["catName"];
				}
			}
			// Text is truncated to avoid node overflow
			return text.substring(0, 40);
		},
	},
	"Level 2":{
		returnAttributes:["catID", "countParentCat", "pageUrl", "pageID", "pagesFetched", "countSubCat", "dateLastProcessed", "catName", "dateCreated", "language", "subcatsFetched", "imgFetched", "balanceIndex", "level", "countPages", "levelSubCat", "imgSrc"],
		constraintAttribute:"catID",
		"getTextValue": function (node) {
			var text;
			if (node.type === popoto.graph.node.NodeTypes.VALUE) {
				text = "" + node.attributes["catName"];
			} else {
				if (node.value === undefined) {
					text = node.label;
				} else {
					text = "" + node.value.attributes["catName"];
				}
			}
			// Text is truncated to avoid node overflow
			return text.substring(0, 40);
		},
	},
	"Level 1":{
		returnAttributes:["catID", "countParentCat", "pageUrl", "pageID", "pagesFetched", "countSubCat", "dateLastProcessed", "catName", "dateCreated", "language", "subcatsFetched", "imgFetched", "balanceIndex", "level", "countPages", "levelSubCat"],
		constraintAttribute:"catID",
		"getTextValue": function (node) {
			var text;
			if (node.type === popoto.graph.node.NodeTypes.VALUE) {
				text = "" + node.attributes["catName"];
			} else {
				if (node.value === undefined) {
					text = node.label;
				} else {
					text = "" + node.value.attributes["catName"];
				}
			}
			// Text is truncated to avoid node overflow
			return text.substring(0, 40);
		},
	},
	"Level 4":{
		returnAttributes:["catID", "countParentCat", "pageUrl", "pageID", "pagesFetched", "countPages", "countSubCat", "dateLastProcessed", "catName", "levelSubCat", "dateCreated", "language", "subcatsFetched", "imgFetched", "balanceIndex", "level", "imgSrc"],
		constraintAttribute:"catID",
		"getTextValue": function (node) {
			var text;
			if (node.type === popoto.graph.node.NodeTypes.VALUE) {
				text = "" + node.attributes["catName"];
			} else {
				if (node.value === undefined) {
					text = node.label;
				} else {
					text = "" + node.value.attributes["catName"];
				}
			}
			// Text is truncated to avoid node overflow
			return text.substring(0, 40);
		},
	},
	"RootCategory":{
		returnAttributes:["catID", "countParentCat", "pageUrl", "pageID", "pagesFetched", "countPages", "countSubCat", "dateLastProcessed", "catName", "dateCreated", "language", "subcatsFetched", "imgFetched", "balanceIndex", "level", "imgSrc"],
		constraintAttribute:"catID",
		"getTextValue": function (node) {
			var text;
			if (node.type === popoto.graph.node.NodeTypes.VALUE) {
				text = "" + node.attributes["catName"];
			} else {
				if (node.value === undefined) {
					text = node.label;
				} else {
					text = "" + node.value.attributes["catName"];
				}
			}
			// Text is truncated to avoid node overflow
			return text.substring(0, 40);
		},
	},
	"Category":{
		returnAttributes:["catID", "countParentCat", "pageUrl", "pageID", "pagesFetched", "countPages", "countSubCat", "dateLastProcessed", "catName", "dateCreated", "language", "subcatsFetched", "imgFetched", "balanceIndex", "level", "levelSubCat", "imgSrc"],
		constraintAttribute:"catID",
		"getTextValue": function (node) {
			var text;
			if (node.type === popoto.graph.node.NodeTypes.VALUE) {
				text = "" + node.attributes["catName"];
			} else {
				if (node.value === undefined) {
					text = node.label;
				} else {
					text = "" + node.value.attributes["catName"];
				}
			}
			// Text is truncated to avoid node overflow
			return text.substring(0, 40);
		},
	},
};

/**
 * Here a listener is used to retrieve the total results count and update the page accordingly.
 * This listener will be called on every graph modification.
 */
popoto.result.onTotalResultCount(function (count) {
	document.getElementById("result-total-count").innerHTML = "(" + count + ")";
});

/**
 * The number of results returned can be changed with the following parameter.
 * Default value is 100.
 *
 * Note that in this current version no pagination mechanism is available in displayed results
 */
//popoto.query.RESULTS_PAGE_SIZE = 100;


/**
 * For this version, popoto.js has been generated with debug traces you can activate with the following properties:
 * The value can be one in DEBUG, INFO, WARN, ERROR, NONE.
 *
 * With INFO level all the executed cypher query can be seen in the navigator console.
 * Default is NONE
 */
//popoto.logger.LEVEL = popoto.logger.LogLevels.INFO;

/**
 * Start popoto.js generation.
 * The function requires the label to use as root element in the graph.
 */
popoto.start("Page");