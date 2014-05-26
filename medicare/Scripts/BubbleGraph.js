
// Bubble Graph: Specialties
//
(function () {
    var diameter = 800,
format = d3.format(",d");

    var bubble = d3.layout.pack()
        .sort(null)
        .size([diameter, diameter])
        .padding(1.5);

    var svg = d3.select("#bySpecialtyUS").append("svg")
        .attr("width", diameter)
        .attr("height", diameter)
        .attr("class", "bubble");

    d3.json("Data/BubbleGraph/BubbleGraph.json", function (error, data) {
        var node = svg.selectAll(".node")
            .data(bubble.nodes(data)
            .filter(function (d) { return !d.children; }))
          .enter().append("g")
            .attr("class", "node")
            .attr("transform", function (d) { return "translate(" + d.x + "," + d.y + ")"; });

        node.append("title")
            .text(function (d) { return d.className + ": " + format(d.value); });

        node.append("circle")
            .attr("r", function (d) { return d.r; })
            .style("fill", "dodgerblue");

        node.append("text")
            .attr("dy", ".3em")
            .style("text-anchor", "middle")
            .text(function (d) { return d.className.substring(0, d.r / 3); });
    });
})();
