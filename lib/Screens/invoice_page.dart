import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:mall_purchase/API/firebase_api.dart';
import 'package:mall_purchase/Managers/managers.dart';
import 'package:mall_purchase/Models/models.dart';
import 'package:mall_purchase/components/components.dart';
import 'package:provider/provider.dart';

class InvoicePage extends StatefulWidget {
  final List<ProductModel> items;
  final bool showAddButton;

  const InvoicePage({
    Key? key,
    required this.items,
    required this.showAddButton,
  }) : super(key: key);

  @override
  State<InvoicePage> createState() => _InvoicePageState();
}

class _InvoicePageState extends State<InvoicePage> {
  double grandTotal = 0;
  FireBaseApi fireBaseApi = FireBaseApi();
  List<TextEditingController> tecs = [];

  @override
  Widget build(BuildContext context) {
    grandTotal = 0;
    for (int i = 0; i < widget.items.length; i++) {
      double indexTotal = widget.items[i].price * widget.items[i].quantity;
      String indexTotalString = indexTotal.toStringAsFixed(3);
      indexTotal = double.parse(indexTotalString);
      grandTotal += indexTotal;
      String grandTotalString = grandTotal.toStringAsFixed(3);
      grandTotal = double.parse(grandTotalString);
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Invoice Page'),
      ),
      body: SizedBox(
          child: Scrollable( viewportBuilder: (context, position) => Column(
              children: [
                Expanded(
                  child: Container(
                    child: ListView.builder(
                      physics: AlwaysScrollableScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: widget.items.length + 1,
                      itemBuilder: (context, index) {
                        if (index == widget.items.length) {
                          return Column(
                            children: [
                              const SizedBox(
                                height: 20,
                              ),
                              Container(
                                alignment: Alignment.center,
                                width: MediaQuery.of(context).size.width * 0.4,
                                height: 100,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.6),
                                      blurRadius: 8.0,
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [

                                    const Text(
                                      'المجموع الكلي',
                                      style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Text(
                                      '$grandTotal',
                                      style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                              widget.showAddButton
                                  ? Container(
                                      width: MediaQuery.of(context).size.width * 0.8,
                                      height: 45,
                                      decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.all(Radius.circular(20)),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(0.6),
                                            blurRadius: 8.0,
                                          ),
                                        ],
                                      ),
                                      margin: const EdgeInsets.only(top: 18),
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.white,
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(50))),
                                        onPressed: () {
                                          fireBaseApi.addInvoice(
                                              DateTime.now(), widget.items, grandTotal);
                                        },
                                        child: const Text('خزن الفاتورة',
                                            style: TextStyle(color: Colors.black)),
                                      ),
                                    )
                                  : Container(),
                              const SizedBox(
                                height: 20,
                              ),
                            ],
                          );
                        }
                        tecs.add(TextEditingController());
                        double total = widget.items[index].price * widget.items[index].quantity;
                        tecs[index].text = widget.items[index].quantity.toString();
                        String inString = total.toStringAsFixed(3);
                        double fixedTotal = double.parse(inString);

                        return Dismissible(
                          key: UniqueKey(),
                          direction: widget.showAddButton ? DismissDirection.startToEnd : DismissDirection.none,
                          onDismissed: (direction) {
                            setState(() {
                              Provider.of<PurchaseItemManager>(context, listen: false)
                                  .removeItem(index);
                            });
                          },
                          child: ItemRow(item: widget.items[index], index: index, total: fixedTotal),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
    );
  }
}
