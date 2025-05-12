import 'package:flutter/material.dart';
import 'dart:async';

import '../widgets.dart';

class BadgeScreenMain extends StatefulWidget {
  const BadgeScreenMain({super.key});

  @override
  State<BadgeScreenMain> createState() => _BadgeScreenMainState();
}

class _BadgeScreenMainState extends State<BadgeScreenMain> {
  // 레벨별 배지 위치 데이터
  final Map<int, List<Map<String, double>>> badgePositions = {
    1: [ // 레벨 1의 배지 위치
      {'top': 40, 'left': 90},
      {'top': 90, 'left': 180},
      {'top': 160, 'left': 250},
      {'top': 210, 'left': 140},
      {'top': 250, 'left': 40},
    ],
    2: [ // 레벨 2의 배지 위치 (연못 징검다리)
      {'top': 20, 'left': 100},
      {'top': 90, 'left': 200},
      {'top': 130, 'left': 110},
      {'top': 210, 'left': 190},
      {'top': 250, 'left': 80},
    ],
    3: [ // 레벨 3의 배지 위치 (마을 도로)
      {'top': 30, 'left': 190},
      {'top': 90, 'left': 80},
      {'top': 140, 'left': 200},
      {'top': 200, 'left': 50},
      {'top': 250, 'left': 150},
    ],
  };

  // 레벨별 배경 이미지
  final Map<int, String> backgroundImages = {
    1: 'assets/images/badge_map/badge_map_level_one.png',
    2: 'assets/images/badge_map/badge_map_level_two.png',
    3: 'assets/images/badge_map/badge_map_level_three.png',
  };

  // 레벨별 타이틀
  final Map<int, String> levelTitles = {
    1: '도전자',
    2: '모험가',
    3: '고수',
    4: '마스터', // 미래를 위한 값
  };

  // 레벨별 축하 타이틀
  final Map<int, String> congratulationTitles = {
    1: '모험가',
    2: '고수',
    3: '마스터',
  };

