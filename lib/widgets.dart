import 'package:flutter/material.dart';
import 'package:flutter_inner_shadow/flutter_inner_shadow.dart';

// 색상 설정하는 곳
class CustomColors {
  // 기본 배경 색상
  // 사용처
  // 1. spalsh_screen.dart
  static Color defaultBackgroundColor = Color(0xFFFFF7DC);
}

// 페이지 넘기는 라우팅 관련 위젯
class Routing {
  // 모핑을 곁들인 화면 전환
  static PageRouteBuilder customPageRouteBuilder(Widget destinationWidget, int duration) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => destinationWidget,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
      transitionDuration: Duration(milliseconds: duration),
    );
  }

  // 뒤로가기 버튼의 위치 (부모로는 SafeArea)
  static Padding backButton() {
    return Padding(
      padding: const EdgeInsets.only(
        left: 16,
        top: 12,
      ),
      child: Icon(
        Icons.arrow_back_ios_new,
        size: 24,
        color: Color(0xFF000000),
      ),
    );
  }
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

class AfterOnboarding {
  // 내부 padding all 12, 외부 padding horizontal 32 기준, 우측 정렬된 경우 사용할 notificationButton
  static Column notificationButton(Color backgroundColor, Color iconColor) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: backgroundColor,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1), // 아주 연한 그림자
                blurRadius: 5, // 퍼짐 정도
                spreadRadius: 0, // 그림자 크기 확장 없음
                offset: Offset(0, 2), // 아래쪽으로 살짝 이동
              ),
              BoxShadow(
                color: Colors.black.withOpacity(0.1), // 아주 연한 그림자
                blurRadius: 5, // 퍼짐 정도
                spreadRadius: 0, // 그림자 크기 확장 없음
                offset: Offset(0, -2), // 아래쪽으로 살짝 이동
              ),
            ],
          ),
          child: Center(
            child: Icon(
              Icons.notifications,
              size: 20,
              color: iconColor,
            ),
          ),
        ),
        SizedBox(height: 32),
      ],
    );
  }
}

class CustomSnackBar {
  static void show(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Color(0xFF8C7154),
        duration: Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        margin: EdgeInsets.only(
          left: 16,
          right: 16,
          bottom: (message == "남겨주신 사진과 소감을 저장하고 있어요\n조금만 기다려주세요") ? 300 : 58, // 네비게이션 바 위로 올리기
          top: 16,
        ),
      ),
    );
  }
}