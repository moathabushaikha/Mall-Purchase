import 'package:flutter/material.dart';
import 'package:mall_purchase/Screens/items_list_view.dart';
import 'package:mall_purchase/Screens/screens.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  bool pressed1 = false,pressed2 = false,pressed3 = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(alignment: Alignment.centerRight,child: const Text('القائمة الرئيسية', textAlign: TextAlign.center,)),
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Stack(
          fit: StackFit.loose,
          children: [
            ClipPath(
              clipper: ArcClipper(),
              child: Container(
                alignment: Alignment.center,
                height: 240,
                width: MediaQuery.of(context).size.width,
                color: Colors.orange,
                child: Column(
                  children: const [
                    SizedBox(height: 45,),
                    Text(
                      'مشتريات و فواتير',
                      style: TextStyle(
                        fontSize: 35,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Spacer()
                  ],
                ),
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height * 0.16,
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.6,
                child: ClipPath(
                  clipper: OvalTopBorderClipper(),
                  child: Container(
                    color: Colors.lightBlueAccent,
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 60,
                        ),
                        GestureDetector(
                          onTapUp: (details) {
                            setState(() {
                              pressed1 = false;
                            });
                          },
                          onTapDown: (details) {
                            setState(() {
                              pressed1 = true;
                            });
                          },
                          onTap: () => Navigator.of(context)
                              .push(MaterialPageRoute(builder: (context) => const MainScreen())),
                          child: Container(
                            alignment: Alignment.centerRight,
                            width: 200,
                            height: 70,
                            clipBehavior: Clip.antiAlias,
                            decoration: BoxDecoration(
                              color: !pressed1 ? Colors.orangeAccent : Colors.white,
                              border: Border.all(),
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                const Text(
                                  'فاتورة جديدة',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 24,
                                      color: Colors.black),
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
                                          Icons.add_rounded,
                                          size: 30,
                                          color: Colors.white,
                                        ))),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        GestureDetector(
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
                          onTap: () => Navigator.of(context).push(
                              MaterialPageRoute(builder: (context) => const InvoicesListView())),
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
                                  'تصفح فواتير',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 24,
                                      color: Colors.black),
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
                        const SizedBox(
                          height: 10,
                        ),
                        GestureDetector(
                          onTapUp: (details) {
                            setState(() {
                              pressed3 = false;
                            });
                          },
                          onTapDown: (details) {
                            setState(() {
                              pressed3 = true;
                            });
                          },
                          onTap: () => Navigator.of(context).push(
                              MaterialPageRoute(builder: (context) => const ItemsListView())),
                          child: Container(
                            alignment: Alignment.centerRight,
                            width: 200,
                            height: 70,
                            clipBehavior: Clip.antiAlias,
                            decoration: BoxDecoration(
                              color: !pressed3 ? Colors.orangeAccent : Colors.white,
                              border: Border.all(),
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                const Text(
                                  'تصفح السلع',
                                  style: TextStyle(
                                      fontSize: 24,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
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
                                          Icons.table_rows_rounded,
                                          size: 30,
                                          color: Colors.white,
                                        ))),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height * 0.60,
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.3,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.lightBlueAccent,
                          Colors.lightBlueAccent.shade200,
                          Colors.white
                        ]),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
