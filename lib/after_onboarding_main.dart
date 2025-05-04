import 'package:flutter/material.dart';

import '../lounge/lounge_screen_main.dart';
import '../save/save_screen_main.dart';
import '../badge/badge_screen_main.dart';
import '../profile/profile_screen_main.dart';

class AfterOnboardingMain extends StatefulWidget {
  const AfterOnboardingMain({super.key, this.pageIndex});

  final int? pageIndex;

  @override
  State<AfterOnboardingMain> createState() => _AfterOnboardingMainState();
}

class _AfterOnboardingMainState extends State<AfterOnboardingMain> {
  int _currentPageIndex = 0; // 현재 페이지 인덱스

  List<Widget> afterOnboardingPages = [
    LoungeScreenMain(),
    SaveScreenMain(),
    BadgeScreenMain(),
    ProfileScreenMain(),
  ];

  @override
  void initState() {
    super.initState();
    if(widget.pageIndex != null) {
      _currentPageIndex = widget.pageIndex!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: (_currentPageIndex == 2) ? Color(0xFFA58768) : Color(0xFFFFF7DC),
      body: Stack(
        children: [
          SafeArea(
            child: afterOnboardingPages[_currentPageIndex],
          ),
          // 바텀 네비게이션 바
          Positioned(
            left: 16,
            right: 16,
            bottom: 24, // SafeArea 밖이니까
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
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _currentPageIndex = 0;
                      });
                    },
                    child: Image.asset(
                      'assets/images/bottom_nav_icon/lounge_icon.png',
                      width: 24,
                      color: (_currentPageIndex == 0) ? Colors.black : Colors.grey,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        // mvp에서는 비활성화!
                        //_currentPageIndex = 1;
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("현재 기능은 준비 중입니다."),
                          behavior: SnackBarBehavior.floating,
                          backgroundColor: Colors.black87,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          margin: EdgeInsets.only(
                            bottom: MediaQuery.of(context).size.height * 0.075,
                            left: 16,
                            right: 16,
                          ),
                        ),
                      );
                    },
                    child: Image.asset(
                      'assets/images/bottom_nav_icon/save_icon.png',
                      width: 24,
                      color: (_currentPageIndex == 1) ? Colors.black : Colors.grey,
                    ),
                  ),
                  IconButton(
                    icon: FloatingActionButton(
                      onPressed: () {
                        // onboarding쪽으로 넘겨야대.
                      },
                      backgroundColor: Color(0xFF8C7154),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(1000),
                      ),
                      child: Icon(Icons.add),
                    ),
                    onPressed: () {},
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _currentPageIndex = 2;
                      });
                    },
                    child: Image.asset(
                      'assets/images/bottom_nav_icon/badge_icon.png',
                      width: 24,
                      color: (_currentPageIndex == 2) ? Colors.black : Colors.grey,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _currentPageIndex = 3;
                      });
                    },
                    child: Image.asset(
                      'assets/images/bottom_nav_icon/profile_icon.png',
                      width: 24,
                      color: (_currentPageIndex == 3) ? Colors.black : Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
