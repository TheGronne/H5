const Type = require("./models/types");

module.exports = (app) => {
    app.get('/admin/type', async (req, res) => {
        let types = await Type.find();

        res.render('adminType', {
            types: types
        });
    })

    app.get('/admin/type/:id', async (req, res) => {
        let type = await Type.findById(req.params.id);
        let types = await Type.find();
    
        res.render('adminType', {
            types: types,
            chosen: type
        });
    })
        
    app.post('/admin/type', async (req, res) => {

        let message = []
        message = await validateType(req);
        if(message.length == 0){
            await Type.create(req.body);
            res.redirect('/admin/type');
        } else {
            let types = await Type.find();
            res.render("adminType", {
                message: message.join(', '),
                chosen: req.body,
                types: types
            })
        }
    })
    
    app.get("/admin/type/delete/:id", async (req, res) => {
        await Type.findByIdAndDelete(req.params.id);
        res.redirect("/admin/type");
    })
    
    app.get("/admin/type/edit/:id", async (req, res) => {
        let type = await Type.findById(req.params.id);
        let types = await Type.find();
    
        res.render('adminType', {
            chosen: type,
            types: types,
            editing: true
        });
    })
    
    app.post("/admin/type/edit/:id", async (req, res) => {

        let message = []
        message = await validateType(req);
        if(message.length == 0){
            await Type.findByIdAndUpdate(req.params.id, req.body);
            res.redirect("/admin/type/" + req.params.id);
        } else {
            let types = await Type.find();
            res.render("adminType", {
                message: message.join(', '),
                chosen: req.body,
                types: types
            })
        }
    })    
}

async function validateType(req){
    let message = [];
    if (req.body?.name == ''){
        message.push("Enter name")
    }
    if (req.body?.description == ''){
        message.push("Enter description")
    }
    return message;
}