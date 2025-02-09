IMPORT $;
MozMusic := $.File_Music.MozDS;

//display the first 150 records

OUTPUT(CHOOSEN(MozMusic, 150), NAMED('Moz_MusicDS'));

//*********************************************************************************
//*********************************************************************************

//                                CATEGORY ONE 

//*********************************************************************************
//*********************************************************************************

//Challenge: 
//Count all the records in the dataset:

COUNT(MozMusic);

//Result: Total count is 136510

//*********************************************************************************
//*********************************************************************************
//Challenge: 

//Sort by "name",  and display (OUTPUT) the first 50(Hint: use CHOOSEN):

//You should see a lot of songs by NSync 

SortedName := SORT(MozMusic, name);
Top50Names := CHOOSEN(SortedName, 50);
OUTPUT(Top50Names, NAMED('SortedName'));

//*********************************************************************************
//*********************************************************************************
//Challenge: 
//Count total songs in the "Rock" genre and display number:

MOZMUSIC(genre='Country');
//Result should have 12821 Rock songs

//Display your Rock songs (OUTPUT):

GetRockSongs := MozMusic(genre='Rock');
OUTPUT(COUNT(GetRockSongs), NAMED('RockSongsCount'));
OUTPUT(GetRockSongs, NAMED('RockSongs'));

//*********************************************************************************
//*********************************************************************************
//Challenge: 
//Count how many songs was released by Depeche Mode between 1980 and 1989

//Filter ds for "Depeche_Mode" AND releasedate BETWEEN 1980 and 1989
GetDepecheModeSongs := MozMusic(name='Depeche_Mode' AND (INTEGER)releasedate BETWEEN 1980 AND 1989);

// Count and display total
OUTPUT(COUNT(GetDepecheModeSongs), NAMED('DepecheModeSongsCount'));

//Result should have 127 songs 

//Bonus points: filter out duplicate tracks (Hint: look at DEDUP):
RemoveDepecheModeDuplicates := DEDUP(GetDepecheModeSongs, title);
OUTPUT(RemoveDepecheModeDuplicates, NAMED('DepecheModeSongsNoDuplicates'));
// OUTPUT(COUNT(RemoveDepecheModeDuplicates), NAMED('DepecheModeSongsNoDuplicatesCount'));


//*********************************************************************************
//*********************************************************************************
//Challenge: 
//Who sang the song "My Way"?
//Filter for "My Way" tracktitle

// Result should have 136 records 

//Display count and result 
GetMyWaySongs := MozMusic(tracktitle='My Way');
OUTPUT(COUNT(GetMyWaySongs), NAMED('MyWaySongsCount'));
OUTPUT(GetMyWaySongs, NAMED('MyWaySongs'));

//*********************************************************************************
//*********************************************************************************
//Challenge: 
//What song(s) in the Music Moz Dataset has the longest track title in CD format?

//Get the longest description (tracktitle) field length in CD "formats"
//Filter dataset for tracktitle with the longest value
//Display the result

CDFormatTracks := MozMusic(formats='CD');
LongestTrackTitles := SORT(CDFormatTracks, -LENGTH(tracktitle));
// OUTPUT(LongestTrackTitles, NAMED('LongestTrackTitles'));
LongestTrackTitle := CHOOSEN(LongestTrackTitles, 1);
OUTPUT(LongestTrackTitle, NAMED('LongestTrackTitle'));

//Longest track title is by the "The Brand New Heavies"               


//*********************************************************************************
//*********************************************************************************

//                                CATEGORY TWO

//*********************************************************************************
//*********************************************************************************
//Challenge: 
//Display all songs produced by "U2" , SORT it by title.


//Filter track by artist
U2Songs := MozMusic(name='U2');

//Sort the result by tracktitle
SortedU2Songs := SORT(U2Songs, title);

//Output the result
OUTPUT(SortedU2Songs, NAMED('U2Songs'));

//Count result 
OUTPUT(COUNT(SortedU2Songs), NAMED('U2SongsCount'));

//Result has 190 records


//*********************************************************************************
//*********************************************************************************
//Challenge: 
//Count all songs where guest musicians appeared 

//Hint: Think of the filter as "not blank" 

//Filter for "guestmusicians"


//Display Count result
                             

//Result should be 44588 songs  


//*********************************************************************************
//*********************************************************************************
//Challenge: 
//Create a new recordset which only has "Track", "Release", "Artist", and "Year"
// Get the "track" value from the MusicMoz TrackTitle field
// Get the "release" value from the MusicMoz Title field
// Get the "artist" value from the MusicMoz Name field
// Get the "year" value from the MusicMoz ReleaseDate field

//Result should only have 4 fields. 

//Hint: First create your new RECORD layout  
mainInfoRec := RECORD
  STRING Track;
  STRING Release;
  STRING Artist;
  INTEGER Year;
END;


//Next: Standalone Transform - use TRANSFORM for new fields.
mainInfoRec trimThem(MozMusic L) := TRANSFORM
  SELF.Track := L.tracktitle;
  SELF.Release := L.title;
  SELF.Artist := L.name;
  SELF.Year := (INTEGER)L.releaseDate;
END;

//Use PROJECT, to loop through your music dataset
Result := PROJECT(MozMusic, trimThem(LEFT));

// Display result  
OUTPUT(Result, NAMED('MainInfo')); 

//*********************************************************************************
//*********************************************************************************

//                                CATEGORY THREE

//*********************************************************************************
//*********************************************************************************

//Challenge: 
//Display number of songs per "Genre", display genre name and count for each 

//Hint: All you need is a 2 field TABLE using cross-tab
SongsPerGenre_Layout := RECORD
    MozMusic.genre;
    UNSIGNED totalSongs := COUNT(GROUP);
END;

SongsPerGenre := TABLE(MozMusic,
    SongsPerGenre_Layout,
    MozMusic.genre);

//Display the TABLE result      
OUTPUT(SongsPerGenre, NAMED('SongsPerGenre'));

//Count and display total records in TABLE
OUTPUT(COUNT(SongsPerGenre), NAMED('SongsPerGenreCount'));

//Result has 2 fields, Genre and TotalSongs, count is 1000

//*********************************************************************************
//*********************************************************************************
//What Artist had the most releases between 2001-2010 (releasedate)?

//Hint: All you need is a cross-tab TABLE 
//Output Name, and Title Count(TitleCnt)
//Filter for year (releasedate)
//Cross-tab TABLE
//Display the result  


releasesFrom2000s := MozMusic((INTEGER)releasedate BETWEEN 2001 AND 2010);

mostReleases := TABLE(releasesFrom2000s,
    {
        releasesFrom2000s.name,
        UNSIGNED TitleCnt := COUNT(GROUP)
    },
    name);

sortedReleases := SORT(mostReleases, -TitleCnt);
// OUTPUT(sortedReleases, NAMED('SortedMostReleases'));

TopArtist := CHOOSEN(sortedReleases, 1);
OUTPUT(TopArtist, NAMED('TopArtist'));
