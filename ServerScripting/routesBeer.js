const Beer = require("./models/beers");
const Type = require("./models/types");
const fs = require("fs");

module.exports = (app) => {
    app.get('/', async (req, res) => {
        let beers = await Beer.find();
        res.render('index', {
            beers: beers
        });
    })

    app.get('/admin/beer', async (req, res) => {
        let beers = await Beer.find();
        let types = await Type.find();

        res.render('adminBeer', {
            beers: beers,
            types: types
        });
    })

    app.get('/admin/beer/:id', async (req, res) => {
        let beer = await Beer.findById(req.params.id);
        let beers = await Beer.find();
        let types = await Type.find();

        res.render('adminBeer', {
            beers: beers,
            chosen: beer,
            types: types
        });
    })
      
    app.post('/admin/beer', async (req, res) => {

        let message = []
        message = await validateBeer(req);
        console.log(message)
        if(message.length == 0){
            
            if(req.files != undefined && req.files.image != null && req.files.image != ''){
                await req.files.image.mv("./ServerScripting/public/images/" + req.files.image.name);
                req.body.image = req.files.image.name;
            }

            await Beer.create(req.body);
            res.redirect('/admin/beer');
        } else {
            let beers = await Beer.find();
            res.render("adminBeer", {
                message: message.join(', '),
                chosen: req.body,
                beers: beers
            })
        }
    })
    
    app.get("/admin/beer/delete/:id", async (req, res) => {
        let beer = await Beer.findById(req.params.id);
        if(fs.existsSync("./ServerScripting/public/images/" + beer.image)){
            fs.unlink("./ServerScripting/public/images/" + beer.image, (err) => {
                if (err) console.log(err);
            });
        }
           
        await Beer.findByIdAndDelete(req.params.id);
        res.redirect("/admin/beer");
    })

    app.get("/admin/beer/edit/:id", async (req, res) => {
        let beer = await Beer.findById(req.params.id);
        let beers = await Beer.find();
        let types = await Type.find();

        res.render('adminBeer', {
            beers: beers,
            chosen: beer,
            types: types,
            editing: true
        });
    })

    app.post("/admin/beer/edit/:id", async (req, res) => {
        
        let message = []
        message = await validateBeer(req);
        console.log(message)
        if(message.length == 0){

            if(req.files != undefined && req.files.image != null){
                let beer = await Beer.findById(req.params.id);
                if(beer.image != null && beer.image != ''){
                    if(fs.existsSync("./ServerScripting/public/images/" + beer.image)){
                        fs.unlink("./ServerScripting/public/images/" + beer.image, (err) => {
                            if (err) console.log(err);
                        });
                    }
                    req.body.image = req.files.image.name;
                }
            }

            await Beer.findByIdAndUpdate(req.params.id, req.body);
            res.redirect("/admin/beer");
        } else {
            let beers = await Beer.find();
            res.render("adminBeer", {
                message: message.join(', '),
                chosen: req.body,
                beers: beers
            })
        }
    })
      
    app.get('/beerDetailed/:id', async (req, res) => {
        let beer = await Beer.findById(req.params.id);
    
        res.render('beerDetailed', {
            beer: beer
        });
    })
}

async function validateBeer(req){
    let typeNames = await Type.findOne({name: req.body.type}) ? true : false;
    let message = [];
        
    if (req.body?.name == ''){
        message.push("Enter name")
    }
    if (!typeNames){
        message.push("Enter type")
    }
    if (req.body?.year == ''){
        message.push("Enter year")
    }
    if (req.body?.color == ''){
        message.push("Enter color")
    }
    if (req.body?.strength == ''){
        message.push("Enter strength")
    }

    return message;
}