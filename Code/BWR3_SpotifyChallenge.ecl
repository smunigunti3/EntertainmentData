IMPORT $;
SpotMusic := $.File_Music.SpotDS;

//display the first 150 records

OUTPUT(CHOOSEN(SpotMusic, 150), NAMED('Raw_MusicDS'));


//*********************************************************************************
//*********************************************************************************

//                                CATEGORY ONE 

//*********************************************************************************
//*********************************************************************************

//Challenge: 
//Sort songs by genre and count the number of songs in your total music dataset 

 

//Sort by "genre" (See SORT function)
genreSort := SORT(SpotMusic, genre);

//Display them: (See OUTPUT)
OUTPUT(genreSort, NAMED('SortedByGenre'));

//Count and display result (See COUNT)
//Result: Total count is 1159764:
totalSongs := COUNT(genreSort);
OUTPUT(totalSongs, NAMED('NumSongsSortedByGenre'));

//*********************************************************************************
//*********************************************************************************

//Challenge: 
//Display songs by "garage" genre and then count the total 
//Filter for garage genre and OUTPUT them:
garageSongs := SpotMusic(genre = 'garage');
OUTPUT(garageSongs, NAMED('GarageSongs'));

//Count total garage songs
//Result should have 17123 records:
numGarageSongs := COUNT(garageSongs);
OUTPUT(numGarageSongs, NAMED('NumGarageSongs'));

//*********************************************************************************
//*********************************************************************************

//Challenge: 
//Count how many songs was produced by "Prince" in 2001

//Filter ds for 'Prince' AND 2001
prince2001Songs := SpotMusic(Artist_name = 'Prince' AND year = 2001);

//Count and output total - should be 35 
num20001PrinceSongs := COUNT(prince2001Songs);
OUTPUT(num20001PrinceSongs, NAMED('Num2001PrinceSongs'));


//*********************************************************************************
//*********************************************************************************

//Challenge: 
//Who sang "Temptation to Exist"?

// Result should have 1 record and the artist is "New York Dolls"

//Filter for "Temptation to Exist" (name is case sensitive)

//Display result 
OUTPUT(SpotMusic(Track_name = 'Temptation to Exist'), NAMED('TemptationToExist'));

//*********************************************************************************
//*********************************************************************************

//Challenge: 
//Output songs sorted by Artist_name and track_name, respectively

//Result: First few rows should have Artist and Track as follows:
// !!! 	Californiyeah                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        
// !!! 	Couldn't Have Known                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  
// !!! 	Dancing Is The Best Revenge                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          
// !!! 	Dear Can   
// (Yes, there is a valid artist named "!!!")                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          


//Sort dataset by Artist_name, and track_name:
sortByArtistAndTrack := SORT(SpotMusic, Artist_name, Track_name);

//Output here:
OUTPUT(SORT(SpotMusic, Artist_name, Track_name), NAMED('SortedByArtistAndTrack'));


//*********************************************************************************
//*********************************************************************************

//Challenge: 
//Find the MOST Popular song using "Popularity" field

//Get the most Popular value (Hint: use MAX)
mostPop := MAX(SpotMusic, Popularity);

//Filter dataset for the mostPop value


//Display the result - should be "Flowers" by Miley Cyrus
OUTPUT(SpotMusic(Popularity = mostPop), NAMED('MostPopularSong'));


//*********************************************************************************
//*********************************************************************************

//                                CATEGORY TWO

//*********************************************************************************
//*********************************************************************************

//Challenge: 
//Display all games produced by "Coldplay" Artist AND has a 
//"Popularity" greater or equal to 75 ( >= 75 ) , SORT it by title.
//Count the total result

//Result has 9 records

//Get songs by defined conditions
coldplaySongs := SpotMusic(Artist_name = 'Coldplay' AND Popularity >= 75);

//Sort the result
sortColdplaySongs := SORT(coldplaySongs, Track_name);

//Output the result
OUTPUT(sortColdplaySongs, NAMED('ColdplaySongs'));

//Count and output result 
OUTPUT(COUNT(sortColdplaySongs), NAMED('NumColdplaySongs'));

//*********************************************************************************
//*********************************************************************************

//Challenge: 
//Count all songs that whose "SongDuration" (duration_ms) is between 200000 AND 250000 AND "Speechiness" is above .75 
//Hint: (Duration_ms BETWEEN 200000 AND 250000)

//Filter for required conditions
durationSpeechSongs := SpotMusic(duration_ms BETWEEN 200000 AND 250000 AND Speechiness > 0.75);                          

//Count result (should be 2153):
numDurationSpeechSongs := COUNT(durationSpeechSongs);
//Display result:
OUTPUT(numDurationSpeechSongs, NAMED('NumDurationSpeechSongs'));

