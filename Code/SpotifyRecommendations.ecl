#OPTION('obfuscateOutput', TRUE);

IMPORT $;
MSDMusic := $.File_Music.MSDDS;

OUTPUT(CHOOSEN(MSDMusic,10), NAMED('MSDMusicSample'));

MinTempo := MIN(MSDMusic, tempo);
MaxTempo := MAX(MSDMusic, tempo);
MinLoudness := MIN(MSDMusic, loudness);
MaxLoudness := MAX(MSDMusic, loudness);

NormalizedMSDMusic_Layout := RECORD
    REAL tempoNorm := (MSDMusic.tempo - MinTempo) / (MaxTempo - MinTempo);
    REAL loudnessNorm := (MSDMusic.loudness - MinLoudness) / (MaxLoudness - MinLoudness);
END;
NormalizedMSDMusic := TABLE(MSDMusic, NormalizedMSDMusic_Layout, MSDMusic.artist_name, MSDMusic.title, MSDMusic.tempo, MSDMusic.loudness);
OUTPUT(NormalizedMSDMusic, NAMED('NormalizedMSDMusic'));

Similarity := FUNCTION(song1, song2) := 
    SQRT( (song1.tempoNorm - song2.tempoNorm) * (song1.tempoNorm - song2.tempoNorm) + 
          (song1.loudnessNorm - song2.loudnessNorm) * (song1.loudnessNorm - song2.loudnessNorm) );
END;