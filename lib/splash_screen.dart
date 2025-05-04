import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart'; // kIsWeb

import 'onboarding/onboarding_main.dart';
import 'widgets.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  Future<void> _loadAssetsAndDelayAndNavigate() async {
    /// 여기에 들어갈 image를 꽃잎 이미지로 바꿔줘야 함.
    await precacheImage(
      AssetImage('assets/images/background_onboarding_screen.png'),
      context,
    );

    await Future.delayed(Duration(milliseconds: 750 * 6));

    // 이제 안전하게 다음 화면으로 이동
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

  // Slogan, Character, Title을 보여줄 지 결정하는 boolean 변수 3개
  bool _showSlogan = false;
  bool _showCharacter = false;
  bool _showTitle = false;

  @override
  void initState() {
    super.initState();
    // 순차적으로 애니메이션 보이게 하기
    Future.delayed(Duration(milliseconds: 750), () {
      setState(() => _showSlogan = true);
    });
    Future.delayed(Duration(milliseconds: 750 * 2), () {
      setState(() => _showCharacter = true);
    });
    Future.delayed(Duration(milliseconds: 750 * 3), () {
      setState(() => _showTitle = true);
    });
  }

  // initState에서는, MediaQuery, Theme등이 준비되지 않았음
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadAssetsAndDelayAndNavigate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.splashScreenBackgroundColor,
      body: SafeArea(
        child: GestureDetector(
          onTap: () {
            // 웹의 경우 터치하면 실행
            if(kIsWeb) {
              Navigator.of(context).pushReplacement(
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) => const OnboardingMain(),
                  transitionsBuilder: (context, animation, secondaryAnimation, child) {
                    return FadeTransition(
                      opacity: animation,
                      child: child,
                    );
                  },
                  transitionDuration: const Duration(milliseconds: 1000),
                ),
              );
            }
            // 모바일의 경우 아무것도 실행하지 않음.
          },
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedOpacity(
                  opacity: _showSlogan ? 1.0 : 0.0,
                  duration: Duration(milliseconds: 850),
                  child: _slogan(),
                ),
                SizedBox(height: 40),
                AnimatedOpacity(
                  opacity: _showCharacter ? 1.0 : 0.0,
                  duration: Duration(milliseconds: 850),
                  child: _character(),
                ),
                AnimatedOpacity(
                  opacity: _showTitle ? 1.0 : 0.0,
                  duration: Duration(milliseconds: 850),
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
                color: Color(0xFFFFDE9F).withOpacity(0.5), // 노란빛 후광
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