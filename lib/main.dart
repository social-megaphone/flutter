import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import 'splash_screen.dart';

void main() async {
  // 플러그인이 제대로 초기화되도록 추가
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 430, // 아이폰 14 Pro 가로 폭 고정
          maxHeight: (kIsWeb) ? 430 * 17 / 9 : 430 * 19.5 / 9, // 아이폰 14 Pro 세로 폭 고정
        ),
        child: AspectRatio(
          aspectRatio: (kIsWeb) ? 9 / 17 : 9 / 19.5,
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              fontFamily: 'NotoSansKR',
            ),
            home: SplashScreen(),
          ),
        ),
      ),
    );
  }
}