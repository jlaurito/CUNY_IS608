
 // Set a callback to run when the Google Visualization API is loaded.
 google.charts.setOnLoadCallback(drawVisualization)

    // function using chart filtering to show the performance of five known coffee shops in Manhattan over the years (2012-2016).
   //The five restaurants are (Starbucks, Gregory’s, Dunkin donuts, the Coffee Bean Tea and Leaf, and Piccolo Cafe).
     function drawVisualization() {
         var dashboard = new google.visualization.Dashboard(
             document.getElementById('dashboard'));

         debugger;
         var control = new google.visualization.ControlWrapper({
           'controlType': 'ChartRangeFilter',
           'containerId': 'control',
           'options':
           {
             // Filter by the date axis.
             'filterColumnIndex': 0,
             'ui': {
                    'chartType': 'LineChart',
                    'chartOptions':
                        {
                            'chartArea': {'width': '90%'},
                            'hAxis': {'baselineColor': 'none'}
                        },

               // Display a single series that shows the score of each restaurant.
               // Thus, this view has two columns: the date (axis) and the average score value (line series).
                    'chartView':
                        {
                            'columns': [0, 2]
                        },

                    }
           },
           // Initial range: 2012-01-01 to 2012-01-01.
           'state': {'range': {'start': new Date(2012, 1, 1), 'end': new  Date(2016, 1, 1)}}
         });

      debugger;

         var chart = new google.visualization.ChartWrapper({
           'chartType': 'LineChart',
           'containerId': 'chart',
           'options': { title: 'Chart 4\nTop Coffee Shops Scores since 2012',
                        hAxis: {
                                textStyle : {fontSize: 8 },
                                title: 'Year',
                                minValue: 0
                                },
                        vAxis: {  textStyle : {fontSize: 8 },
                                title: 'Score'
                                },
                        colors: ['#AED6F1', '#85C1E9', '#5DADE2', '#2980B9', '#1F618D'],

             // Use the same chart area width as the control for axis alignment.
                        'chartArea': {'height': '80%', 'width': '90%'},
                        'hAxis': {'slantedText': false},
                        'vAxis': {'viewWindow': {'min': 0, 'max': 24}},
                        'legend': {'position': 'none'}
           },
           // Convert the first column from 'date' to 'string'.
           'view': {
                'columns': [
                        { 'calc': function(dataTable, rowIndex)
                            {
                                return dataTable.getFormattedValue(rowIndex, 0);
                            },
                            'type': 'string'
                        }, 1, 2, 3, 4, 5
                ]
           }
         });

      debugger;
        var data = new google.visualization.DataTable();
            data.addColumn('date', 'Year');
            data.addColumn('number', 'STARBUCKS');
            data.addColumn('number', 'DUNKIN DONUTS');
            data.addColumn('number', 'PICCOLO CAFE');
            data.addColumn('number', 'THE COFFEE BEAN TEA LEAF');
            data.addColumn('number', 'GREGORYS COFFEE');

            data.addRows([
            [new Date(2012,1,1),8,12.4,18.2,17.33,13.76],
            [new Date(2013,1,1),9.96,13.99,15.5,11,10],
            [new Date(2014,1,1),16.3,11.28,12.93,11.4,14.21],
            [new Date(2015,1,1),9.07,13.5,15.73,11.18,11.57],
            [new Date(2016,1,1),9.2,9.57,11.33,19.8,20.88]
            ]);

            dashboard.bind(control, chart);
            dashboard.draw(data);
      }

     google.setOnLoadCallback(drawVisualization);
