const fs = require('fs');
var url = require("url");
const express = require('express');
const path = require('path');
const mongoose = require('mongoose');
var bodyParser = require('body-parser');

const hostname = '127.0.0.1';
const port = process.env.PORT || 3000;
const app = express();

// Import the mongoose module
mongoose.set('strictQuery', false);
mongoose.connect("mongodb://127.0.0.1:27017/ServerScripting")
  .catch(err => console.log('MONGOOSE ERROR:', err));

app.set('views', './ServerScripting/views');
app.set('view engine', 'ejs');

app.use(bodyParser.urlencoded({extended: false}))

const fileupload = require('express-fileupload');
app.use(fileupload({
  limits: {
    fileSize: 10 * 1024 * 1024
  } // 10mb
}));


var routes = require('./routes')(app);

app.use(express.static("ServerScripting/public"));

app.listen(port, hostname, () => {
  //if (err) console.log(err);
  console.log(`Server running at http://${hostname}:${port}/`);
});