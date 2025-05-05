import 'package:flutter/material.dart';

import 'onboarding/onboarding_main.dart';
import 'widgets.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  // Slogan, Character, Title을 보여줄 지 결정하는 boolean 변수 3개
  bool _showSlogan = false;
  bool _showCharacter = false;
  bool _showTitle = false;

  // Slogan, Character, Title을 차례대로 나타내고, 온보딩 화면으로 Navigate
  Future<void> _animateAndNavigate() async {

    // 슬로건 나타내기
    await Future.delayed(Duration(milliseconds: 750), () {
      setState(() => _showSlogan = true);
    });
    // 캐릭터 나타내기
    await Future.delayed(Duration(milliseconds: 750), () {
      setState(() => _showCharacter = true);
    });
    // 타이틀 나타내기
    await Future.delayed(Duration(milliseconds: 750), () {
      setState(() => _showTitle = true);
    });

    await Future.delayed(Duration(milliseconds: 750 * 3));

    // SplashScreen이 Widget Tree에 Mounted 되어있을 때만 온보딩 화면으로 Navigate
    if(!mounted) return;
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => const OnboardingMain(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 1500),
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
                AnimatedOpacity(
                  opacity: _showCharacter ? 1.0 : 0.0,
                  duration: Duration(milliseconds: 750),
                  child: _character(),
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

  Stack _character() {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 175,
          height: 175,
          margin: EdgeInsets.only(bottom: 25),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Color(0x80FFDE9F),// 노란빛 후광
                blurRadius: 30,
                spreadRadius: 10,
              ),
            ],
          ),
        ),
        // 방석 아이콘 (width < height 이므로, height만 설정)
        Image.asset('assets/images/character_with_cushion.png', height: 175),
      ],
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