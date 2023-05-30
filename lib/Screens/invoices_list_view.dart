import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mall_purchase/Models/models.dart';
import 'screens.dart';
import 'package:mall_purchase/API/firebase_api.dart';

class InvoicesListView extends StatefulWidget {
  const InvoicesListView({Key? key}) : super(key: key);

  @override
  State<InvoicesListView> createState() => _InvoicesListViewState();
}

class _InvoicesListViewState extends State<InvoicesListView> {
  FireBaseApi fireBaseApi = FireBaseApi();
  List<bool> isPressed = [];
  List<Invoice> allInvoices = [];
  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    getAllInvoices();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.lightBlueAccent, Colors.white])),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Container(alignment: Alignment.centerRight, child: const Text('الفواتير')),
        ),
        body: Column(
          children: [
            Container(
              margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: TextField(
                controller: controller,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  hintText: 'قيمة الفاتورة',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Colors.orangeAccent),
                  ),
                ),
                onChanged: searchItem,
              ),
            ),
            Expanded(
              child: ListView.builder(
                  itemCount: allInvoices.length,
                  itemBuilder: (context, index) {
                    final Invoice invoice = allInvoices[index];
                    final DateFormat formatter = DateFormat('yyyy-MM-dd');
                    final String formatted = formatter.format(invoice.creationTime);
                    return GestureDetector(
                      onTapDown: (details) => setState(() {
                        isPressed[index] = true;
                      }),
                      onTapUp: (details) => setState(() {
                        isPressed[index] = true;
                      }),
                      onTap: () => Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => InvoicePage(items: invoice.items, showAddButton: false),
                      )),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: 100,
                        margin: const EdgeInsets.all(20.0),
                        alignment: const Alignment(-0.7, -0.8),
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.6),
                              blurRadius: 8.0,
                            ),
                          ],
                          color: Colors.orangeAccent,
                          borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(10.0),
                              bottomRight: Radius.circular(120.0),
                              topLeft: Radius.circular(120.0),
                              bottomLeft: Radius.circular(10.0)),
                        ),
                        child: Stack(
                          children: [
                            Positioned(
                              width: 200,
                              right: 10,
                              top: 10,
                              child: Row(
                                children: [
                                  Text(
                                    formatted,
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                                  ),
                                  const SizedBox(
                                    width: 15,
                                  ),
                                  const Text(
                                    ' : تاريخ الفاتورة',
                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                                  )
                                ],
                              ),
                            ),
                            Positioned(
                              width: 200,
                              right: 0,
                              top: 30,
                              child: Row(
                                children: [
                                  Text(
                                    '${invoice.grandTotal}',
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                                  ),
                                  const SizedBox(
                                    width: 15,
                                  ),
                                  const Text(
                                    ' : السعر الاجمالي',
                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                                  )
                                ],
                              ),
                            ),
                            Positioned(
                              width: 200,
                              right: 0,
                              top: 50,
                              child: Row(
                                children: [
                                  Text(
                                    '${invoice.items.length}',
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                                  ),
                                  const SizedBox(
                                    width: 15,
                                  ),
                                  const Text(
                                    ' : عدد السلع',
                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                                  )
                                ],
                              ),
                            ),
                            Positioned(
                              left: 0,
                              top: 0,
                              height: 100,
                              width: 100,
                              child: Container(
                                padding: const EdgeInsets.all(20),
                                height: 100,
                                width: 100,
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.6),
                                      blurRadius: 8.0,
                                    ),
                                  ],
                                  color: Colors.black,
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    topRight: Radius.circular(10),
                                    bottomLeft: Radius.circular(10),
                                    bottomRight: Radius.circular(80),
                                  ),
                                ),
                                child: Text(
                                  (index + 1).toString(),
                                  style: const TextStyle(
                                      fontSize: 60, fontWeight: FontWeight.bold, color: Colors.white),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }

  void searchItem(String query) {
    if (query.isEmpty) {
      setState(() async {
        allInvoices = await fireBaseApi.getAllInvoices();
      });
    } else if (allInvoices.isNotEmpty) {
      final suggestions = allInvoices.where((item) {
        final grandTotal = item.grandTotal.toString();
        final input = query.toLowerCase();
        return grandTotal.contains(input);
      }).toList();
      setState(() {
        allInvoices = suggestions;
      });
    }
  }

  void getAllInvoices() async {
    List<Invoice> list = await fireBaseApi.getAllInvoices();
    setState(() {
      allInvoices = list;
    });
  }
}
