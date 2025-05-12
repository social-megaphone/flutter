import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mvp/lounge/lounge_post_screen.dart';

import '../widgets.dart';

class LoungeScreenMain extends StatefulWidget {
  const LoungeScreenMain({super.key});

  @override
  State<LoungeScreenMain> createState() => _LoungeScreenMainState();
}

class _LoungeScreenMainState extends State<LoungeScreenMain> {

  List<String> tagList = ['전체', '생활습관', '감정돌봄', '대인관계', '자기계발', '작은도전'];

  // '전체 포스트들'의 정보를 담은 리스트
  final List<List<String>> _allPostInfoList = [
    ['생활습관', '조용한 강아지', '침대 정리하기', '내가 건강해지는 기분이 들어서 좋아요.\n이제 3일 루틴을 시도해보고 싶어요.'],
    ['감정돌봄', '따뜻한 고양이', '내 감정 한 줄 쓰기', '내가 건강해지는 기분이 들어서 좋아요.\n이제 3일 루틴을 시도해보고 싶어요.'],
    ['대인관계', '활발한 거북이', '아침 물 한 잔 마시기', '내가 건강해지는 기분이 들어서 좋아요.\n이제 3일 루틴을 시도해보고 싶어요.'],
    ['자기계발', '유쾌한 참새', '책 한 쪽 읽기', '내가 건강해지는 기분이 들어서 좋아요.\n이제 3일 루틴을 시도해보고 싶어요.'],
    ['작은도전', '용감한 토끼', '새로운 길로 출근하기', '내가 건강해지는 기분이 들어서 좋아요.\n이제 3일 루틴을 시도해보고 싶어요.'],
  ];

  // '보여질 포스트들'의 정보를 담은 리스트
  List<List<String>> postInfoList = [];

  @override
  void initState() {
    super.initState();
    postInfoList = List.from(_allPostInfoList);
    final storage = FlutterSecureStorage();

    Future<void> loadStoredPost() async {
      final tag = await storage.read(key: 'tag');
      final randomName = await storage.read(key: 'randomName');
      final routineName = await storage.read(key: 'routineName');
      final sogam = await storage.read(key: 'sogam');

      if (tag != null && randomName != null && routineName != null && sogam != null) {
        final newPost = [tag, randomName, routineName, sogam];
        setState(() {
          _allPostInfoList.insert(0, newPost);
          postInfoList = List.from(_allPostInfoList);
        });
      }
    }

    loadStoredPost();
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
          AfterOnboarding.notificationButton(Color(0xFFFFF7DC)),
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
            postInfoList = List.from(_allPostInfoList);
          } else {
            postInfoList = _allPostInfoList.where((post) => post[0] == selectedTag).toList();
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
        return _buildPost(postInfoList[index]);
      },
      separatorBuilder: (BuildContext context, int index) {
        return SizedBox(height: 24);
      },
    );
  }

  Widget _buildPost(List<String> postInfo) {
    PageController pageController = PageController();
    int currentIndex = 0;

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
            height: 295,
            margin: EdgeInsets.symmetric(
              horizontal: 16,
            ),
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
                  height: 136,
                  child: PageView.builder(
                    controller: pageController,
                    itemCount: 5,
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
                            margin: EdgeInsets.symmetric(horizontal: 4),
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: Color(0xFFB0A18E),
                                width: 2,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                '사진${index + 1}',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF7A634B),
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
                                children: List.generate(5, (dotIndex) {
                                  return Container(
                                    margin: EdgeInsets.symmetric(horizontal: 4),
                                    width: 8,
                                    height: 8,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: currentIndex == dotIndex ? Color(0xFF7A634B) : Color(0xFFD9D9D9),
                                    ),
                                  );
                                }),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
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