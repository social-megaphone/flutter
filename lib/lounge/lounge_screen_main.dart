import 'package:flutter/material.dart';
import 'package:mvp/lounge/lounge_post_screen.dart';

class LoungeScreenMain extends StatefulWidget {
  const LoungeScreenMain({super.key});

  @override
  State<LoungeScreenMain> createState() => _LoungeScreenMainState();
}

class _LoungeScreenMainState extends State<LoungeScreenMain> {

  List<String> tagList = ['전체', '생활습관', '감정돌봄', '대인관계', '자기계발'];

  // '전체 포스트들'의 정보를 담은 리스트
  final List<List<String>> _allPostInfoList = [
    ['생활습관', '조용한 강아지', '침대 정리하기'],
    ['감정돌봄', '따뜻한 고양이', '내 감정 한 줄 쓰기'],
    ['대인관계', '활발한 거북이', '아침 물 한 잔 마시기'],
    ['자기계발', '유쾌한 참새', '책 한 쪽 읽기'],
  ];

  // '보여질 포스트들'의 정보를 담은 리스트
  List<List<String>> postInfoList = [];

  final PageController _pageController = PageController(viewportFraction: 1);
  int currentPageIndex = 0;

  @override
  void initState() {
    super.initState();
    postInfoList = List.from(_allPostInfoList);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            SizedBox(height: 12),
            // 제목 및 캐릭터 및 알림 버튼
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 32,
              ),
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
                  Image.asset('assets/images/character_without_cushion.png', height: 100),
                  Spacer(),
                  Column(
                    children: [
                      Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Color(0xFFD9D9D9), width: 1),
                        ),
                        child: Center(
                          child: Icon(Icons.notifications, size: 24),
                        ),
                      ),
                      SizedBox(height: 32),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 24),
            // 태그
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 16,
              ),
              child: SizedBox(
                height: 36,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: tagList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return _buildTag(tagList[index]);
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return SizedBox(width: 10);
                  },
                ),
              ),
            ),
            SizedBox(height: 24),
            // 게시물 리스트
            ListView.separated(
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
            ),
            SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  String selectedTag = '전체';

  Widget _buildTag(String tagName) {
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
        padding: EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          color: (selectedTag == tagName) ? const Color(0xFF121212) : const Color(0xFFFAFAFA),
          borderRadius: BorderRadius.circular(1000),
          border: Border.all(color: Color(0xFFD9D9D9), width: 0.5),
        ),
        child: Center(
          child: Text(
            tagName,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: (selectedTag == tagName) ? const Color(0xFFFAFAFA) : const Color(0xFF121212),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPost(List<String> postInfo) {
    PageController pageController = PageController();
    int currentIndex = 0;

    return StatefulBuilder(
      builder: (context, setState) {
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
            margin: EdgeInsets.symmetric(
              horizontal: 20,
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
                    // '조용한 강아지의 잇루틴'
                    Text.rich(
                      TextSpan(
                          children: [
                            TextSpan(
                              text: '${postInfo[1]}님',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF8C7154),
                              ),
                            ),
                            TextSpan(
                              text: '의 잇루틴',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF121212),
                              ),
                            ),
                          ]
                      ),
                    ),
                    // 태그
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0x335F83FF),
                        borderRadius: BorderRadius.circular(1000),
                        border: Border.all(color: Color(0xFFD9D9D9), width: 0.5),
                      ),
                      child: Text(
                        postInfo[0],
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF5F83FF),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // 사진 (PageView)
                SizedBox(
                  width: double.infinity,
                  height: 120,
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
                    // 루틴 제목
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0x335F83FF),
                        borderRadius: BorderRadius.circular(1000),
                        border: Border.all(color: Color(0xFFD9D9D9), width: 0.5),
                      ),
                      child: Text(
                        postInfo[2],
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF5F83FF),
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
                  '내가 건강해지는 기분이 들어서 좋아요.\n이제 3일 루틴을 시도해보고 싶어요.',
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
      },
    );
  }
}