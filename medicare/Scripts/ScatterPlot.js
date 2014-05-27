
// Scatter Plot: Provider Spending for Internal Medicince in Cook County
//
(function () {
    var margin = { top: 20, right: 10, bottom: 30, left: 40 },
        width = 800 - margin.left - margin.right,
        height = 500 - margin.top - margin.bottom;

    var x = d3.scale.linear()
        .range([0, width]);

    var y = d3.scale.linear()
        .range([height, 0]);

    var color = d3.scale.category10();

    var xAxis = d3.svg.axis()
        .scale(x)
        .orient("bottom");

    var yAxis = d3.svg.axis()
        .scale(y)
        .orient("left");

    var svg = d3.select("#scatterCookIntMedNPI").append("svg")
        .attr("width", width + margin.left + margin.right)
        .attr("height", height + margin.top + margin.bottom)
      .append("g")
        .attr("transform", "translate(" + margin.left + "," + margin.top + ")");

    d3.tsv("Data/ScatterPlot/Cook_IM_NPI.tsv", function (error, data) {
        data.forEach(function (d) {
            d.TotalPaymentSum = +d.TotalPaymentSum;
            d.ServiceCount = +d.ServiceCount;
        });

        x.domain(d3.extent(data, function (d) { return d.ServiceCount; })).nice();
        y.domain(d3.extent(data, function (d) { return d.TotalPaymentSum; })).nice();

        svg.append("g")
            .attr("class", "x axis")
            .attr("transform", "translate(0," + height + ")")
            .call(xAxis)
          .append("text")
            .attr("class", "label")
            .attr("x", width)
            .attr("y", -6)
            .style("text-anchor", "end")
            .text("Service Count (K)");

        svg.append("g")
            .attr("class", "y axis")
            .call(yAxis)
          .append("text")
            .attr("class", "label")
            .attr("transform", "rotate(-90)")
            .attr("y", 6)
            .attr("dy", ".71em")
            .style("text-anchor", "end")
            .text("Payment Amount (K)")

        svg.selectAll(".dot")
            .data(data)
          .enter().append("circle")
            .attr("class", "dot")
            .attr("r", function (d) { return d.UniqueBeneficiaries; })
            .attr("cx", function (d) { return x(d.ServiceCount); })
            .attr("cy", function (d) { return y(d.TotalPaymentSum); })
            .style("fill", function (d) { return color(d.npi); });

        var legend = svg.selectAll(".legend")
            .data(color.domain().slice(0, 10))
          .enter().append("g")
            .attr("class", "legend")
            .attr("transform", function (d, i) { return "translate(0," + i * 20 + ")"; });

        legend.append("rect")
            .attr("x", width - 18)
            .attr("width", 18)
            .attr("height", 18)
            .style("fill", color);

        legend.append("text")
            .attr("x", width - 24)
            .attr("y", 9)
            .attr("dy", ".35em")
            .style("text-anchor", "end")
            .text(function (d) { return d; });

    });

})();


// Scatter Plot: Payment for 99232 in ZipCode 6085
//
(function () {

    (function () {
        var margin = { top: 20, right: 20, bottom: 30, left: 50 },
            width = 800 - margin.left - margin.right,
            height = 500 - margin.top - margin.bottom;

        var x = d3.scale.linear()
            .range([0, width]);

        var y = d3.scale.linear()
            .range([height, 0]);

        var r = d3.scale.linear()
            .range([3, 30]);

        var color = d3.scale.category10();

        var xAxis = d3.svg.axis()
            .scale(x)
            .orient("bottom");

        var yAxis = d3.svg.axis()
            .scale(y)
            .orient("left");

        var svg = d3.select("#scatter60805_99232").append("svg")
            .attr("width", width + margin.left + margin.right)
            .attr("height", height + margin.top + margin.bottom)
          .append("g")
            .attr("transform", "translate(" + margin.left + "," + margin.top + ")");

        d3.tsv("Data/ScatterPlot/Zip_99232_Payments.tsv", function (error, data) {
            data.forEach(function (d) {
                d.TotalPaymentSum = +d.TotalPaymentSum;
                d.ServiceCount = +d.ServiceCount;
            });

            x.domain(d3.extent(data, function (d) { return d.ServiceCount; })).nice();
            y.domain(d3.extent(data, function (d) { return d.TotalPaymentSum; })).nice();
            r.domain(d3.extent(data, function (d) { return d.bene_unique_cnt; })).nice();

            svg.append("g")
                .attr("class", "x axis")
                .attr("transform", "translate(0," + height + ")")
                .call(xAxis)
              .append("text")
                .attr("class", "label")
                .attr("x", width)
                .attr("y", -6)
                .style("text-anchor", "end")
                .text("Total Services");

            svg.append("g")
                .attr("class", "y axis")
                .call(yAxis)
              .append("text")
                .attr("class", "label")
                .attr("transform", "rotate(-90)")
                .attr("y", 6)
                .attr("dy", ".71em")
                .style("text-anchor", "end")
                .text("Total Payment")

            svg.selectAll(".dot")
                .data(data)
              .enter().append("circle")
                .attr("class", "dot")
                .attr("r", function (d) { return r(d.bene_unique_cnt); })
                .attr("cx", function (d) { return x(d.ServiceCount); })
                .attr("cy", function (d) { return y(d.TotalPaymentSum); })
                .style("fill", function (d) { return color(d.npi); });

            var legend = svg.selectAll(".legend")
                .data(color.domain())
              .enter().append("g")
                .attr("class", "legend")
                .attr("transform", function (d, i) { return "translate(0," + i * 20 + ")"; });

            legend.append("rect")
                .attr("x", 18)
                .attr("width", 18)
                .attr("height", 18)
                .style("fill", color);

            legend.append("text")
                .attr("x", 40)
                .attr("y", 9)
                .attr("dy", ".35em")
                .style("text-anchor", "front")
                .text(function (d) { return d; });

        });

    })();

})();
