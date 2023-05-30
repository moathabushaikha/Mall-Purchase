import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mall_purchase/Models/models.dart';

class FireBaseApi {

  Future<List<ProductModel>> getAllProducts() async{
    List<ProductModel> allDocs = [];
    await FirebaseFirestore.instance.collection("Products").get().then(
          (querySnapshot) {
        for (var docSnapshot in querySnapshot.docs) {
          allDocs.add(ProductModel.fromMap(docSnapshot.data()));
        }
      },
      onError: (e) => print("Error completing: $e"),
    );
    return allDocs;
  }

  void addProduct(ProductModel product) async{
    final docProduct = FirebaseFirestore.instance.collection('Products').doc(product.name);
      product.id = docProduct.id;
      final json = product.toMap();
      await docProduct.set(json);
  }
  void update(ProductModel product) async{
    final docProduct = FirebaseFirestore.instance.collection('Products').doc(product.id);
    await docProduct.update({'oldPrice': product.oldPrices});
  }
  void addInvoice(DateTime dateTime,List<ProductModel> items, double grandTotal) async{
    Invoice invoice = Invoice('', creationTime: DateTime.now(), items: items, grandTotal: grandTotal);
    final docInvoice = FirebaseFirestore.instance.collection('Invoices').doc();
    invoice.id = docInvoice.id;
    final json = invoice.toMap();
    await docInvoice.set(json);
  }

  Future<List<Invoice>> getAllInvoices() async {
    List<Invoice> allDocs = [];
    await FirebaseFirestore.instance.collection("Invoices").get().then(
          (querySnapshot) {
        for (var docSnapshot in querySnapshot.docs) {
          allDocs.add(Invoice.fromMap(docSnapshot.data()));
        }
      },
      onError: (e) => print("Error completing: $e"),
    );
    return allDocs;
  }
}
