import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:mvp/lounge/lounge_post_screen.dart';

import '../widgets.dart';

class LoungeScreenMain extends StatefulWidget {
  const LoungeScreenMain({super.key});

  @override
  State<LoungeScreenMain> createState() => _LoungeScreenMainState();
}

class _LoungeScreenMainState extends State<LoungeScreenMain> {
  // 태그 리스트
  List<String> tagList = ['전체', '생활습관', '감정돌봄', '대인관계', '자기계발', '작은도전'];

  // SecureStorage 인스턴스
  final fsStorage = FlutterSecureStorage();

  // 루틴 로그 데이터 (각 포스트 정보)
  List<List<String>> fetchedRoutineLogs = [];
  List<List<String>> postInfoList = [];

  // 페이지네이션 관련 상태
  String? nextCursor; // 다음 페이지 커서
  bool hasMore = true; // 더 불러올 데이터가 있는지
  bool isLoading = false; // 현재 로딩 중인지
  String selectedTag = '전체'; // 현재 선택된 태그

  // 각 게시물별 이미지 PageView의 현재 인덱스 상태 관리
  final Map<int, int> postPageIndices = {};

  @override
  void initState() {
    super.initState();
    _fetchInitialRoutines(); // 최초 데이터 로드
  }

  @override
  void dispose() {
    super.dispose();
  }

  // 최초 데이터 로드 (상태 초기화)
  Future<void> _fetchInitialRoutines() async {
    print('_fetchInitialRoutines: 상태 초기화 및 첫 fetchRoutines 호출');
    setState(() {
      fetchedRoutineLogs = [];
      postInfoList = [];
      nextCursor = null;
      hasMore = true;
      isLoading = false;
    });
    await fetchRoutines();
  }

