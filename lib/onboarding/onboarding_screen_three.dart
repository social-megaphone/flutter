import 'package:flutter/material.dart';

import '../widgets.dart';

class OnboardingScreenThree extends StatefulWidget {
  final void Function(bool)? onTagSelectionChanged;
  final void Function(String)? onTagSelected;

  const OnboardingScreenThree({super.key, this.onTagSelectionChanged, this.onTagSelected});

  @override
  State<OnboardingScreenThree> createState() => _OnboardingScreenThreeState();
}

class _OnboardingScreenThreeState extends State<OnboardingScreenThree> {

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
          '우와~ 정말 멋진 목표인걸요?\n\n하루잇에서 시도해보고 싶은\n목표 태그를 골라주세요.'
        ),
        SizedBox(height: 20),
        // 선택 가능권
        Container(
          margin: EdgeInsets.symmetric(
            horizontal: 40,
          ),
          child: GridView.count(
            crossAxisCount: 3, // 3열
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: 5/3,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              _buildGridItem('건강'),
              _buildGridItem('생활습관'),
              _buildGridItem('감정돌봄'),
              _buildGridItem('진로'),
              _buildGridItem('배움'),
              _buildGridItem('자기계발'),
              _buildGridItem('독서'),
              _buildGridItem('용기'),
              _buildGridItem('대인관계'),
            ],
          ),
        ),
      ],
    );
  }

  List<String> selectedTags = []; // 선택된 태그들 저장

  Widget _buildGridItem(String tagName) {
    final bool isSelected = selectedTags.contains(tagName);

    return GestureDetector(
      onTap: () {
        setState(() {
          if (isSelected) {
            selectedTags.clear(); // 선택 해제
          } else {
            selectedTags
              ..clear()
              ..add(tagName); // 하나만 선택되도록
          }
          widget.onTagSelectionChanged?.call(selectedTags.isNotEmpty);
          if (!isSelected) {
            widget.onTagSelected?.call(tagName);
          }
        });
      },
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF8C7154) : Colors.white, // 선택되면 색 바뀜
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Center(
          child: Text(
            tagName,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: isSelected ? Colors.white : Colors.black, // 글자색도 반전
            ),
          ),
        ),
      ),
    );
  }

}