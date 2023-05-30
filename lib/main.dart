// import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mall_purchase/Managers/managers.dart';
import 'package:mall_purchase/Screens/screens.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // final cameras = await availableCameras();
  // final firstCamera = cameras.first;
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (context) => ProductManager()),
    ChangeNotifierProvider(create: (context) => PurchaseItemManager())
  ], child: const MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mall Purchase',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MainPage(),
    );
  }
}
