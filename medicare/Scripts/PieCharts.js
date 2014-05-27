
// Pie Chart: US Federal Budget 2012
//
(function () {
    var width = 400,
        height = 400,
        radius = Math.min(width, height) / 2;

    var color = d3.scale.ordinal()
        .range(["dodgerblue", "dodgerblue", "dodgerblue", "dodgerblue", "dodgerblue", "dodgerblue", "orange"]);

    var arc = d3.svg.arc()
              .outerRadius(radius - 10)
              .innerRadius(0);

    var pie = d3.layout.pie()
        .sort(null)
        .value(function (d) { return d.Percent; });

    var svg = d3.select("#pieFederalBudget").append("svg")
        .attr("width", width)
        .attr("height", height)
      .append("g")
        .attr("transform", "translate(" + width / 2 + "," + height / 2 + ")");

    d3.csv("Data/PieChart/FederalBudget.tsv", function (error, data) {

        data.forEach(function (d) {
            d.Percent = +d.Percent;
        });

        var g = svg.selectAll(".arc")
            .data(pie(data))
          .enter().append("g")
            .attr("class", "arc");

        g.append("path")
            .attr("d", arc)
            .style("fill", function (d) { return color(d.data.Category); });

        g.append("text")
            .attr("transform", function (d) { return "translate(" + arc.centroid(d) + ")"; })
            .attr("dy", ".35em")
            .style("text-anchor", "middle")
            .text(function (d) { return d.data.Category; });
    });

})();


// Pie Chart: US Medicare Budget 2012
//
(function () {
    var width = 400,
        height = 400,
        radius = Math.min(width, height) / 2;

    var color = d3.scale.ordinal()
        .range(["dodgerblue", "orange", "dodgerblue", "dodgerblue", "dodgerblue", "dodgerblue", "dodgerblue"]);

    var arc = d3.svg.arc()
              .outerRadius(radius - 10)
              .innerRadius(0);

    var pie = d3.layout.pie()
        .sort(null)
        .value(function (d) { return d.Percent; });

    var svg = d3.select("#pieMedicareBudget").append("svg")
        .attr("width", width)
        .attr("height", height)
      .append("g")
        .attr("transform", "translate(" + width / 2 + "," + height / 2 + ")");

    d3.csv("Data/PieChart/MedicareBreakdown.tsv", function (error, data) {

        data.forEach(function (d) {
            d.Percent = +d.Percent;
        });

        var g = svg.selectAll(".arc")
            .data(pie(data))
          .enter().append("g")
            .attr("class", "arc");

        g.append("path")
            .attr("d", arc)
            .style("fill", function (d) { return color(d.data.Category); });

        g.append("text")
            .attr("transform", function (d) { return "translate(" + arc.centroid(d) + ")"; })
            .attr("dy", ".35em")
            .style("text-anchor", "middle")
            .text(function (d) { return d.data.Category; });
    });

})();
