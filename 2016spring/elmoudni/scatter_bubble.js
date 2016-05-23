


   //function using bubble and scatter charts to show the worst scored restaurants in 2016.
  //Restaurants with scores of 27 or higher are being shown.
   function drawChart(){
   // get data

   //obsolete path
    //    $.get('https://raw.githubusercontent.com/simonnyc/IS608-NYC-data/master/D3_assign06.csv', function(csvData){

    //relative path
        $.get('ScatterChart_final.csv', function(csvData){
          var memoryData = $.csv.toArrays(csvData, {
            onParseValue: $.csv.hooks.castToScalar
          });
        var resData = new google.visualization.DataTable();
                      resData.addColumn('string', 'RESTAURANT');
                      resData.addColumn('number', 'count');
                      // A column for custom tooltip content
                      resData.addColumn({name:'count', type:'number', role:'tooltip'});

        var tempArray = [];
        for (i = 1; i < memoryData.length; i++){
          tempArray.push([memoryData[i][2],memoryData[i][3], memoryData[i][4]]);
        };
        resData.addRows(tempArray);
        console.log(resData);
        var options = {
                        title: 'Chart 1\nCritical Violations Count and Scores (2016)',
                        colors: [ '#5DADE2', '#2980B9', '#1F618D'],
                        // This line makes the entire category's tooltip active.
                        focusTarget: 'category',
                       // Use an HTML tooltip.
                        tooltip: { isHtml: true },
                        width: 600,
                        height: 500,
                        hAxis: {title: 'Count',
                                minValue: resData.getColumnRange(1).min,
                                maxValue: resData.getColumnRange(1).max
                              },
                        vAxis: { textStyle: {
                                            color: 'black',
                                            fontName: 'Arial',
                                            fontSize: 12
                                            },
                              title: 'Score ',titleTextStyle: {fontName: 'Arial Black'},
                              minValue: resData.getColumnRange(2).min,
                                maxValue: resData.getColumnRange(2).max
                              },
                       hAxis: { textStyle: {
                                            color: 'black',
                                            fontName: 'Arial',
                                            fontSize: 12
                                            },
                                title: 'Restaurant',titleTextStyle: {fontName: 'Arial Black'},
                                minValue: resData.getColumnRange(1).min,
                                maxValue: resData.getColumnRange(1).max
                               },
                        legend: 'none',
                        bars: 'horizontal'
                     }
        var chart = new google.visualization.ScatterChart(document.getElementById('ViolationChar1'));
        chart.draw(resData, options);
        })

        // bubble chart code starts here...
        // get data
        //obsolete path
        // $.get('https://raw.githubusercontent.com/simonnyc/IS608-NYC-data/master/Gchart2_assign06.csv',function(csvData){

        //relative path
         $.get('BubbleChart_final.csv',function(csvData){
          var memoryData2 = $.csv.toArrays(csvData, {
            onParseValue: $.csv.hooks.castToScalar
          });
        var presData2 = new google.visualization.DataTable();
                      presData2.addColumn('string', 'GRADE');
                      presData2.addColumn('number', 'Score');
                      presData2.addColumn('number', 'count');
                      presData2.addColumn('string', 'Restaurant');

        var tempArray2 = [];
        for (i = 1; i < memoryData2.length; i++){
          tempArray2.push([memoryData2[i][0], memoryData2[i][1],memoryData2[i][2], memoryData2[i][3]]);
         };

        presData2.addRows(tempArray2);
        var options2 = {
               title: 'Chart 2\nCritical Violations Count and Score Grade (2016)',
               colors: ['#AED6F1', '#85C1E9', '#5DADE2', '#2980B9', '#1F618D'],
               width: 600,
               height: 500,
                hAxis: {title: 'Count',
                                minValue: 0,
                                maxValue: 70
                              },
               vAxis: { textStyle: {
                                    color: 'black',
                                    fontName: 'Arial',
                                    fontSize: 12
                                    },
                              title: 'Number of Critical Violations ',titleTextStyle: {fontName: 'Arial Black'},
                              minValue: 0,
                              maxValue: 15
                              },
               hAxis: { textStyle: {
                                    color: 'black',
                                    fontName: 'Arial',
                                    fontSize: 12
                                    },
                      title: 'Score',titleTextStyle: {fontName: 'Arial Black'},
                      minValue: 0,
                      maxValue: 70
                      },
               sizeAxis: {minValue: 0,  maxSize: 12},
               bubble: {
               textStyle: {
               auraColor: 'none'
          }
        }
      };


        var chart = new google.visualization.BubbleChart(document.getElementById('bubble_chart_div'));
          chart.draw(presData2, options2);

        })
        // bubble chart code ends here...
   };
   drawChart();
