import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app_internship/screens/CartScreen.dart';
import 'package:shopping_app_internship/screens/HomeScreen.dart';
/**
 * Main.dart used for setting up the material app, and screen routes.
 * */
void main() {
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return   ChangeNotifierProvider<Data>(create:(context)=> Data(),
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          home:HomePage(),

          routes: {
            HomePage.id:(context)=>HomePage(),
            CartScreen.id:(context)=>CartScreen()
          } ),
    );


  }
}
