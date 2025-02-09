IMPORT $;
MSDMusic := $.File_Music.MSDDS;

//display the first 150 records

OUTPUT(CHOOSEN(MSDMusic, 150), NAMED('Raw_MusicDS'));

//*********************************************************************************
//*********************************************************************************

//                                CATEGORY ONE 

//*********************************************************************************
//*********************************************************************************
//Challenge: 
//Reverse Sort by "year" and count your total music dataset and display the first 50

//Result: Total count is 1000000

//Reverse sort by "year"
reverseYear := SORT(MSDMUSIC, -year);

//display the first 50
first50ReverseYear := CHOOSEN(reverseYear, 50);
OUTPUT(first50ReverseYear, NAMED('First50ReverseYear'));

//Count and display result
totalCount := COUNT(reverseYear);
OUTPUT(totalCount, NAMED('TotalCount'));


//*********************************************************************************
//*********************************************************************************
//Challenge: 
//Display first 50 songs by of year 2010 and then count the total 

//Result should have 9397 songs for 2010

//Filter for 2010 and display the first 50
songsFrom2010 := MSDMusic(year = 2010);
first50Songs2010 := CHOOSEN(songsFrom2010, 50);
OUTPUT(first50Songs2010, NAMED('First50Songs2010'));

//Count total songs released in 2010:
OUTPUT(COUNT(songsFrom2010), NAMED('TotalSongs2010'));


//*********************************************************************************
//*********************************************************************************
//Challenge: 
//Count how many songs was produced by "Prince" in 1982

//Result should have 4 counts

//Filter ds for "Prince" AND 1982
prince1982 := MSDMusic(artist_name = 'Prince' AND year = 1982);

//Count and print total
OUTPUT(COUNT(prince1982), NAMED('Prince1982')); 

//*********************************************************************************
//*********************************************************************************
//Challenge: 
//Who sang "Into Temptation"?

// Result should have 3 records

//Filter for "Into Temptation"
intoTemptationArtist := MSDMusic(title = 'Into Temptation');

//Display result
OUTPUT(intoTemptationArtist, NAMED('IntoTemptationArtist'));


//*********************************************************************************
//*********************************************************************************
//Challenge: 
//Sort songs by Artist and song title, output the first 100

//Result: The first 10 records have no artist name, followed by "- PlusMinus"                                     

//Sort dataset by Artist, and Title
sortedArtistAndTitle := SORT(MSDMusic, artist_name, title);
first100SortedArtistAndTitle := CHOOSEN(sortedArtistAndTitle, 100);

//Output the first 100
OUTPUT(first100SortedArtistAndTitle, NAMED('First100SortedArtistAndTitle'));


//*********************************************************************************
//*********************************************************************************
//Challenge: 
//What is the hottest song by year in the Million Song Dataset?
//Sort Result by Year (filter out zero Year values)
nonZeroYears := MSDMusic(year != 0);
hottestSongsByYear := SORT(nonZeroYears, nonZeroYears.year, -nonZeroYears.song_hotness);

//Result is
OUTPUT(hottestSongsByYear, NAMED('HottestSongsByYear')); 

//Get the datasets maximum hotness value

//Filter dataset for the maxHot value
maxHottestSongs := SORT(hottestSongsByYear, -hottestSongsByYear.song_hotness);
maxHot := CHOOSEN(maxHottestSongs, 1);

//Display the result
OUTPUT(maxHot, NAMED('MaxHot'));



//*********************************************************************************
//*********************************************************************************

//                                CATEGORY TWO

//*********************************************************************************
//*********************************************************************************
//Challenge: 
//Display all songs produced by the artist "Coldplay" AND has a 
//"Song Hotness" greater or equal to .75 ( >= .75 ) , SORT it by title.
//Count the total result

//Result has 47 records

//Get songs by defined conditions
hotColdplaySongs := MSDMusic(artist_name = 'Coldplay' AND song_hotness >= .75);

//Sort the result
sortedHotColdplaySongs := SORT(hotColdplaySongs, hotColdplaySongs.title);

//Output the result
OUTPUT(sortedHotColdplaySongs, NAMED('SortedHotColdplaySongs'));

//Count and output result 
OUTPUT(COUNT(hotColdplaySongs), NAMED('TotalHotColdplaySongs'));


//*********************************************************************************
//*********************************************************************************
//Challenge: 
//Count all songs where "Duration" is between 200 AND 250 (inclusive) 
//AND "song_hotness" is not equal to 0 
//AND familarity > .9

//Result is 762 songs  

//Hint: (SongDuration BETWEEN 200 AND 250)

//Filter for required conditions
hotFamiliarSongs := MSDMusic(duration BETWEEN 200 AND 250 AND song_hotness != 0 AND familiarity > .9);

//Count result
OUTPUT(COUNT(hotFamiliarSongs), NAMED('TotalHotFamiliarSongs'));                   

//Display result
OUTPUT(hotFamiliarSongs, NAMED('HotFamiliarSongs'));

//*********************************************************************************
//*********************************************************************************
//Challenge: 
//Create a new dataset which only has  "Title", "Artist_Name", "Release_Name" and "Year"
//Display the first 50

