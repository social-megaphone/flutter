import 'package:flutter/material.dart';

// 색상 설정하는 곳
class CustomColors {
  // 기본 배경 색상
  // 사용처
  // 1. spalsh_screen.dart
  static Color defaultBackgroundColor = Color(0xFFFFF7DC);
}

// 온보딩 스크린 관련 위젯
class Onboarding {
  static Container onboardingScreenMainTextContainer(String onboardingScreenMainText) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: 20,
      ),
      padding: EdgeInsets.symmetric(
        vertical: 20,
        horizontal: 40,
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
      child: Text(
        onboardingScreenMainText,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w500,
          color: Color(0xFF121212),
          height: 1.5, // 줄 간격 조금 띄우기
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}