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

  List<String> tagList = ['전체', '생활습관', '감정돌봄', '대인관계', '자기계발', '작은도전'];

  @override
  void initState() {
    super.initState();

    fetchRoutines(); // -> 이걸 하면 알아서 fetchedRoutineLogs가 업데이트 됨.
  }

  final fsStorage = FlutterSecureStorage();

  List<List<String>> fetchedRoutineLogs = [];

  // '보여질 포스트들'의 정보를 담은 리스트
  List<List<String>> postInfoList = [];

  Future<void> fetchRoutines() async {
    // jwt_token 불러옴
    final String? token = await fsStorage.read(key: 'jwt_token');
    if(token == null) {
      print('jwt_token is null. error happened');
    } else {
      print('jwt_token exists: $token');
    }

    // jwt_token 활용해서 루틴 로그 불러옴
    final uri = Uri.parse('https://haruitfront.vercel.app/api/routine-log');
    final response = await http.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      }
    );

    if (response.statusCode == 200) {
      // 받아오는 데이터 전체 -> jsonData
      final Map<String, dynamic> jsonData = jsonDecode(response.body);
      // 그 중, 루틴 로그와 관련된 부분 -> routineLogs
      final List<dynamic> routineLogs = jsonData['routineLogs'];
      // 그 중, 다음 커서와 관련된 부분 -> nextCursor
      final String nextCursor = jsonData['nextCursor'];
      // 그 중, 더 불러올 수 있는지 여부와 관련된 부분 -> hasMore
      final bool hasMore = jsonData['hasMore'];



      final List<List<String>> tempLogs = [];

      for(var log in routineLogs) {
        final String category = categoryFinder(log['title']);
        final List<String> imageUrls = log['logImg'] != null ? 
          (log['logImg'] as String).split(', ').where((url) => url.isNotEmpty).toList() : [];

        tempLogs.add([
          category,
          log['nickname'],
          log['title'],
          log['reflection'],
          imageUrls.join(','), // 이미지 URL들을 쉼표로 구분된 문자열로 저장
        ]);
      }

      setState(() {
        fetchedRoutineLogs = tempLogs;
        postInfoList = List.from(fetchedRoutineLogs); // 여기서 같이 초기화
      });
    } else {
      print('오류 발생: ${response.statusCode}');
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
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            SizedBox(height: 16),
            header(), // 제목 및 캐릭터 및 알림 버튼
            SizedBox(height: 30),
            tagPart(), // 태그
            SizedBox(height: 18),
            postPart(), // 게시물
            SizedBox(height: 80),
          ],
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
          AfterOnboarding.notificationButton(Color(0xFFFFF7DC), Color(0xFF8C7154)),
        ],
      ),
    );
  }

  SizedBox tagPart() {
    return SizedBox(
      height: 33,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: tagList.length,
        itemBuilder: (BuildContext context, int index) {
          return _buildTag(tagList[index]);
        },
        separatorBuilder: (BuildContext context, int index) {
          return SizedBox(width: 8);
        },
      ),
    );
  }

  String selectedTag = '전체';

  Widget _buildTag(String tagName) {
    // 태그에 따른 색상 반환 함수
    Color getTagColor(String tag) {
      switch (tag) {
        case '전체':
          return const Color(0xFF666666);
        case '생활습관':
          return const Color(0xFF7896FF);
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
        setState(() {
          selectedTag = tagName;
          if (selectedTag == '전체') {
            postInfoList = List.from(fetchedRoutineLogs);
          } else {
            postInfoList = fetchedRoutineLogs.where((post) => post[0] == selectedTag).toList();
          }
        });
      },
      // 태그 컨테이너
      child: Container(
        margin: (tagName == '전체') ? EdgeInsets.only(left: 16, bottom: 4) : (tagName == '작은도전') ? EdgeInsets.only(right: 16, bottom: 4) : EdgeInsets.only(bottom: 4),
        padding: EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: selectedTag == tagName ? getTagColor(tagName) : const Color(0xFFFFFFFF),
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha((0.1 * 255).toInt()), // 아주 연한 그림자
              blurRadius: 2, // 퍼짐 정도
              spreadRadius: 0, // 그림자 크기 확장 없음
              offset: Offset(0, 2), // 아래쪽으로 살짝 이동
            ),
          ]
        ),
        child: Center(
          child: Text(
            tagName,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: (selectedTag == tagName) ? const Color(0xFFFFFFFF) : const Color(0xFF121212),
            ),
          ),
        ),
      ),
    );
  }

  ListView postPart() {
    return ListView.separated(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      scrollDirection: Axis.vertical,
      itemCount: postInfoList.length,
      itemBuilder: (BuildContext context, int index) {
        return _buildRoutineLogPost(postInfoList[index]);
      },
      separatorBuilder: (BuildContext context, int index) {
        return SizedBox(height: 24);
      },
    );
  }

  Widget _buildRoutineLogPost(List<String> postInfo) {
    PageController pageController = PageController();
    int currentIndex = 0;
    final List<String> imageUrls = postInfo[4].isNotEmpty ? postInfo[4].split(',') : [];

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
                        text: postInfo[1],
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
                    postInfo[0],
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
                      currentIndex = index;
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
                    color: getTagColor(postInfo[0]).withOpacity(0.2), // 태그 색상 20% 투명도
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Color(0xFFD9D9D9), width: 0.5),
                  ),
                  child: Text(
                    postInfo[2],
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
              postInfo[3],
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