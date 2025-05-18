import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../lounge/lounge_screen_main.dart';
import '../save/save_screen_main.dart';
import '../badge/badge_screen_main.dart';
import '../profile/profile_screen_main.dart';
import 'onboarding/onboarding_main.dart';
import 'widgets.dart';

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
                  // 라운지
                  bottomNavigationButton(0, 'lounge_icon'),
                  // 저장
                  bottomNavigationButton(1, 'save_icon'),
                  // 새 루틴
                  GestureDetector(
                    // Padding 부분도 터치되게 하는 코드.
                    behavior: HitTestBehavior.translucent,
                    onTap: () async {
                      final fsStorage = FlutterSecureStorage();

                      final streak = await fsStorage.read(key: 'streak');
                      final goalDate = await fsStorage.read(key: 'goalDate');

                      if(streak != null && goalDate != null && int.parse(streak) < int.parse(goalDate)) {
                        CustomSnackBar.show(
                          context,
                          '현재 진행중인 루틴이 있어요.\n그걸 먼저 완료해볼까요?',
                        );
                      } else {
                        Navigator.of(context).push(
                          Routing.customPageRouteBuilder(
                            OnboardingMain(pageIndex: 1, afterOnboarding: true),
                            500,
                          ),
                        );
                      }
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 12,
                      ),
                      child: Image.asset(
                        'assets/images/bottom_nav_icon/routine_add_icon.png',
                        width: 40,
                      ),
                    ),
                  ),
                  // 뱃지
                  bottomNavigationButton(2, 'badge_icon'),
                  // 프로필
                  bottomNavigationButton(3, 'profile_icon'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  GestureDetector bottomNavigationButton(int index, String imageUrl) {
    return GestureDetector(
      // Padding 부분도 터치되게 하는 코드.
      behavior: HitTestBehavior.translucent,
      onTap: () {
        setState(() {
          _currentPageIndex = index;
        });
      },
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: 20,
          horizontal: 12,
        ),
        child: Image.asset(
          'assets/images/bottom_nav_icon/$imageUrl.png',
          width: 24,
          color: (_currentPageIndex == index) ? Colors.black : Colors.grey,
        ),
      ),
    );
  }
}
