import 'package:flutter/material.dart';

// 바텀네비게이션 바 관련 위젯
/*
class BottomWidgets {
  static Positioned customBottomNavigationBar(
      BuildContext context,
      int selectedBottomIndex,
      Function(int) onItemTapped,
      ) {
    return Positioned(
      left: 20,
      right: 20,
      bottom: 40, // 40이나 넣는 이유는, SafeArea 밖이라 그래.
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 10,
        ),
        decoration: BoxDecoration(
          color: const Color(0xFFFFF2CD),
          borderRadius: BorderRadius.circular(30),
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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: const Icon(Icons.home),
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) => const ShareScreenOne(),
                    transitionsBuilder: (context, animation, secondaryAnimation, child) {
                      return FadeTransition(
                        opacity: animation,
                        child: child,
                      );
                    },
                    transitionDuration: const Duration(milliseconds: 500),
                  ),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.bookmark_border),
              onPressed: () {},
            ),
            IconButton(
              icon: FloatingActionButton(
                onPressed: () {

                },
                backgroundColor: Color(0xFF8C7154),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(1000),
                ),
                child: Icon(Icons.add),
              ),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.pets),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.person_outline),
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) => const ProfileScreenOne(),
                    transitionsBuilder: (context, animation, secondaryAnimation, child) {
                      return FadeTransition(
                        opacity: animation,
                        child: child,
                      );
                    },
                    transitionDuration: const Duration(milliseconds: 500),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
*/

// 색상 설정하는 곳
class CustomColors {
  // 스플래시 스크린 배경 색상
  static Color splashScreenBackgroundColor = Color(0xFFFFF7DC);

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