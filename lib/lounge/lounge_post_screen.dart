import 'package:flutter/material.dart';

class LoungePostScreen extends StatefulWidget {
  const LoungePostScreen({super.key, required this.postInfo});

  final List<String> postInfo;

  @override
  State<LoungePostScreen> createState() => _LoungePostScreenState();
}

class _LoungePostScreenState extends State<LoungePostScreen> {
  late PageController pageController;
  int currentImageIndex = 0;
  final FocusNode _commentFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    pageController = PageController();
  }

  @override
  void dispose() {
    pageController.dispose();
    _commentFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // 빈 공간 터치 시 키보드 unfocus
        if (_commentFocusNode.hasFocus) {
          _commentFocusNode.unfocus();
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Color(0xFFFFF7DC),
        appBar: AppBar(
          backgroundColor: const Color(0xFFFFF7DC), // 배경색 맞추기
          surfaceTintColor: const Color(0xFFFFF7DC),
          elevation: 0, // 그림자 제거
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: Color(0xFF7A634B)),
            onPressed: () {
              Navigator.pop(context); // 뒤로가기
            },
          ),
          centerTitle: true, // 제목 중앙 정렬
          title: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Text(
                '하루잇 Haru-It',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF7A634B),
                ),
              ),
              SizedBox(height: 4),
              Text(
                '게시물',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF121212),
                ),
              ),
            ],
          ),
        ),
        body: SafeArea(
          child: Container(
            margin: EdgeInsets.symmetric(
              horizontal: 16,
            ),
            child: SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.only(bottom: 100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Divider(
                    color: Color(0xFF8C7154),
                    thickness: 1,
                  ),
                  SizedBox(height: 12),
                  // 유저 프로필 이미지 + 유저 닉네임
                  Row(
                    children: [
                      // 유저 프로필 이미지
                      Image.asset(
                        'assets/images/profile_image_temp.png',
                        width: 36,
                      ),
                      const SizedBox(width: 12),
                      // 유저 닉네임
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              // 작성자 id
                              text: '${widget.postInfo[1]}님',
                              style: TextStyle(
                                color: Color(0xFF8C7154),
                              ),
                            ),
                            TextSpan(
                              text: '의 잇루틴',
                            ),
                          ],
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF121212),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  // 사진
                  SizedBox(
                    width: double.infinity,
                    height: 200,
                    child: PageView.builder(
                      controller: pageController,
                      itemCount: 5,
                      pageSnapping: true,
                      onPageChanged: (index) {
                        setState(() {
                          currentImageIndex = index;
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
                                    fontSize: 16,
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
                                        color: currentImageIndex == dotIndex ? Color(0xFF7A634B) : Color(0xFFD9D9D9),
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
                  SizedBox(height: 16),
                  // 루틴 제목
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Color(0x335F83FF),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      widget.postInfo[2],
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF5F83FF),
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  // 소감
                  Text(
                    '깔끔하고 깨끗해진 내 책상을 보니 뿌듯해요.\n다음에는 내 방 청소에 도전해볼게요!',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF121212),
                      height: 1.5,
                    ),
                  ),
                  SizedBox(height: 8),
                  // 좋아요, 댓글, 저장
                  Row(
                    children: const [
                      Icon(Icons.favorite_border, size: 24, color: Color(0xFF8C7154)),
                      SizedBox(width: 4),
                      Text(
                        '10',
                        style: TextStyle(
                          color: Color(0xFF8C7154),
                        ),
                      ),
                      SizedBox(width: 12),
                      Icon(Icons.mode_comment_outlined, size: 24, color: Color(0xFF8C7154)),
                      SizedBox(width: 4),
                      Text(
                        '5',
                        style: TextStyle(
                          color: Color(0xFF8C7154),
                        ),
                      ),
                      Spacer(),
                      Icon(Icons.bookmark_outline, size: 24, color: Color(0xFF8C7154)),
                    ],
                  ),
                  SizedBox(height: 4),
                  Divider(
                    color: Color(0xFF8C7154),
                    thickness: 1,
                  ),
                  // 댓글 리스트 렌더링
                  ListView.separated(
                    itemCount: commentList.length,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    separatorBuilder: (context, index) => SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final comment = commentList[index];
                      return _buildComment(comment[0], comment[1]);
                    },
                  ),
                  SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
        persistentFooterButtons: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 4),
            width: double.infinity,
            color: Color(0xFFFFF7DC),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.add_circle_outline, color: Color(0xFF8C7154)),
                  onPressed: () {
                    // 추가 기능을 위한 자리
                  },
                ),
                Expanded(
                  child: TextFormField(
                    focusNode: _commentFocusNode,
                    decoration: InputDecoration(
                      hintText: '댓글을 입력해보세요',
                      hintStyle: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF828282),
                      ),
                      contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(36),
                        borderSide: BorderSide(
                          width: 1,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(36),
                        borderSide: BorderSide(
                          color: Color(0xFFEEEEEE),
                          width: 1,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(36),
                        borderSide: BorderSide(
                          color: Color(0xFF8C7154),
                          width: 1.5,
                        ),
                      ),
                      filled: true,
                      fillColor: Color(0xFFF5F5F5),
                    ),
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF121212),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send, color: Color(0xFF8C7154)),
                  onPressed: () {
                    //print('댓글 전송됨');
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<String> selectedTags = [];

  // 댓글 데이터
  final List<List<String>> commentList = [
    ['활발한 거북이', '우와! 진짜 깔끔해진 사진만 봐도 기분이 좋아져요. 저도 다음 루틴으로 해봐야겠네요!'],
    ['유쾌한 참새', '루틴 완주를 응원해요! 화이팅~'],
    ['느긋한 사자', '정말 멋져요. 꾸준함이 빛나네요!'],
    ['창의적인 다람쥐', '저도 자극받아서 오늘 루틴 실천했어요.'],
    ['진지한 부엉이', '사진에서 집중력이 느껴져요!'],
    ['활발한 강아지', '정말 깨끗하네요~ 다음에도 기대할게요.'],
    ['신중한 고양이', '꼼꼼하게 정리한 게 느껴져요. 대단해요!'],
    ['열정적인 펭귄', '보기만 해도 저도 동기부여 되네요.'],
    ['낙천적인 토끼', '감탄하고 갑니다~'],
    ['조용한 여우', '루틴 공유해줘서 고마워요 :)'],
  ];

  // 댓글 위젯 추출
  Widget _buildComment(String writer, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          writer,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF121212),
          ),
        ),
        Text(
          content,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Color(0xFF121212),
            height: 1.5,
          ),
        ),
      ],
    );
  }
}