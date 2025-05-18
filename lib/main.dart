import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http; // 네트워크 통신 패키지
import 'dart:convert'; // JSON 파싱 패키지

import 'package:firebase_core/firebase_core.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'splash_screen.dart';

void main() async {
  // 플러그인이 제대로 초기화되도록 추가
  WidgetsFlutterBinding.ensureInitialized();

  // Hive Initialization and open userBox
  await Hive.initFlutter();
  await Hive.openBox('userBox');
  //123
  //await fetchRoutines();
  //await registerUser();

  runApp(const MyApp());
}

List<Map<String, dynamic>> fetchedRoutine = [];

Future<void> fetchRoutines() async {
  final uri = Uri.parse('https://haruitfront.vercel.app/api/routine?tag=자기이해');
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

// 현재 기준 얘처럼 보내면 아무 문제 없음
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
        "id": "6822a2d2e908569ba237f299",
        "title": "오늘의 기분 한 줄 남기기",
        "desc": "하루를 마무리하며, 내 감정이나 기분을 한 문장으로 기록해요. 조금 어설퍼도 괜찮아요.",
        "how": "내 감정을 떠올리게 하는 사진을 찍거나, 감정을 표현한 이미지를 올려요. 한 문장으로 오늘의 기분을 기록해요.",
        "icon": "✍️",
        "color": "FFE8F3"
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