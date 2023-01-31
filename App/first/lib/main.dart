void main() {
  CoolClass t = CoolClass(1, 'Abton');
  print(t.name);
}

class CoolClass {
  int? id;
  String? name;
  String ident;

  CoolClass(int? this.id, String? this.name) : ident = "Id: $id";
}

class SecondClass {
  int? id;
  String? name;

  SecondClass({this.id = 0, this.name = "Sup"});
}
