# Data Pipeline for Loading Realtime Data to a Database
This repo contains scripts designed to extract data from the GTFS API provided by Translink, the transit agency responsible for running the transit service in the Canadian province of British Columbia.

This script reads the vehicle position updates, does some cleaning and transforming before uploading to a Postgres database. There is also capability to write to a csv.

## What Does This Do?
1. Connects to the TransLink Open API and downloads the latest feed
2. Uses generators to read from the downloaded PB file
3. Performs some basic transformation
4. Inserts the data to a Postgres database

## Running the Scripts
To run the scripts, you'll need:
- Python 3+ and related packages specified in the Pipfiles
- Your own API key from TransLink
    - Sensitive information is stored in local environmental variables
- PostgreSQL to store the data

## Terms of Use
By accessing the data, it's automatically assumed that you agree to the [terms of use](https://developer.translink.ca/Home/TermsOfUse). You'll have to agree to them in order to obtain your own key.