# Metoo movement and the 2018 US midterm elections

1. build
    * 1-downloadTweets
        * GetOldTweets-python (library to scrap tweets from https://github.com/Jefferson-Henrique/GetOldTweets-python)
        * get-old-tweets.ipynb implements the library and saves output to ./tweets-data in the form of *\*month*\*2018.csv
        * main output folder is ./tweets-data:
            * with the main **output files** as ***\*month*\*2018.csv** with *\*month*\* = {jan, feb, ..., nov}
            * merge-separated-months.ipynb merged Sep 2018 data (and Dec 2017) data where I split the months scraping work
		* hashtags
			* get-hashtags.ipynb (gets hashtags.csv)
			* hashtags.csv
        * dependencies:
            * GetOldTweets-python
            
    * 2-downloadGeolocation
        * get-twitteruser-loc.ipynb
            * get user geolocations using the official twitter API---tweepy
            * input files come from ./1-downloadTweets/tweets-data/*\*month*\*.csv
        * out-userGeolocations (is the output folder):
            * main **output file** is **twitter-users-jan2018-6nov2018.csv**
        
        * dependencies:
            * tweepy
            
    * 3-parseGeolocation
        * parseGeolocation.ipynb         
            * input files:
                * ../2-downloadGeolocation/out-userGeolocations/twitter-users-jan2018-6nov2018.csv
                * ./countriesCitiesData/iso-country-codes.csv
                * ./countriesCitiesData/us-counties.csv
                * ./countriesCitiesData/uscitiesv1.4.csv
            * **ouput**:
                * parsed-geoloc.csv (containing twitter users and their profile locations)
        * countriesCitiesData (folder containing countries, cities, counties data, readme.txt lists them and their sources)
            
    * 4-elections2018Data
        * parse-election-data.ipynb
        * VoteCountByStates (folder containing the election vote count by States and counties)
        * output:
            * **counties-election-results.csv**
            * **politicians.csv**
            * county-list.csv
	    
	* 5-election2016Data
		* get-house-2016.ipynb
		* input file --- countypres_2000-2016.csv
		* output files:
			* ./out/house-2016.csv
			* ./out/politicians.csv (contains list of politicians)
			* ./out/politician-edited.csv (contains list of politicians with gender, incumbency, and race)
			
	* 6-internetAccess
		* get-internet-access-data.ipynb
		* input files:
			* countytimeserieslong.xlsx
			* FCC (folder):
				* County Connections Jun 2017.xlsx
				* County Connections Jun 2016.xlsx
				* County Connections Dec 2016.xlsx
				
	* 7-VOTER
		* main input file:
			* ../../metoo-lf/VOTER/2018/VOTER_Survey_April18_Release1.csv
		* get-voter-data.ipynb
			* get data from above and takes care of merging zipcode to FIPS and district
		* processVOTER.ipynb
			* generates the main output variables and save to intermediate data to be merged with final data
		* output files:
			* voter.csv (for county level)
			* voter-district.csv (for district level)
		
    * mergeForStata     
        * election-context-2018.csv (from https://github.com/MEDSL/2018-elections-unoffical)
        * merging.ipynb
            * input files:
				* ..\3-parseGeolocation\output\parsed-geoloc.csv
				* ..\4-election2018Data\output\counties-election-results.csv
				* .\election-context-2018.csv
            * output file:
                * ./output/forStata.csv
        * output:
            * forStata.csv
    
	* summary
		* summary.ipynb
		* output files:
			* examples-parseGeoLoc.csv
			* tweets-ts-week.csv
