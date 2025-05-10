import 'package:flutter/material.dart';
import 'package:flutter_inner_shadow/flutter_inner_shadow.dart';

import '../after_onboarding_main.dart';
import '../falling_petal.dart';

class RoutineScreenTwo extends StatefulWidget {
  const RoutineScreenTwo({super.key});

  @override
  State<RoutineScreenTwo> createState() => _RoutineScreenTwoState();
}

class _RoutineScreenTwoState extends State<RoutineScreenTwo> {
  final TextEditingController _reflectionController = TextEditingController();
  bool isButtonEnabled = false;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _reflectionController.addListener(() {
      setState(() {
        // 사진이 선택되었거나 텍스트가 입력되었을 때 버튼 활성화
        isButtonEnabled = _reflectionController.text.trim().isNotEmpty;
      });
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
    return GestureDetector(
      onTap: _unfocus,
      child: Scaffold(
        backgroundColor: Color(0xFFFFF7DC),
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            // 꽃 떨어지는 부분
            ...List.generate(45, (index) => FallingPetal(
              indexForPositionX: index % 5,
              fallDelay: Duration(milliseconds: 500 * index),
              //fallDelay: _fallDelay(index),
            )),
            SafeArea(
              child: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 32,
                  ),
                  child: Column(
                    children: [
                      SizedBox(height: 60),
                      Image.asset('assets/images/character_with_cushion.png', height: 175),
                      SizedBox(height: 12), // 텍스트와 이미지 간 간격
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
                                  text: '활발한 거북이님',
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
                      ),
                      SizedBox(height: 20),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(
                          vertical: 16,
                          horizontal: 16,
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
                        child: TextFormField(
                          controller: _reflectionController,
                          focusNode: _focusNode,
                          decoration: InputDecoration(
                            hintText: '7일 간 하루잇 루틴을 도전해본\n소감을 자유롭게 적어봐요.',
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
                          textAlign: TextAlign.center,
                          textAlignVertical: TextAlignVertical.center,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF121212),
                          ),
                        ),
                      ),
                      SizedBox(height: 80), // 버튼을 위한 여유 공간
                    ],
                  ),
                ),
              ),
            ),
            // 넘어가는 버튼
            Positioned(
              left: 40,
              right: 40,
              bottom: 40, // 40이나 넣는 이유는, SafeArea 밖이라 그래.
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).pushReplacement(
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) => AfterOnboardingMain(),
                      transitionsBuilder: (context, animation, secondaryAnimation, child) {
                        return FadeTransition(
                          opacity: animation,
                          child: child,
                        );
                      },
                      transitionDuration: const Duration(milliseconds: 500),
                    ),
                  );
                },
                child: Container(
                  padding: EdgeInsets.symmetric(
                    vertical: 10,
                  ),
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}