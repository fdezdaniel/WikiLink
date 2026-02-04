function popUnder(node) {
    var newWindow = window.open("about:blank", node.target, "width=500,height=500");
    newWindow.blur();
    window.focus();
    newWindow.location.href = node.href;
    return false;
}

$(function () {
	function coalesce() {
		var len = arguments.length;
		for (var i=0; i<len; i++) {
			if (arguments[i] !== null && arguments[i] !== undefined) {
				return arguments[i];
			}
		}
		return null;
	}	
	function insertParam(key, value)
	{
		key = encodeURI(key); value = encodeURI(value);

		var kvp = "explore-path.html";

		var i=kvp.length; var x; while(i--) 
		{
			x = kvp[i].split('=');

			if (x[0]==key)
			{
				x[1] = value;
				kvp[i] = x.join('=');
				break;
			}
		}

		if(i<0) {kvp[kvp.length] = [key,value].join('=');}

		//this will reload the page, it's likely better to store this until finished
		document.location.search = kvp.join('&'); 
	}	
	var getUrlParameter = function getUrlParameter(sParam) {
		var sPageURL = decodeURIComponent(window.location.search.substring(1)),
			sURLVariables = sPageURL.split('&'),
			sParameterName,
			i;

		for (i = 0; i < sURLVariables.length; i++) {
			sParameterName = sURLVariables[i].split('=');

			if (sParameterName[0] === sParam) {
				return sParameterName[1] === undefined ? true : sParameterName[1];
			}
		}
	};	

	function search() {
		if (!document.getElementById("btn-search-from").value)
		{
			$("#btn-search-from").css("background-color", "#ffff66");
			$("#btn-search-from").focus()
			return false;
		} 
		if (!document.getElementById("btn-search-to").value)
		{
			$("#btn-search-to").css("background-color", "#ffff66");
			$("#btn-search-to").focus()
			return false;
		} 		
			$("#btn-search-from").css("background-color", "white");
			$("#btn-search-to").css("background-color", "white");
			var qfrom=$("#search").find("input[name=from]").val();
			var qto=$("#search").find("input[name=to]").val();
			insertParam("qfrom", query);
			insertParam("qto", query);
			return false;
	}
	var explore = getUrlParameter('from');
	var path = getUrlParameter('to');
	if (explore !== undefined && explore !== null && path !== undefined && path !== null) {
		explore = "explore-shortest-path?from=" + explore + "&to=" + path;
	} else {
		explore = "explore-shortest-path";
	}
	
	//d3.js -- Script to run graph by background
	var width = 1360, height = 900;
	//var width = 1920, height = 1080;

	var force = d3.layout.force()
			.charge(-75).linkDistance(100).size([width, height]);

	var svg = d3.select("#graph").append("svg")
			.attr("width", "100%").attr("height", "100%")
			.attr("pointer-events", "all");
	
	d3.json(explore, function(error, graph) {
		if (error) return;
		
		force.nodes(graph.nodes).links(graph.links).start();

		var link = svg.selectAll(".link")
				.data(graph.links).enter()
				.append("line").attr("class", "link");

		var node = svg.selectAll(".node")
				.data(graph.nodes).enter()
				.append("circle")
				.attr("class", function (d) { return "node "+d.label })
				.attr("r", 10)
				.call(force.drag);

		// html title attribute
		node.append("title")
				.text(function (d) { return d.title; })

		// force feed algo ticks
		force.on("tick", function() {
			link.attr("x1", function(d) { return d.source.x; })
					.attr("y1", function(d) { return d.source.y; })
					.attr("x2", function(d) { return d.target.x; })
					.attr("y2", function(d) { return d.target.y; });

			node.attr("cx", function(d) { return d.x; })
					.attr("cy", function(d) { return d.y; });
		});
	});	
})