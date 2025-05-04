import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';

import '../widgets.dart';

class OnboardingScreenTwo extends StatefulWidget {
  final Function(int)? onDaySelected;
  const OnboardingScreenTwo({super.key, this.onDaySelected});

  @override
  State<OnboardingScreenTwo> createState() => _OnboardingScreenTwoState();
}

class _OnboardingScreenTwoState extends State<OnboardingScreenTwo> {
  int _selectedDayCount = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
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
        Container(
          margin: EdgeInsets.symmetric(
            horizontal: 20,
          ),
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
              NumberPicker(
                value: _selectedDayCount,
                minValue: 0,
                maxValue: 30,
                itemHeight: 40,
                axis: Axis.vertical,
                textStyle: TextStyle(
                  fontSize: 18,
                  color: Color(0xFFB0A18E),
                  fontWeight: FontWeight.w500,
                ),
                selectedTextStyle: TextStyle(
                  fontSize: 24,
                  color: Color(0xFF121212),
                  fontWeight: FontWeight.w700,
                ),
                onChanged: (value) {
                  setState(() {
                    _selectedDayCount = value;
                  });
                  widget.onDaySelected?.call(value);
                },
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
      ],
    );
  }
}