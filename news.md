---
layout: other
title: News
---
<div class="w3-row-padding w3-container">
    <div class="w3-twothird">
    	{% for post in site.posts %}
            {% capture modulo %}{{ forloop.index0 | modulo :4 }}{% endcapture %}
            {% if forloop.index0 ==4 %}
                </div>
                <div id="social-networks" class="w3-third">
                <table>
                    <tr>
                        <td width="25%">
                            <i class='fa fa-facebook-official w3-text-blue' aria-hidden='true' onclick='facebook();'></i>
                        </td>
                        <td width="25%">
                            <i class='fa fa-git w3-text-blue' aria-hidden='true' onclick='commits();'></i>
                        </td>
                        <td width="25%">
                            <i class='fa fa-github w3-text-blue' aria-hidden='true' onclick='issues();'></i>
                        </td>
                        <td width="25%">
                            <i class='fa fa-google w3-text-blue' aria-hidden='true' onclick='google();'></i>
                        </td>
                    </tr>
                </table>
                <div id="quotes">
                </div>
            {% endif %}
            {% if modulo == '0'%}
            </div>
            <div class="w3-twothird">
            {% endif %}
        <div class="w3-quarter">
          <img src="{{post.image}}" alt="Gama Post" style="width:100%">
          <h3><a href="{{ post.url }}">{{ post.title }}</a></h3>
          <p><small><strong>{{ post.date | date: "%B %e, %Y" }} - {{ post.author }}</strong> -  {{ post.categories| join: ' '  }}  <a href="http://dphilippon.github.io{{ post.url }}"></a></small></p>			
          <div class="span10">
                <p>{{ post.content | strip_html | truncatewords: 20 }}
                </p>
          </div>
        </div>	
        {% endfor %}	
    </div>
    
    
</div>
<script>
  $( document ).ready(function() 
  {
    facebook();
  });
  function facebook()
  {
        $.getJSON('https://graph.facebook.com/238065426321929/feed?access_token=229040647557399|MQKFlFYX7YW25XGj4GUYZ7B1lcY', function(data) 
        {
		var ahtml="";
		for(var i = 0; i < 5; i++) 
                {
		
			var d = new Date(data["data"][i]["created_time"]);
			ahtml=ahtml+"<div class='w3-border-top w3-border-bottom'>";
			if("message" in data["data"][i])
			{
				ahtml=ahtml+"<i class='fa  fa-2x fa-facebook-official w3-text-blue' aria-hidden='true'></i><small> - "+d.getDate()  + "-" + (d.getMonth()) + "-" + d.getFullYear() + " " +d.getHours() + ":" + d.getMinutes()+"</small><p>"+data["data"][i]["message"]+" ";
			}
			else
			{
				ahtml=ahtml+"<i class='fa  fa-2x fa-facebook-official w3-text-blue' aria-hidden='true'></i><small> - "+d.getDate()  + "-" + (d.getMonth()) + "-" + d.getFullYear() + " " +d.getHours() + ":" + d.getMinutes()+"</small><p>"+data["data"][i]["story"]+" ";
			}
			ahtml=ahtml+"</p></div>";
		}
		ahtml=ahtml+"";
		$("#quotes").html(ahtml);
		$("#quotes").linkify();
	});
  }
  
  function issues()
  {
       		
        $.getJSON('https://api.github.com/repos/gama-platform/gama/issues', function(data) 
        {
                var ahtml="";
                for(var i = 0; i < 5; i++) {
                        ahtml=ahtml+"<div class='w3-border-top w3-border-bottom'>";
                        var d = new Date(data[i]["created_at"]);
                        ahtml=ahtml+"<i class='fa  fa-2x fa-github w3-text-blue' aria-hidden='true'></i><small> -"+d.getDate()  + "-" + (d.getMonth()+1) + "-" + d.getFullYear() + " " +d.getHours() + ":" + d.getMinutes()+"</small><p>"+data[i]["title"]+" by "+data[i]["user"]["login"]+" <a href='"+data[i]["html_url"]+"'> See more</a>";
                        ahtml=ahtml+"</p></div>";
                }
                ahtml=ahtml+"";
                $("#quotes").html(ahtml);
                $("#quotes").linkify();
        });
  }
  function commits()
  {
       		
        $.getJSON('https://api.github.com/repos/gama-platform/gama/commits', function(data) 
        {
                var ahtml="";
                for(var i = 0; i < 5; i++) 
                {
                        ahtml=ahtml+"<div class='w3-border-top w3-border-bottom'>";
                        var d = new Date(data[i]["commit"]["author"]["date"]);
                        ahtml=ahtml+"<i class='fa  fa-2x fa-git w3-text-blue' aria-hidden='true'></i><small> - "+d.getDate()  + "-" + (d.getMonth()) + "-" + d.getFullYear() + " " +d.getHours() + ":" + d.getMinutes()+"</small><p>"+data[i]["commit"]["message"]+" by "+data[i]["commit"]["author"]["name"]+" <a href='"+data[i]["html_url"]+"'> See more</a>";
                        ahtml=ahtml+"</p></div>";
                }
                ahtml=ahtml+"";
                $("#quotes").html(ahtml);
                $("#quotes").linkify();
        });
  }
  
  function google()
  {
       		
        $.getJSON('https://api.rss2json.com/v1/api.json?rss_url=https%3A%2F%2Fgroups.google.com%2Fforum%2Ffeed%2Fgama-platform%2Ftopics%2Frss.xml%3Fnum%3D15', function(data) 
        {
                var ahtml="";
                for(var i = 0; i < 5; i++) {
                        ahtml=ahtml+"<div class='w3-border-top w3-border-bottom'>";
                        var d = new Date(data["items"][i]["pubDate"]);
                        ahtml=ahtml+"<i class='fa  fa-2x fa-google w3-text-blue' aria-hidden='true'></i><small> - "+d.getDate()  + "-" + (d.getMonth()) + "-" + d.getFullYear() + " " +d.getHours() + ":" + d.getMinutes()+"</small><p>"+data["items"][i]["title"]+" by "+data["items"][i]["author"]+" <a href='"+data["items"][i]["link"]+"'> See more</a>";
                        ahtml=ahtml+"</p></div>";

                }
                ahtml=ahtml+"";
                $("#quotes").html(ahtml);
                $("#quotes").linkify();
        });
  }
  
</script>
