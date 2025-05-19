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

  // create FlutterSecureStorage instance
  final fsStorage = FlutterSecureStorage();

  Future<bool> checkIfReturningUser() async {
    // check whether JWT_TOKEN exists or not
    final String? token = await fsStorage.read(key: 'jwt_token');

    // JWT_TOKEN does not exist (which means, this user is new user)
    if (token == null) {
      return false;
    }

    // JWT_TOKEN exists (which means, this user is returning user)
    print('jwt_token: $token');

    // access to endpoint for user profile
    final uri = Uri.parse('https://haruitfront.vercel.app/api/auth/mypage');

    // /api/auth/mypage에 GET 요청 보냄 with [header]
    // [header]는 $token을 갖고 있음.
    final response = await http.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      }
    );

    if (response.statusCode == 200) {
      // response를 잘 받아 왔을 때,
      final data = jsonDecode(response.body);
      print('기존 사용자 확인됨: ${data["data"]["nickname"]}');
      print('기존 사용자의 id: ${data["data"]["id"]}');
      return true;
    } else {
      // 그렇지 못 했을 때
      print('토큰 인증 실패 (status: ${response.statusCode}) → 신규 사용자로 간주');
      return false;
    }
  }

  // these will determine that widgets will be displayed or not
  bool _showSlogan = false;
  bool _showCharacter = false;
  bool _showBlur = false;
  bool _showTitle = false;

  // display widgets one by one
  // and navigate to OnboardingMain or AfterOnboardingMain
  Future<void> _displayAndNavigate() async {
    await Future.delayed(Duration(milliseconds: 400), () {
      setState(() => _showSlogan = true);
    });
    await Future.delayed(Duration(milliseconds: 400), () {
      setState(() => _showCharacter = true);
    });
    await Future.delayed(Duration(milliseconds: 400), () {
      setState(() => _showBlur = true);
    });
    await Future.delayed(Duration(milliseconds: 400*2), () {
      setState(() => _showTitle = true);
    });

    // Wait 1000 milliseconds after displaying all widgets
    await Future.delayed(Duration(milliseconds: 500 * 2));

    // check that user is whether new or returning
    final isReturningUser = await checkIfReturningUser();

    if(!mounted) return;

    // pageIndex: 2 -> BadgeScreenMain (which is home of this application)
    Navigator.of(context).pushReplacement(
      Routing.customPageRouteBuilder(
        isReturningUser ? AfterOnboardingMain(pageIndex: 2) : OnboardingMain(),
        300,
      ),
    );
  }

  // MediaQuery and Theme are not ready in initState.
  // So, we call _displayAndNavigate in didChangeDependencies
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _displayAndNavigate();
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
                  duration: Duration(milliseconds: 500),
                  child: _slogan(),
                ),
                SizedBox(height: 40),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Opacity(
                      opacity: _showBlur ? 1.0 : 0.0,
                      child: _blur(),
                    ),
                    AnimatedOpacity(
                      opacity: _showCharacter ? 1.0 : 0.0,
                      duration: Duration(milliseconds: 500),
                      child: _character(),
                    ),
                  ],
                ),
                AnimatedOpacity(
                  opacity: _showTitle ? 1.0 : 0.0,
                  duration: Duration(milliseconds: 500),
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