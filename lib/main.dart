import 'dart:io';
import 'package:akhbari/pages/categories_page.dart';
import 'package:akhbari/pages/home_page.dart';
import 'package:akhbari/pages/news_page.dart';
import 'package:akhbari/pages/signin_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:responsive_framework/breakpoint.dart';
import 'package:responsive_framework/responsive_breakpoints.dart';

class MyHttpOverrides extends HttpOverrides {
  HttpClientcreateHttpClient(SecurityContext context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  HttpOverrides.global = new MyHttpOverrides();

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: (context, child) => ResponsiveBreakpoints.builder(
        child: child!,
        breakpoints: [
          const Breakpoint(start: 0, end: 450, name: MOBILE),
          const Breakpoint(start: 451, end: 800, name: TABLET),
          const Breakpoint(start: 801, end: 1920, name: DESKTOP),
          const Breakpoint(start: 1921, end: double.infinity, name: '4K'),
        ],
      ),
      debugShowCheckedModeBanner: false,
      title: 'Akhbari News App',
      theme: ThemeData(
        primarySwatch: Colors.grey,
      ),
      initialRoute: '/login',
      routes: {
        Login.routeName: (context) => Login(),
        HomeScreen.routeName: (context) => HomeScreen(),
        Categories.routeName: (context) => Categories(),
        NewsScreen.routeName: (context) => NewsScreen(),
      },
    );
  }
}
