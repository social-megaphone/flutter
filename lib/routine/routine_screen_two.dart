import 'package:flutter/material.dart';
import 'package:flutter_inner_shadow/flutter_inner_shadow.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../after_onboarding_main.dart';
import '../falling_petal.dart';
import '../widgets.dart';
import 'routine_screen_one.dart';

class RoutineScreenTwo extends StatefulWidget {
  const RoutineScreenTwo({super.key, required this.genesisRoutine, required this.howToRoutine});

  final List<String> genesisRoutine;
  final String howToRoutine;
  @override
  State<RoutineScreenTwo> createState() => _RoutineScreenTwoState();
}

class _RoutineScreenTwoState extends State<RoutineScreenTwo> {
  final TextEditingController _reflectionController = TextEditingController();
  bool isButtonEnabled = false;
  final FocusNode _focusNode = FocusNode();
  final fsStorage = FlutterSecureStorage();
  String? nickname;
  int? goalDate;

  @override
  void initState() {
    super.initState();
    _loadData();
    _reflectionController.addListener(() {
      setState(() {
        // 사진이 선택되었거나 텍스트가 입력되었을 때 버튼 활성화
        isButtonEnabled = _reflectionController.text.trim().isNotEmpty;
      });
    });
  }

  Future<void> _loadData() async {
    final storedNickname = await fsStorage.read(key: 'randomName');
    final storedGoalDate = await fsStorage.read(key: 'goalDate');
    setState(() {
      nickname = storedNickname;
      goalDate = storedGoalDate != null ? int.parse(storedGoalDate) : 7;
    });
  }

  @override
  void dispose() {
    _reflectionController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _unfocus() {
    if (_focusNode.hasFocus) {
      _focusNode.unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFF7DC),
      body: GestureDetector(
        onTap: () {
          if (_focusNode.hasFocus) {
            _focusNode.unfocus();
          }
        },
        child: Stack(
          children: [
            // 꽃 떨어지는 부분
            ...List.generate(45, (index) => FallingPetal(
              indexForPositionX: index % 5,
              fallDelay: Duration(milliseconds: 500 * index),
              //fallDelay: _fallDelay(index),
            )),
            SingleChildScrollView(
              child: SafeArea(
                child: Stack(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 32),
                      child: Column(
                        children: [
                          SizedBox(height: 60),
                          Image.asset('assets/images/character_with_cushion.png', height: 175),
                          SizedBox(height: 12),
                          mainText(), // 메인 텍스트
                          SizedBox(height: 20),
                          reviewTextFormField(), // 회고 TextFormField
                          SizedBox(height: 20),
                          submitButton(), // 다음 버튼
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        // 이전 화면으로 돌아가는 기능
                        Navigator.of(context).pop(
                          Routing.customPageRouteBuilder(RoutineScreenOne(
                            genesisRoutine: widget.genesisRoutine,
                            howToRoutine: widget.howToRoutine,
                          ), 1000),
                        );
                      },
                      child: Routing.backButton(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  InnerShadow mainText() {
    return InnerShadow(
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
          horizontal: 40,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.transparent,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 5,
              spreadRadius: 1,
              offset: Offset(0, 2),
            ),
            BoxShadow(
              color: Colors.white.withOpacity(0.9),
              blurRadius: 0,
              spreadRadius: -1,
              offset: Offset(0, 0),
            ),
          ],
        ),
        child: Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: '루틴을 시도해본 소감이 어때요?\n',
              ),
              TextSpan(
                text: '${nickname ?? "활발한 거북이"}님',
                style: TextStyle(
                  color: Color(0xFF8C7154),
                ),
              ),
              TextSpan(
                text: '만의 여정을\n기록으로 남겨보아요.',
              ),
            ],
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Color(0xFF121212),
              height: 1.5, // 줄 간격 조금 띄우기
            ),
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Container reviewTextFormField() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        vertical: 32,
        horizontal: 16,
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
      child: TextFormField(
        controller: _reflectionController,
        focusNode: _focusNode,
        decoration: InputDecoration(
          hintText: '${goalDate ?? 7}일 간 하루잇 루틴을 도전해본\n소감을 자유롭게 적어봐요.',
          hintStyle: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Color(0xFF828282),
          ),
          contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          border: InputBorder.none,
          alignLabelWithHint: true,
        ),
        maxLines: null,
        textAlign: TextAlign.left,
        textAlignVertical: TextAlignVertical.center,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: Color(0xFF121212),
        ),
      ),
    );
  }

  GestureDetector submitButton() {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushReplacement(
          Routing.customPageRouteBuilder(AfterOnboardingMain(
            // 라운지로 이동! -> 시간 순으로 포스트 보여주니, 니께 제일 위에 뜰 거임.
            pageIndex: 0,
          ), 300),
        );
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isButtonEnabled ? Color(0xFF8C7154) : Color(0xFFD6C5B4),
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
    );
  }
}