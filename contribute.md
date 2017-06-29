---
layout: 
title: Search
---
<script src="https://code.jquery.com/jquery-3.2.1.min.js"></script>
<script src="https://unpkg.com/lunr/lunr.js"></script>
<form action="" >
  <label for="search-box">Search</label>
  <input type="text" id="search-box" name="query">
  <input type="submit" value="search" onclick="return search();">
</form>

<ul id="search-results"></ul>

<script>
var json = (function () {
    var json = null;
    $.ajax({
        'async': false,
        'global': false,
        'url': "search.json",
        'dataType': "json",
        'success': function (data) {
            json = data;
        }
    });
    return json;
})(); 
function search() {
  console.log(json);
  function displaySearchResults(results, store) {
    var searchResults = document.getElementById('search-results');

    if (results.length) { // Are there any results?
      var appendString = '';

      for (var i = 0; i < results.length; i++) {  // Iterate over the results
        var item = store[results[i].ref];
        appendString += '<li><a href="' + item.url + '"><h3>' + item.title + '</h3></a>';
      }

      searchResults.innerHTML = appendString;
    } else {
      searchResults.innerHTML = '<li>No results found</li>';
    }
  }

  var searchTerm = document.getElementById('search-box').value;

  if (searchTerm) {
     // Initalize lunr with the fields it will be searching on. I've given title
    // a boost of 10 to indicate matches on this field are more important.
    var idx = lunr(function () 
    {
      	this.field('id');
      	this.field('title', { boost: 10 });
      	this.field('content');
       	for (var key in json) 
       	{ 
      		this.add({
        			'id': key,
        			'title': json[key].title,
        			'content': json[key].content
      		});
    	}
    });
    console.log("FINISHING INDEX");
     var results = idx.search(searchTerm); // Get lunr to perform a search
     
    console.log("FINISHING SEARCH");
     displaySearchResults(results, json); // We'll write this in the next section
     var serializedIdx = JSON.stringify(idx.toJSON());
     console.log(serializedIdx)
  }
  
    return false;
}
</script>