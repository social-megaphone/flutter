import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'onboarding/onboarding_main.dart';
import 'after_onboarding_main.dart';
import 'widgets.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  // FlutterSecureStorage 인스턴스 생성
  final fsStorage = FlutterSecureStorage();

  Future<bool> checkIfReturningUser() async {
    // jwt_token이 있는 지 체크
    final token = await fsStorage.read(key: 'jwt_token');

    if (token == null) {
      // token이 없을 때 == 신규 사용자 일 때
      print('jwt_token is null. this user is new user');
      return false;
    }

    // token이 있을 때 == 기존 사용자 일 때
    print('jwt_token is not null. this user is returning user');
    print('jwt_token: $token');

    // /api/auth/mypage로 접근
    final uri = Uri.parse('https://haruitfront.vercel.app/api/auth/mypage');

    // /api/auth/mypage에 GET 요청 보냄 with [header]
    // [header]는 $token을 갖고 있음.
    final response = await http.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      // response를 잘 받아 왔을 때,
      final data = jsonDecode(response.body);
      print('기존 사용자 확인됨: ${data["data"]["nickname"]}');
      return true;
    } else {
      // 그렇지 못 했을 때
      print('토큰 인증 실패 (status: ${response.statusCode}) → 신규 사용자로 간주');
      return false;
    }
  }

  // Slogan, Character, Blur, Title을 보여줄 지 결정하는 boolean 변수 4개
  bool _showSlogan = false;
  bool _showCharacter = false;
  bool _showBlur = false;
  bool _showTitle = false;

  // Slogan, Character, Blur, Title을 차례대로 나타내고, 온보딩 화면으로 Navigate
  Future<void> _animateAndNavigate() async {
    // 슬로건 나타내기
    await Future.delayed(Duration(milliseconds: 750), () {
      setState(() => _showSlogan = true);
    });
    // 캐릭터 나타내기
    await Future.delayed(Duration(milliseconds: 750), () {
      setState(() => _showCharacter = true);
    });
    // 블러 효과 나타내기
    await Future.delayed(Duration(milliseconds: 750), () {
      setState(() => _showBlur = true);
    });
    // 타이틀 나타내기
    await Future.delayed(Duration(milliseconds: 750*2), () {
      setState(() => _showTitle = true);
    });

    // 모든 요소가 보여진 후 더 오래 대기
    await Future.delayed(Duration(milliseconds: 750 * 4));

    final isReturningUser = await checkIfReturningUser();

    // SplashScreen이 Widget Tree에 Mounted 되어있을 때만 온보딩 화면으로 Navigate
    if(!mounted) return;
    Navigator.of(context).pushReplacement(
      Routing.customPageRouteBuilder(
        isReturningUser ? AfterOnboardingMain() : OnboardingMain(),
        1000,
      ),
    );
  }

  // initState에서는, MediaQuery, Theme등이 준비되지 않았음
  // 그래서 _animateAndNavigate를 didChangeDependencies에서 처리
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _animateAndNavigate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.defaultBackgroundColor,
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedOpacity(
                  opacity: _showSlogan ? 1.0 : 0.0,
                  duration: Duration(milliseconds: 750),
                  child: _slogan(),
                ),
                SizedBox(height: 40),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    AnimatedOpacity(
                      opacity: _showBlur ? 1.0 : 0.0,
                      duration: Duration(milliseconds: 750),
                      curve: Curves.easeInOutCubic,
                      child: _blur(),
                    ),
                    AnimatedOpacity(
                      opacity: _showCharacter ? 1.0 : 0.0,
                      duration: Duration(milliseconds: 750),
                      child: _character(),
                    ),
                  ],
                ),
                AnimatedOpacity(
                  opacity: _showTitle ? 1.0 : 0.0,
                  duration: Duration(milliseconds: 750),
                  child: _title(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Text _slogan() {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
              text: '학교 밖 고립, 은둔형\n청소년을 잇는 '
          ),
          WidgetSpan(
            child: Container(
              width: 60,
              height: 2.5,
              decoration: BoxDecoration(
                color: Color(0xFF8C7154),
                borderRadius: BorderRadius.circular(1000),
              ),
            ),
            alignment: PlaceholderAlignment.middle,
          ),
          TextSpan(
            text: '\n',
          ),
          WidgetSpan(
            child: Container(
              width: 80,
              height: 2.5,
              decoration: BoxDecoration(
                color: Color(0xFF8C7154),
                borderRadius: BorderRadius.circular(1000),
              ),
            ),
            alignment: PlaceholderAlignment.middle,
          ),
          TextSpan(
            text: ' 안전한 루틴',
          ),
        ],
        style: TextStyle(
          fontSize: 25,
          fontWeight: FontWeight.w700,
          color: Color(0xFF8C7154),
          height: 1.5,
        ),
      ),
      textAlign: TextAlign.center,
    );
  }

  Image _character() {
    return Image.asset('assets/images/character_with_cushion.png', height: 175);
  }

  Widget _blur() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 2000),
      curve: Curves.easeInOutCubic,
      width: _showBlur ? 175 : 0,
      height: _showBlur ? 175 : 0,
      margin: EdgeInsets.only(bottom: 25),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Color(0x80FFDE9F),
            blurRadius: _showBlur ? 30 : 0,
            spreadRadius: _showBlur ? 10 : 0,
          ),
        ],
      ),
    );
  }

  Text _title() {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: '하루 ',
          ),
          WidgetSpan(
            child: Container(
              width: 40,
              height: 5,
              decoration: BoxDecoration(
                color: Color(0xFF8C7154),
                borderRadius: BorderRadius.circular(1000),
              ),
            ),
            alignment: PlaceholderAlignment.middle,
          ),
          TextSpan(
            text: ' 잇',
          ),
        ],
        style: TextStyle(
          fontSize: 50,
          fontWeight: FontWeight.w700,
          color: Color(0xFF8C7154),
        ),
      ),
    );
  }
}