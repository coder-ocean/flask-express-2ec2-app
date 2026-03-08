const express = require('express');
const app = express();

app.set('view engine', 'ejs');

const URL = process.env.BACKEND_URL || "http://localhost:5000/api";

app.get('/', async function(req, res) {
    try {
        const response = await fetch(URL);
        const result = await response.json();

        res.render('index', { data: result.data });

    } catch (err) {
        console.error(err);
        res.status(500).json({ msg: 'Internal Server Error.' });
    }
});

app.listen(3000, function(){
    console.log('Ares listening on port 3000!');
});
