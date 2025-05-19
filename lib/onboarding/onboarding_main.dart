import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import 'onboarding_screen_one.dart';
import 'onboarding_screen_two.dart';
import 'onboarding_screen_three.dart';
import 'onboarding_screen_four.dart';
import '../falling_petal.dart';
import '../widgets.dart';

class OnboardingMain extends StatefulWidget {
  const OnboardingMain({super.key, this.pageIndex, this.afterOnboarding});

  final int? pageIndex;
  final bool? afterOnboarding;

  @override
  State<OnboardingMain> createState() => _OnboardingMainState();
}

class _OnboardingMainState extends State<OnboardingMain> {
  int _onboardingPageIndex = 0; // 현재 페이지 인덱스
  bool _isNextEnabled = true;
  int _dayCount = 1; // two에서 고른 day
  String _selectedTag = '';
  bool isOnboardingDone = false; // 기본적으로 onboarding 과정이라고 생각하고, isOnboardingDone은 false로 설정


  late final List<FallingPetal> _shuffledPetals;

  List<Widget> _buildOnboardingPages() {
    return [
      OnboardingScreenOne(

      ),
      OnboardingScreenTwo(
        onDaySelected: (day) {
          setState(() {
            _dayCount = day;
          });
        },
        // 초기 카운트. one에서 two로 갈때는 1로 전달
        // three에서 two로 갈때는 변한 _dayCount 전달
        initialDayCount: _dayCount,
      ),
      OnboardingScreenThree(
        onCategorySelectionChanged: (isEnabled) {
          setState(() {
            _isNextEnabled = isEnabled;
          });
        },
        onCategorySelected: (category) {
          setState(() {
            _selectedTag = category;
          });
        },
        // 초기 태그. two에서 three로 갈때는 아무것도 전달 X
        // four에서 three로 갈때는 변한 _selectedTag 전달
        initialSelectedCategory: _selectedTag,
      ),
      OnboardingScreenFour(
        dayCount: _dayCount,
        selectedCategory: _selectedTag,
      ),
    ];
  }

  @override
  void initState() {
    super.initState();
    if(widget.pageIndex != null) {
      _onboardingPageIndex = widget.pageIndex!;
    }

    if(widget.afterOnboarding != null) {
      isOnboardingDone = widget.afterOnboarding!; // afterOnboaring이 true일 때만, isOnboardingDone도 true로 설정.
      _isNextEnabled = true;
    }

    // 꽃잎 관련 코드
    final List<FallingPetal> petals = [];
    for (int cycle = 0; cycle < 4; cycle++) {
      final indices = List<int>.generate(5, (i) => i)..shuffle();
      for (int i = 0; i < 5; i++) {
        petals.add(FallingPetal(
          indexForPositionX: indices[i],
          fallDelay: Duration(milliseconds: 500 * (cycle * 5 + i)),
        ));
      }
    }
    _shuffledPetals = petals;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.defaultBackgroundColor,
      body: Stack(
        children: [
          ..._shuffledPetals,
          // 화면 전환 부분
          SafeArea(
            child: Stack(
              children: [
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300), // 전환 애니메이션 속도
                  child: _buildOnboardingPages()[_onboardingPageIndex],
                  transitionBuilder: (Widget child, Animation<double> animation) {
                    return FadeTransition(opacity: animation, child: child);
                  },
                ),
                if(_onboardingPageIndex > 0)...[
                  GestureDetector(
                    onTap: () {
                      // isOnboardingDone 값에 따라서, _onboardingPage == 1의 뒤로가기 버튼의 역할이 달라짐
                      if(isOnboardingDone == true && _onboardingPageIndex == 1) {
                        setState(() {
                          Navigator.of(context).pop();
                        });
                      } else {
                        setState(() {
                          // 한 페이지 앞으로 돌아옴
                          _onboardingPageIndex--;
                          // 앞으로 돌아옴에 따라서, _isNextEnabled 조정.
                          _isNextEnabled = true;
                        });
                      }
                    },
                    child: Routing.backButton(),
                  ),
                ],
              ],
            ),
          ),
          if(_onboardingPageIndex != _buildOnboardingPages().length - 1)...[
            // 화면 넘기는 버튼
            Positioned(
              left: 32,
              right: 32,
              bottom: (kIsWeb) ? 0 : 40, // 40이나 넣는 이유는, SafeArea 밖이라 그래.
              child: GestureDetector(
                onTap: _isNextEnabled ? () {
                  setState(() {
                    _onboardingPageIndex++;
                    // 무조건 three라고 false를 처리하지 않고, _selectedTag가 없을 때만 false로 처리.
                    if (_onboardingPageIndex == 2 && _selectedTag == '') _isNextEnabled = false;
                  });
                } : null,
                child: Container(
                  // 왜인지 모르겠지만, Text가 상하 중앙 정렬이 자동으로 되지 않아서, 수동으로 조정함.
                  padding: EdgeInsets.fromLTRB(0, 9, 0, 11),
                  decoration: BoxDecoration(
                    color: _isNextEnabled ? Color(0xFF8C7154) : Color(0xFFBFAE9C),
                    borderRadius: BorderRadius.circular(1000),
                  ),
                  child: Center(
                    child: Text(
                      '다음',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFFFFF2CD),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
          // 디자인적 오류 방지.
          if(_onboardingPageIndex == 3)...[
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.05,
                color: Color(0xFFFFF7DC),
              ),
            ),
          ],
        ],
      ),
    );
  }
}