import 'package:flutter/material.dart';
import 'package:mall_purchase/API/firebase_api.dart';
import 'package:mall_purchase/Models/models.dart';

class ItemsListView extends StatefulWidget {
  const ItemsListView({Key? key}) : super(key: key);

  @override
  State<ItemsListView> createState() => _ItemsListViewState();
}

class _ItemsListViewState extends State<ItemsListView> {
  final FireBaseApi fireBaseApi = FireBaseApi();
  List<ProductModel> allProducts = [];
  List<bool> isPressed = [];
  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    getAllProducts();
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
            colors: [Colors.lightBlueAccent, Colors.white]),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Container(
            alignment: Alignment.centerRight,
            child: const Text('عرض السلع'),
          ),
        ),
        body: Column(
          children: [
            Container(
              margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: TextField(
                controller: controller,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  hintText: 'اسم السلعة',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Colors.orangeAccent),
                  ),
                ),
                onChanged: searchItem,
              ),
            ),
            Expanded(
              child: GridView.builder(
                  itemBuilder: (context, index) {
                    final item = allProducts[index];
                    return GestureDetector(
                      onTapDown: (details) => setState(() {
                        isPressed[index] = true;
                      }),
                      onTapUp: (details) => setState(() {
                        isPressed[index] = true;
                      }),
                      onTap: () {},
                      child: Container(
                        clipBehavior: Clip.antiAlias,
                        width: 150,
                        height: 300,
                        margin: const EdgeInsets.all(20.0),
                        alignment: const Alignment(-0.7, -0.8),
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(
                              '${item.imagePath}',
                            ),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.6),
                              blurRadius: 8.0,
                            ),
                          ],
                          color: Colors.orangeAccent,
                          borderRadius: const BorderRadius.all(Radius.circular(16)),
                        ),
                        child: Stack(
                          children: [
                            Positioned(
                                width: 150,
                                height: 60,
                                bottom: 0,
                                child: Container(
                                  alignment: Alignment.bottomCenter,
                                  color: Colors.black.withOpacity(0.3),
                                  child: Text(
                                    '${item.name}',
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 28),
                                  ),
                                ))
                          ],
                        ),
                      ),
                    );
                  },
                  padding: const EdgeInsets.all(8),
                  itemCount: allProducts.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 5,
                    crossAxisSpacing: 2,
                  )),
            )
          ],
        ),
      ),
    );
  }

  void searchItem(String query){
    if (query.isEmpty || query == ' ') {
      setState(() async {
        allProducts = await fireBaseApi.getAllProducts();
      });
    } else if (allProducts.isNotEmpty) {
      final suggestions = allProducts.where((item) {
        final itemName = item.name?.toLowerCase();
        final input = query.toLowerCase();
        return itemName!.contains(input);
      }).toList();
      setState(() {
        allProducts = suggestions;
      });
    }
  }

  void getAllProducts() async {
    List<ProductModel> list = [];
    list = await fireBaseApi.getAllProducts();
    setState(() {
      allProducts = list;
      isPressed = List.generate(list.length, (index) => false);
    });
  }
}
