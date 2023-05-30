import 'package:flutter/material.dart';
import 'package:mall_purchase/Models/models.dart';

class ItemRow extends StatelessWidget {
  final ProductModel item;
  final int index;
  final double total;
  const ItemRow(
      {required this.item,
      required this.index,
      Key? key, required this.total})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
        alignment: Alignment.center,
        width: size.width,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.6),
              blurRadius: 8.0,
            ),
          ],
        ),
        height: 120,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          clipBehavior: Clip.antiAliasWithSaveLayer,
          color: index.isEven ? Colors.orange : Colors.blue,
          child: Row(
            children: [
              Container(
                width: size.width * 0.2,
                alignment: Alignment.center,
                padding: const EdgeInsets.only(bottom: 10),
                margin: const EdgeInsets.only(right: 15, left: 5),
                child: item.imagePath != null
                    ? Container(
                        width: 120,
                        height: 120,
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.7),
                              spreadRadius: 2,
                              blurRadius: 2,
                              offset: const Offset(0, 3), // changes position of shadow
                            ),
                          ],
                        ),
                        child: Image.network(
                          item.imagePath!,
                          fit: BoxFit.cover,
                        ),
                      )
                    : Container(),
              ),
              Expanded(
                child: Container(
                    margin: const EdgeInsets.only(right: 8),
                    decoration: BoxDecoration(border: Border.all()),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                            margin: const EdgeInsets.only(right: 5, left: 5),
                            decoration: const BoxDecoration(border: Border(bottom: BorderSide())),
                            alignment: Alignment.center,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                item.name != null
                                    ? Text(
                                        item.name!,
                                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                                      )
                                    : const Text('data missing'),
                                const Text(': اسم السلعة'),
                              ],
                            )),
                        Container(
                            margin: const EdgeInsets.only(right: 5, left: 5),
                            decoration: const BoxDecoration(border: Border(bottom: BorderSide())),
                            alignment: Alignment.center,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                item.price != null
                                    ? Text(
                                        item.price.toString(),
                                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                                      )
                                    : const Text('data missing'),
                                const Text(': سعر السلعة'),
                              ],
                            )),
                        Container(
                            margin: const EdgeInsets.only(right: 5, left: 5),
                            decoration: const BoxDecoration(border: Border(bottom: BorderSide())),
                            alignment: Alignment.center,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                item.measuringUnit != null
                                    ? Text(
                                        item.measuringUnit.toString(),
                                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                                      )
                                    : const Text('data missing'),
                                const Text(': نوع السلعة'),
                              ],
                            )),
                        Container(
                            margin: const EdgeInsets.only(right: 5, left: 5),
                            decoration: const BoxDecoration(border: Border(bottom: BorderSide())),
                            alignment: Alignment.center,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                item.quantity != null
                                    ? Text(
                                        item.quantity.toString(),
                                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                                      )
                                    : const Text('data missing'),
                                const Text(
                                  ': الكمية',
                                ),
                              ],
                            )),
                      ],
                    )),
              ),
              Container(
                width: 100,
                  padding: const EdgeInsets.only(left: 5, right: 5),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(width: 3, color: Colors.black)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text('المجموع'),
                      total != null
                          ? Text(
                              total.toString(),
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                            )
                          : const Text('data missing'),
                    ],
                  )),

            ],
          ),
        ));
  }
}
