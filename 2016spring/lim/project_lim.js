
//To write options from 1960 to 2014
$(function(){
    var $select = $(".1960-2014");
    for (i=1960;i<=2014;i++){
        $select.append($('<option></option>').val(i).html(i))
    }
});




function DrawGraph(){

d3.select("#chart1").selectAll("svg").remove();

var countries = new Array();

    $(document).ready(function() {

    $("#country option:selected").each(function() {
       countries.push($(this).val());
        });

    });


//Initial country
if (countries.length==0) {
    countries.push("Cambodia","Congo, Rep.","United States", "OECD members")}


// Set the dimensions of the canvas / graph
var margin = {top: 30, right: 40, bottom: 30, left: 70};
var width = 560 - margin.left - margin.right;
var height = 400 - margin.top - margin.bottom;

// Set the ranges
var x = d3.scale.linear().range([0, width]);
var y = d3.scale.linear().range([height, 0]);


// Define the axes
var xAxis = d3.svg.axis().scale(x)
    .orient("bottom").ticks(50)
    .tickFormat(d3.format("d"));
    ;

var yAxis = d3.svg.axis().scale(y)
    .orient("left").ticks(10)
    .tickFormat(function(d) { return d + "y"; });


var yAxis2 = d3.svg.axis().scale(y)
    .orient("right").ticks(10)
    .tickFormat(d3.format(".2s"));



// Define the line
var lifeExpectancyline = d3.svg.line()
    .x(function(d) { return x(d.year); })
    .y(function(d) { return y(d.lifeExpectancy); })
    ;
    

var gdp_line = d3.svg.line()
    .x(function(d) { return x(d.year); })
    .y(function(d) { return y(d.GDP); })
    ;


// Adds the svg canvas
var svg = d3.select("#chart1")
    .append("svg")
        .attr("width", width + margin.left + margin.right)
        .attr("height", height + margin.top + margin.bottom)
    .append("g")
        .attr("transform", 
              "translate(" + margin.left + "," + margin.top + ")");






// Get the data
d3.csv("https://raw.githubusercontent.com/nathanlim45/is608/master/final/data/life_exp_long_data.csv", function(data) {
     var data=data.filter(function(row) {

        return countries.indexOf(row['Country.Name'])>-1;
    })

 // Cast Numeric value, handling NaN as zero
      data.forEach(function(d) {
          d.lifeExpectancy = Number(d.lifeExpectancy)||0;
        });


    // Scale the range of the data
    x.domain(d3.extent(data, function(d) { return d.year; }));
    y.domain([d3.min(data, function(d) { return d.lifeExpectancy; }), d3.max(data, function(d) { return d.lifeExpectancy; })]); 





    // Nest the entries by symbol

   var dataNest = d3.nest()
        .key(function(d) {return d["Country.Name"];})
        .entries(data);

    var color = d3.scale.category10();   // set the colour scale

    legendSpace = width/dataNest.length; // spacing for legend

    // Loop through each symbol / key
    dataNest.forEach(function(d,i) { 

        svg.append("path")
            .attr("class", "line")
            .style("stroke", function() {
                return d.color = color(d.key); })
            .style("stroke-opacity", 0.7)
            .attr("d", lifeExpectancyline(d.values));



//legend
        svg.append("text")
        .attr("x", 30) // spacing
        .attr("y", i*20)
        .attr("class", "legend")    // style the legend
        .style("fill", function() { // dynamic colours
            return d.color = color(d.key); })
        .text(d.key);


    });


    // Add the X Axis
    svg.append("g")
        .attr("class", "x axis")
        .attr("transform", "translate(0," + height + ")")
        .call(xAxis)
        .selectAll("text")
        .attr("transform", "rotate(-50)")
        .attr("dx", "-.8em")
        .attr("text-anchor", "end")
        .style("font-size","8px");

var format = d3.format(",.2f");

    // Add the Y Axis
    svg.append("g")
        .attr("class", "y axis")
        .call(yAxis)


});





// Get the data
d3.csv("https://raw.githubusercontent.com/nathanlim45/is608/master/final/data/GDP_cleaned.csv", function(data) {
     var data=data.filter(function(row) {

        return countries.indexOf(row['Country.Name'])>-1;
    })

 // Cast Numeric value, handling NaN as zero
      data.forEach(function(d) {
          d.GDP = Number(d.GDP)||0;
        });


    // Scale the range of the data
    x.domain(d3.extent(data, function(d) { return d.year; }));
    y.domain([d3.min(data, function(d) { return d.GDP; }), d3.max(data, function(d) { return d.GDP; })]); 





    // Nest the entries by symbol

   var dataNest = d3.nest()
        .key(function(d) {return d["Country.Name"];})
        .entries(data);

    var color = d3.scale.category10();   // set the colour scale

    legendSpace = width/dataNest.length; // spacing for legend

    // Loop through each symbol / key
    dataNest.forEach(function(d,i) { 

        svg.append("path")
            .attr("class", "line")
            .style("stroke-dasharray", ("3, 3"))
            .style("stroke-opacity", 0.5)
            .style("stroke", function() {
                return d.color = color(d.key); })
            .attr("d", gdp_line(d.values))
    });

    // Add the X Axis
    svg.append("g")
        .attr("class", "x axis")
        .attr("transform", "translate(0," + height + ")")
        .call(xAxis)
        .selectAll("text")
        .attr("transform", "rotate(-50)")
        .attr("dx", "-.8em")
        .attr("text-anchor", "end")
        .style("font-size","8px");

    svg.append("text")
        .attr("text-anchor", "middle")
        .text("Age");

    svg.append("text")
        .attr("text-anchor", "middle")
        .attr("transform", "translate(" + width + " ,0)")
        .text("GDP($)");

var format = d3.format(",.2f");

    // Add the Y Axis
    svg.append("g")
        .attr("transform", "translate(" + width + " ,0)")
        .attr("class", "y axis")
        .call(yAxis2)

});



};








function DrawMap(){

d3.select("#map").selectAll("svg").remove();

var year = new Array();

    $(document).ready(function() {

    $("#YEAR option:selected").each(function() {
       year.push($(this).val());
        });

    });
var new_year = "Y" + year



var map = d3.geomap.choropleth()
    .geofile('https://rawgit.com/nathanlim45/is608/master/final/d3-geomap/topojson/world/countries.json')
    .colors(colorbrewer.YlGnBu[9])
    .column(new_year)
    .unitId('Country Code')
    .legend(true);

d3.csv('https://raw.githubusercontent.com/nathanlim45/is608/master/final/data/life_exp_data.csv', function(error, data) {
      

    d3.select('#map')
        .datum(data)
        .call(map.draw, map);
});

};






