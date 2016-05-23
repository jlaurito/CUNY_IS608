
   // Load the Visualization API and the controls package.
   google.charts.load('current', {'packages':['corechart', 'controls', 'map', 'table']});

    // Set a callback to run when the Google Visualization API is loaded.
   google.charts.setOnLoadCallback(drawDashboard)

   // function using dashboard and controls to show the score of five known coffee shops in Manhattan over the years (2012-2016).
   //The five restaurants are (Starbucks, Gregory’s, Dunkin donuts, the Coffee Bean Tea and Leaf, and Piccolo Cafe).
   function drawDashboard() {
       // the summarized coffee shop data derived over the years 2012-2016
      var data = google.visualization.arrayToDataTable([
         ['Year','STARBUCKS','DUNKIN DONUTS','PICCOLO CAFE','THE COFFEE BEAN TEA LEAF','GREGORYS COFFEE'],
         ['2012 ',8,12.4,18.2,17.33,13.76],
         ['2013 ',9.96,13.99,15.5,11,10],
         ['2014 ',16.3,11.28,12.93,11.4,14.21],
         ['2015 ',9.07,13.5,15.73,11.18,11.57],
         ['2016 ',9.2,9.57,11.33,19.8,20.88]
        ]);

        // Create a dashboard.
      var dashboard = new google.visualization.Dashboard(
            document.getElementById('dashboard_div'));

        // Create a range slider, passing some options
      var coffeeRangeSlider = new google.visualization.ControlWrapper({
          'controlType': 'NumberRangeFilter',
          'containerId': 'filter_div',
          'options': {
                        'filterColumnLabel': 'STARBUCKS',
                    'ui': { 'label': 'Score' }
                    },

      });

        // Create a line chart, passing some options
      var LineChart = new google.visualization.ChartWrapper({
          'chartType': 'LineChart',
          'containerId': 'chart_div',
          'options': {
                title: 'Chart 3\nTop Coffee Shops since 2012 ',
                'width': 600,
                'height': 500,
                'pieSliceText': 'value',
                'legend': 'right',
                 hAxis: {
                        textStyle : {fontSize: 12, color: 'black' },
                        title: 'Year',titleTextStyle: {fontName: 'Arial Black'},
                        minValue: 0
                 },
                 vAxis: {
                        textStyle : {fontSize: 12, color: 'black' },
                        title: 'Score',titleTextStyle: {fontName: 'Arial Black'}
                 },
                  colors: ['#AED6F1', '#85C1E9', '#5DADE2', '#2980B9', '#1F618D']

          }
      });

        // Establish dependencies, declaring that 'filter' drives 'lineChart',
        // so that the line chart will only display entries that are let through
        // given the chosen slider range.
      dashboard.bind(coffeeRangeSlider, LineChart);

        // Draw the dashboard.
        dashboard.draw(data);
   };
