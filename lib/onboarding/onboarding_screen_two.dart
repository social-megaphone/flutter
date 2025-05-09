import 'package:flutter/material.dart';
import 'package:flutter_inner_shadow/flutter_inner_shadow.dart';

import '../widgets.dart';

class OnboardingScreenTwo extends StatefulWidget {
  final Function(int)? onDaySelected;
  const OnboardingScreenTwo({super.key, this.onDaySelected});

  @override
  State<OnboardingScreenTwo> createState() => _OnboardingScreenTwoState();
}

class _OnboardingScreenTwoState extends State<OnboardingScreenTwo> {
  int _selectedDayCount = 1;
  final List<int> _availableDays = [1, 3, 5, 7, 14, 30];

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
            '내가 그리는 나의 모습,\n하루잇 일기장에 남겨볼까요?'
          ),
          SizedBox(height: 28),
          // 목표설정 부분
          InnerShadow(
            shadows: [
              Shadow(
                color: Colors.grey,
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
            child: Container(
              width: double.infinity,
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
                  Text(
                    '저는 $_selectedDayCount일 동안',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF121212),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 12),
                  // 커스텀 NumberPicker
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.keyboard_arrow_up, 
                          color: _selectedDayCount == 1 
                            ? Color(0xFFB0A18E).withOpacity(0.3)  // 비활성화 상태
                            : Color(0xFFB0A18E),  // 활성화 상태
                          size: 32,
                        ),
                        onPressed: _selectedDayCount == 1 
                          ? null  // 비활성화 상태
                          : () {
                              final currentIndex = _availableDays.indexOf(_selectedDayCount);
                              if (currentIndex > 0) {
                                setState(() {
                                  _selectedDayCount = _availableDays[currentIndex - 1];
                                });
                                widget.onDaySelected?.call(_selectedDayCount);
                              }
                            },
                      ),
                      Text(
                        '$_selectedDayCount일',
                        style: TextStyle(
                          fontSize: 24,
                          color: Color(0xFF121212),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.keyboard_arrow_down,
                          color: _selectedDayCount == 30 
                            ? Color(0xFFB0A18E).withOpacity(0.3)  // 비활성화 상태
                            : Color(0xFFB0A18E),  // 활성화 상태
                          size: 32,
                        ),
                        onPressed: _selectedDayCount == 30 
                          ? null  // 비활성화 상태
                          : () {
                              final currentIndex = _availableDays.indexOf(_selectedDayCount);
                              if (currentIndex < _availableDays.length - 1) {
                                setState(() {
                                  _selectedDayCount = _availableDays[currentIndex + 1];
                                });
                                widget.onDaySelected?.call(_selectedDayCount);
                              }
                            },
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  Text(
                    '루틴을 하고 싶어요',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF121212),
                    ),
                    textAlign: TextAlign.center,
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