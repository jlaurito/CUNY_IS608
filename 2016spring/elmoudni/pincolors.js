
    // Set a callback to run when the Google Visualization API is loaded.
    google.charts.setOnLoadCallback(drawMap);

    //function using google map pin colors to show the worst and best 50 scored restaurants in 2016.
    // green pins show restaurants with better score; red pins show restaurants with bad pins

    function drawMap () {

      //obsolete oath
     // $.get("https://raw.githubusercontent.com/simonnyc/IS608-NYC-data/master/best50_worst50_lat_long.csv", function(csvString) {

      // relative path
       $.get("best50_worst50_lat_long.csv", function(csvString) {
      // transform the CSV string into a 2-dimensional array
        var arrayData = $.csv.toArrays(csvString, {onParseValue: $.csv.hooks.castToScalar});

        // this new DataTable object holds all the data
        var data = new google.visualization.arrayToDataTable(arrayData);

      // this view can select a subset of the data at a time
        var view = new google.visualization.DataView(data);
        view.setColumns([0,2]);
        var url = 'http://icons.iconarchive.com/icons/icons-land/vista-map-markers/48/';

        var options = {
                title:'50 Best and 50 worst Restaurants in Manhattan ',
                zoomLevel: 12,
                showTip: true,
                useMapTypeControl: true,
                icons: {
                      blue: {
                            normal:   url + 'Map-Marker-Ball-Azure-icon.png',
                            selected: url + 'Map-Marker-Ball-Right-Azure-icon.png'
                      },
                      green: {
                            normal:   url + 'Map-Marker-Push-Pin-1-Chartreuse-icon.png',
                            selected: url + 'Map-Marker-Push-Pin-1-Right-Chartreuse-icon.png'
                      },
                      pink: {
                            normal:   url + 'Map-Marker-Ball-Pink-icon.png',
                            selected: url + 'Map-Marker-Ball-Right-Pink-icon.png'
                      }
                }
      };
      var map = new google.visualization.Map(document.getElementById('map_div'));
      map.draw(data, options);
      }
      )
    };
