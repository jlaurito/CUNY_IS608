

// Bar Chart: Top Ten Counties Total
//
(function () {

    var margin = { top: 20, right: 20, bottom: 30, left: 40 },
        width = 900 - margin.left - margin.right,
        height = 400 - margin.top - margin.bottom;

    var x0 = d3.scale.ordinal()
               .rangeRoundBands([0, width], .1);

    var x1 = d3.scale.ordinal();

    var y = d3.scale.linear()
               .range([height, 0]);

    var color = d3.scale.ordinal()
                  .range(["crimson", "steelblue", "gold"]);

    var xAxis = d3.svg.axis()
                  .scale(x0)
                  .orient("bottom");

    var yAxis = d3.svg.axis()
                  .scale(y)
                  .orient("left")
                  .tickFormat(d3.format(".2s"));

    var svg = d3.select("#byTopCountyPayment").append("svg")
                .attr("width", width + margin.left + margin.right)
                .attr("height", height + margin.top + margin.bottom)
              .append("g")
                .attr("transform", "translate(" + margin.left + "," + margin.top + ")");

    d3.tsv("Data/BarChart/TopCountiesTotal.tsv", function (error, data) {

        var groups = ["TotalChargedSum", "TotalAllowedSum", "TotalPaymentSum"];

        data.forEach(function (d) {
            d.amounts = groups.map(function (name) { return { name: name, value: +d[name] }; });
        });

        x0.domain(data.map(function (d) { return d.County; }));
        x1.domain(groups).rangeRoundBands([0, x0.rangeBand()]);
        y.domain([0, d3.max(data, function (d) { return d3.max(d.amounts, function (d) { return d.value; }); })]);

        svg.append("g")
            .attr("class", "x axis")
            .attr("transform", "translate(0," + height + ")")
            .call(xAxis);

        svg.append("g")
            .attr("class", "y axis")
            .call(yAxis)
          .append("text")
            .attr("transform", "rotate(-90)")
            .attr("y", 6)
            .attr("dy", ".71em")
            .style("text-anchor", "end")
            .text("Amount in Millions");

        var state = svg.selectAll(".state")
            .data(data)
          .enter().append("g")
            .attr("class", "g")
            .attr("transform", function (d) { return "translate(" + x0(d.County) + ",0)"; });

        state.selectAll("rect")
            .data(function (d) { return d.amounts; })
          .enter().append("rect")
            .attr("width", x1.rangeBand())
            .attr("x", function (d) { return x1(d.name); })
            .attr("y", function (d) { return y(d.value); })
            .attr("height", function (d) { return height - y(d.value); })
            .style("fill", function (d) { return color(d.name); });


        var legend = svg.selectAll(".legend")
            .data(["TotalAllowedSum", "TotalChargedSum", "TotalPaymentSum"])
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

// Bar Chart: Top Ten Counties Count
//
(function () {

    var margin = { top: 20, right: 20, bottom: 30, left: 40 },
        width = 900 - margin.left - margin.right,
        height = 400 - margin.top - margin.bottom;

    var x0 = d3.scale.ordinal()
               .rangeRoundBands([0, width], .1);

    var x1 = d3.scale.ordinal();

    var y = d3.scale.linear()
               .range([height, 0]);

    var color = d3.scale.ordinal()
                  .range(["darkmagenta", "darkgreen", "orange"]);

    var xAxis = d3.svg.axis()
                  .scale(x0)
                  .orient("bottom");

    var yAxis = d3.svg.axis()
                  .scale(y)
                  .orient("left")
                  .tickFormat(d3.format(".2s"));

    var svg = d3.select("#byTopCountyUtilization").append("svg")
                .attr("width", width + margin.left + margin.right)
                .attr("height", height + margin.top + margin.bottom)
              .append("g")
                .attr("transform", "translate(" + margin.left + "," + margin.top + ")");

    d3.tsv("Data/BarChart/TopCountiesTotal.tsv", function (error, data) {

        var groups = ["ServiceCount", "BeneficiaryServiceCount", "UniqueBeneficiaries"];

        //var groups = ["AverageChargedSum", "AverageAllowedSum", "AveragePaymentSum"];

        data.forEach(function (d) {
            d.amounts = groups.map(function (name) { return { name: name, value: +d[name] }; });
        });

        x0.domain(data.map(function (d) { return d.County; }));
        x1.domain(groups).rangeRoundBands([0, x0.rangeBand()]);
        y.domain([0, d3.max(data, function (d) { return d3.max(d.amounts, function (d) { return d.value; }); })]);

        svg.append("g")
            .attr("class", "x axis")
            .attr("transform", "translate(0," + height + ")")
            .call(xAxis);

        svg.append("g")
            .attr("class", "y axis")
            .call(yAxis)
          .append("text")
            .attr("transform", "rotate(-90)")
            .attr("y", 6)
            .attr("dy", ".71em")
            .style("text-anchor", "end")
            .text("Amount in Millions");

        var state = svg.selectAll(".state")
            .data(data)
          .enter().append("g")
            .attr("class", "g")
            .attr("transform", function (d) { return "translate(" + x0(d.County) + ",0)"; });

        state.selectAll("rect")
            .data(function (d) { return d.amounts; })
          .enter().append("rect")
            .attr("width", x1.rangeBand())
            .attr("x", function (d) { return x1(d.name); })
            .attr("y", function (d) { return y(d.value); })
            .attr("height", function (d) { return height - y(d.value); })
            .style("fill", function (d) { return color(d.name); });


        var legend = svg.selectAll(".legend")
            .data(groups)
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


// Bar Chart: Top Ten Counties Total
//
(function () {

    var margin = { top: 20, right: 20, bottom: 30, left: 40 },
        width = 900 - margin.left - margin.right,
        height = 400 - margin.top - margin.bottom;

    var x0 = d3.scale.ordinal()
               .rangeRoundBands([0, width], .1);

    var x1 = d3.scale.ordinal();

    var y = d3.scale.linear()
               .range([height, 0]);

    var color = d3.scale.ordinal()
                  .range(["crimson", "steelblue", "gold"]);

    var xAxis = d3.svg.axis()
                  .scale(x0)
                  .orient("bottom");

    var yAxis = d3.svg.axis()
                  .scale(y)
                  .orient("left")
                  .tickFormat(d3.format(".2s"));

    var svg = d3.select("#byTopSpecialtyPayment").append("svg")
                .attr("width", width + margin.left + margin.right)
                .attr("height", height + margin.top + margin.bottom)
              .append("g")
                .attr("transform", "translate(" + margin.left + "," + margin.top + ")");

    d3.tsv("Data/BarChart/TopSpecialtiesTotal.tsv", function (error, data) {

        var groups = ["TotalChargedSum", "TotalAllowedSum", "TotalPaymentSum"];

        data.forEach(function (d) {
            d.amounts = groups.map(function (name) { return { name: name, value: +d[name] }; });
        });

        x0.domain(data.map(function (d) { return d.Specialty; }));
        x1.domain(groups).rangeRoundBands([0, x0.rangeBand()]);
        y.domain([0, d3.max(data, function (d) { return d3.max(d.amounts, function (d) { return d.value; }); })]);

        //svg.append("g")
        //	.attr("class", "x axis")
        //	.attr("transform", "translate(0," + height + ")")
        //	.call(xAxis);


        svg.append("g")
            .attr("class", "x axis")
            .attr("transform", "translate(0," + height + ")")
            .call(xAxis)
          .selectAll(".tick text")
            .call(wrap, x0.rangeBand());

        svg.append("g")
            .attr("class", "y axis")
            .call(yAxis)
          .append("text")
            .attr("transform", "rotate(-90)")
            .attr("y", 6)
            .attr("dy", ".71em")
            .style("text-anchor", "end")
            .text("Amount in Millions");

        var state = svg.selectAll(".state")
            .data(data)
          .enter().append("g")
            .attr("class", "g")
            .attr("transform", function (d) { return "translate(" + x0(d.Specialty) + ",0)"; });

        state.selectAll("rect")
            .data(function (d) { return d.amounts; })
          .enter().append("rect")
            .attr("width", x1.rangeBand())
            .attr("x", function (d) { return x1(d.name); })
            .attr("y", function (d) { return y(d.value); })
            .attr("height", function (d) { return height - y(d.value); })
            .style("fill", function (d) { return color(d.name); });


        var legend = svg.selectAll(".legend")
            .data(["TotalAllowedSum", "TotalChargedSum", "TotalPaymentSum"])
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

    function wrap(text, width) {
        text.each(function () {
            var text = d3.select(this),
                words = text.text().split(/\s+/).reverse(),
                word,
                line = [],
                lineNumber = 0,
                lineHeight = 1.1, // ems
                y = text.attr("y"),
                dy = parseFloat(text.attr("dy")),
                tspan = text.text(null).append("tspan").attr("x", 0).attr("y", y).attr("dy", dy + "em");
            while (word = words.pop()) {
                line.push(word);
                tspan.text(line.join(" "));
                if (tspan.node().getComputedTextLength() > width) {
                    line.pop();
                    tspan.text(line.join(" "));
                    line = [word];
                    tspan = text.append("tspan").attr("x", 0).attr("y", y).attr("dy", ++lineNumber * lineHeight + dy + "em").text(word);
                }
            }
        });
    }

})();

// Bar Chart: Top Ten Counties Count
//
(function () {

    var margin = { top: 20, right: 20, bottom: 30, left: 40 },
        width = 900 - margin.left - margin.right,
        height = 400 - margin.top - margin.bottom;

    var x0 = d3.scale.ordinal()
               .rangeRoundBands([0, width], .1);

    var x1 = d3.scale.ordinal();

    var y = d3.scale.linear()
               .range([height, 0]);

    var color = d3.scale.ordinal()
                  .range(["darkmagenta", "darkgreen", "orange"]);

    var xAxis = d3.svg.axis()
                  .scale(x0)
                  .orient("bottom");

    var yAxis = d3.svg.axis()
                  .scale(y)
                  .orient("left")
                  .tickFormat(d3.format(".2s"));

    var svg = d3.select("#byTopSpecialtyUtilization").append("svg")
                .attr("width", width + margin.left + margin.right)
                .attr("height", height + margin.top + margin.bottom)
              .append("g")
                .attr("transform", "translate(" + margin.left + "," + margin.top + ")");

    d3.tsv("Data/BarChart/TopSpecialtiesTotal.tsv", function (error, data) {

        var groups = ["ServiceCount", "BeneficiaryServiceCount", "UniqueBeneficiaries"];

        //var groups = ["AverageChargedSum", "AverageAllowedSum", "AveragePaymentSum"];

        data.forEach(function (d) {
            d.amounts = groups.map(function (name) { return { name: name, value: +d[name] }; });
        });

        x0.domain(data.map(function (d) { return d.Specialty; }));
        x1.domain(groups).rangeRoundBands([0, x0.rangeBand()]);
        y.domain([0, d3.max(data, function (d) { return d3.max(d.amounts, function (d) { return d.value; }); })]);

        //svg.append("g")
        //	.attr("class", "x axis")
        //	.attr("transform", "translate(0," + height + ")")
        //	.call(xAxis);

        svg.append("g")
            .attr("class", "x axis")
            .attr("transform", "translate(0," + height + ")")
            .call(xAxis)
          .selectAll(".tick text")
            .call(wrap, x0.rangeBand());

        svg.append("g")
            .attr("class", "y axis")
            .call(yAxis)
          .append("text")
            .attr("transform", "rotate(-90)")
            .attr("y", 6)
            .attr("dy", ".71em")
            .style("text-anchor", "end")
            .text("Amount in Millions");

        var state = svg.selectAll(".state")
            .data(data)
          .enter().append("g")
            .attr("class", "g")
            .attr("transform", function (d) { return "translate(" + x0(d.Specialty) + ",0)"; });

        state.selectAll("rect")
            .data(function (d) { return d.amounts; })
          .enter().append("rect")
            .attr("width", x1.rangeBand())
            .attr("x", function (d) { return x1(d.name); })
            .attr("y", function (d) { return y(d.value); })
            .attr("height", function (d) { return height - y(d.value); })
            .style("fill", function (d) { return color(d.name); });


        var legend = svg.selectAll(".legend")
            .data(groups)
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

    function wrap(text, width) {
        text.each(function () {
            var text = d3.select(this),
                words = text.text().split(/\s+/).reverse(),
                word,
                line = [],
                lineNumber = 0,
                lineHeight = 1.1, // ems
                y = text.attr("y"),
                dy = parseFloat(text.attr("dy")),
                tspan = text.text(null).append("tspan").attr("x", 0).attr("y", y).attr("dy", dy + "em");
            while (word = words.pop()) {
                line.push(word);
                tspan.text(line.join(" "));
                if (tspan.node().getComputedTextLength() > width) {
                    line.pop();
                    tspan.text(line.join(" "));
                    line = [word];
                    tspan = text.append("tspan").attr("x", 0).attr("y", y).attr("dy", ++lineNumber * lineHeight + dy + "em").text(word);
                }
            }
        });
    }

})();
