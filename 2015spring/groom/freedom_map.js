
// The SVG container
var width  = 960,
    height = 550;

var color = d3.scale.category10();

var projection = d3.geo.mercator()
                .translate([480, 300])
                .scale(140);

var path = d3.geo.path()
    .projection(projection);

var svg = d3.select("#map").append("svg")
    .attr("width", width)
    .attr("height", height);

var tooltip = d3.select("#map").append("div")
    .attr("class", "tooltip");

queue()
    .defer(d3.json, "world-110m.json")
    //.defer(d3.tsv, "data/world-country-names.tsv")
    .defer(d3.csv,"freedom_ratings_3.csv")
    .await(ready);

function ready(error, world, names) {

  var countries = topojson.object(world, world.objects.countries).geometries,
      neighbors = topojson.neighbors(world, countries),
      i = -1,
      n = countries.length;
//alert(names[0]);
  countries.forEach(function(d) { 
  //	console.log(d,names);
  if (d.id==-99){
  	d.name = "unknown country";
  } else {
    var currElement = names.filter(function(csvEntry) {return d.id == csvEntry.id; });
    if(currElement[0]){
      d.name = currElement[0].name + ": Freedom rating is: " + currElement[0].rating;
      d.rating = currElement[0].rating;
      console.log(n.id + " ");
    }
    //console.log(d);
	}

});

var country = svg.selectAll(".country").data(countries);
var color = "ABCDEF";
var colorInt = parseInt(color, 16);
var colorIncrement = 200;

  country
   .enter()
    .insert("path")
    .attr("class", function(d,i){return "country" + d.rating;})    
      .attr("title", function(d,i) { return d.name; })
      .attr("d", path)
      .style("fill", function(d, i) {
        //var colorInt = 8517892;
        var countryColor = colorInt + (colorIncrement * d.rating);
        countryColor = countryColor.toString(16);
        countryColor = "#" + countryColor;
        return countryColor;
        /*return color(d.color = d3.max(neighbors[i], function(n) { return countries[n].color; }) + 1 | 0);*/
    });

    //Show/hide tooltip
    country
      .on("mousemove", function(d,i) {
        var mouse = d3.mouse(svg.node()).map( function(d) { return parseInt(d); } );



        tooltip
          .classed("hidden", false)
          .attr("style", "left:"+(mouse[0]+25)+"px;top:"+mouse[1]+"px; position:absolute")
          .html(d.name)
      })
      .on("mouseout",  function(d,i) {
        tooltip.classed("hidden", true)
      });

}