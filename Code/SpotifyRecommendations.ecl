#OPTION('obfuscateOutput', TRUE);

IMPORT $;
MSDMusic := $.File_Music.MSDDS;

OUTPUT(CHOOSEN(MSDMusic,10), NAMED('MSDMusicSample'));

MinTempo := MIN(MSDMusic, tempo);
MaxTempo := MAX(MSDMusic, tempo);
MinLoudness := MIN(MSDMusic, loudness);
MaxLoudness := MAX(MSDMusic, loudness);

NormalizedMSDMusic_Layout := RECORD
    String Artist;
    String Title;
    String Tempo;
    String Loudness;
    REAL tempoNorm;
    REAL loudnessNorm;
END;

NormalizedMSDMusic := PROJECT(MSDMusic, TRANSFORM(NormalizedMSDMusic_Layout,
    SELF.Artist := LEFT.artist_name;
    SELF.Title := LEFT.title;
    SELF.Tempo := (STRING)LEFT.tempo;
    SELF.Loudness := (STRING)LEFT.loudness;
    SELF.tempoNorm := (LEFT.tempo - MinTempo) / (MaxTempo - MinTempo);
    SELF.loudnessNorm := (LEFT.loudness - MinLoudness) / (MaxLoudness - MinLoudness);
));
//NormalizedMSDMusic := TABLE(MSDMusic, NormalizedMSDMusic_Layout, MSDMusic.artist_name, MSDMusic.title, MSDMusic.tempo, MSDMusic.loudness);
OUTPUT(NormalizedMSDMusic, NAMED('NormalizedMSDMusic'));

//song_DS := CHOOSEN(NormalizedMSDMusic, 1, 55);
//OUTPUT(song_DS, NAMED('song_DS'));
selectedSong := NormalizedMSDMusic[55];
OUTPUT(selectedSong, NAMED('selectedSong'));
similarityLayout := RECORD
    String Artist;
    String Title;
    REAL SimilarityScore;
END;

SimilarMSDMusic := PROJECT(NormalizedMSDMusic, TRANSFORM(similarityLayout,
    SELF.Artist := LEFT.Artist;
    SELF.Title := LEFT.Title;
    SELF.SimilarityScore := SQRT(
        POWER(LEFT.tempoNorm - selectedSong.tempoNorm, 2) +
        POWER(LEFT.loudnessNorm - selectedSong.loudnessNorm, 2)
    );
));

OUTPUT(SimilarMSDMusic, NAMED('SimilarMSDMusic'));
//OUTPUT(Count(SimilarMSDMusic), NAMED('CountSimilarMSDMusic'));
filterSimilarMSDMusic := SimilarMSDMusic(title <> selectedSong.title);
//OUTPUT(COUNT(filterSimilarMSDMusic), NAMED('CountFilterSimilarMSDMusic'));

sortedSimilarMSDMusic := SORT(filterSimilarMSDMusic, SimilarityScore);
OUTPUT(sortedSimilarMSDMusic, NAMED('sortedSimilarMSDMusic'));

OUTPUT(CHOOSEN(sortedSimilarMSDMusic, 10), NAMED('Top10SimilarMSDMusic'));
/*
similar := TABLE(NormalizedMSDMusic, similarityLayout);
OUTPUT(similarityTable, NAMED('similarityTable'));

filteredTable := similarityTable(title <> referenceTitle);
OUTPUT(filteredTable, NAMED('filteredTable'));
*/
//sortedTable := SORT(filteredTable, SimilarityScore);
//OUTPUT(sortedTable, NAMED('sortedTable'));

//OUTPUT(SimilarMSDMusic, NAMED('SimilarMSDMusic'));
/*
Similarity(DATASET(NormalizedMSDMusic_Layout) song1, DATASET(NormalizedMSDMusic_Layout) song2) := FUNCTION
    result := SQRT( (song1.tempoNorm - song2.tempoNorm) * (song1.tempoNorm - song2.tempoNorm) + 
          (song1.loudnessNorm - song2.loudnessNorm) * (song1.loudnessNorm - song2.loudnessNorm) );
    RETURN result;
END;
*/


