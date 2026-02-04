// Filter List Function - Copyright (c) 2010 Kilian Valkhof - https://kilianvalkhof.com/2010/javascript/how-to-build-a-fast-simple-list-filter-with-jquery/

(function ($) {
  // custom css expression for a case-insensitive contains()
  jQuery.expr[':'].Contains = function(a,i,m){
      return (a.textContent || a.innerText || "").toUpperCase().indexOf(m[3].toUpperCase())>=0;
  };

  function listFilter(header, list) { // header is any element, list is an unordered list
    // create and add the filter form to the header
    var form = $("<form>").attr({"class":"filterform","action":"#"}),
        input = $("<input>").attr({"class":"filterinput","type":"text","id":"inputwikidetails", "placeholder":"Type to filter the list..."});
    $(form).append(input).appendTo(header);

    $(input)
      .change( function () {
        var filter = $(this).val();
        if(filter) {
          // this finds all links in a list that contain the input,
          // and hide the ones not containing the input while showing the ones that do
          $(list).find("a:not(:Contains(" + filter + "))").parent().slideUp();
          $(list).find("a:Contains(" + filter + ")").parent().slideDown();
        } else {
          $(list).find("li").slideDown();
        }
        return false;
      })
    .keyup( function () {
        // fire the above change event after every letter
        $(this).change();
    });
  }
  
  //ondomready
  $(function () {
    listFilter($("#details-header"), $("#wikidetails_list"));
  });
}(jQuery));
//End of Filter List. Added <br> & placeholder

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
	function filter_wikidetails(element) {
		var value = $(element).val().toLowerCase();
		$("#wikidetails_list > li").each(function () {
			var $this = $(this),
				lower = $this.text;
			if (lower.indexOf(value) > -1) {
				$this.show();
			} else {
				$this.hide();
			}
		});
	}
	function toggleDiv(divId) {
	   $("#"+divId).toggle();
	}	
	function showWikiGraph(title) {
		if (typeof title === "undefined") {return false};
		$.get("/categorify/" + encodeURIComponent(title),
				function (data) {
					if (!data) return;
					//$("#wikilinks").text("     Click on \"Title\" at left or \"Details\" here to go to each Wikipedia page!     ");
					if (data.imgSrc !== null){ 
						$("#poster").attr("src", data.imgSrc);	
					} else { $("#poster").attr("src", "/img/noimage.png");	 };
					var $list = $("#wikidetails_list").empty();
					data.wiki.forEach(function (wiki) {
						if (wiki.subtitle !== null){	
							$list.append($("<li>" + (wiki.reltype  !== "subcat" ?  "<img src=\"/img/page-icon.png\" class=\"list-type\" alt=\"Page\">" : "<img src=\"/img/categories-icon.png\" class=\"list-type\" alt=\"Category\">") + "<a href=\"" + wiki.pageurl + "\" target=\"_blank\">  "+ wiki.subtitle + "</a></li>"));
						}
					});				
				}, "json");
		$.get("/pagify/" + encodeURIComponent(title),
				function (data) {
					if (!data) return;
					var $list = $("#wikidetails_list");
					data.wiki.forEach(function (wiki) {
						if (wiki.subtitle !== null){						
							$list.append($("<li>" + (wiki.reltype  !== "subcat" ?  "<img src=\"/img/page-icon.png\" class=\"list-type\" alt=\"Page\">" : "<img src=\"/img/categories-icon.png\" class=\"list-type\" alt=\"Category\">") + "<a href=\"" + wiki.pageurl + "\" target=\"_blank\">  "+ wiki.subtitle + "</a></li>"));
						}
					});				
				}, "json");
		$("#inputwikidetails").val("");				
		var results_count = $("#wikidetails_list").children().length;
		$("#title").html("\"" + title + "\": search found " + results_count + " results"
			+ "<span style=\"float:right;\"><img src=\"/img/page-icon.png\" class=\"list-type\" alt=\"Page\">  Page  <img src=\"/img/categories-icon.png\" class=\"list-type\" alt=\"Category\">Category</span>");					
		return false;
	}
	function search() {
		if (!document.getElementById("btn-search").value)
		{
			$("#btn-search").css("background-color", "#ffff66");
			$("#btn-search").focus()
			return false;
		} 
			$("#btn-search").css("background-color", "white");
			var query=$("#search").find("input[name=search]").val();
			var rowlimit=coalesce($("#search").find("input[name=rowlimit]").val(), 10);
			if (rowlimit < 1 ){ 
				rowlimit = 10
				$("#rowlimit").val(10)	
			};
			if (rowlimit > 500 ){ 
				rowlimit = 500 
				$("#rowlimit").val(500);		
			};
			$.get("search-world?q=" + encodeURIComponent(query) + "&l=" + encodeURIComponent(rowlimit),
					function (data) {
						if (!data || data.length == 0) return;	//4 cover 'null' object return					
						var t = $("table#results tbody").empty();
						data.forEach(function (row) {
							var wikigraph = row.wikigraph;					
							$("<tr><td class='wikigraph'><a href=\"" + wikigraph.pageUrl + "\" target=\"_blank\">" + coalesce(wikigraph.catName, wikigraph.pageTitle)
								+ "</a></td><td style=\"text-align:center\">" + (typeof wikigraph.catID  !== "undefined" ?  "<img src=\"/img/categories-icon.png\" class=\"list-type\" alt=\"Category\">" : "<img src=\"/img/page-icon.png\" class=\"list-type\" alt=\"Page\">")
								+ "</td><td style=\"text-align:center\">" + coalesce(wikigraph.countSubCat, 0)
								+ "</td><td style=\"text-align:center\">" + coalesce(wikigraph.countPages, 0)
								+ "</td></tr>").appendTo(t)
									.click(function() { showWikiGraph($(this).find("td.wikigraph").text());})
						});
						showWikiGraph(data[0].wikigraph.catName);
					}, "json");
			return false;
	}

	$("#search").submit(search);
	//search();
})