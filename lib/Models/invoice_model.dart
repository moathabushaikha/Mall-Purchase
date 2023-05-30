import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mall_purchase/Models/models.dart';

class Invoice {
  String id;
  DateTime creationTime;
  List<ProductModel> items;
  double grandTotal;

  Invoice(this.id,
      {required this.creationTime, required this.items, required this.grandTotal});

  factory Invoice.fromMap(Map<String, dynamic> map) {
    DateTime crtDate = (map['creationTime'] as Timestamp).toDate();
    double grandTotalFFB = double.parse(map['grandTotal'].toString());
    String gTStr = grandTotalFFB.toStringAsFixed(3);
    grandTotalFFB = double.parse(gTStr);
    List<dynamic> itemMap = map['items'];
    List<ProductModel> itemsList = itemMap.map((item) => ProductModel.fromMap(item)).toList();
    return Invoice(map['id'],
        creationTime: crtDate, items: itemsList , grandTotal: grandTotalFFB);
  }

  Map<String, dynamic> toMap() {
    var itemList = items.map((item) => item.toMap());
    Map<String, dynamic> map = {
      'id': id,
      'creationTime': creationTime,
      'items': itemList,
      'grandTotal': grandTotal
    };
    return map;
  }
}
