/**
 * Created by jnarhan on 5/16/15.
 */
var datafile = "./assets/data/DenHDI_2013_copy.csv";  // Default view 2013 data

// Creating a selection box to pick the year for data viz:
var denYrs = ['2013 Data', '2010 Data', '2000 Data', '1990 Data', '1980 Data'];

var select = d3.select('.densityYears')
    .append('select')
    .attr('class', 'select')
    .on('change', onchange);

var options = select.selectAll('option')
    .data(denYrs)
    .enter()
    .append('option')
    .text(function(d) { return d;});

function onchange() {
    selectedVal = d3.select('select').property('value');

    switch (selectedVal) {
        case "2013 Data":
            datafile='./assets/data/DenHDI_2013_copy.csv';
            break;
        case "2010 Data":
            datafile='./assets/data/DenHDI_2010_copy.csv';
            break;

        case "2000 Data":
            datafile='./assets/data/DenHDI_2000_copy.csv';
            break;

        case "1990 Data":
            datafile='./assets/data/DenHDI_1990_copy.csv';
            break;

        case "1980 Data":
            datafile='./assets/data/DenHDI_1980_copy.csv';
            break;

        default:
            break;
    }

    updateData();
}

// Setting up the SVG
var width = document.getElementById('container').offsetWidth;
var height = width/ 2, padding = 40;
var dpsize = 7; // default size for circles on scatter plot.

var svg = d3.select('body')
    .append('svg')
    .attr('width',  width)
    .attr('height', height);

var colors = ["#C52231", "#CC9E23", "#2D298E", "#8ABE21"];
var color = d3.scale.ordinal()
    .domain(["Low", "Medium", "High", "Very High"])
    .range(colors);
var xAxis, yAxis;

d3.csv(datafile, function(error, data) {
    if (error) {
        console.log(error);

    } else {
        hdi = data.map( function(d) {
            return {
                "Country" :  d.Country,
                "Log_Den" : +d.Log_Density,
                "HDI"     : +d.HDI,
                "Ranking" :  d.HDI_2013_Rank
            };
        });

        console.log(hdi);
        // organize scales on the SVG
        xS = getXScale(hdi);
        yS = getYScale(hdi);

        // Adding tooltips
        var tipData ='';

        var tip = d3.tip()
            .attr('class', 'd3-tip')
            .html(function(d) { return tipData })
            .direction('ne');

        function toolMove() { return svg.call(tip);};
        function writeTip() { return toolMove(); };

        // Visualize the data on first load of page
        svg.append('g')
            .attr('id', 'circles')
            .selectAll('circle')
            .data(hdi)
            .enter()
            .append('circle')
            .attr('id', function(d) { return d.Country})
            .attr('cx', padding)
            .attr('cy', height - padding)
            .attr('r', 1)
            .text( function (d){ return d.Country;})
            .on('mousemove', tip.show)
            .on('mouseout', tip.hide)
            .on('mouseover', function(d) {
                tipData = d.Country;
                return toolMove();
            })
            .transition()
            .delay( function(d,i) { return (setDel(d.Ranking))})
            .duration(4000)
            .attr('cx', function(d) {return xS(d.Log_Den)})
            .attr('cy', function(d) {return (yS(d.HDI))})
            .attr('r', dpsize)
            .attr('fill', function(d) { return color(d.Ranking)});

        // Add scales
        setAxis(xS, yS);

        // Add legend and legend title
        svg.selectAll('.legendlabel')
            .data(["2013 HDI Ranking"])
            .enter().append('g')
            .attr('class', 'legendlabel')
            .attr('transform', 'translate(' + (width) + ',15)')
            .append('text')
            .style("text-anchor", "end")
            .text(function(d) { return d; });

        var legend = svg.selectAll('.legend')
            .data(color.domain())
            .enter().append('g')
            .attr('class', 'legend')
            .attr('transform', function(d, i) { return 'translate(0,' + (i+1) * 20 + ')'; });

        legend.append('rect')
            .attr('x', width - 18)
            .attr('width', 18)
            .attr('height', 18)
            .style('fill', color);

        legend.append('text')
            .attr('x', width - 24)
            .attr('y', 9)
            .attr('dy', '.35em')
            .style('text-anchor', 'end')
            .text(function(d) { return d; });

    }
});