  // 각 배지의 활성화 상태를 관리하는 리스트
  List<bool> badgeActivated = List.generate(5, (index) => false);
  int activationCount = 0;
  bool isDialogShown = false;
  int currentLevel = 1; // 현재 레벨

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: AlwaysScrollableScrollPhysics(),
      child: Column(
        children: [
          SizedBox(height: 12),
          // 제목 및 알림 버튼
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 32,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // 제목
                Text(
                  '나의 하루잇\n루틴 현황',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFFFCE9B2),
                  ),
                ),
                Spacer(),
                // 알림 버튼
                AfterOnboarding.notificationButton(Color(0xFF8C7154)),
              ],
            ),
          ),
          SizedBox(height: 32),
          // 상단 캐릭터 카드 + 진행도 카드
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 16,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // 캐릭터 카드
                Container(
                  width: (MediaQuery.of(context).size.width - 16 * 3) / 2 - 25, // 좌우 여백 고려
                  height: 172,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Color(0xFFFAFAFA),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      width: 3,
                      color: Color(0xFFFFF2CD),
                    ),
                  ),
                  child: Column(
                    children: [
                      Image.asset(
                        'assets/images/profile_image_temp.png',
                        height: 70,
                      ),
                      SizedBox(height: 12),
                      Text(
                        '활발한 거북이',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF8C7154),
                        ),
                      ),
                      SizedBox(height: 12),
                      Container(
                        width: double.infinity,
                        margin: EdgeInsets.symmetric(
                          horizontal: 16,
                        ),
                        padding: EdgeInsets.symmetric(
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Color(0xFF7A634B),
                          borderRadius: BorderRadius.circular(1000),
                        ),
                        child: Text(
                          levelTitles[currentLevel] ?? '도전자',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFFFAFAFA),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
                // 도전 진행도 카드
                Container(
                  width: (MediaQuery.of(context).size.width - 16 * 3) / 2 + 25,
                  height: 172,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Color(0xFFFAFAFA),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      width: 3,
                      color: Color(0xFFFFF2CD),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '1일 연속\n도전 중',
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF8C7154),
                        ),
                        textAlign: TextAlign.right,
                      ),
                      SizedBox(height: 8),
                      LinearProgressIndicator(
                        value: 1/7, // 예시로 1/7 진행
                        backgroundColor: Colors.grey[300],
                        color: Color(0xFFD27CEE),
                        minHeight: 12,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      SizedBox(height: 8),
                      Text(
                        '조금씩이라도\n매일 해내는 네가 대단해',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF7A634B),
                        ),
                        textAlign: TextAlign.end,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16),
          // 하단 성장 배경 그림
          growingMap(),
          SizedBox(height: 108),
        ],
      ),
    );
  }

  Widget growingMap() {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 16,
      ),
      child: GestureDetector(
        onTap: () {
          // 마지막 레벨(3)에 도달하고 모든 배지가 활성화된 경우 더이상 아무 일도 일어나지 않음
          if (currentLevel > 3 || (currentLevel == 3 && activationCount >= 5)) {
            return;
          }

          setState(() {
            if (activationCount < 5) {
              badgeActivated[activationCount] = true;
              activationCount++;
              
              // 모든 배지가 활성화되면 축하 다이얼로그 표시
              if (activationCount == 5 && !isDialogShown) {
                isDialogShown = true;
                
                // 0.5초 후에 다이얼로그 표시
                Timer(Duration(milliseconds: 500), () {
                  _showCongratulationDialog();
                });
              }
            }
          });
        },
        child: Stack(
          children: [
            // 배경 이미지
            Image.asset(
              backgroundImages[currentLevel] ?? 'assets/images/badge_map/badge_map_level_one.png',
              width: MediaQuery.of(context).size.width - 32,
              fit: BoxFit.cover,
            ),
            // 동적으로 배지 생성
            ...List.generate(5, (index) {
              final positions = badgePositions[currentLevel] ?? badgePositions[1]!;
              final position = positions[index];
              
              return Positioned(
                top: position['top'],
                left: position['left'],
                child: Container(
                  width: 75,
                  height: 75,
                  decoration: BoxDecoration(
                    color: Color(0xFFFFF2CD).withOpacity(badgeActivated[index] ? 1.0 : 0.5),
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: badgeActivated[index]
                      ? Center(
                          child: Image.asset(
                            'assets/images/badge_map/badge_map_${String.fromCharCode(97 + index)}.png', // a, b, c, d, e
                            width: 55,
                            height: 55,
                          ),
                        )
                      : null,
                ),
              );
            }),
            // 이정표 위치
            Positioned(
              bottom: 0,
              right: 10,
              child: Container(
                width: 100,
                height: 75,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/badge_map/badge_map_milestone.png'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Center(
                  child: Row(
                    children: [
                      SizedBox(width: 16),
                      Text(
                        levelTitles[currentLevel] ?? '도전자',
                        style: TextStyle(
                          color: Color(0xFF8C7154),
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  // 축하 다이얼로그 표시
  void _showCongratulationDialog() {
    showModalBottomSheet(
      context: context,
      isDismissible: false,
      enableDrag: false,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        // 1.5초 후에 자동으로 다이얼로그 닫고 레벨업
        Timer(Duration(milliseconds: 1500), () {
          Navigator.of(context).pop();
          _levelUp();
        });
        
        return Container(
          decoration: BoxDecoration(
            color: Color(0xFFFFF7DC),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '활발한 거북이님,\n레벨업 축하해요!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF8C7154),
                ),
              ),
              SizedBox(height: 20),
              Image.asset(
                'assets/images/character_without_cushion.png',
                height: 120,
              ),
              SizedBox(height: 20),
              Container(
                width: 150,
                height: 50,
                decoration: BoxDecoration(
                  color: Color(0xFFA7CA60),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Center(
                  child: Text(
                    congratulationTitles[currentLevel] ?? '모험가',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    icon: Icon(Icons.home_outlined, color: Color(0xFFBFB192), size: 30),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: Icon(Icons.bookmark_border_outlined, color: Color(0xFFBFB192), size: 30),
                    onPressed: () {},
                  ),
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Color(0xFF8C7154),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.add, color: Colors.white, size: 30),
                  ),
                  IconButton(
                    icon: Icon(Icons.assistant_navigation, color: Color(0xFFBFB192), size: 30),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: Icon(Icons.person_outline, color: Color(0xFFBFB192), size: 30),
                    onPressed: () {},
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  // 레벨업 처리
  void _levelUp() {
    if (currentLevel < 3) { // 최대 레벨은 3
      setState(() {
        currentLevel += 1;
        badgeActivated = List.generate(5, (index) => false); // 배지 초기화
        activationCount = 0;
        isDialogShown = false;
      });
    }
  }
}