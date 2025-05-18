import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';

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
  final TextEditingController _commentController = TextEditingController();

  // 상세 조회 상태
  int likeCount = 0;
  int commentCount = 0;
  bool isLiked = false;
  bool isBookmarked = false;
  String performedAt = '';
  List<Map<String, dynamic>> comments = [];

  @override
  void initState() {
    super.initState();
    pageController = PageController();
    _fetchRoutineLogDetail();
    _fetchComments();
  }

  final fsStorage = FlutterSecureStorage();

  Future<void> _fetchRoutineLogDetail() async {
    final routineLogId = widget.postInfo[0];

    try {
      final token = await fsStorage.read(key: 'jwt_token');
      print('token: $token');

      // 쿼리 파라미터 이렇게 처리하기도 하더라.
      final uri = Uri.https('haruitfront.vercel.app', '/api/routine-log/detail', {'id': routineLogId});
      final response = await http.get(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
        }, 
      );

      if (response.statusCode == 200) {
        final routineLogDetatilData = jsonDecode(response.body);
        print('routineLogDetatilData: $routineLogDetatilData');
        setState(() {
          likeCount = routineLogDetatilData['likeCount'] ?? 0;
          commentCount = routineLogDetatilData['commentCount'] ?? 0;
          isLiked = routineLogDetatilData['isLiked'] ?? false;
          isBookmarked = routineLogDetatilData['isBookmarked'] ?? false;
          performedAt = routineLogDetatilData['performedAt'] ?? '';
          comments = List<Map<String, dynamic>>.from(routineLogDetatilData['comments'] ?? []);
        });
      } else {
        print('루틴 로그 상세 조회 실패: statusCode=${response.statusCode}');
      }
    } catch (e) {
      print('루틴 로그 상세 조회 중 예외 발생: $e');
    }
  }

  Future<void> _fetchComments() async {
    final routineLogId = widget.postInfo[0];
    try {
      final uri = Uri.https('haruitfront.vercel.app', '/api/comment', {'routineLogId': routineLogId});
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          comments = List<Map<String, dynamic>>.from(data['comments'] ?? []);
        });
      } else {
        print('댓글 목록 조회 실패: statusCode=${response.statusCode}');
      }
    } catch (e) {
      print('댓글 목록 조회 중 예외 발생: $e');
    }
  }

  @override
  void dispose() {
    pageController.dispose();
    _commentFocusNode.dispose();
    _commentController.dispose();
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
                        SizedBox(height: 100), // 댓글 입력창 높이만큼 여유 공간
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          // 하단 고정 댓글 입력창
          SafeArea(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                padding: EdgeInsets.only(bottom: 16),
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
                          controller: _commentController,
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
                        onPressed: () async {
                          final content = _commentController.text.trim();
                          if (content.isEmpty) return;
                          final routineLogId = widget.postInfo[0];
                          final token = await fsStorage.read(key: 'jwt_token');
                          final uri = Uri.https('haruitfront.vercel.app', '/api/comment');
                          final response = await http.post(
                            uri,
                            headers: {
                              'Content-Type': 'application/json',
                              'Authorization': 'Bearer $token',
                            },
                            body: jsonEncode({'routineLogId': routineLogId, 'content': content}),
                          );
                          if (response.statusCode == 200) {
                            final data = jsonDecode(response.body);
                            setState(() {
                              comments.add({
                                'nickname': data['nickname'] ?? '나',
                                'content': data['content'] ?? content,
                              });
                              commentCount += 1;
                            });
                            _commentController.clear();
                            _commentFocusNode.unfocus();
                          } else {
                            print('댓글 작성 실패: statusCode=${response.statusCode}');
                          }
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
                text: widget.postInfo[2],
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
    final List<String> imageUrls = widget.postInfo[5].isNotEmpty ? widget.postInfo[5].split(',') : [];

    return SizedBox(
      width: double.infinity,
      child: AspectRatio(
        aspectRatio: 1/1,
        child: PageView.builder(
          controller: pageController,
          itemCount: imageUrls.isEmpty ? 1 : imageUrls.length,
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
                              color: currentImageIndex == dotIndex ? Color(0xFF7A634B) : Color(0xFFD9D9D9),
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
    );
  }

  Padding likeCommentSave() {
    return Padding(
      // 시각적으로 vertical align 되게 하기 위해서, horizontal padding을 4 정도 줌.
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Row(
        children: [
          GestureDetector(
            onTap: () async {
              // 루틴 Id
              final routineLogId = widget.postInfo[0];

              final token = await fsStorage.read(key: 'jwt_token');

              final uri = Uri.https('haruitfront.vercel.app', '/api/like');
              final response = await http.post(
                uri,
                headers: {
                  'Content-Type': 'application/json',
                  'Authorization': 'Bearer $token',
                },
                body: jsonEncode({'routineLogId': routineLogId}),
              );

              if (response.statusCode == 200) {
                print('좋아요 토글 성공: ${response.body}');
                final data = jsonDecode(response.body);
                setState(() {
                  if (data['liked'] == true) {
                    isLiked = true;
                    likeCount += 1;
                  } else {
                    isLiked = false;
                    likeCount = likeCount > 0 ? likeCount - 1 : 0;
                  }
                });
              } else {
                print('좋아요 토글 실패: statusCode=${response.statusCode}');
              }
            },
            child: Icon(
              isLiked ? Icons.favorite : Icons.favorite_border,
              size: 24,
              color: Color(0xFF8C7154),
            ),
          ),
          SizedBox(width: 4),
          Text(
            likeCount.toString(),
            style: TextStyle(
              color: Color(0xFF8C7154),
            ),
          ),
          SizedBox(width: 12),
          Icon(Icons.mode_comment_outlined, size: 24, color: Color(0xFF8C7154)),
          SizedBox(width: 4),
          Text(
            commentCount.toString(),
            style: TextStyle(
              color: Color(0xFF8C7154),
            ),
          ),
          Spacer(),
          GestureDetector(
            onTap: () async {
              final routineLogId = widget.postInfo[0];
              final token = await fsStorage.read(key: 'jwt_token');
              final uri = Uri.https('haruitfront.vercel.app', '/api/bookmark');
              final response = await http.post(
                uri,
                headers: {
                  'Content-Type': 'application/json',
                  'Authorization': 'Bearer $token',
                },
                body: jsonEncode({'routineLogId': routineLogId}),
              );
              if (response.statusCode == 200) {
                print('북마크 토글 성공: ${response.body}');
                final data = jsonDecode(response.body);
                setState(() {
                  isBookmarked = data['bookmarked'] ?? false;
                });
              } else {
                print('북마크 토글 실패: statusCode=${response.statusCode}');
              }
            },
            child: Icon(
              isBookmarked ? Icons.bookmark : Icons.bookmark_outline,
              size: 24,
              color: Color(0xFF8C7154),
            ),
          ),
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
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: getTagColor(widget.postInfo[1]).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  widget.postInfo[3], // 루틴 제목
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF666666),
                  ),
                ),
              ),
              Spacer(),
              if (performedAt.isNotEmpty)
                Text(
                  performedAt.split('T').first,
                  style: TextStyle(
                    fontSize: 13,
                    color: Color(0xFF8C7154),
                  ),
                ),
            ],
          ),
          SizedBox(height: 8),
          // 소감
          Text(
            widget.postInfo[4],
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
                  likeCount.toString(),
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
                  likeCount.toString(),
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
        itemCount: comments.length,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        separatorBuilder: (context, index) => SizedBox(height: 12),
        itemBuilder: (context, index) {
          final comment = comments[index];
          return _buildComment(
            comment['nickname'] ?? '알 수 없음',
            comment['content'],
          );
        },
      ),
    );
  }

  Widget _buildComment(String writer, String content) {
    if (writer == null) {
      print('[_buildComment] writer is null, content: $content');
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: '${writer ?? '알 수 없음'}님 ',
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