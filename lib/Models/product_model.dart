import 'dart:convert';

ProductModel productFromJson(String str) => ProductModel.fromMap(json.decode(str));

String productToJson(ProductModel data) => json.encode(data.toMap());

class ProductModel {
  String id;
  String? name;
  double price;
  List<double?> oldPrices;
  double quantity;
  String? measuringUnit;
  String? imagePath;

  ProductModel(this.id,this.oldPrices, this.quantity, this.imagePath,
      {required this.name, required this.price, required this.measuringUnit});

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    List<dynamic> fromFBOldPrices = map['oldPrice'];
    List<double?> oldPricesList = [];
    for (var price in fromFBOldPrices){
      oldPricesList.add(price);
    }
    return ProductModel(map['id'],oldPricesList, map['quantity'], map['imagePath'],
        measuringUnit: map['measuringUnit'], name: map['name'], price: map['price']);
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'id': id,
      'oldPrice': oldPrices,
      'quantity': quantity,
      'imagePath': imagePath,
      'name': name,
      'price': price,
      'measuringUnit': measuringUnit
    };
    return map;
  }
}
