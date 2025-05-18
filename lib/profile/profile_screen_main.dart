import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

class ProfileScreenMain extends StatefulWidget {
  const ProfileScreenMain({super.key});

  @override
  State<ProfileScreenMain> createState() => _ProfileScreenMainState();
}

class _ProfileScreenMainState extends State<ProfileScreenMain> {
  int _selectedTabIndex = 0;
  int _tapCount = 0;

  // flutter secure storage에 접근
  final fsStorage = FlutterSecureStorage();

  String _userNickname = '';
  String _userId = '';
  List<Map<String, dynamic>> _myRoutineLogs = [];
  bool _isLoadingRoutines = true;

  Future<void> _loadUserNicknameAndId() async {
    final userNickname = await fsStorage.read(key: 'randomName');
    setState(() {
      _userNickname = userNickname ?? '활발한 거북이';
    });
    // 내 userId 가져오기
    final token = await fsStorage.read(key: 'jwt_token');

    if (token != null) {
      final uri = Uri.https('haruitfront.vercel.app', '/api/auth/mypage');
      final response = await http.get(uri, headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      });

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _userId = data['data']['id'] ?? '';
        });

        print('userId: $_userId');
        _fetchMyRoutineLogs();
      }
    }
  }

  Future<void> _fetchMyRoutineLogs() async {
    setState(() {
      _isLoadingRoutines = true;
    });

    final token = await fsStorage.read(key: 'jwt_token');
    if (token == null || _userId.isEmpty) {
      setState(() {
        _isLoadingRoutines = false;
      });
      print('_fetchMyRoutineLogs에서 token을 못 받아왔거나 userId가 비어있어요');
      return;
    }

    final uri = Uri.https('haruitfront.vercel.app', '/api/routine-log', {'limit': '1000'});

    final response = await http.get(uri, headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    });

    if (response.statusCode == 200) {
      print('_fetchMyRoutineLogs에서 200 코드 받아왔어요');

      final data = jsonDecode(response.body);
      final List<dynamic> logs = data['routineLogs'] ?? [];
      final myLogs = logs.where((log) => log['userId'] == _userId).toList();
      print('_fetchMyRoutineLogs에서 myLogs: $myLogs');
      setState(() {
        _myRoutineLogs = myLogs.map((log) => {
          'category': categoryFinder(log['title']),
          'title': log['title'] ?? '',
          'date': log['performedAt'] ?? '',
        }).toList();
        _isLoadingRoutines = false;
      });
    } else {
      setState(() {
        _isLoadingRoutines = false;
      });
    }
  }

  String categoryFinder(String title) {
    switch (title) {
      case '아침 물 한 잔 마시기':
      case '5분 스트레칭 하기':
      case '기상 또는 취침 시간 지키기':
      case '나를 위한 건강식 한 끼':
      case '내 공간 1개 정돈하기':
      case '바람 따라 걷기 20분':
        return '생활습관';
      case '오늘의 기분 한 줄 남기기':
      case '고요한 숨, 3분 호흡하기':
      case '1년 뒤의 나에게 보내는 편지':
      case '마음에 새기는 한 문장':
      case '나에게 보내는 칭찬 한마디':
      case '나를 위한 선물 사보기':
        return '감정돌봄';
      case '일일 간단한 대화하기':
      case '3분 경청하기':
      case '작은 응원 한마디':
      case '고마운 사람에게 마음 전하기':
      case '닮고 싶은 배울 점 찾기':
      case '한 장의 손편지 쓰기':
        return '대인관계';
      case '마음에 닿는 한 줄 소개하기':
      case '멘토와의 작은 만남':
      case '내 관심 분야의 글 읽기':
      case '오늘의 흥미 저장하기':
      case '새로운 취미 한 걸음':
      case '내가 꿈꾸는 나':
        return '자기계발';
      case '스스로 음식 주문해보기':
      case '오늘의 랜덤 이동 기록하기':
      case '오늘의 하늘 기록하기':
      case '목적 없는 가벼운 산책':
        return '작은도전';
      default:
        return '기타';
    }
  }

  @override
  void initState() {
    super.initState();
    // 여기서 nickname은 Display를 위해서, id는 _fetchMyRoutineLogs를 위해서 Load함.
    _loadUserNicknameAndId();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 60),
          profileHeader(),
          const SizedBox(height: 24),
          userGuide(),
          const SizedBox(height: 24),
          const Divider(
            thickness: 10,
            color: Color(0xFFFCE9B2),
          ),
          const SizedBox(height: 12),
          buildTabBar(context),
          buildTabContent(),
        ],
      ),
    );
  }

  Padding profileHeader() {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 20,
      ),
      child: Row(
        children: [
          Image.asset(
            'assets/images/profile_image_temp.png',
            width: 50,
          ),
          SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _userNickname,
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF000000),
                ),
              ),
              SizedBox(height: 10),
              Container(
                padding: EdgeInsets.fromLTRB(8, 2, 8, 4),
                decoration: BoxDecoration(
                  color: Color(0xFF9BC84C),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Text(
                  '도전자',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFFFFFFFF),
                  ),
                ),
              ),
            ],
          ),
          Spacer(),
          GestureDetector(
            onTap: () async {
              _tapCount++;
              if (_tapCount == 10) {
                _tapCount = 0;
                // 여기에 원하는 await 동작 수행
                await fsStorage.deleteAll();
              }
            },
            child: Icon(
              Icons.arrow_forward_ios,
              color: Color(0xFF8C7154),
              size: 24,
            ),
          ),
        ],
      ),
    );
  }

  Padding userGuide() {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 20,
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(
                vertical: 13,
              ),
              decoration: BoxDecoration(
                color: Color(0xFFFCE9B2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  Text(
                    '하루잇 사용 방법은 여기서 확인해요!',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF8C7154),
                    ),
                  ),
                  SizedBox(height: 7),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 7,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: Color(0xFF8C7154),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '루틴 가이드',
                              style: TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFFFFFFFF),
                              ),
                            ),
                            SizedBox(width: 3),
                            Icon(
                              Icons.info_outline,
                              color: Color(0xFFFFFFFF),
                              size: 10,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 15),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: Color(0xFF8C7154),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '뱃지 가이드',
                              style: TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFFFFFFFF),
                              ),
                            ),
                            SizedBox(width: 3),
                            Icon(
                              Icons.info_outline,
                              color: Color(0xFFFFFFFF),
                              size: 10,
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 16, right: 6),
            child: Image.asset(
              'assets/images/character_without_cushion.png',
              width: 96,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTabBar(BuildContext context) {
    final tabTitles = ['참여한 루틴', '마무리 기록', '작성한 댓글'];
    final tabCount = tabTitles.length;
    final indicatorWidth = MediaQuery.of(context).size.width / tabCount - 24;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            children: List.generate(tabCount, (index) {
              final isSelected = _selectedTabIndex == index;
              return Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _selectedTabIndex = index),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        tabTitles[index],
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: isSelected
                              ? const Color(0xFF000000)
                              : const Color(0xFF8C7154),
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
        Stack(
          children: [
            Container(
              height: 5,
              margin: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: const Color(0xFFD9C7B0),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            AnimatedAlign(
              alignment: Alignment(-1 + (_selectedTabIndex * 2 / (tabCount - 1)), 0),
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 12),
                width: indicatorWidth,
                height: 5,
                decoration: BoxDecoration(
                  color: const Color(0xFF8C7154),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget buildTabContent() {
    switch (_selectedTabIndex) {
      case 0:
        // 참여한 루틴
        if (_isLoadingRoutines) {
          print('로딩 중임.');
          return const Expanded(
            child: Center(child: CircularProgressIndicator()),
          );
        }
        if (_myRoutineLogs.isEmpty) {
          print('myRoutineLogs가 비어있어요.');
          return Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.folder_open, size: 80, color: Colors.black87),
                  const SizedBox(height: 16),
                  const Text(
                    '참여한 루틴이 없어요.\n바로 도전하러 가볼까요?',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF000000),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        }
        return Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
            itemCount: _myRoutineLogs.length,
            separatorBuilder: (context, index) => const Divider(height: 1, color: Color(0xFFFCE9B2)),
            itemBuilder: (context, index) {
              final log = _myRoutineLogs[index];
              final date = log['date'] != null && log['date'].toString().isNotEmpty
                  ? DateFormat('yyyy.MM.dd').format(DateTime.parse(log['date']))
                  : '';
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3F3F3),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.image, color: Color(0xFFB0A18E)),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            log['category'] ?? '',
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFFB0A18E),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            log['title'] ?? '',
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF000000),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            date,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                              color: Color(0xFFB0A18E),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      case 1:
        // 마무리 기록 없음
        return Expanded(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.edit_note, size: 80, color: Colors.black87),
                const SizedBox(height: 16),
                const Text(
                  '마무리 기록이 없어요.\n지금 남기러 가볼까요?',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF000000),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      case 2:
        // 작성한 댓글 없음
        return Expanded(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.chat_bubble_outline, size: 80, color: Colors.black87),
                const SizedBox(height: 16),
                const Text(
                  '작성한 댓글이 없어요.\n댓글 달러 가볼까요?',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF000000),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      default:
        return const SizedBox.shrink();
    }
  }
}
