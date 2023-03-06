module.exports = (app) => {
    require("./routesBeer")(app);
    require("./routesType")(app);

    app.get('/admin', async (req, res) => {
        res.render('admin');
    })
}