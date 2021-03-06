class Item {
  //insialisasi atribut
  int _id;
  String _name;
  int _price;
  int _stock;
  String _itemCode;

  // setter dan getter variabel
  // setter : dipakai untuk mengembalikan nilai yang dimasukkan dari constructor
  // getter : mengambil nilai yang dimasukkan ke constructor
  int get id => _id;

  String get name => this._name;
  set name(String value) => this._name = value;

  get price => this._price;
  set price(value) => this._price = value;

  String get itemCode => this._itemCode;
  set itemCode(String value) => this._itemCode = value;

  get stock => this._stock;
  set stock(value) => this._stock = value;

  // konstruktor versi 1
  Item(this._name, this._price, this._stock, this._itemCode);

  // konstruktor versi 2: konversi dari Map ke Item
  // digunakan untuk mengambil data dari sql yang tersimpan berbentuk Map setelah itu akan disimpan kembali dalam bentuk variabel
  Item.fromMap(Map<String, dynamic> map) {
    this._id = map['id'];
    this._name = map['name'];
    this._price = map['price'];
    this._stock = map['stock'];
    this._itemCode = map['itemCode'];
  }

  // konversi dari Item ke Map
  // method Map untuk melakukan update dan insert.
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = Map<String, dynamic>();
    map['id'] = this._id;
    map['name'] = name;
    map['price'] = price;
    map['stock'] = this._stock;
    map['itemCode'] = this._itemCode;
    return map;
  }
}
