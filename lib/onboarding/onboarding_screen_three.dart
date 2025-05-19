import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../widgets.dart';

class OnboardingScreenThree extends StatefulWidget {
  final void Function(bool)? onCategorySelectionChanged;
  final void Function(String)? onCategorySelected;
  final String initialSelectedCategory;

  const OnboardingScreenThree({super.key, this.onCategorySelectionChanged, this.onCategorySelected, required this.initialSelectedCategory});

  @override
  State<OnboardingScreenThree> createState() => _OnboardingScreenThreeState();
}

class _OnboardingScreenThreeState extends State<OnboardingScreenThree> {

  @override
  void initState() {
    super.initState();
    if(widget.initialSelectedCategory != '' && widget.onCategorySelected != null) {
      selectedTheme = widget.initialSelectedCategory;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 32,
      ),
      child: Column(
        children: [
          SizedBox(height: (kIsWeb) ? 10 : 50),
          // 방석 아이콘 (width < height 이므로, height만 설정)
          Image.asset('assets/images/character_with_cushion.png', height: 160),
          SizedBox(height: 10),
          // 메인 텍스트
          Onboarding.onboardingScreenMainTextContainer(
            '우와, 정말 멋진 걸요?\n\n하루잇에서 시도해보고 싶은\n루틴 테마를 골라주세요.'
          ),
          SizedBox(height: 16),
          // 선택 가능권
          Padding(
            padding: const EdgeInsets.all(16),
            child: ListView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _buildCategoryItem(
                  themeName: '생활습관',
                  color: const Color(0xFF7896FF),
                  hashtags: ['#건강', '#운동', '#생활 나눔'],
                ),
                _buildCategoryItem(
                  themeName: '감정돌봄',
                  color: const Color(0xFFEA4793),
                  hashtags: ['#감정 기록', '#감정 표현'],
                ),
                _buildCategoryItem(
                  themeName: '대인관계',
                  color: const Color(0xFFFF9E28),
                  hashtags: ['#관계 연습', '#이해', '#소통'],
                ),
                _buildCategoryItem(
                  themeName: '자기계발',
                  color: const Color(0xFF68BA5A),
                  hashtags: ['#자기 이해', '#진로', '#취미'],
                ),
                _buildCategoryItem(
                  themeName: '작은도전',
                  color: const Color(0xFFC262D3),
                  hashtags: ['#도전', '#용기', '#일상 관찰'],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String selectedTheme = ''; // 선택한 테마

  final fsStorage = FlutterSecureStorage();

  Future<void> storeTheme(String selectedTheme) async {
    await fsStorage.write(key: 'tag', value: selectedTheme);
    final saved = await fsStorage.read(key: 'tag');
    print('테마(저장될 땐 tag라는 key로 저장됨) 저장여부: $saved');
  }

  Widget _buildCategoryItem({
    required String themeName,
    required Color color,
    required List<String> hashtags,
  }) {

    final bool isSelected = selectedTheme == themeName;

    return GestureDetector(
      onTap: () {
        setState(() {
          // selectedTheme 값 변경 부분 -> 이 값에 따라서, isSelected 값이 변경되고, 그 값에 따라서 child: Container의 색상값이 변경됨
          if (isSelected) {
            selectedTheme = '';
          } else {
            selectedTheme = themeName;
          }

          // FlutterSecureStorage에 저장하는 부분
          storeTheme(selectedTheme);

          // 선택된 테마가 변경되었을 때, 테마 선택 여부를 전달하는 부분
          widget.onCategorySelectionChanged?.call(selectedTheme.isNotEmpty);
          if (!isSelected) {
            widget.onCategorySelected?.call(themeName);
          }
        });
      },
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? color : Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.07),
              blurRadius: 4,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              themeName,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: isSelected ? Colors.white : color,
              ),
            ),
            const SizedBox(width: 12),
            Wrap(
              spacing: 3,
              children: hashtags.map((h) => Text(
                h,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: isSelected ? Colors.white.withOpacity(0.85) : Colors.black.withOpacity(0.6),
                ),
              )).toList(),
            ),
          ],
        ),
      ),
    );
  }

}