//*********************************************************************************
//*********************************************************************************

//Challenge: 
//Create a new dataset which only has "Artist", "Title" and "Year"
//Output them

//Result should only have 3 columns. 

//Hint: Create your new layout and use TRANSFORM for new fields. 
//Use PROJECT, to loop through your music dataset

//Define RECORD here:
artistTitleYearRec := RECORD
  STRING Artist;
  STRING Title;
  INTEGER Year;
END;
//Standalone TRANSFORM Here 

//PROJECT here:
artistTitleYearProj := PROJECT(SpotMusic, TRANSFORM(artistTitleYearRec, 
    SELF.Artist := LEFT.Artist_name;
    SELF.Title := LEFT.Track_name;
    Self.Year := LEFT.Year;
));
//OUTPUT your PROJECT here:
OUTPUT(artistTitleYearProj, NAMED('ArtistTitleYear'));      

//*********************************************************************************
//*********************************************************************************

//COORELATION Challenge: 
//1- What’s the correlation between "Popularity" AND "Liveness"
//2- What’s the correlation between "Loudness" AND "Energy"

//Result for liveness = -0.05696845812100079, Energy = -0.03441566150625201
livenessCorr := CORRELATION(SpotMusic, Popularity, Liveness);
energyCorr := CORRELATION(SpotMusic, (INTEGER)Loudness, (INTEGER)Energy);
OUTPUT(livenessCorr, NAMED('LivenessCorrelation'));
OUTPUT(energyCorr, NAMED('EnergyCorrelation'));

//*********************************************************************************
//*********************************************************************************

//                                CATEGORY THREE

//*********************************************************************************
//*********************************************************************************

//Challenge: 
//Create a new dataset which only has following conditions
//   *  STRING Column(field) named "Song" that has "Track_Name" values
//   *  STRING Column(field) named "Artist" that has "Artist_name" values
//   *  New BOOLEAN Column called isPopular, and it's TRUE is IF "Popularity" is greater than 80
//   *  New DECIMAL3_2 Column called "Funkiness" which is  "Energy" + "Danceability"
//Display the output

//Result should have 4 columns called "Song", "Artist", "isPopular", and "Funkiness"


//Hint: Create your new layout and use TRANSFORM for new fields. 
//      Use PROJECT, to loop through your music dataset

//Define the RECORD layout
songArtistPopularFunkyRec := RECORD
  STRING Song;
  STRING Artist;
  BOOLEAN isPopular;
  DECIMAL3_2 Funkiness
END;

//Build TRANSFORM


//Project here:
songArtistPopularFunkyProj := PROJECT(SpotMusic, TRANSFORM(songArtistPopularFunkyRec, 
    SELF.Song := LEFT.Track_name;
    SELF.Artist := LEFT.Artist_name;
    SELF.isPopular := IF(LEFT.Popularity > 80, TRUE, FALSE);
    SELF.Funkiness := (DECIMAL3_2)LEFT.Energy + LEFT.Danceability;
));

//Display result here:
OUTPUT(songArtistPopularFunkyProj, NAMED('SongArtistPopularFunky'));

                       
                                              
//*********************************************************************************
//*********************************************************************************

//Challenge: 
//Display number of songs for each "Genre", output and count your total 

//Result has 2 col, Genre and TotalSongs, count is 82

//Hint: All you need is a TABLE - this is a CrossTab report 
genre_Layout := RECORD
    SpotMusic.genre;
    UNSIGNED TotalSongs := COUNT(GROUP);
END;

genre_DS := TABLE(SpotMusic, genre_Layout, SpotMusic.genre);

//Printing the first 50 records of the result      
OUTPUT(CHOOSEN(genre_DS, 50), NAMED('GenreTotalSongs'));
//Count and display total - there should be 82 unique genres
numGenres := COUNT(genre_DS);
OUTPUT(numGenres, NAMED('TotalNumGenres'));
//Bonus: What is the top genre?
topGenre := SORT(genre_DS, -TotalSongs);
OUTPUT(topGenre[1], NAMED('TopGenre'));
//*********************************************************************************
//*********************************************************************************
//Calculate the average "Danceability" per "Artist" for "Year" 2023

//Hint: All you need is a TABLE 

//Result has 37600 records with two col, Artist, and DancableRate.

//Filter for year 2023

year2023 := SpotMusic(Year = 2023);

danceability_Layout := RECORD
    String Artist := year2023.Artist_name;
    DECIMAL8_2 DanceableRate := AVE(GROUP, year2023.Danceability);
END;

danceability_DS := TABLE(year2023, danceability_Layout, year2023.Artist_name);

OUTPUT(danceability_DS, NAMED('DanceabilityByArtist'));