//Result should only have 4 columns. 

//Hint: Create your new RECORD layout and use TRANSFORM for new fields. 
//Use PROJECT, to loop through your music dataset


//Standalone Transform 
condensedInfoRec := RECORD
    STRING Title;
    STRING Artist_Name;
    STRING Release_Name;
    UNSIGNED2 Year;
END;

condensedInfoRec getCondensed(MSDMusic L) := TRANSFORM
    SELF.Title := L.title;
    SELF.Artist_Name := L.artist_name;
    SELF.Release_Name := L.release_name;
    SELF.Year := L.year;
END;

//PROJECT
result := PROJECT(MSDMusic, getCondensed(LEFT));

// Display result
resultTop50 := CHOOSEN(result, 50);  
OUTPUT(resultTop50, NAMED('CondensedInfo'));

//*********************************************************************************
//*********************************************************************************

//Challenge: 
//1- What’s the correlation between "song_hotness" AND "artist_hotness"
//2- What’s the correlation between "barsstartdev" AND "beatsstartdev"

//Result for hotness = 0.4706972681953097, StartDev = 0.8896342348554744
hotnessCorrelation := CORRELATION(MSDMusic, song_hotness, artist_hotness);
startDevCorrelation := CORRELATION(MSDMusic, barsstartdev, beatsstartdev);
OUTPUT(hotnessCorrelation, NAMED('HotnessCorrelation'));
OUTPUT(startDevCorrelation, NAMED('StartDevCorrelation'));


//*********************************************************************************
//*********************************************************************************

//                                CATEGORY THREE

//*********************************************************************************
//*********************************************************************************
//Challenge: 
//Create a new dataset which only has following conditions
//   *  Column named "Song" that has "Title" values 
//   *  Column named "Artist" that has "artist_name" values 
//   *  New BOOLEAN Column called isPopular, and it's TRUE is IF "song_hotness" is greater than .80
//   *  New BOOLEAN Column called "IsTooLoud" which is TRUE IF "Loudness" > 0
//Display the first 50

//Result should have 4 columns named "Song", "Artist", "isPopular", and "IsTooLoud"

//Hint: Create your new layout and use TRANSFORM for new fields. 
//      Use PROJECT, to loop through your music dataset

//Create the RECORD layout
popularLoudSongs_Layout := RECORD
    STRING Song;
    STRING Artist_Name;
    BOOLEAN isPopular;
    BOOLEAN IsTooLoud;
END;

//Build your TRANSFORM

//Creating the PROJECT

popularLoudSongs := PROJECT(MSDMusic, 
    TRANSFORM(popularLoudSongs_Layout,
        SELF.Song := LEFT.title;
        SELF.Artist_Name := LEFT.artist_name;
        SELF.isPopular := IF(LEFT.song_hotness > .80, TRUE, FALSE);
        SELF.IsTooLoud := IF(LEFT.loudness > 0, TRUE, FALSE);
    )
);

//Display the result
first50popularLoudSongs := CHOOSEN(popularLoudSongs, 50);
OUTPUT(first50popularLoudSongs, NAMED('PopularLoudSongs'));

                       
                                              
//*********************************************************************************
//*********************************************************************************
//Challenge: 
//Display number of songs per "Year" and count your total 

//Result has 2 col, Year and TotalSongs, count is 89

//Hint: All you need is a cross-tab TABLE 
SongsPerYear_Layout := RECORD
    MSDMusic.year;
    UNSIGNED totalSongs := COUNT(GROUP);
END;

SongsPerYear := TABLE(MSDMusic,
    SongsPerYear_Layout,
    MSDMusic.year);

//Display the  result    
OUTPUT(SongsPerYear, NAMED('SongsPerYearCount'));  

//Count and display total number of years counted
uniqueYearsCount := COUNT(SongsPerYear);
OUTPUT(uniqueYearsCount, NAMED('UniqueYearsCount'));

//*********************************************************************************
//*********************************************************************************
// What Artist had the overall hottest songs between 2006-2007?
// Calculate average "song_hotness" per "Artist_name" for "Year" 2006 and 2007


// Hint: All you need is a TABLE, and see the TOPN function for your OUTPUT 

// Output the top ten results showing two columns, Artist_Name, and HotRate.

// Filter for year
HotSongsFrom2006_2007 := MSDMusic(year BETWEEN 2006 AND 2007);

// Create a Cross-Tab TABLE:
AvgHotSongs_Layout := RECORD
    STRING artist_name := HotSongsFrom2006_2007.artist_name;
    REAL avgHotness := AVE(GROUP, HotSongsFrom2006_2007.song_hotness);
END;
AvgHotSongs := TABLE(HotSongsFrom2006_2007, AvgHotSongs_Layout, HotSongsFrom2006_2007.artist_name);

// Display the top ten results with top "HotRate"      
// Output the top ten results showing two columns, Artist_Name, and HotRate.

SortedAvgHotSongs := SORT(AvgHotSongs, -avgHotness);
Top10HotSongs := CHOOSEN(SortedAvgHotSongs, 10);
OUTPUT(Top10HotSongs, NAMED('Top10HotSongs'));