class User {
  String? id;
  String? name;
  String? email;
  String? phoneno;
  String? pass;
  String? homeaddress;
  String? datereg;
  String? cart;

  User({this.id, this.name, this.email, this.phoneno, String? this.pass, String? this.homeaddress, this.datereg , this.cart});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    phoneno = json['phoneno'];
    pass = json['pass'];
    homeaddress = json['homeaddress'];
    datereg = json['datereg'];
    cart = json['cart'].toString();
  }

  get userID => null;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['email'] = email;
    data['phoneno'] = phoneno;
    data['pass'] = pass;
    data['homeaddress'] = homeaddress;
    data['datereg'] = datereg;
    data['cart'] = cart.toString();
    return data;
  }
}