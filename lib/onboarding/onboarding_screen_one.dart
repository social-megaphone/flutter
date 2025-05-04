import 'package:flutter/material.dart';

import '../widgets.dart';

class OnboardingScreenOne extends StatefulWidget {
  const OnboardingScreenOne({super.key});

  @override
  State<OnboardingScreenOne> createState() => _OnboardingScreenOneState();
}

class _OnboardingScreenOneState extends State<OnboardingScreenOne> {

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 60),
        // 방석 아이콘 (width < height 이므로, height만 설정)
        Image.asset('assets/images/character_with_cushion.png', height: 175),
        SizedBox(height: 12),
        // 메인 텍스트
        Onboarding.onboardingScreenMainTextContainer(
          '똑똑, 하루잇 방에\n찾아온 활발한 거북이님,\n만나서 반가워요!'
        ),
        SizedBox(height: 28),
        // 닉네임 부분
        Container(
          padding: EdgeInsets.symmetric(
            vertical: 20,
            horizontal: 80,
          ),
          decoration: BoxDecoration(
            color: Color(0xFFFAFAFA),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1), // 아주 연한 그림자
                blurRadius: 20, // 퍼짐 정도
                spreadRadius: 0, // 그림자 크기 확장 없음
                offset: Offset(0, 8), // 아래쪽으로 살짝 이동
              ),
              BoxShadow(
                color: Colors.black.withOpacity(0.1), // 아주 연한 그림자
                blurRadius: 20, // 퍼짐 정도
                spreadRadius: 0, // 그림자 크기 확장 없음
                offset: Offset(0, -8), // 아래쪽으로 살짝 이동
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 12),
              // 방석 아이콘 (width < height 이므로, height만 설정)
              Image.asset('assets/images/profile_image_temp.png', height: 100),
              SizedBox(height: 20),
              Text(
                '활발한 거북이',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF8C7154),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}