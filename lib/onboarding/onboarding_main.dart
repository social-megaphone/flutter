import 'package:flutter/material.dart';

import 'onboarding_screen_one.dart';
import 'onboarding_screen_two.dart';
import 'onboarding_screen_three.dart';
import 'onboarding_screen_four.dart';
import '../falling_petal.dart';

class OnboardingMain extends StatefulWidget {
  const OnboardingMain({super.key});

  @override
  State<OnboardingMain> createState() => _OnboardingMainState();
}

class _OnboardingMainState extends State<OnboardingMain> {
  int _currentPage = 0; // 현재 페이지 인덱스
  bool _isNextEnabled = true;
  int _dayCount = 0; // two에서 고른 day
  String _selectedTag = '';

  List<Widget> _buildOnboardingPages() {
    return [
      OnboardingScreenOne(),
      OnboardingScreenTwo(
        onDaySelected: (day) {
          setState(() {
            _dayCount = day;
            _isNextEnabled = day > 0;
          });
        },
      ),
      OnboardingScreenThree(
        onTagSelectionChanged: (isEnabled) {
          setState(() {
            _isNextEnabled = isEnabled;
          });
        },
        onTagSelected: (tag) {
          setState(() {
            _selectedTag = tag;
          });
        },
      ),
      OnboardingScreenFour(
        dayCount: _dayCount,
        selectedTag: _selectedTag,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF7DC),
      body: Stack(
        children: [
          ...List.generate(45, (index) => FallingPetal(
            indexForPositionX: index % 5,
            fallDelay: Duration(milliseconds: 500 * index),
            //fallDelay: _fallDelay(index),
          )),
          // 화면 전환 부분
          SafeArea(
            child: Center(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 1000), // 전환 애니메이션 속도
                child: _buildOnboardingPages()[_currentPage],
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return FadeTransition(opacity: animation, child: child);
                },
              ),
            ),
          ),
          if(_currentPage != _buildOnboardingPages().length - 1)...[
            // 화면 넘기는 버튼
            Positioned(
              left: 40,
              right: 40,
              bottom: 40, // 40이나 넣는 이유는, SafeArea 밖이라 그래.
              child: GestureDetector(
                onTap: _isNextEnabled ? () {
                  setState(() {
                    _currentPage++;
                    if (_currentPage == 1) _isNextEnabled = false;
                    if (_currentPage == 2) _isNextEnabled = false;
                  });
                } : null,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    vertical: 10,
                  ),
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
          if(_currentPage == 3)...[
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