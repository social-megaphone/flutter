import 'package:flutter/material.dart';

import 'onboarding/onboarding_main.dart';
import 'widgets.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

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

    // SplashScreen이 Widget Tree에 Mounted 되어있을 때만 온보딩 화면으로 Navigate
    if(!mounted) return;
    Navigator.of(context).pushReplacement(
      Routing.customPageRouteBuilder(OnboardingMain(), 1000),
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