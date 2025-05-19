import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../widgets.dart';

class OnboardingScreenTwo extends StatefulWidget {
  
  const OnboardingScreenTwo({super.key, this.onDaySelected, required this.initialDayCount});

  final Function(int)? onDaySelected;
  final int initialDayCount;

  @override
  State<OnboardingScreenTwo> createState() => _OnboardingScreenTwoState();
}

class _OnboardingScreenTwoState extends State<OnboardingScreenTwo> {
  late int _selectedDayCount;
  final List<int> _availableDays = [1, 3, 5, 7, 14, 30];
  late final FixedExtentScrollController _scrollController;

  // FlutterSecureStorage 인스턴스 생성
  final fsStorage = FlutterSecureStorage();

  // Save the selected day count to secure storage
  Future<void> storeGoalDate(String goalDate) async {
    await fsStorage.write(key: 'goalDate', value: _selectedDayCount.toString());
    final saved = await fsStorage.read(key: 'goalDate');
    print('목표 일수 저장여부: $saved');
  }

  @override
  void initState() {
    super.initState();
    _selectedDayCount = widget.initialDayCount;
    // Find the index of initialDayCount in _availableDays
    final initialIndex = _availableDays.indexOf(widget.initialDayCount);
    // If initialDayCount is not in _availableDays, default to 0
    _scrollController = FixedExtentScrollController(
      initialItem: initialIndex >= 0 ? initialIndex : 0,
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onValueChanged(int index) {
    setState(() {
      _selectedDayCount = _availableDays[index];
    });
    // fsStorage에 저장
    storeGoalDate(_selectedDayCount.toString());

    // firestore에 저장


    widget.onDaySelected?.call(_selectedDayCount);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 32,
      ),
      child: Column(
        children: [
          SizedBox(height: (kIsWeb) ? 10 : 60),
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
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 20,
                  spreadRadius: 0,
                  offset: Offset(0, 8),
                ),
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 20,
                  spreadRadius: 0,
                  offset: Offset(0, -8),
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
                // CupertinoPicker
                SizedBox(
                  width: 80,
                  height: 150,
                  child: CupertinoPicker(
                    // Picker내부 아이템 각각의 높이
                    itemExtent: 50,
                    backgroundColor: Colors.transparent,
                    onSelectedItemChanged: _onValueChanged,
                    scrollController: _scrollController,
                    children: _availableDays.map((day) => Center(
                      child: Text(
                        '$day일',
                        style: TextStyle(
                          fontSize: 24,
                          color: Color(0xFF121212),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    )).toList(),
                  ),
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
      ),
    );
  }
}