  // 실제 API 호출 함수 (커서 기반 페이지네이션)
  Future<void> fetchRoutines() async {
    print('fetchRoutines: 진입, isLoading=$isLoading, hasMore=$hasMore, nextCursor=$nextCursor');
    if (isLoading || !hasMore) {
      print('fetchRoutines: 중복 호출 방지로 리턴');
      return;
    }
    setState(() { isLoading = true; });

    final String? token = await fsStorage.read(key: 'jwt_token');
    if (token == null) {
      print('fetchRoutines: token이 null, 리턴');
      setState(() { isLoading = false; });
      return;
    }

    // 쿼리 파라미터 구성
    final params = <String, String>{
      'limit': '10',
    };
    if (nextCursor != null) {
      params['cursor'] = nextCursor!;
    }
    final uri = Uri.https('haruitfront.vercel.app', '/api/routine-log', params);

    print('fetchRoutines: GET $uri');
    final response = await http.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = jsonDecode(response.body);
      print('fetchRoutines: jsonData: $jsonData');
      final List<dynamic> routineLogs = jsonData['routineLogs'] ?? [];
      final String? newNextCursor = jsonData['nextCursor'];
      final bool newHasMore = jsonData['hasMore'] ?? false;

      final List<List<String>> tempLogs = [];
      for (var log in routineLogs) {
        final String category = categoryFinder(log['title']);
        final List<String> imageUrls = log['logImg'] is List
            ? List<String>.from(log['logImg'])
            : (log['logImg']?.toString().split(', ') ?? []).where((url) => url.isNotEmpty).toList();
        if (selectedTag == '전체' || category == selectedTag) {
          tempLogs.add([
            log['id'] ?? '',
            category,
            log['nickname'] ?? '',
            log['title'] ?? '',
            log['reflection'] ?? '',
            imageUrls.join(','),
          ]);
        }
      }

      print('fetchRoutines: 받아온 routineLogs 개수: ${tempLogs.length}');
      setState(() {
        fetchedRoutineLogs.addAll(tempLogs); // append 방식
        postInfoList = List.from(fetchedRoutineLogs);
        nextCursor = newNextCursor;
        hasMore = newHasMore;
        isLoading = false;
      });
      print('fetchRoutines: setState 후 postInfoList.length=${postInfoList.length}, nextCursor=$nextCursor, hasMore=$hasMore');
    } else {
      print('fetchRoutines: 오류 발생 statusCode=${response.statusCode}');
      setState(() { isLoading = false; });
    }
    print('fetchRoutines: 종료');
  }

  // 게시물 리스트 (무한스크롤 적용)
  Widget postPart() {
    return Column(
      children: [
        for (int i = 0; i < postInfoList.length; i++) ...[
          _buildRoutineLogPost(postInfoList[i], i),
          if (i != postInfoList.length - 1)
            const SizedBox(height: 24), // 마지막 아이템 뒤에는 간격 없음
        ],
        if (hasMore)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: Center(child: isLoading ? const CircularProgressIndicator() : const SizedBox()),
          ),
      ],
    );
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
  Widget build(BuildContext context) {
    // NotificationListener로 스크롤 이벤트 감지하여 무한 스크롤 구현
    return NotificationListener<ScrollNotification>(
      onNotification: (scrollInfo) {
        // 스크롤이 maxScrollExtent - 400 이상 내려오면 fetchRoutines 호출
        if (scrollInfo.metrics.pixels >= scrollInfo.metrics.maxScrollExtent - 1000) {
          print('NotificationListener: 끝에 가까워짐(-400), fetchRoutines 호출');
          fetchRoutines();
        }
        return false;
      },
      child: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              SizedBox(height: 16),
              header(), // 제목 및 캐릭터 및 알림 버튼
              SizedBox(height: 30),
              categoryPart(), // 태그
              SizedBox(height: 18),
              postPart(), // 게시물
              SizedBox(height: 80),
            ],
          ),
        ),
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
            '함께하는\n하루잇러들',
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w800,
              color: Color(0xFF7A634B),
            ),
          ),
          SizedBox(width: 12),
          // 캐릭터
          Image.asset('assets/images/character_without_cushion.png', height: 80),
          Spacer(),
          // 알림 버튼
          GestureDetector(
            onTap: () {
              CustomSnackBar.show(
                context,
                '알림 기능은 현재 준비 중입니다.',
              );
            },
            child: AfterOnboarding.notificationButton(Color(0xFFFFF7DC), Color(0xFF8C7154)),
          ),
        ],
      ),
    );
  }

  SizedBox categoryPart() {
    return SizedBox(
      height: 33,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: tagList.length,
        itemBuilder: (BuildContext context, int index) {
          return _buildCategory(tagList[index]);
        },
        separatorBuilder: (BuildContext context, int index) {
          return SizedBox(width: 8);
        },
      ),
    );
  }

  // 태그 선택 시 데이터 리셋 후 새로 로드
  Widget _buildCategory(String categoryName) {
    Color getTagColor(String tag) {
      switch (tag) {
        case '전체': return const Color(0xFF666666);
        case '생활습관': return const Color(0xFF7896FF);
        case '감정돌봄': return const Color(0xFFEA4793);
        case '대인관계': return const Color(0xFFFF9E28);
        case '자기계발': return const Color(0xFF68BA5A);
        case '작은도전': return const Color(0xFFC262D3);
        default: return const Color(0xFF666666);
      }
    }
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedTag = categoryName;
        });
        _fetchInitialRoutines(); // 태그 변경 시 데이터 리셋 후 새로 로드
      },
      child: Container(
        margin: (categoryName == '전체') ? EdgeInsets.only(left: 16, bottom: 4) : (categoryName == '작은도전') ? EdgeInsets.only(right: 16, bottom: 4) : EdgeInsets.only(bottom: 4),
        padding: EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: selectedTag == categoryName ? getTagColor(categoryName) : const Color(0xFFFFFFFF),
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha((0.1 * 255).toInt()),
              blurRadius: 2,
              spreadRadius: 0,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Center(
          child: Text(
            categoryName,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: (selectedTag == categoryName) ? const Color(0xFFFFFFFF) : const Color(0xFF121212),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRoutineLogPost(List<String> postInfo, int postIndex) {
    final PageController pageController = PageController();
    final List<String> imageUrls = postInfo[5].isNotEmpty ? postInfo[5].split(',') : [];
    // 현재 게시물의 페이지 인덱스, 없으면 0
    final int currentIndex = postPageIndices[postIndex] ?? 0;

    // 태그에 따른 색상 반환 함수 (배경색)
    Color getTagColor(String tag) {
      switch (tag) {
        case '전체':
          return const Color(0xFF666666);
        case '생활습관':
          return const Color(0xFF5F83FF);
        case '감정돌봄':
          return const Color(0xFFEA4793);
        case '대인관계':
          return const Color(0xFFFF9E28);
        case '자기계발':
          return const Color(0xFF68BA5A);
        case '작은도전':
          return const Color(0xFFC262D3);
        default:
          return const Color(0xFF666666);
      }
    }

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => LoungePostScreen(
              postInfo: postInfo,
            ),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(1.0, 0.0),
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              );
            },
            transitionDuration: const Duration(milliseconds: 150),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFFAFAFA),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha((0.1 * 255).toInt()), // 아주 연한 그림자
              blurRadius: 20, // 퍼짐 정도
              spreadRadius: 0, // 그림자 크기 확장 없음
              offset: Offset(0, 8), // 아래쪽으로 살짝 이동
            ),
            BoxShadow(
              color: Colors.black.withAlpha((0.1 * 255).toInt()), // 아주 연한 그림자
              blurRadius: 20, // 퍼짐 정도
              spreadRadius: 0, // 그림자 크기 확장 없음
              offset: Offset(0, -8), // 아래쪽으로 살짝 이동
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // '조용한 강아지의 잇루틴' + 태그
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // '조용한 강아지님의 잇루틴'
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: postInfo[2],
                        style: const TextStyle(
                          color: Color(0xFF8C7154),
                        ),
                      ),
                      TextSpan(
                        text: '님의 잇루틴',
                      ),
                    ]
                  ),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF121212),
                  ),
                  maxLines: 2,
                ),
                // 태그
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 7,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Color(0xFF8C7154), width: 1),
                  ),
                  child: Text(
                    postInfo[1],
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF8C7154),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // 사진 (PageView)
            SizedBox(
              width: double.infinity,
              child: AspectRatio(
                aspectRatio: 4/3,
                child: PageView.builder(
                  controller: pageController,
                  itemCount: imageUrls.isEmpty ? 1 : imageUrls.length,
                  pageSnapping: true,
                  onPageChanged: (index) {
                    setState(() {
                      postPageIndices[postIndex] = index;
                    });
                  },
                  itemBuilder: (context, index) {
                    return Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Color(0xFFB0A18E),
                              width: 2,
                            ),
                          ),
                          child: imageUrls.isEmpty ? 
                            Center(
                              child: Text(
                                'placeholder',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF7A634B),
                                ),
                              ),
                            ) :
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: SizedBox.expand(
                                child: Image.network(
                                  imageUrls[index],
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Center(
                                      child: Text(
                                        'placeholder',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Color(0xFF7A634B),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            margin: EdgeInsets.only(bottom: 8),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: List.generate(
                                imageUrls.isEmpty ? 1 : imageUrls.length,
                                (dotIndex) {
                                  return Container(
                                    margin: EdgeInsets.symmetric(horizontal: 4),
                                    width: 8,
                                    height: 8,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: currentIndex == dotIndex ? Color(0xFF7A634B) : Color(0xFFD9D9D9),
                                    ),
                                  );
                                }
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 12),
            // 루틴 제목 + 저장 버튼
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // 루틴 제목 - 여기도 색상 변경
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: getTagColor(postInfo[1]).withOpacity(0.2), // 태그 색상 20% 투명도
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Color(0xFFD9D9D9), width: 0.5),
                  ),
                  child: Text(
                    postInfo[3],
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF666666),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    // 색상 변화 로직 + 실제 저장 로직
                  },
                  child: Icon(Icons.bookmark_outline_rounded),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // 소감
            Text(
              postInfo[4],
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Color(0xFF121212),
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}