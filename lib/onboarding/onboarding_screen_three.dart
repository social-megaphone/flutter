import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../widgets.dart';

class OnboardingScreenThree extends StatefulWidget {
  final void Function(bool)? onTagSelectionChanged;
  final void Function(String)? onTagSelected;
  final String initialSelectedTag;

  const OnboardingScreenThree({super.key, this.onTagSelectionChanged, this.onTagSelected, required this.initialSelectedTag});

  @override
  State<OnboardingScreenThree> createState() => _OnboardingScreenThreeState();
}

class _OnboardingScreenThreeState extends State<OnboardingScreenThree> {

  @override
  void initState() {
    super.initState();
    if(widget.initialSelectedTag != '' && widget.onTagSelected != null) {
      selectedTags.add(widget.initialSelectedTag);
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
          SizedBox(height: 50),
          // 방석 아이콘 (width < height 이므로, height만 설정)
          Image.asset('assets/images/character_with_cushion.png', height: 160),
          SizedBox(height: 10),
          // 메인 텍스트
          Onboarding.onboardingScreenMainTextContainer(
            '우와, 정말 멋진 걸요?\n\n하루잇에서 시도해보고 싶은\n목표 태그를 골라주세요.'
          ),
          SizedBox(height: 16),
          // 선택 가능권
          Padding(
            padding: const EdgeInsets.all(16),
            child: GridView.count(
                crossAxisCount: 3, // 3열
                mainAxisSpacing: 16, // 간격 늘림
                crossAxisSpacing: 20, // 간격 늘림
                childAspectRatio: 1.6/1, // 버튼 비율 원복
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _buildGridItem('생활리듬'),
                  _buildGridItem('건강/운동'),
                  _buildGridItem('감정돌봄'),
                  _buildGridItem('자기이해'),
                  _buildGridItem('대인관계'),
                  _buildGridItem('취미탐색'),
                  _buildGridItem('진로탐색'),
                  _buildGridItem('자기계발'),
                  _buildGridItem('일상관찰'),
                  _buildGridItem('용기실천'),
                  _buildGridItem('기록/표현'),
                  _buildGridItem('기타'),
                ],
              ),
          ),
        ],
      ),
    );
  }

  List<String> selectedTags = []; // 선택된 태그들 저장

  final fsStorage = FlutterSecureStorage();

  Future<void> storeTag(List<String> selectedTags) async {
    await fsStorage.write(key: 'tag', value: selectedTags[0]);
    final saved = await fsStorage.read(key: 'tag');
    print('태그 저장여부: $saved');
  }

  // Firestore에 저장하는 코드
  final firestore = FirebaseFirestore.instance;

  Future<void> firestoreTag(List<String> selectedTags) async {
    // selectedTags 중 1번째 값 (사실 값이 1개긴 함)
    final tag = selectedTags[0];

    // Hive/userBox 연 뒤
    final userBox = Hive.box('userBox');

    // uuid에 접근해서 이를 이름으로하는 doc을 업데이트
    await firestore.collection('posts').doc(userBox.get('uuid')).update({
      "tag" : tag,
    });
  }

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
          storeTag(selectedTags);
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
              fontSize: 14, // 폰트 크기 원복
              fontWeight: FontWeight.w500,
              color: isSelected ? Colors.white : Colors.black, // 글자색도 반전
            ),
            textAlign: TextAlign.center, // 텍스트 중앙 정렬
          ),
        ),
      ),
    );
  }

}