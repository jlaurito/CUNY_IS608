************** Deployment Instructions **********************

The files needed to deploy the project are all contained within the "DeploymentFiles" folder.  There are two html pages, 1 css file and
a sub folder of images.  You should be able to run the project simply by opening one of the two html pages in a browser (Chrome, Firefox, IE 10 tested).

You should be able to serve these pages with any simple webserver.  IIS, IIS Express and Tomcat all work fine on my end for this purpose.

To ease deployment, the data for this project is being served by the DangleFactory servers through a webservice.  The URLs for the service calls
can be found in the <script> portion of the "Visuals.html" file.  The webservice here uses Microsoft's WebAPI technology and I've allowed for access
to the project specific service resources from all domains.  Note that this is a potential security concern (from the DangleFactory) and does open those resources up to a particular flavor of DoS attacks.  

The data comes back as JSON.  It should be live now.  Please let me know ASAP if the pages are not able to hit the service endpoints when you run the project.

************** Reference Folder ******************************

Nothing in this folder is required to run the project.  It is simply provided to provide some transparency as to what's happening on the server side of the application.  

The application is a basic 3 tier architecture.


1) database (MS SQL Server, cloud hosted)
2) webservice (MS WebAPI, MVC5)
3) client (javascript, jquery, google charts, html, css)

The basic flow of the application is as follows.

On page load: 
	- page makes ajax calls to service resources
        - service handles requests and brokers calls to database through Microsoft's Entity Framework ORM
        - the database processes the query and returns the result to the service
        - the service transforms the query result into JSON and sends it back to the page
        - page accepts JSON data and transforms it into visuals.

I've included a representative sample of the service code.  You won't be able to run/compile it.  That shouldn't matter as again, the data is already
being hosted live and is publicly accessible.  This representative sample is coded in C# and can be found in (For Reference Only) -> WebService -> DFSController.

I've also included the raw return data (as .csv files) for the two main views used in the application.  This can be found in (For Reference Only) ->RawData -> ViewOutputs.  This is only for reference and does not have to be deployed anywhere.


If you have any problems, please contact me immediately.  I do check my CUNY email occasionally but jhink7@gmail.com is a better place to reach me.

Thanks for the term,

-Justin Hink