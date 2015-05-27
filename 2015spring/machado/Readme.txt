Following is a summary of important files that are in the project.
1) Project.doc : This files contains the description of the project and the implementation details.
2) server.R : This file contains the main analytics code.
3) ui.R: This along with the the server.R file creates the shiny visualizaions.
4) runApp.R: Excecute this file to bootstrap the Shiny server.
5) www/google_charts.html : This file contains the google charts visualization.
6) www/returns.csv:  This file is created when the shiny server is run. It is used for google charts visualization.

The 'Implementation and Installation details' section in the Project.doc file explains how to run the project.

You have to run the shiny server first before running the google charts visualization. 
This is because the returns.csv file used by the google visualiation is created when the shiny server is run.
The shiny server also acts like a web server (through the www folder) for the goolge visualizations.
Use the following URL to view the google charts visualization.
http://127.0.0.1:7777/google_charts.html
The port number is set in the runApp.R file. The Shiny server is also used to serve this file, so it should be up.
The www folder acts like the web root for serving html files. 

