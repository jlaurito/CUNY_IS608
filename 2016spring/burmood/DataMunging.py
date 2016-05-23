# -*- coding: utf-8 -*-
"""
Created on Tue Apr 26 10:11:04 2016

@author: JeffAtLaptop
"""

# ISDA 608 Final Project - Jeffrey Burmood
#
# Load libraries
import pymongo
import pandas as pd

# This function will convert a fahrenheit temperature to celsius and return the result.
# The formula is C = (F - 32) * 5/9
def convertToC(temp):
    return (temp-32.0)*(5.0/9.0)

# This function will calculate and return a relative humidity (RH) value based on the provided ambient 
# temperature and dewpoint temperature values. All calculations are performed in celsius units and the incoming
# temperatures are in fahrenheit so they will be converted to celsius first.
#
def calcRH(dewpt, ambient):
    dewpt = float(dewpt)
    ambient = float(ambient)
    
    m = 7.591386
    tn = 240.7663  # constants from reference table for anticipated temp range
    
    dewptC = convertToC(dewpt)
    ambientC = convertToC(ambient)
    
    exp = m * ((dewptC/(dewptC+tn)) - (ambientC/(ambientC+tn)))
    rh = 100.0 * (10**exp)
    
    if rh >= 100.0:  # if the resulting calculation arrives at RH at or above 100%, round down to 99.9 for accuracy
        rh = 99.9
        
    return round(rh,1)

if __name__ == "__main__":
    # At this point, the data has been read in the weather and station data from the ZIP archive files, cleaned up, 
    # and loaded into the MongoDB. Now, we extract the data and perform the data munging we need to 
    # get the data in the format we need for analysis and visualization.
    
    # This code will create a connection to the MongoDB database.
    connection = pymongo.MongoClient()
    db = connection.weatherDB
    
    # Now build two dataframes by extracting the data in MongoDB, one for the weather data, 
    # and one for the station data.
    stationL = []
    scur = db.station.find()  # set up a cursor to read from the station collection
    for station in scur:
        stationL.append(station)
    
    stationDF_raw = pd.DataFrame(stationL, columns=['long','lat', 'stname', 'ststate', 'wban'])

    # We only want the stations in the 50 US states so remove all others.
    fifty = stationDF_raw['ststate'] != 'VI'
    
    stationDF = stationDF_raw[fifty]
    
    fifty = stationDF_raw['ststate'] != 'PR'
    
    stationDF = stationDF[fifty]

    fifty = stationDF_raw['ststate'] != 'GU'
    
    stationDF = stationDF[fifty]

    fifty = stationDF_raw['ststate'] != 'MP'
    
    stationDF = stationDF[fifty]

    fifty = stationDF_raw['ststate'] != 'CQ'
    
    stationDF = stationDF[fifty]

    fifty = stationDF_raw['ststate'] != 'FM'
    
    stationDF = stationDF[fifty]

    fifty = stationDF_raw['ststate'] != 'PC'
    
    stationDF = stationDF[fifty]

    weatherL = []
    wcur = db.weather.find()  # set up a cursor to read from the station collection
    for weather in wcur:
        weatherL.append(weather)
    
    # Add the water production "wp" column so we can calculate the water production value later and add it
    # easily to the data frame.
    weatherDF = pd.DataFrame(weatherL, columns=['dewpt', 'tavg', 'wban', 'yrmon', 'wp'])
    
    # Convert the unicode values backs to floats
    weatherDF['dewpt'] = weatherDF['dewpt'].astype(float)
    weatherDF['tavg'] = weatherDF['tavg'].astype(float)
    
    # Now, calculate the monthly relative humidity for each monthly weather entry based on
    # the temperature and the dew point temperature. Then, using the water production
    # model formula, caluclate the estimated monthly water production based on the monthly
    # relative humidity. Incorporate the water production values into the weather data frame as a new column.
    
    waterprod = []

    for i in range(len(weatherDF)):
        rh = calcRH(weatherDF['dewpt'][i], weatherDF['tavg'][i])
        # Based on the RH, apply the monthly water production rate (liters/month)
        # This is based on a linear model derived from published water production rates 
        wp = -76.364 + 6.164*rh
        # Make adjustments for production rates that come out negative. Negative results mean the
        # monthly relative humidity average is less than 30% which is where the competing system 
        # is unable to generate measureable water.
        if wp < 0.0:
            wp = 0.0
        
        waterprod.append(round(wp,1))
    
    weatherDF['wp'] = waterprod
    
    # Get a list of the unique yr/month values
    dateInfo = weatherDF['yrmon'].unique()
    
    # This loop will build a subset of all reporting stations for a given yr/month
    for i in range(len(dateInfo)):
        
        weatherSubset = (weatherDF['yrmon']==dateInfo[i])
        
        weather = weatherDF[weatherSubset]

        # Group all of the weather data by the station ID (wban) and calculate the mean for each station.
        # This represents the average numeric values over the time period for each station.

        stMean = weather.groupby('wban').mean() 

        # Set up the groupby wban index correctly so we can use it to merge with the station DF
        stMeanR = stMean.reset_index()
    
        # Now aggregate the weather data and the station location data based on the station ID (wban)
        # using the groupedBy object.
        results = stMeanR.merge(stationDF, how='outer', on='wban')
        resultsclean = results.dropna(how='any')
    
        # Construct the CSV filename from the yr/month being worked on
        fileName = dateInfo[i] + ".csv"
        
        resultsclean.to_csv(fileName)
        
        print "Working on Date ", dateInfo[i]
        
    
    print "All Done!"