// Get the values of min and max of both x (Density) and y (HDI) for the visualization
function getXScale(dataset) {
    var minDen = d3.min(dataset.map(function(d) {return d.Log_Den}));
    var maxDen = d3.max(dataset.map(function(d) {return d.Log_Den}));
    var legPadding = 100;
    console.log([minDen, maxDen]);

    return( d3.scale.linear()
        .domain([minDen, maxDen])
        .range([padding, width - padding - legPadding]));
}

function getYScale(dataset) {
    var minHDI = d3.min(dataset.map(function(d) {return d.HDI}));
    var maxHDI = d3.max(dataset.map(function(d) {return d.HDI}));
    console.log([minHDI, maxHDI]);


    return (d3.scale.linear()
        .domain([minHDI, maxHDI])
        .range([height - padding, padding])); // (0,0) is top left. Flip the mapping of domain to range.
}

function addDataPoints(dataset, xScale, yScale) {

    svg.selectAll('circle')
        .data(dataset)
        .transition()
        .duration(1000)
        .transition()
        .delay( function(d,i) { return (setDel(d.Ranking))})
        .duration(4000)
        .attr('cx', function(d) {return xScale(d.Log_Den)})
        .attr('cy', function(d) {return (yScale(d.HDI))})
        //.attr('r', function(d) { return (setSize(d.Ranking))})
        .attr('r', dpsize)
        .attr('fill', function(d) { return color(d.Ranking)});
}

function setDel(val) {
    switch (val) {
        case "Very High":
            return 1800;
        case "High":
            return 1200;
        case "Medium":
            return 800;
        case "Low":
            return 50;
        default:
            return 0;
    }
}


function setAxis(xScale, yScale) {
    xAxis = d3.svg.axis()
        .scale(xScale).orient('bottom')
        .ticks(5);
    yAxis = d3.svg.axis()
        .scale(yScale).orient('left')
        .ticks(5);

    // Add it to the plot
    svg.append('g')
        .attr('class', 'x axis')
        .attr('transform', 'translate(0,' + (height-padding + 5) +')')
        .call(xAxis)
        .append('text')
        .attr('x', width)
        .attr('dy','-7')
        .style('text-anchor', 'end')
        .text('Log of Population Density');

    svg.append('g')
        .attr('class', 'y axis')
        .attr('transform', 'translate(' + (padding -5) + ',0)')
        .call(yAxis)
        .append('text')
        .attr("transform", "rotate(-90)")
        .attr("y", 10)
        .attr("dy", ".5em")
        .style('text-anchor', 'end')
        .text('Human Development Index');
}

function updateData() {
    d3.csv(datafile, function(error, data) {
        if (error) {
            console.log(error);

        } else {
            hdi = data.map( function(d) {
                return {
                    "Country" :  d.Country,
                    "Log_Den" : +d.Log_Density,
                    "HDI"     : +d.HDI,
                    "Ranking" :  d.HDI_2013_Rank
                };
            });

            console.log(hdi);
            // organize scales on the SVG
            xS = getXScale(hdi);
            yS = getYScale(hdi);
            // Functions to visualize the data
            addDataPoints(hdi, xS, yS);
            // update the axis
            xAxis.scale(xS);
            yAxis.scale(yS);
            svg.select('.x.axis')
                .transition()
                .duration(1500)
                .call(xAxis);
            svg.select('.y.axis')
                .transition()
                .duration(1500)
                .call(yAxis);


            var legend = svg.selectAll(".legend")
                .data(color.domain())
            //.enter().append("g")
            //.attr("class", "legend")
            //.attr("transform", function(d, i) { return "translate(0," + i * 20 + ")"; });

            legend.append("rect")
                .attr("x", width - 18)
                .attr("width", 18)
                .attr("height", 18)
                .style("fill", color);


        }
    });
}

