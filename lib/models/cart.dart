class Cart {
  String? cartid;
  String? sbname;
  String? price;
  String? cartqty;
  String? sbid;
  String? pricetotal;

  Cart(
      {this.cartid,
      this.sbname,
      this.price,
      this.cartqty,
      this.sbid,
      this.pricetotal});

  Cart.fromJson(Map<String, dynamic> json) {
    cartid = json['cartid'];
    sbname = json['sbname'];
    price = json['price'];
    cartqty = json['cartqty'];
    sbid = json['sbid'];
    pricetotal = json['pricetotal'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['cartid'] = cartid;
    data['sbname'] = sbname;
    data['price'] = price;
    data['cartqty'] = cartqty;
    data['sbid'] = sbid;
    data['pricetotal'] = pricetotal;
    return data;
  }
}