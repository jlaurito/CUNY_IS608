
(function () {
    var width = 460,
        height = 400,
        radius = Math.min(width, height) / 2;

    var color = d3.scale.ordinal()
        .range(["#98abc5", "#8a89a6", "#7b6888", "#6b486b", "#a05d56", "#d0743c", "#ff8c00"]);

    // This is for Donut chart
    //var arc = d3.svg.arc()
    //	.outerRadius(radius - 10)
    //	.innerRadius(radius - 90);

    var arc = d3.svg.arc() //this will create <path> elements for us using arc data
              .outerRadius(radius - 10)
              .innerRadius(0);

    var pie = d3.layout.pie()
        .sort(null)
        .value(function (d) { return d.population; });

    var svg = d3.select("#federal").append("svg:svg")
        .attr("width", width)
        .attr("height", height)
      .append("g")
        .attr("transform", "translate(" + width / 2 + "," + height / 2 + ")");

    d3.csv("Data/PieChart/FederalBudget.tsv", function (error, data) {

        data.forEach(function (d) {
            d.population = +d.population;
        });

        var g = svg.selectAll(".arc")
            .data(pie(data))
          .enter().append("g")
            .attr("class", "arc");

        g.append("path")
            .attr("d", arc)
            .style("fill", function (d) { return color(d.data.age); });

        g.append("text")
            .attr("transform", function (d) { return "translate(" + arc.centroid(d) + ")"; })
            .attr("dy", ".35em")
            .style("text-anchor", "middle")
            .text(function (d) { return d.data.age; });
    });

})();


(function () {
    var width = 460,
        height = 400,
        radius = Math.min(width, height) / 2;

    var color = d3.scale.ordinal()
        .range(["#98abc5", "#8a89a6", "#7b6888", "#6b486b", "#a05d56", "#d0743c", "#ff8c00"]);


    var arc = d3.svg.arc()
              .outerRadius(radius - 10)
              .innerRadius(0);

    var pie = d3.layout.pie()
        .sort(null)
        .value(function (d) { return d.population; });

    var svg = d3.select("#medicare").append("svg:svg")
        .attr("width", width)
        .attr("height", height)
      .append("g")
        .attr("transform", "translate(" + width / 2 + "," + height / 2 + ")");

    d3.csv("Data/PieChart/MedicareBreakdown.tsv", function (error, data) {

        data.forEach(function (d) {
            d.population = +d.population;
        });

        var g = svg.selectAll(".arc")
            .data(pie(data))
          .enter().append("g")
            .attr("class", "arc");

        g.append("path")
            .attr("d", arc)
            .style("fill", function (d) { return color(d.data.age); });

        g.append("text")
            .attr("transform", function (d) { return "translate(" + arc.centroid(d) + ")"; })
            .attr("dy", ".35em")
            .style("text-anchor", "middle")
            .text(function (d) { return d.data.age; });
    });

})();
