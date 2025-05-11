import 'package:flutter/material.dart';

class LoungePostScreen extends StatefulWidget {
  const LoungePostScreen({super.key, required this.postInfo});

  final List<String> postInfo;

  @override
  State<LoungePostScreen> createState() => _LoungePostScreenState();
}

class _LoungePostScreenState extends State<LoungePostScreen> {
  // 태그에 따른 색상 반환 함수
  Color getTagColor(String tag) {
    switch (tag) {
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
    return Scaffold(
      backgroundColor: Color(0xFFFFF7DC),
      appBar: appBar(),
      body: Stack(
        children: [
          // 본문 스크롤 영역
          Positioned.fill(
            child: GestureDetector(
              onTap: () {
                if (_commentFocusNode.hasFocus) {
                  _commentFocusNode.unfocus();
                }
              },
              child: SafeArea(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 16),
                  child: SingleChildScrollView(
                    physics: AlwaysScrollableScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Divider(
                          color: Color(0xFF8C7154),
                          thickness: 1,
                        ),
                        SizedBox(height: 12),
                        userData(), // 유저 프로필 이미지 + 유저 닉네임
                        SizedBox(height: 16),
                        pics(), // 사진
                        SizedBox(height: 8),
                        likeCommentSave(), // 좋아요, 댓글, 저장
                        SizedBox(height: 16),
                        mainContent(), // 루틴 제목, 소감
                        SizedBox(height: 20),
                        commentPart(), // 댓글
                        SizedBox(height: 80), // 댓글 입력창 높이만큼 여유 공간
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          // 하단 고정 댓글 입력창
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Builder(
              builder: (footerContext) => AnimatedContainer(
                duration: Duration(milliseconds: 300),
                padding: EdgeInsets.only(
                  //bottom: MediaQuery.of(footerContext).viewInsets.bottom,
                ),
                color: Color(0xFFFFF7DC),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 4, horizontal: 16),
                  width: double.infinity,
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
              ),
            ),
          ),
        ],
      ),
    );
  }

  AppBar appBar() {
    return AppBar(
      backgroundColor: const Color(0xFFFFF7DC),
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
    );
  }

  Row userData() {
    return Row(
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
                text: widget.postInfo[1],
                style: TextStyle(
                  color: Color(0xFF8C7154),
                ),
              ),
              TextSpan(
                text: '님의 잇루틴',
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
    );
  }

  SizedBox pics() {
    return SizedBox(
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
    );
  }

  Padding likeCommentSave() {
    return Padding(
      // 시각적으로 vertical align 되게 하기 위해서, horizontal padding을 4 정도 줌.
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Row(
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
    );
  }

  Container mainContent() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFFFFFBED),
        border: Border.all(color: Color(0xFF8C7154), width: 1),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 4,
            ),
            decoration: BoxDecoration(
              color: getTagColor(widget.postInfo[0]).withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              widget.postInfo[2],
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: Color(0xFF666666),
              ),
            ),
          ),
          SizedBox(height: 8),
          // 소감
          Text(
            '깔끔하고 깨끗해진 내 책상을 보니 뿌듯해요.\n다음에는 내 방 청소에 도전해볼게요!',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: Color(0xFF121212),
              height: 1.5,
            ),
          ),
          SizedBox(height: 8),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: Color(0xFF8C7154),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  'assets/images/post_like_emojies/like_emoji_love.png',
                  width: 12,
                ),
                SizedBox(width: 4),
                Text(
                  '3',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFFFFF7DC),
                  ),
                ),
                SizedBox(width: 10),
                Image.asset(
                  'assets/images/post_like_emojies/like_emoji_thumbsup.png',
                  width: 12,
                ),
                SizedBox(width: 4),
                Text(
                  '2',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFFFFF7DC),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Padding commentPart() {
    return Padding(
      // 시각적으로 vertical align 되게 하기 위해서, horizontal padding을 2 정도 줌.
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: ListView.separated(
        itemCount: commentList.length,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        separatorBuilder: (context, index) => SizedBox(height: 12),
        itemBuilder: (context, index) {
          final comment = commentList[index];
          return _buildComment(comment[0], comment[1]);
        },
      ),
    );
  }

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

  Widget _buildComment(String writer, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: '$writer님 ',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF121212),
                ),
              ),
              TextSpan(
                text: content,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF121212),
                  height: 1.5,
                ),
              ),
            ]
          ),
        ),
      ],
    );
  }
}