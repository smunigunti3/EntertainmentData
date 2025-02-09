const express = require('express');
const app = express();
const port = 3000;

app.use(express.static('/Users/sirimunigunti/Documents/GitHub/EntertainmentData/web'));

// Simulate the ECL recommendation logic (replace this with actual ECL code)
const getSimilarSongsFromECL = (songId) => {
    return [
        { song_id: 1235, tempo: 120, loudness: -5 },
        { song_id: 1236, tempo: 115, loudness: -4 },
        { song_id: 1237, tempo: 122, loudness: -6 },
        { song_id: 1238, tempo: 118, loudness: -5 },
        { song_id: 1239, tempo: 121, loudness: -4 }
    ];
};

// API endpoint to get similar songs
app.get('/api/getSimilarSongs', (req, res) => {
    const songId = req.query.songId;

    if (!songId) {
        return res.status(400).send({ error: 'Song ID is required' });
    }

    // Call the ECL function to get similar songs (replace with actual ECL call)
    const similarSongs = getSimilarSongsFromECL(songId);

    // Send the similar songs as a JSON response
    res.json(similarSongs);
});

// Start the server
app.listen(port, () => {
    console.log(`Server is running on http://localhost:${port}`);
});