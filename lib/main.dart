import 'package:flutter/material.dart';

import 'splash_screen.dart';

void main() {
  // To ensure that plugins are properly initialized
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: MaterialApp(
        // disable the debug banner at top right
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: 'NotoSansKR',
        ),
        // So, the application starts at SplashScreen
        home: SplashScreen(),
      ),
    );
  }
}