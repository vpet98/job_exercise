#!/usr/bin/python3

# import libraries
import requests
from statistics import mean

# initialize variables
maxLat = -90
maxAvgTemp = -float('Inf')

# API host and basepath
baseURL = 'http://localisation.flotteoceanographique.fr/api/v2'

# send GET request to API to collect vessels
subdomains = '/vessels' # specific API endpoint
resp = requests.get(url = baseURL+subdomains) # send request and save the response as response object
vessels = resp.json() # extract data in json format


for v in vessels:
    # for each vessel collect positions in year 2021
    subdomains = '/vessels/' + v['id'] + '/positions'
    parameters = {'startDate':'2021-01-01T00:00:00.000Z', 'endDate':'2021-12-31T23:59:59.000Z'}
    resp = requests.get(url = baseURL+subdomains, params = parameters)
    positions = resp.json()

    # calculate vessel's maximum latitude found
    maxLatOfVessel = max([p['lat'] for p in positions])
    # if vessel's latitude greater than current maximum value, keep it
    if maxLat < maxLatOfVessel:
        maxLat = maxLatOfVessel
        maxLatName = v['name']

    # calculate vessel's average temperature
    # Note: some positions['data'] objects are empty
    avgTempOfVessel = mean([p['data']['seatemp'] for p in positions if 'seatemp' in p['data']])
    # if vessel's average temperature greater than current maximum value, keep it
    if maxAvgTemp < avgTempOfVessel:
        maxAvgTemp = avgTempOfVessel
        maxAvgTempName = v['name']


# print results
print('The name of the vessel which went most in North in 2021 is ' + maxLatName +
' and reached a position with latitude +' + str(maxLat) + '.')

print('The name of the vessel which collected the maximum average sea temperature in it\'s overall travel in 2021 is '
+ maxAvgTempName + ' and the corresponding temperature is ' + str(maxAvgTemp) + ' degrees Celsius.')
