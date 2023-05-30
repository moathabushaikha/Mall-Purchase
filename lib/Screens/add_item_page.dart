import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'dart:io';
import 'package:mall_purchase/Models/models.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mall_purchase/Screens/screens.dart';
import 'package:provider/provider.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:mall_purchase/Managers/managers.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List<String> items = ['حبة', 'كيلو', 'علبة', 'كيس'];
  List<ProductModel>? allProducts;
  String? selectedItem;
  File? fileImage;
  String imagePath = '';
  bool itemExist = false, clearName = false, pressed = false, pressed2 = false;
  int itemIndex = -1;
  List<String> matches = <String>[];
  TextEditingController nameTec = TextEditingController();
  TextEditingController priceTec = TextEditingController();
  TextEditingController quantityTec = TextEditingController();
  TextEditingController oldPriceTec = TextEditingController();
  FocusNode focusNode1 = FocusNode();
  Reference referenceStroage = FirebaseStorage.instance.ref();
  final formKey = GlobalKey<FormState>();

  Future pickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.camera);
      if (image == null) return;
      final imageTemp = File(image.path);
      setState(() {
        fileImage = imageTemp;
      });
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  @override
  void initState() {
    getItems();
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
          title: Container(
              alignment: Alignment.centerRight,
              child: const Text(
                'اضافة فاتورة',
                textAlign: TextAlign.center,
              )),
        ),
        body: Consumer2<ProductManager, PurchaseItemManager>(
            builder: (context, productManager, purchaseManager, child) {
          List<String> suggestions = [];
          for (var product in productManager.items) {
            suggestions.add(product.name.toString());
          }
          return SingleChildScrollView(
              child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 8, bottom: 4),
                  width: MediaQuery.of(context).size.width,
                  height: 200,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      fileImage != null || imagePath.isNotEmpty
                          ? IconButton(
                              onPressed: () {
                                setState(() {
                                  fileImage = null;
                                  imagePath = '';
                                });
                              },
                              icon: const Icon(Icons.highlight_remove_sharp),
                              iconSize: 30,
                            )
                          : Container(),
                      Container(
                        clipBehavior: Clip.antiAlias,
                        alignment: Alignment.center,
                        width: 200,
                        decoration: BoxDecoration(boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 8.0,
                          ),
                        ], borderRadius: BorderRadius.circular(12), border: Border.all(width: 3,color: Colors.black)),
                        child: GestureDetector(
                          onTap: pickImage,
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height,
                            child: imagePath.isNotEmpty
                                ? Image.network(
                                    imagePath,
                                    fit: BoxFit.cover,
                                    loadingBuilder: (BuildContext context, Widget child,
                                        ImageChunkEvent? loadingProgress) {
                                      if (loadingProgress == null) return child;
                                      return Center(
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                          value: loadingProgress.expectedTotalBytes != null
                                              ? loadingProgress.cumulativeBytesLoaded /
                                                  loadingProgress.expectedTotalBytes!
                                              : null,
                                        ),
                                      );
                                    },
                                  )
                                : fileImage != null
                                    ? Image.file(
                                        fileImage!,
                                        fit: BoxFit.cover,
                                      )
                                    : SizedBox(
                                        child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: const [
                                          Text(
                                            'حمل صورة من الكاميرا',
                                            style: TextStyle(color: Colors.black,fontSize: 20),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Icon(
                                            Icons.camera_alt_outlined,
                                            size: 52,
                                            color: Colors.black,
                                          ),
                                        ],
                                      )),
                          ),
                        ),
                      ),
                      fileImage != null
                          ? const SizedBox(
                              width: 40,
                            )
                          : Container()
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: RawAutocomplete(
                      textEditingController: nameTec,
                      focusNode: focusNode1,
                      optionsBuilder: (TextEditingValue textEditingValue) {
                        if (textEditingValue.text == '') {
                          return const Iterable<String>.empty();
                        } else {
                          matches = [];
                          matches.addAll(suggestions);
                          matches.retainWhere((s) {
                            return s.toLowerCase().contains(textEditingValue.text.toLowerCase());
                          });
                          return matches;
                        }
                      },
                      onSelected: (String selection) {
                        setState(() {
                          itemIndex = suggestions.indexOf(selection);
                          priceTec.text = (productManager.items[itemIndex].price).toString();
                          imagePath = (productManager.items[itemIndex].imagePath).toString();
                          oldPriceTec.text =
                              (productManager.items[itemIndex].oldPrices.last).toString();
                          selectedItem = (productManager.items[itemIndex].measuringUnit).toString();
                          itemExist = true;
                        });
                      },
                      fieldViewBuilder: (BuildContext context,
                          TextEditingController textEditingController,
                          FocusNode focusNode,
                          VoidCallback onFieldSubmitted) {
                        return TextFormField(
                          validator: (value) =>
                              value == null || value.isEmpty ? 'يجب تعبئة اسم السلعة' : null,
                          controller: textEditingController,
                          focusNode: focusNode,
                          textAlign: TextAlign.center,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            alignLabelWithHint: true,
                            filled: true,
                            suffixIcon: const Icon(Icons.dashboard_customize_outlined),
                            fillColor: Colors.white,
                            //const Color.fromRGBO(255, 255, 255, 0.4),
                            floatingLabelStyle: const TextStyle(color: Colors.black, fontSize: 20),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(color: Colors.black, width: 2)),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            label: Container(
                                color: Colors.transparent,
                                margin: const EdgeInsets.only(top: 3),
                                alignment: Alignment.topRight,
                                child: const Text(
                                  'اسم المادة',
                                  textAlign: TextAlign.right,
                                )),
                          ),
                        );
                      },
                      optionsViewBuilder: (BuildContext context, void Function(String) onSelected,
                          Iterable<String> options) {
                        return Material(
                            child: SizedBox(
                                height: 200,
                                child: SingleChildScrollView(
                                    child: Column(
                                  children: options.map((opt) {
                                    return InkWell(
                                        onTap: () {
                                          onSelected(opt);
                                        },
                                        child: Container(
                                            padding: const EdgeInsets.only(right: 60),
                                            child: Card(
                                                child: Container(
                                              width: double.infinity,
                                              padding: const EdgeInsets.all(10),
                                              child: Text(opt),
                                            ))));
                                  }).toList(),
                                ))));
                      },
                    )),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  children: [
                    SizedBox(
                        width: MediaQuery.of(context).size.width * 0.5,
                        child: TextFormField(
                          validator: (value) =>
                              value == null || value.isEmpty ? 'يجب تعبئة سعر السلعة' : null,
                          controller: priceTec,
                          textAlign: TextAlign.center,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            alignLabelWithHint: true,
                            filled: true,
                            suffixIcon: const Icon(Icons.money),
                            fillColor: Colors.white,
                            //const Color.fromRGBO(255, 255, 255, 0.4),
                            floatingLabelStyle: const TextStyle(color: Colors.black, fontSize: 20),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(color: Colors.black, width: 2)),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            label: Container(
                                color: Colors.transparent,
                                margin: const EdgeInsets.only(top: 3),
                                alignment: Alignment.topRight,
                                child: const Text(
                                  'سعر السلعة',
                                  textAlign: TextAlign.right,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )),
                          ),
                        )),
                    const SizedBox(
                      width: 15,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.45,
                      child: TextFormField(
                        validator: (value) =>
                            value == null || value.isEmpty ? 'يجب تعبئة الكمية' : null,
                        controller: quantityTec,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          alignLabelWithHint: true,
                          filled: true,
                          fillColor: Colors.white,
                          //const Color.fromRGBO(255, 255, 255, 0.4),
                          floatingLabelStyle: const TextStyle(color: Colors.black, fontSize: 20),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(color: Colors.black, width: 2)),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          label: Container(
                              color: Colors.transparent,
                              margin: const EdgeInsets.only(top: 3),
                              alignment: Alignment.topRight,
                              child: const Text(
                                'الكمية',
                                textAlign: TextAlign.right,
                              )),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 25,
                ),
                Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(),
                          borderRadius: const BorderRadius.all(Radius.circular(10))),
                      width: MediaQuery.of(context).size.width * 0.5,
                      alignment: Alignment.bottomRight,
                      child: DropdownButton<String>(
                        value: selectedItem,
                        icon: const Icon(Icons.category),
                        hint: const Text(
                          'النوع                                     ',
                          textAlign: TextAlign.right,
                        ),
                        items: items
                            .map((item) => DropdownMenuItem<String>(
                                  value: item,
                                  child: Text(item),
                                ))
                            .toList(),
                        onChanged: (item) {
                          setState(() {
                            selectedItem = item;
                          });
                        },
                      ),
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.45,
                      child: TextField(
                        controller: oldPriceTec,
                        textInputAction: TextInputAction.next,
                        enabled: false,
                        decoration: InputDecoration(
                          alignLabelWithHint: true,
                          filled: true,
                          suffixIcon: const Icon(Icons.change_circle_outlined),
                          fillColor: Colors.white,
                          //const Color.fromRGBO(255, 255, 255, 0.4),
                          floatingLabelStyle: const TextStyle(color: Colors.black, fontSize: 20),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(color: Colors.black, width: 2)),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          label: Container(
                              color: Colors.transparent,
                              margin: const EdgeInsets.only(top: 3),
                              alignment: Alignment.topRight,
                              child: const Text(
                                'السعر القديم',
                                textAlign: TextAlign.right,
                              )),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 60,
                ),
                Row(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: GestureDetector(
                        onTapUp: (details) {
                          setState(() {
                            pressed2 = false;
                          });
                        },
                        onTapDown: (details) {
                          setState(() {
                            pressed2 = true;
                          });
                        },
                        onTap: () {
                          purchaseManager.items.isNotEmpty
                              ? Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => InvoicePage(items: purchaseManager.items,showAddButton: true),
                                ))
                              : ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(content: Text('لا يوجد مشتريات')));
                        },
                        child: Container(
                          alignment: Alignment.centerRight,
                          width: 200,
                          height: 70,
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(
                            color: !pressed2 ? Colors.orangeAccent : Colors.white,
                            border: Border.all(),
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              const Text(
                                'معاينة الفاتورة',
                                style: TextStyle(
                                    fontSize: 18, color: Colors.black, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              ClipPath(
                                  clipper: OvalLeftBorderClipper(),
                                  child: Container(
                                      height: MediaQuery.of(context).size.height,
                                      width: 60,
                                      color: Colors.black,
                                      child: const Icon(
                                        Icons.my_library_books,
                                        size: 30,
                                        color: Colors.white,
                                      ))),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.45,
                      child: GestureDetector(
                        onTapUp: (details) {
                          setState(() {
                            pressed = false;
                          });
                        },
                        onTapDown: (details) {
                          setState(() {
                            pressed = true;
                          });
                        },
                        onTap: () async {
                          final isValid = formKey.currentState?.validate();
                          if (isValid != null && isValid) {
                            ProductModel product = ProductModel(
                                '',
                                itemIndex != -1 ? productManager.items[itemIndex].oldPrices : [],
                                double.parse(quantityTec.text),
                                '',
                                name: nameTec.text,
                                price: double.parse(priceTec.text.toString()),
                                measuringUnit: selectedItem);
                            if (!itemExist) {
                              product.oldPrices.add(product.price);
                              Reference rootImages = referenceStroage.child('Images');
                              Reference imageToUpload = rootImages.child(nameTec.text);
                              try {
                                if (fileImage != null) {
                                  await imageToUpload.putFile(fileImage!);
                                  imagePath = await imageToUpload.getDownloadURL();
                                  product.imagePath = imagePath;
                                }
                              } catch (error) {}
                              productManager.addItem(product);
                            } else {
                              if (productManager.items[itemIndex].oldPrices.last != product.price) {
                                product.oldPrices.add(product.price);
                                productManager.updateItem(product);
                              }
                              product.imagePath = imagePath;
                            }
                            purchaseManager.addItem(product);

                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('تم اضافة السلعة ${nameTec.text}')));
                            }
                            priceTec.clear();
                            quantityTec.clear();
                            oldPriceTec.clear();
                            nameTec.clear();
                            setState(() {
                              itemExist = false;
                              matches = [];
                              itemIndex = -1;
                              selectedItem = null;
                              clearName = true;
                              fileImage = null;
                              imagePath = '';
                            });
                          }
                        },
                        child: Container(
                          alignment: Alignment.centerRight,
                          width: 200,
                          height: 70,
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(
                            color: !pressed ? Colors.orangeAccent : Colors.white,
                            border: Border.all(),
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              const Text(
                                'اضف للفاتورة',
                                style: TextStyle(
                                    fontSize: 18, color: Colors.black, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              ClipPath(
                                  clipper: OvalLeftBorderClipper(),
                                  child: Container(
                                      height: MediaQuery.of(context).size.height,
                                      width: 60,
                                      color: Colors.black,
                                      child: const Icon(
                                        Icons.add_shopping_cart,
                                        size: 30,
                                        color: Colors.white,
                                      ))),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ));
        }),
      ),
    );
  }

  void getItems() async {
    await Provider.of<ProductManager>(context, listen: false).getProducts();
  }
}
