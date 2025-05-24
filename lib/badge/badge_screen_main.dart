import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:async';
import 'dart:convert';

import '../widgets.dart';
import '../routine/routine_screen_one.dart';

// home of this application
class BadgeScreenMain extends StatefulWidget {
  const BadgeScreenMain({super.key});

  @override
  State<BadgeScreenMain> createState() => _BadgeScreenMainState();
}

class _BadgeScreenMainState extends State<BadgeScreenMain> {
  @override
  void initState() {
    super.initState();
    _loadData();
    _checkRoutineCompletion();
  }

  // true -> CircularProgressIndicator
  // false -> Real Screen
  bool isLoading = false;

  // FlutterSecureStorage instance
  // read [nickname], [goalDate], [streak], [previousStreak]
  final fsStorage = FlutterSecureStorage();

  // variable that stores data read from fsStorage
  String? nickname;
  String? goalDate;
  int? currentStreak; // streak for current routine
  int? previousStreak; // streak for previous routine's'

  // variable that determined by currentStreak and previousStreak
  int? level;

  Future<void> _loadData() async {
    print('loadData 호출됨');
    setState(() {
      isLoading = true;
    });

    final storedNickname = await fsStorage.read(key: 'randomName');
    final storedGoalDate = await fsStorage.read(key: 'goalDate');
    final storedCurrentStreak = await fsStorage.read(key: 'streak');
    final storedPreviousStreak = await fsStorage.read(key: 'previousStreak');

    if (!mounted) return;

    print('storedNickname: $storedNickname');
    print('storedGoalDate: $storedGoalDate');
    print('storedCurrentStreak: $storedCurrentStreak');
    print('storedPreviousStreak: $storedPreviousStreak');

    setState(() {
      nickname = storedNickname ?? '랜덤 닉네임';
      goalDate = (storedGoalDate != null) ? storedGoalDate : null;
      currentStreak = (storedCurrentStreak != null) ? int.parse(storedCurrentStreak) : 0;
      previousStreak = (storedPreviousStreak != null) ? int.parse(storedPreviousStreak) : 0;
      level = (currentStreak! + previousStreak!) ~/ 5;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: AlwaysScrollableScrollPhysics(),
      child: (!isLoading) ? Column(
        children: [
          SizedBox(height: 16),
          header(), // '나의 하루잇 루틴 현황' + notification button
          SizedBox(height: 32),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                profileCard(),
                progressCard(),
              ],
            ),
          ),
          SizedBox(height: 16),
          growingMap(),
          SizedBox(height: 108),
        ],
      ) : SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Center(child: CircularProgressIndicator()),
      ),
    );
  }

  Padding header() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 32),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            '나의 하루잇\n루틴 현황',
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w800,
              color: Color(0xFFFCE9B2),
            ),
          ),
          Spacer(),
          // notification button
          GestureDetector(
            onTap: () {
              CustomSnackBar.show(
                context,
                '알림 기능은 현재 준비 중 입니다.',
              );
            },
            child: AfterOnboarding.notificationButton(Color(0xFF8C7154), Color(0xFFFCE9B2)),
          ),
        ],
      ),
    );
  }

  Container profileCard() {
    return Container(
      width: (MediaQuery.of(context).size.width - 16 * 3) / 2 - 25, // 좌우 여백 고려
      height: 194,
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Image.asset(
            'assets/images/profile_image_temp.png',
            height: 70,
          ),
          SizedBox(height: 12),
          // 닉네임
          Text(
            nickname!,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: Color(0xFF8C7154),
            ),
          ),
          SizedBox(height: 12),
          // 레벨
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 4),
            decoration: BoxDecoration(
              color: Color(0xFF7A634B),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              dataBasedOnLevel[level!][2]!,
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
    );
  }

  // 현재 루틴 완주 여부 확인
  Future<void> _checkRoutineCompletion() async {
    // 데이터가 로드될 때까지 잠시 대기
    await Future.delayed(Duration(milliseconds: 500));

    if (!mounted) return;

    if (currentStreak != null && goalDate != null && currentStreak == int.parse(goalDate!)) {
      // 1초 후에 완료 다이얼로그 표시
      await Future.delayed(Duration(seconds: 1));
      if (!mounted) return;

      _showCompletionDialog();
    }
  }
  // 완주 시 보여줄 다이얼로그
  void _showCompletionDialog() {
    showModalBottomSheet(
      context: context,
      isDismissible: true,
      enableDrag: false,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          width: MediaQuery.of(context).size.width,
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
                '축하해요!\n$goalDate일간의 루틴을\n성공적으로 완료했어요!',
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
              GestureDetector(
                onTap: () {
                  setState(() {
                    Navigator.pop(context);
                  });
                },
                child: Container(
                  width: 150,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Color(0xFFA7CA60),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Center(
                    child: Text(
                      '완료',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 30),
            ],
          ),
        );
      },
    ).then((_) async {
      // 다이얼로그가 닫히기 전에 currentStreak을 previousStreak에 추가
      if (currentStreak != null) {
        final newPreviousStreak = (previousStreak ?? 0) + currentStreak!;
        await fsStorage.write(key: 'previousStreak', value: newPreviousStreak.toString());
        print('previousStreak: $previousStreak');
        print('currentStreak: $currentStreak');
        print('new total: ${previousStreak ?? 0 + currentStreak!}');
        setState(() {
          // 이게 효과가 있으려나? 한 번 보죠.
        });
      }

      // streak과 goalDate 초기화
      fsStorage.delete(key: 'streak');
      fsStorage.delete(key: 'goalDate');
      // 화면 새로고침
      setState(() {
        currentStreak = 0;
        goalDate = null;
      });
    });
  }

  Container progressCard() {
    // streak이나 goalDate가 없으면 빈 카드 표시
    if (currentStreak == null || goalDate == null) {
      return Container(
        width: (MediaQuery.of(context).size.width - 16 * 3) / 2 + 25,
        height: 194,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Color(0xFFFFF7DC),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            width: 3,
            color: Color(0xFFFFF2CD),
          ),
        ),
        child: Center(
          child: Text(
            '진행중인 루틴 없음',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Color(0xFF8C7154),
            ),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return Container(
      width: (MediaQuery.of(context).size.width - 16 * 3) / 2 + 25,
      height: 194,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Color(0xFFFFF7DC),
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
            '$currentStreak일 연속\n도전 중',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: Color(0xFF8C7154),
            ),
            textAlign: TextAlign.right,
          ),
          Text(
            // 여기 1을 실제로 루틴을 진행한 날로 변경해야 함.
            '완주까지 ${int.parse(goalDate!) - currentStreak!}일 남았어요',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: Color(0xFF8C7154),
            ),
            textAlign: TextAlign.right,
          ),
          SizedBox(height: 6),
          LinearProgressIndicator(
            // 여기 1을 내가 실제로 루틴을 진행한 날로 변경해야 함.
            value: currentStreak! / int.parse(goalDate!),
            backgroundColor: Colors.grey[300],
            color: Color(0xFFD27CEE),
            minHeight: 20,
            borderRadius: BorderRadius.circular(10),
          ),
          SizedBox(height: 8),
          GestureDetector(
            onTap: () async {
              final genesisRoutine = List<String>.from(jsonDecode(await fsStorage.read(key: 'genesisRoutine') ?? '[]'));
              final howToRoutine = await fsStorage.read(key: 'howToRoutine') ?? '';

              // 여기서 루틴 이어하는 화면으로 넘어가야 함.
              Navigator.push(context, MaterialPageRoute(builder: (context) => RoutineScreenOne(
                genesisRoutine: genesisRoutine,
                howToRoutine: howToRoutine,
              )));
            },
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 6,
              ),
              decoration: BoxDecoration(
                color: Color(0xFFFFFFFF),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Color(0xFF000000).withOpacity(0.1),
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: '도전 중인\n',
                    ),
                    TextSpan(
                      text: '루틴 이어가기 >',
                      style: TextStyle(
                        color: Color(0xFFD27CEE),
                      ),
                    ),
                  ],
                ),
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF8C7154),
                ),
                textAlign: TextAlign.right,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 레벨에 의한 데이터 총 집합
  // dataBasedOnLevel[level!][1]과 같이 사용한다.
  // [0]은 badge_map을 위해서
  // [1]은 badge position을 위해서
  // [2]는 profileCard를 위해서
  // [3]은 milestone을 위해서
  List<List<dynamic>> dataBasedOnLevel = [
    [
      'one',
      [
        {'top': 40, 'left': 90},
        {'top': 90, 'left': 180},
        {'top': 160, 'left': 250},
        {'top': 210, 'left': 140},
        {'top': 250, 'left': 40},
      ],
      '초보자',
      '도전자',
    ],
    [
      'two',
      [
        {'top': 20, 'left': 100},
        {'top': 90, 'left': 200},
        {'top': 130, 'left': 110},
        {'top': 210, 'left': 190},
        {'top': 250, 'left': 80},
      ],
      '도전자',
      '모험가',
    ],
    [
      'three',
      [
        {'top': 30, 'left': 190},
        {'top': 90, 'left': 80},
        {'top': 140, 'left': 200},
        {'top': 200, 'left': 50},
        {'top': 250, 'left': 150},
      ],
      '모험가',
      '고수',
    ],
  ];

  Widget growingMap() {
    return SizedBox(
      height: 355,
      child: PageView.builder(
        controller: PageController(
          // 초기 화면은 level에 의해서 결정!
          initialPage: level!,
        ),
        itemCount: 3,
        itemBuilder: (BuildContext context, int pageIndex) {
          // 전체 badge 개수
          final badgeCount = currentStreak! + previousStreak!;

          final showingBadgeCount = badgeCount - (5 * pageIndex);

          return Stack(
            children: [
              badgeMap(pageIndex),
              for(int i = 0; i<5; i++)...[
                badges(dataBasedOnLevel[pageIndex][1][i], pageIndex, showingBadgeCount > i),
              ],
              milestone(pageIndex),
            ],
          );
        },
      ),
    );
  }

  Widget badgeMap(int pageIndex) {
    return Container(
      width: double.infinity,
      height: 355,
      margin: EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        image: DecorationImage(
          image: AssetImage('assets/images/badge_map/badge_map_level_${dataBasedOnLevel[pageIndex][0]}.png'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget badges(Map<String, int> badgePositionData, int pageIndex, bool isFilled) {
    print('현재 streak: $currentStreak');
    print('이전 streak: $previousStreak');
    // 전체 badge 개수
    final badgeCount = currentStreak! + previousStreak!;

    if (pageIndex == 0) {
      if (badgeCount >= 5) {
        // 다 채우면 됨.
      } else {
        // badgeCount만큼만 채우면 됨.
      }
    } else if (pageIndex == 1) {
      if (badgeCount >= 10) {
        // 다 채우면 됨
      } else {
        // badgeCount - 5만큼만 채우면 됨.
      }
    } else if (pageIndex == 2) {
      if (badgeCount >= 15) {
        // 다 채우면 됨
      } else {
        // badgeCount - 10만큼만 채우면 됨.
      }
    }

    return Positioned(
      top: badgePositionData['top']!.toDouble(),
      left: badgePositionData['left']!.toDouble(),
      child: Container(
        width: 75,
        height: 75,
        decoration: BoxDecoration(
          color: isFilled ? Color(0xFFFFF2CD) : Color(0xFFFFF2CD).withOpacity(0.5),
          borderRadius: BorderRadius.circular(100),
        ),
        child: isFilled ? Center(
          child: Image.asset(
            'assets/images/badge_map/badge_map_a.png',
            width: 40,
            height: 40,
          ),
        ) : null,
      ),
    );
  }

  Widget milestone(int pageIndex) {
    return Positioned(
      bottom: 4,
      right: 28,
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
               dataBasedOnLevel[pageIndex][3]!,
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
    );
  }
}