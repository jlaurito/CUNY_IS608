import httplib2

from apiclient.discovery import *
from oauth2client.client import SignedJwtAssertionCredentials

# REPLACE WITH YOUR Project ID
PROJECT_NUMBER = 'premium-weft-555'
# REPLACE WITH THE SERVICE ACCOUNT EMAIL FROM GOOGLE DEV CONSOLE
SERVICE_ACCOUNT_EMAIL = '795597216083-mvv55odvfaalm3056mt2di2mtg9afi1e@developer.gserviceaccount.com'

f = file('0811690b6744c9921161b317fd8c00783bfe1d28-privatekey.p12', 'rb')
key = f.read()
f.close()

credentials = SignedJwtAssertionCredentials(
    SERVICE_ACCOUNT_EMAIL,
    key,
    scope='https://www.googleapis.com/auth/bigquery')

http = httplib2.Http()
http = credentials.authorize(http)

service = build('bigquery', 'v2')
datasets = service.datasets()
#response = datasets.list(projectId=PROJECT_NUMBER).execute(http)

# print('Dataset list:\n')
# for dataset in response['datasets']:
#   print("%s\n" % dataset['id'])

def bq_query(service, query_string, project_id, http, timeout=10000):
    job_collection = service.jobs()
    query_data = {'query':query_string,
                 'timeoutMs':timeout}

    query_reply = job_collection.query(projectId=project_id,
                                     body=query_data).execute(http)

    jobReference=query_reply['jobReference']
    print

    # Timeout exceeded: keep polling until the job is complete.
    while(not query_reply['jobComplete']):
        print 'Job not yet complete...'
        query_reply = job_collection.getQueryResults(
                          projectId=jobReference['projectId'],
                          jobId=jobReference['jobId'],
                          timeoutMs=timeout).execute(http)

    # If the result has rows, print the rows in the reply.
    if('rows' in query_reply):
        #printTableData(query_reply, 0)
        currentRow = len(query_reply['rows'])

        # # Loop through each page of data
        # while('rows' in query_reply and currentRow < query_reply['totalRows']):
        #     query_reply = job_collection.getQueryResults(
        #                       projectId=jobReference['projectId'],
        #                       jobId=jobReference['jobId'],
        #                       startIndex=currentRow).execute()
    
    output = []
    for row in query_reply['rows']:
        output.append(row)

    return output