## Data on countries, cities, counties

Files:
	* countries_codes_and_coordinates.csv (https://gist.github.com/tadast/8827699)
	* iso-country-codes.csv 
	* toponyms.csv (https://github.com/datasets/world-cities)
	* us_cities_states_counties.csv (https://github.com/grammakov/USA-cities-and-states/blob/master/us_cities_states_counties.csv)
	* uscitiesv1.4.csv (https://simplemaps.com/data/us-cities)
	* us-counties.csv (parsed version of us_cities_states_counties.csv)
	* world-cities.csv (https://simplemaps.com/data/world-cities)

Files I used:
	* iso-country-codes.csv 
	* uscitiesv1.4.csv

### Notes on uscitiesv1.4.csv Simplemaps data: 
* Added Bristol County to Rhode Island in uscitiesv1.4.csv (uscitiesv1.4-original.csv is the original unaltered file)
* Contains only mapping of City/Town/Municipality to a primary county, defined by USGS as the centriod of the city (take the average point of a city's shape and see which county that point belongs to)
