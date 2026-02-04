//WikiLink
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
	function toggleDiv(divId) {
	   $("#"+divId).toggle();
	}	
})