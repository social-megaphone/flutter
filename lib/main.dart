import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http; // 네트워크 통신 패키지
import 'dart:convert'; // JSON 파싱 패키지

import 'splash_screen.dart';

void main() async {
  // 플러그인이 제대로 초기화되도록 추가
  WidgetsFlutterBinding.ensureInitialized();

  //await fetchRoutines();
  //await registerUser();

  runApp(const MyApp());
}

List<Map<String, dynamic>> fetchedRoutine = [];

Future<void> fetchRoutines() async {
  final uri = Uri.parse('https://haruitfront.vercel.app/api/routine');
  final response = await http.get(uri);

  if (response.statusCode == 200) {
    final List<dynamic> jsonData = jsonDecode(response.body);
    for (var routine in jsonData) {
      fetchedRoutine.add(routine);
    }

    print('fetchedRoutine: $fetchedRoutine');
    
  } else {
    print('오류 발생: ${response.statusCode}');
  }
}

Future<void> registerUser() async {
  final uri = Uri.parse('https://haruitfront.vercel.app/api/auth/initial');

  final response = await http.post(
    uri,
    headers: {
      'Content-Type': 'application/json',
    },
    body: jsonEncode({
      // _id는 짜피 랜덤 선택되는데, 그렇다면, 어떻게 사용자를 구분하는가?
      // JWT_TOKEN으로 구분한다!
      // JWT_TOKEN은 response["JWT_TOKEN"]으로 받아올 수 있다.
      "nickname": "무슨 거북이 머시기 그런 거", // onboarding_screen_one에서 randomName으로 저장함
      "goalDate": 30, // onboarding_screen_two에서 goalDate로 저장함
      "routine": {
        "id": "68218b8d1cfea378c19e9475",
        "title": "내 공간 1개 정돈하기",
        "desc": "깔끔하고 깨끗해진 내 공간을 만들어보세요.",
        "how": "깔끔하게 정돈한 사진을 찍고, 공유해요.",
        "icon": "🗑️️",
        "color": "yellow"
      },
      "reflection": "책상을 정리하니 행복하네.",
      "imgSrc": "https://i.imgur.com/Ot5DWAW.png"
    }),
  );

  if (response.statusCode == 200) {
    final responseData = jsonDecode(response.body);
    
    // 회원가입 성공 메시지 출력
    print('회원가입 성공: ${responseData["message"]}');
    // JWT Token 출력
    print('JWT Token: ${responseData["JWT_TOKEN"]}');
  } else {
    print('회원가입 실패: ${response.statusCode}');
    print('response.body: ${response.body}');
  }
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