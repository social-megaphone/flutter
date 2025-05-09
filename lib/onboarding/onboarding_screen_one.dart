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
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 32,
      ),
      child: Column(
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
          Stack(
            children: [
              Image.asset('assets/images/profile_background_temp.png', height: 280),
              Positioned.fill(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
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
          ),
        ],
      ),
    );
  }
}