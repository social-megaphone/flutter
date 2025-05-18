import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../widgets.dart';
import '../routine/routine_screen_one.dart';
import 'dart:convert';

// this is kinda home screen that user will see when they open the app.
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

  // 각 맵의 배지 활성화 상태를 관리하는 리스트
  List<List<bool>> mapBadgeStates = List.generate(3, (_) => List.generate(5, (index) => false));
  bool isDialogShown = false;
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    _loadData();
    _checkRoutineCompletion();
  }

  // CircularProgessIndicator 보여줄 지, 실제 화면 보여줄 지 결정
  // 추후에 CircularProgessIndicator -> Skeleton 으로 바꿔야 함.
  bool isLoaded = false;

  // nickname, goalDate, streak, previousStreak 받아오기
  final fsStorage = FlutterSecureStorage();

  // fsStorage에서 받아올 데이터들이 들어갈 곳
  String? nickname;
  String? goalDate;
  int? currentStreak; // 현재 루틴 몇 일 했는지
  int? previousStreak; // 현재 루틴 이전의 루틴들까지 합쳐서 몇 일 했는지
  int? level; // currentStreak, previeousStreak에 의해서 결정되는 level 값.

  Future<void> _loadData() async {
    final storedNickname = await fsStorage.read(key: 'randomName');
    final storedGoalDate = await fsStorage.read(key: 'goalDate');
    final storedCurrentStreak = await fsStorage.read(key: 'streak');
    final storedPreviousStreak = await fsStorage.read(key: 'previousStreak');

    if (!mounted) return;

    setState(() {
      nickname = storedNickname;
      goalDate = (storedGoalDate != null) ? storedGoalDate : null;
      currentStreak = (storedCurrentStreak != null) ? int.parse(storedCurrentStreak) : null;
      previousStreak = (storedPreviousStreak != null) ? int.parse(storedPreviousStreak) : 0;
      level = ((currentStreak ?? 0) + (previousStreak ?? 0)) ~/ 5 + 1;
      isLoaded = true;
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  // 레벨업 다이얼로그 표시
  void _showCongratulationDialog() {
    if (isDialogShown) return;
    isDialogShown = true;

    showModalBottomSheet(
      context: context,
      isDismissible: false,
      enableDrag: false,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        // 1.5초 후에 자동으로 다이얼로그 닫기
        Timer(Duration(milliseconds: 1500), () {
          Navigator.of(context).pop();
          isDialogShown = false;
        });

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
                '$nickname님,\n레벨업 축하해요!',
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
                    titleBasedOnLevel[level! + 1]!, // 본인 title 다음 title 표시!
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 30),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    print('streak: $currentStreak');
    print('previousStreak: $previousStreak');
    print('badgeCount: ${currentStreak!+previousStreak!}');

    return SingleChildScrollView(
      physics: AlwaysScrollableScrollPhysics(),
      child: (isLoaded) ? Column(
        children: [
          SizedBox(height: 16),
          header(), // 제목 및 알림 버튼
          SizedBox(height: 32),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                profileCard(), // 프로필 카드
                progressCard(), // 진행도 카드
              ],
            ),
          ),
          SizedBox(height: 16),
          growingMap(), // 하단 성장 배경 그림
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
          GestureDetector(
            onTap: () {
              CustomSnackBar.show(
                context,
                '알림 기능은 현재 준비 중입니다.',
              );
            },
            child: AfterOnboarding.notificationButton(Color(0xFF8C7154), Color(0xFFFCE9B2)),
          ),
        ],
      ),
    );
  }

  // 레벨별 타이틀
  final Map<int, String> titleBasedOnLevel = {
    1: '도전자',
    2: '모험가',
    3: '고수',
    4: '마스터',
  };

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
          Text(
            nickname!,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: Color(0xFF8C7154),
            ),
          ),
          SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 4),
            decoration: BoxDecoration(
              color: Color(0xFF7A634B),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              titleBasedOnLevel[level!]!,
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
                '축하해요!\n${goalDate}일간의 루틴을\n성공적으로 완료했어요!',
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
                  Navigator.pop(context);
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
      }

      // streak과 goalDate 초기화
      fsStorage.delete(key: 'streak');
      fsStorage.delete(key: 'goalDate');
      // 화면 새로고침
      setState(() {
        currentStreak = null;
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

  Padding growingMap() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: SizedBox(
        height: 360,
        child: PageView.builder(
          controller: _pageController,
          itemCount: 3,
          onPageChanged: (index) {
            setState(() {
              level = index + 1;
            });
            
            // 이전 맵의 모든 배지가 활성화되어 있고, 다음 맵으로 넘어갈 때
            if (index > 0 && mapBadgeStates[index - 1].every((badge) => badge)) {
              _showCongratulationDialog();
            }
          },
          itemBuilder: (context, index) {
            return Stack(
              children: [
                Image.asset(
                  backgroundImages[index + 1] ?? 'assets/images/badge_map/badge_map_level_one.png',
                  width: MediaQuery.of(context).size.width - 32,
                  height: 360,
                  fit: BoxFit.cover,
                ),
                // 동적으로 배지 생성
                ...List.generate(5, (badgeIndex) {
                  final positions = badgePositions[level] ?? badgePositions[1]!;
                  final position = positions[badgeIndex];
                  
                  return Positioned(
                    top: position['top'],
                    left: position['left'],
                    child: Container(
                      width: 75,
                      height: 75,
                      decoration: BoxDecoration(
                        color: Color(0xFFFFF2CD).withOpacity(mapBadgeStates[index][badgeIndex] ? 1.0 : 0.5),
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: mapBadgeStates[index][badgeIndex] ? Center(
                        child: Image.asset(
                          'assets/images/badge_map/badge_map_${String.fromCharCode(97 + badgeIndex)}.png',
                          width: 55,
                          height: 55,
                        ),
                      ) : null,
                    ),
                  );
                }),
                // 이정표
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
                            titleBasedOnLevel[level]!,
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
            );
          },
        ),
      ),
    );
  }
}