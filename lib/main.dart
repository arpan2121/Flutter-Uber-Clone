import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'authentication/sign_up_page.dart';
import 'authentication/login.dart';
import 'package:flutter/widgets.dart';
import 'pages/home_page.dart';
void main() async
{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
        apiKey: "AIzaSyDIW7iBkkRg6y1alMPVwrBpnBI3nb9OJ-o",
        appId: "1:264406890327:android:d672d68473cfaeb37b3012",
        messagingSenderId: "264406890327",
        projectId: "flutter-uber-clone-admin-5eded"
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black,
      ),
      home:LoginScreen(),
    );
  }
}


