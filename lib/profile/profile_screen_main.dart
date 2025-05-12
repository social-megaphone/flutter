import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ProfileScreenMain extends StatefulWidget {
  const ProfileScreenMain({super.key});

  @override
  State<ProfileScreenMain> createState() => _ProfileScreenMainState();
}

class _ProfileScreenMainState extends State<ProfileScreenMain> {
  int _selectedTabIndex = 0;

  final fsStorage = FlutterSecureStorage();

  String _userNickname = '';

  Future<void> _loadUserNickname() async {
    final userNickname = await fsStorage.read(key: 'randomName');
    setState(() {
      _userNickname = userNickname ?? '활발한 거북이';
    });
  }

  @override
  void initState() {
    super.initState();
    _loadUserNickname();
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
            onTap: () {
              // 어디로 넘어가는 거에요?
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
        // 참여한 루틴 없음
        return Expanded(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.folder_open, size: 80, color: Colors.black87),
                const SizedBox(height: 16),
                const Text(
                  '참여한 루틴이 없어요.\n바로 도전하러 가볼까요?',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 17, color: Colors.black),
                ),
              ],
            ),
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
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 17, color: Colors.black),
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
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 17, color: Colors.black),
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
