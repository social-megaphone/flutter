import 'package:flutter/material.dart';
import 'package:flutter_inner_shadow/flutter_inner_shadow.dart';

// 색상 설정하는 곳
class CustomColors {
  // 기본 배경 색상
  // 사용처
  // 1. spalsh_screen.dart
  static Color defaultBackgroundColor = Color(0xFFFFF7DC);
}

// 온보딩 스크린 관련 위젯
class Onboarding {
  static InnerShadow onboardingScreenMainTextContainer(String onboardingScreenMainText) {
    return InnerShadow(
      shadows: [
        Shadow(
          color: Colors.grey,
          blurRadius: 4,
          offset: Offset(0, 2),
        ),
      ],
      child: Container(
        // 최대 넓이로 설정
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          vertical: 20,
          horizontal: 40,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          // 움푹 들어간 효과를 주는 그라데이션 테두리
          border: Border.all(
            color: Colors.transparent,
          ),
          // 내부에 그림자 효과를 주는 박스 데코레이션
          boxShadow: [
            // 상단 그림자 (진함)
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 5,
              spreadRadius: 1,
              offset: Offset(0, 2),
            ),
            // 전체적인 안쪽 그림자
            BoxShadow(
              color: Colors.white.withOpacity(0.9),
              blurRadius: 0,
              spreadRadius: -1,
              offset: Offset(0, 0),
            ),
          ],
        ),
        child: Text(
          onboardingScreenMainText,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Color(0xFF121212),
            height: 1.5, // 줄 간격 조금 띄우기
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}