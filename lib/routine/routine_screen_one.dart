import 'package:flutter/material.dart';

import '../after_onboarding_main.dart';
import '../falling_petal.dart';

class RoutineScreenOne extends StatefulWidget {
  const RoutineScreenOne({super.key, required this.genesisRoutine});

  final List<String> genesisRoutine;

  @override
  State<RoutineScreenOne> createState() => _RoutineScreenOneState();
}

class _RoutineScreenOneState extends State<RoutineScreenOne> {
  final TextEditingController _reflectionController = TextEditingController();
  bool isButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    _reflectionController.addListener(() {
      setState(() {
        isButtonEnabled = _reflectionController.text.trim().isNotEmpty;
      });
    });
  }

  @override
  void dispose() {
    _reflectionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFF7DC),
      body: Stack(
        children: [
          // 꽃 떨어지는 부분
          ...List.generate(45, (index) => FallingPetal(
            indexForPositionX: index % 5,
            fallDelay: Duration(milliseconds: 500 * index),
            //fallDelay: _fallDelay(index),
          )),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 32,
              ),
              child: Column(
                children: [
                  SizedBox(height: 60),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '내첫루틴을\n시작 해볼까요?',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF7A634B),
                        ),
                      ),
                      // 방석 아이콘 (width < height 이므로, height만 설정)
                      Image.asset('assets/images/character_with_cushion.png', height: 100),
                    ],
                  ),
                  SizedBox(height: 24), // 텍스트와 이미지 간 간격
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                      vertical: 20,
                      horizontal: 20,
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
                      children: [
                        Text(
                          // 0번째 -> routine name
                          widget.genesisRoutine[0],
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF121212),
                            height: 1.5, // 줄 간격 조금 띄우기
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 12),
                        Text(
                          // 2번째 -> routine explanation
                          widget.genesisRoutine[2],
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: Color(0xFF121212),
                            height: 1.5, // 줄 간격 조금 띄우기
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 20),
                        Container(
                          margin: EdgeInsets.symmetric(
                            horizontal: 90,
                          ),
                          padding: EdgeInsets.symmetric(
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Color(0xFF8C7154),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Center(
                            child: Text(
                              '인증 방법',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFFFAFAFA),
                                height: 1.5, // 줄 간격 조금 띄우기
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 12),
                        Text(
                          '여기 들어갈 텍스트도\n만들어주세요',
                          //'물을 마신 컵 또는 잔의 사진을 찍고\n상쾌한 기분에 대한 한 줄 소감을 적어요',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: Color(0xFF121212),
                            height: 1.5, // 줄 간격 조금 띄우기
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 24), // 텍스트와 이미지 간 간격
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: 20,
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
                      children: [
                        Text(
                          '오늘 실천할 순간을\n사진으로 남겨주세요!',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF121212),
                            height: 1.5, // 줄 간격 조금 띄우기
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 12),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 90),
                          decoration: BoxDecoration(
                            color: Color(0xFFFCE9B2),
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
                          child: Center(
                            child: Text(
                              '사진 업로드',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF121212),
                                height: 1.5, // 줄 간격 조금 띄우기
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 24), // 텍스트와 이미지 간 간격
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
                      decoration: InputDecoration(
                        hintText: '실천 후 소감을 솔직하게 적어봐요',
                        hintStyle: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF828282),
                        ),
                        contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                        border: InputBorder.none,
                      ),
                      maxLines: null,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF121212),
                      ),
                    ),
                  ),
                ],
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
                showModalBottomSheet(
                  context: context,
                  isDismissible: false,
                  enableDrag: false,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (context) {
                    return Container(
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height * 0.5,
                      padding: EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Color(0xFFFFF2CD),
                        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);

                                  Future.delayed(Duration(milliseconds: 500));

                                  Navigator.of(context).pushReplacement(
                                    PageRouteBuilder(
                                      pageBuilder: (context, animation, secondaryAnimation) => AfterOnboardingMain(),
                                      transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                        return FadeTransition(
                                          opacity: animation,
                                          child: child,
                                        );
                                      },
                                      transitionDuration: const Duration(milliseconds: 1500),
                                    ),
                                  );
                                },
                                child: Icon(Icons.close, size: 28, color: Colors.black),
                              ),
                            ],
                          ),
                          Text(
                            '축하해요,\n루틴을 완료했어요!',
                            style: TextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF7A634B),
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 24),
                          Image.asset('assets/images/badge_example.png', height: 100),
                          SizedBox(height: 24),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).pushReplacement(
                                PageRouteBuilder(
                                  pageBuilder: (context, animation, secondaryAnimation) => AfterOnboardingMain(
                                    pageIndex: 2,
                                  ),
                                  transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                    return FadeTransition(
                                      opacity: animation,
                                      child: child,
                                    );
                                  },
                                  transitionDuration: const Duration(milliseconds: 1500),
                                ),
                              );
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 32),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(30),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 8,
                                    offset: Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Text(
                                '뱃지 받기',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF7A634B),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
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
                    '다 했어요!',
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
    );
  }
}