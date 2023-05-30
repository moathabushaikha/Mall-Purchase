import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:mall_purchase/API/firebase_api.dart';
import 'package:mall_purchase/Models/models.dart';

class ProductManager extends ChangeNotifier{
  final FireBaseApi fireBaseApi = FireBaseApi();
  final List<ProductModel> _items = [];
  UnmodifiableListView<ProductModel> get items => UnmodifiableListView(_items);

  void addItem(ProductModel item){
    _items.add(item);
    fireBaseApi.addProduct(item);
    notifyListeners();
  }
  void removeAll() {
    _items.clear();
    notifyListeners();
  }

  Future<void> getProducts() async{
    List<ProductModel> itemList = await fireBaseApi.getAllProducts();
    for(ProductModel product in itemList){
      _items.add(product);
    }
    notifyListeners();
  }

  void updateItem(ProductModel item) async{}
}