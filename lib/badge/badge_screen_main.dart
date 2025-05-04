import 'package:flutter/material.dart';

class BadgeScreenMain extends StatefulWidget {
  const BadgeScreenMain({super.key});

  @override
  State<BadgeScreenMain> createState() => _BadgeScreenMainState();
}

class _BadgeScreenMainState extends State<BadgeScreenMain> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: AlwaysScrollableScrollPhysics(),
      child: Column(
        children: [
          SizedBox(height: 12),
          // 제목 및 알림 버튼
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 32,
            ),
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
                Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Color(0xFF8C7154),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1), // 아주 연한 그림자
                            blurRadius: 10, // 퍼짐 정도
                            spreadRadius: 0, // 그림자 크기 확장 없음
                            offset: Offset(0, 4), // 아래쪽으로 살짝 이동
                          ),
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1), // 아주 연한 그림자
                            blurRadius: 10, // 퍼짐 정도
                            spreadRadius: 0, // 그림자 크기 확장 없음
                            offset: Offset(0, -4), // 아래쪽으로 살짝 이동
                          ),
                        ],
                      ),
                      child: Center(
                        child: Icon(
                          Icons.notifications,
                          size: 24,
                          color: Color(0xFFFCE9B2),
                        ),
                      ),
                    ),
                    SizedBox(height: 32),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 32),
          // 상단 캐릭터 카드 + 진행도 카드
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 16,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // 캐릭터 카드
                Container(
                  width: (MediaQuery.of(context).size.width - 16 * 3) / 2 - 25, // 좌우 여백 고려
                  height: 172,
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
                    children: [
                      Image.asset(
                        'assets/images/profile_image_temp.png',
                        height: 70,
                      ),
                      SizedBox(height: 12),
                      Text(
                        '활발한 거북이',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF8C7154),
                        ),
                      ),
                      SizedBox(height: 12),
                      Container(
                        width: double.infinity,
                        margin: EdgeInsets.symmetric(
                          horizontal: 16,
                        ),
                        padding: EdgeInsets.symmetric(
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Color(0xFF7A634B),
                          borderRadius: BorderRadius.circular(1000),
                        ),
                        child: Text(
                          '초보자',
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
                ),

                // 도전 진행도 카드
                Container(
                  width: (MediaQuery.of(context).size.width - 16 * 3) / 2 + 25,
                  height: 172,
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
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '5일 연속\n도전 중',
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF8C7154),
                        ),
                        textAlign: TextAlign.right,
                      ),
                      SizedBox(height: 8),
                      LinearProgressIndicator(
                        value: 2/7, // 예시로 5/7 진행
                        backgroundColor: Colors.grey[300],
                        color: Color(0xFFD27CEE),
                        minHeight: 12,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      SizedBox(height: 8),
                      Text(
                        '조금씩이라도\n매일 해내는 네가 대단해',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF7A634B),
                        ),
                        textAlign: TextAlign.end,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16),
          // 하단 성장 배경 그림
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 16,
            ),
            child: GestureDetector(
              onTap: () {
                /*
                Navigator.of(context).pushReplacement(
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) => ProfileScreenTwo(),
                    transitionsBuilder: (context, animation, secondaryAnimation, child) {
                      return FadeTransition(
                        opacity: animation,
                        child: child,
                      );
                    },
                    transitionDuration: const Duration(milliseconds: 500),
                  ),
                );

                 */
              },
              // 이 이미지는 border가 이미 존재하는 이미지여버림.
              child: Image.asset(
                'assets/images/badge_map/badge_map_zero.png',
                width: MediaQuery.of(context).size.width - 32,
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(height: 108),
        ],
      ),
    );
  }
}