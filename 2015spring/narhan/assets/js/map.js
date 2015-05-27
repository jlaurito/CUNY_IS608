/**
 * Created by jnarhan on 5/16/15.
 */
var width = document.getElementById('container2').offsetWidth;
var height = width/2;

var map_svg, projection, path;
var mcolors = ["#1D5983", "#157B7B", "#CC5823", "#CC8323"];
var mcolor = d3.scale.ordinal();

d3.csv("./assets/data/final_data_copy.csv", function(data) {
    mcolor.domain(data.map(function (d) {return d.Rank2013; }));
    mcolor.range(mcolors);

    d3.json("./assets/data/world-topo-min.json", function(error, json) {
        if (error) {
            return console.error(error);
        }

        projection = d3.geo.mercator()
            .translate([(width/2), (height/2)])
            .scale( width/Math.PI/2);
        path = d3.geo.path()
            .projection(projection);

        var countries = topojson.feature(json, json.objects.countries).features;
        //console.log(countries[0].properties.name);

        for (var i=0; i < data.length; i++) {
            var dataCountry = data[i].Country;
            var dataRating = data[i].Rank2013;
            var dataDen = data[i].Den2013;
            var dataHDI = Math.round(data[i].HDI_13 * 1000)/1000;
            var dataRank = data[i].Rank;

            for (var j=0; j < countries.length; j++) {
                if (dataCountry == countries[j].properties.name) {
                    countries[j].properties.rating = dataRating;
                    countries[j].properties.hdi = dataHDI;
                    countries[j].properties.den = dataDen;
                    countries[j].properties.rank = dataRank;

                    continue; // stop looking through the JSON
                }
            }
        }

        map_svg = d3.select('#container2')
            .append('svg')
            .attr('width', width)
            .attr('height', height);

        map_svg.selectAll('path')
            .data(countries)
            .enter()
            .append('path')
            .attr('d', path)
            .attr('class', 'country')
            .attr('name', function(d) { return d.properties.name; })
            .style('fill', function(d) {
                var value = d.properties.rating;
                if (value) {
                    return(mcolor(value))
                } else {
                    return "#ccc";
                }
            })
            .on('mouseout', function() {
                d3.select('#mtooltip').classed('hidden', true)
            })
            .on('mouseover', function(d) {
                var coordinates = [0,0];
                coordinates = d3.mouse(this);
                //Get x/y values, then augment for the tooltip
                var xPosition = coordinates[0];
                var yPosition = coordinates[1];

                var mtipData = "Country: " + d.properties.name;
                var mtipData2 = "Rank: " + d.properties.rank;
                var mtipData3 = "Score: " + d.properties.hdi;
                var mtipData4 = "PPL/Square KM: " + d.properties.den;

                //Update the tooltip position and value
                d3.select("#mtooltip")
                    .style("left", xPosition + "px")
                    .style("top", yPosition + "px")
                    .select('#value2')
                    .html(mtipData + '<br/>' + mtipData2 + '<br/>' + mtipData3 + '<br/>' + mtipData4);

                //Show the tooltip
                d3.select("#mtooltip").classed("hidden", false);

            });

    });

}); // end of cvs read

