import 'package:flutter/material.dart';

import '../routine/routine_screen_one.dart';

class OnboardingScreenFour extends StatefulWidget {
  const OnboardingScreenFour({super.key, required this.dayCount, required this.selectedTag});

  final int dayCount;
  final String selectedTag;

  @override
  State<OnboardingScreenFour> createState() => _OnboardingScreenFourState();
}

class _OnboardingScreenFourState extends State<OnboardingScreenFour> {

  List<List<String>> suggestedRoutine = [
    ['아침 물 한 잔 마시기', 'assets/images/suggested_routine/drink_water.png', '매일 일어나자마자 물 한 잔을 마시며 상쾌한 아침을 시작해요'],
    ['5분 스트레칭 하기', 'assets/images/suggested_routine/stretch.png', '아침 기상 후 자리에서 할 수 있는 간단한 목, 어깨 스트레칭을 5분 간 해봐요.'],
    ['내 공간 1개 정돈하기', 'assets/images/suggested_routine/get_rid_of.png', '하루에 하나, 침대나 책상 등 내 공간 중 한 곳을 정리해봐요. 공간이 정리되면 마음도 정리돼요.'],
    ['나를 위한 건강식 한 끼', 'assets/images/suggested_routine/slow_food.png', '나를 위해 정성껏 준비한 건강한 한 끼를 먹고 기록해요.'],
    ['바람 따라 걷기 20분', 'assets/images/suggested_routine/windy_walk.png', '바쁜 하루 중 잠시 멈추고, 주변을 둘러보며 산책해봐요. 몸도 마음이 한결 가벼워져요.'],
    ['아침 물 한 잔 마시기', 'assets/images/suggested_routine/drink_water.png', '매일 일어나자마자 물 한 잔을 마시며 상쾌한 아침을 시작해요'],
    ['5분 스트레칭 하기', 'assets/images/suggested_routine/stretch.png', '아침 기상 후 자리에서 할 수 있는 간단한 목, 어깨 스트레칭을 5분 간 해봐요.'],
    ['내 공간 1개 정돈하기', 'assets/images/suggested_routine/get_rid_of.png', '하루에 하나, 침대나 책상 등 내 공간 중 한 곳을 정리해봐요. 공간이 정리되면 마음도 정리돼요.'],
    ['나를 위한 건강식 한 끼', 'assets/images/suggested_routine/slow_food.png', '나를 위해 정성껏 준비한 건강한 한 끼를 먹고 기록해요.'],
    ['바람 따라 걷기 20분', 'assets/images/suggested_routine/windy_walk.png', '바쁜 하루 중 잠시 멈추고, 주변을 둘러보며 산책해봐요. 몸도 마음이 한결 가벼워져요.'],
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 60),
        // 방석 아이콘 (width < height 이므로, height만 설정)
        Image.asset('assets/images/character_with_cushion.png', height: 175),
        SizedBox(height: 12),
        // 메인 텍스트
        Container(
          margin: EdgeInsets.symmetric(
            horizontal: 20,
          ),
          padding: EdgeInsets.symmetric(
            vertical: 20,
            horizontal: 40,
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
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: '${widget.dayCount}일',
                  style: TextStyle(
                    color: Color(0xFF8C7154),
                  ),
                ),
                TextSpan(
                  text: ' 뒤, 건강한 사람이 되고 싶은\n',
                ),
                TextSpan(
                  text: '활발한 거북이님',
                  style: TextStyle(
                    color: Color(0xFF8C7154),
                  ),
                ),
                TextSpan(
                  text: '에게 도움이 될\n',
                ),
                TextSpan(
                  text: widget.selectedTag,
                  style: TextStyle(
                    color: Color(0xFF8C7154),
                  ),
                ),
                TextSpan(
                  text: ' 루틴을 추천할게요.',
                ),
              ],
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Color(0xFF121212),
                height: 1.5, // 줄 간격 조금 띄우기
              ),
            ),
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(height: 20),
        // 추천 루틴
        Container(
          height: 370,
          decoration: BoxDecoration(
            color: Color(0xFFFFF7DC),
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
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 12),
                // 추천 루틴
                Container(
                  margin: EdgeInsets.symmetric(
                    horizontal: 120,
                  ),
                  padding: EdgeInsets.symmetric(
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Color(0xFF8C7154),
                    borderRadius: BorderRadius.circular(1000),
                  ),
                  child: Center(
                    child: Text(
                      '추천 루틴',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFFFAFAFA),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                // 추천 루틴 목록
                Container(
                  margin: EdgeInsets.symmetric(
                    horizontal: 40,
                  ),
                  child: ListView.separated(
                    shrinkWrap: true,
                    physics: BouncingScrollPhysics(),
                    itemCount: suggestedRoutine.length,
                    itemBuilder: (BuildContext context, int index) {
                      return _buildGridItem(index);
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return SizedBox(height: 10);
                    },
                  ),
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGridItem(int index) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          barrierDismissible: true, // 바깥 터치시 닫힘
          builder: (BuildContext context) {
            return routineDialog(index);
          },
        );
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 20,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // 루틴 아이콘
            Image.asset(
              // 1번 : routine의 아이콘
              suggestedRoutine[index][1],
              width: 20,
            ),
            Spacer(),
            // 루틴 제목
            Text(
              // 0번 : routine의 제목
              suggestedRoutine[index][0],
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
            ),
            Spacer(),
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 15,
            ),
          ],
        ),
      ),
    );
  }

  Widget routineDialog(int index) {
    return Dialog(
      backgroundColor: Colors.transparent, // 배경 투명
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFF7598FF),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // 메인 텍스트 + 취소 버튼
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        // 0번 : routine의 제목
                        suggestedRoutine[index][0],
                        style: const TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFFFAFAFA),
                        ),
                        textAlign: TextAlign.left,
                        softWrap: true,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                    ),
                    SizedBox(width: 10),
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Icon(
                          Icons.close,
                          size: 20,
                          color: Color(0xFFFAFAFA),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // 서브 텍스트
                Text(
                  // 2번 -> 설명,
                  suggestedRoutine[index][2],
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFFFAFAFA),
                    height: 1.5,
                  ),
                  textAlign: TextAlign.start,
                ),
                const SizedBox(height: 28),
                // 도전 버튼
                GestureDetector(
                  // RoutineScreen으로 이동하기
                  onTap: () {
                    Navigator.of(context).pushReplacement(
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) => RoutineScreenOne(
                          genesisRoutine: suggestedRoutine[index],
                        ),
                        transitionsBuilder: (context, animation, secondaryAnimation, child) {
                          return FadeTransition(
                            opacity: animation,
                            child: child,
                          );
                        },
                        transitionDuration: const Duration(milliseconds: 1000),
                      ),
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: Color(0xFFFAFAFA),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Text(
                      '도전 해볼래요!',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF121212),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
          Positioned(
            right: -25,
            bottom: -15,
            child: Image.asset(
              'assets/images/routine_explanation_water.png',
              width: 130,
              height: 130,
            ),
          ),
        ],
      ),
    );
  }
}