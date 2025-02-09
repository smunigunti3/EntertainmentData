IMPORT $;
MozMusic  := $.File_Music.MozDS;
MSDMusic  := $.File_Music.MSDDS;
SpotMusic := $.File_Music.SpotDS;

// Combine the three datasets into a composite dataset using a common record format:

CombMusicLayout := RECORD
 UNSIGNED RECID;
 STRING   SongTitle;
 STRING   AlbumTitle;
 STRING   Artist;
 STRING   Genre;
 STRING4  ReleaseYear;
 STRING4  Source; //MOZ,MSD,SPOT
END;

mozProj := PROJECT(MozMusic, TRANSFORM(CombMusicLayout, 
    SELF.RECID := (UNSIGNED)LEFT.id;
    SELF.SongTitle := LEFT.tracktitle;
    SELF.AlbumTitle := LEFT.title;
    SELF.Artist := LEFT.name;
    SELF.Genre := LEFT.genre;
    SELF.ReleaseYear := LEFT.releaseDate;
    SELF.Source := 'MOZ';
));

msdProj := PROJECT(MSDMusic, TRANSFORM(CombMusicLayout, 
    SELF.RECID := LEFT.recid;
    SELF.SongTitle := LEFT.title;
    SELF.AlbumTitle := LEFT.release_name;
    SELF.Artist := LEFT.artist_name;
    SELF.Genre := 'NA';
    SELF.ReleaseYear := (STRING4)LEFT.year;
    SELF.Source := 'MSD';
));

spotProj := PROJECT(SpotMusic, TRANSFORM(CombMusicLayout, 
    SELF.RECID := LEFT.recid;
    SELF.SongTitle := LEFT.track_name;
    SELF.AlbumTitle := 'NA';
    SELF.Artist := LEFT.artist_name;
    SELF.Genre := LEFT.genre;
    SELF.ReleaseYear := (STRING4)LEFT.year;
    SELF.Source := 'SPOT';
));

combinedMusic := mozProj + msdProj + spotProj;
OUTPUT(combinedMusic, NAMED('CombinedMusic'));
//OUTPUT(COUNT(combinedMusic), NAMED('TotalCombinedMusic'));
sortCombinedMusic := SORT(combinedMusic, songtitle);
//OUTPUT(sortCombinedMusic, NAMED('SortedCombinedMusic'));
combinedMusicNoDup := DEDUP(sortCombinedMusic, songtitle, albumtitle, artist);
OUTPUT(combinedMusicNoDup, NAMED('CombinedMusicWithoutDuplicates'));
//OUTPUT(COUNT(combinedMusicNoDup), NAMED('TotalCombinedMusicWithoutDuplicates'));
//After doing this, create different playlists by Year and/or genre! Music is Life! 
Pop2005SongPlaylist := combinedMusicNoDup(releaseyear = '2005' and genre = 'Pop');
OUTPUT(Pop2005SongPlaylist, NAMED('Pop2005SongPlaylist'));