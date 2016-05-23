# -*- coding: utf-8 -*-
"""
Created on Mon May  9 10:48:44 2016

@author: JeffAtLaptop
"""

# ISDA608 - Final Project - Jeffrey Burmood
#
# Load libraries
import urllib
import lxml.html
import zipfile
import pymongo
import os

# This function will build a list of zipped files to be downloaded from the NOAA website. We're
# only going to focus on the newer "zip" files, not the "tar.gz" files just because of the sheer
# number of files involved. The zip files will provide us with a history from 5/2007 - 4/2016.
#
def retrieveWeatherFiles(baselink, workingDir):
    connection = urllib.urlopen(baselink)
    dom = lxml.html.fromstring(connection.read())

# Now we need to find each link URL that contains a ZIP archive file. We will then perform
# a GET on that URL to initiate a download of the associated ZIP archive
    count = 0
    for link in dom.xpath('//a/@href'):
        if ('01.zip' in link):
            print "retrieving ZIP file # ", count
            urllib.urlretrieve(baselink+link, workingDir+link)
            count = count + 1

# This function will populate the DB with data contained in the ZIP archive files in
# the "./datasets" directory. Both a station data and a weather data file from
# the archive are extracted and read. The extracted data is loaded into the DB using the
# provided collection.
#
def populateDatabase(db, filepath):        
    zfile = zipfile.ZipFile(filepath)
    filenames = zfile.namelist()
# find the file name with "station" substring
    for names in filenames:
        if 'station' in names:
            stationfilename = names
            break

    stationFile = zfile.open(stationfilename)
# now readline each line, break up theline, and place needed elements into DB
    header = stationFile.readline() # the first line in the file is a header
    for line in stationFile:
        stationList = line.split("|")
        if len(stationList) == 15: # if all elements present
            if validStation(stationList):
                # load valid elements 0, 6, 7, 9 10 into DB
                wban = stationList[0]
                stname = stationList[6]
                ststate = stationList[7]
                stlat = stationList[9]
                stlong = stationList[10]
                stationEntry={"wban":wban,"stname":stname,"ststate":ststate,"long":stlong,"lat":stlat}
                db.station.update({"wban":wban}, stationEntry, upsert=True)
# Now do the same thing for the monthly weather data        
# find the file name with "monthly" substring
    for names in filenames:
        if 'monthly' in names:
            weatherfilename = names
            break

    weatherFile = zfile.open(weatherfilename)
# now readline each line, break up theline, and place needed elements into DB
    header = weatherFile.readline() # first line in the file is a header
    for line in weatherFile:
        weatherList = line.split(",")
        if len(weatherList) == 50: # if all elements present
            if validWeather(weatherList): # if a valid list
                # load valid elements 6, 7, 9 10 into DB
                weatherwban = weatherList[0]
                yrmon = weatherList[1]
                tavg = weatherList[6]
                dewpt = weatherList[8]
                weatherEntry={"wban":weatherwban,"yrmon":yrmon, "tavg":tavg, "dewpt":dewpt}
                db.weather.insert(weatherEntry)            
    
        
# This function will validate if the provided parameter is a string, empty, or null
# Each of the data fields we will be using is checked for available data, and that
# a string of some sort of information is available. Whatever program generated the data files
# frequently uses the character "M" to indicate missing data, but not always.
def validStr(str):
    if str:
        if str.strip():
            if ('M' in str and len(str) <= 1):
                return False
            else:
                return True
        else:
            return False
    else:
        return False

# This function is used to validate the various fields within a provided weather data entry.
def validWeather(entrydata):
    if not validStr(entrydata[0]):
        return False
    if not validStr(entrydata[1]):
        return False
    if not validStr(entrydata[6]):
        return False
    if not validStr(entrydata[8]):
        return False
    return True
    
# This function is used to validate the various fields within a provided station data entry.
def validStation(entrydata):
    if not validStr(entrydata[0]):
        return False
    if not validStr(entrydata[6]):
        return False
    if not validStr(entrydata[7]):
        return False
    if not validStr(entrydata[9]):
        return False
    if not validStr(entrydata[10]):
        return False
    return True
    
# This function will convert a fahrenheit temperature to celsius and return the result.
# The formula is C = (F - 32) * 5/9
def convertToC(temp):
    return (temp-32.0)*(5.0/9.0)


if __name__ == "__main__":
    # One of the first things we need to do is retrieve the historical weather data from  the NOAA
    # webiste. This is a multi-step process which requires we first download all of the zipped
    # files.
    #
    baselink='http://www.ncdc.noaa.gov/orders/qclcd/'
    workingDir = './datasets/'
    retrieveWeatherFiles(baselink, workingDir)
    
    print "Done downloading ZIP archive files from the web"
    
    # Now, read in the weather and station data from the ZIP archive files that we downloaded into
    # our working directory
    
    # This code will create a connection to the remote MongoDB database. You'll need to update the
    # IP and port number if you are using a different configuration.
    connection = pymongo.MongoClient('192.168.1.3',27017)
    db = connection.weatherDB
    
    # Now cycle through every file in our dataset working directory and, if it is a zip file, extract the
    # files and fields we need and use them to populate the database.
    fileList = os.listdir(workingDir)
    for file in fileList:
        if ".zip" in file:
            print "Working on ", file
            populateDatabase(db,workingDir+file)
    
    print "Done extracting data from the ZIP archive files and populating the database"
