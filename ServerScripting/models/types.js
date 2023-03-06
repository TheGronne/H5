const mongoose = require("mongoose");
const { Schema } = mongoose; // teknik der trækker et objekt ud af et andet objekt...

//Man kan ikke lave flere types. Synes bare at backenden skulle håndtere hvilke typer eksisterer. Jeg ville normalt lave dette i en relationel database, men det er ikke det vi sidder med :)
const typeModel = new Schema({
  name: { type: String },
  description: {type: String}
});
 
module.exports = mongoose.model("Type", typeModel);