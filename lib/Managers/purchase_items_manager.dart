import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:mall_purchase/Models/models.dart';

class PurchaseItemManager extends ChangeNotifier{
  final List<ProductModel> _items = [];
  UnmodifiableListView<ProductModel> get items => UnmodifiableListView(_items);

  addItem(ProductModel item){
    _items.add(item);
    notifyListeners();
  }
  void removeItem(index){
    _items.removeAt(index);
    notifyListeners();
  }
  void removeAll() {
    _items.clear();
    notifyListeners();
  }

}