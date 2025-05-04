import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class ProfileScreenTwo extends StatefulWidget {
  const ProfileScreenTwo({super.key});

  @override
  State<ProfileScreenTwo> createState() => _ProfileScreenTwoState();
}

class _ProfileScreenTwoState extends State<ProfileScreenTwo> {

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 1), () {
      _showLevelUpDialog();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFF7DC),
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              width: double.infinity,
              height: double.infinity,
              padding: EdgeInsets.fromLTRB(40, 10, 40, 0),
              child: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 24),
                    Text(
                      '나의 하루-잇\n루틴 현황',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF7A634B),
                      ),
                    ),
                    SizedBox(height: 24),
                    // 상단 캐릭터 카드 + 진행도 카드
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // 캐릭터 카드
                        Container(
                          width: (kIsWeb) ? (430 - 100) / 2 - 25 : (MediaQuery.of(context).size.width - 100) / 2 - 25, // 좌우 여백 고려
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Color(0xFFFAFAFA),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Color(0xFFB0A18E)),
                          ),
                          child: Column(
                            children: [
                              Image.asset(
                                'assets/images/character_without_cushion.png',
                                width: 60,
                                height: 60,
                              ),
                              SizedBox(height: 8),
                              Text(
                                '활발한 거북이',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF7A634B),
                                ),
                              ),
                              SizedBox(height: 4),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Color(0xFF7A634B),
                                  borderRadius: BorderRadius.circular(1000),
                                ),
                                child: Text(
                                  '씨앗 등급',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // 도전 진행도 카드
                        Container(
                          width: (kIsWeb) ? (430 - 100) / 2 + 25 : (MediaQuery.of(context).size.width - 100) / 2 + 25,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Color(0xFFFAFAFA),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Color(0xFFB0A18E)),
                          ),
                          child: Column(
                            children: [
                              Text(
                                '5일 연속\n도전 중',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xFF7A634B),
                                ),
                              ),
                              SizedBox(height: 8),
                              LinearProgressIndicator(
                                value: 5/7, // 예시로 5/7 진행
                                backgroundColor: Colors.grey[300],
                                color: Color(0xFF7A634B),
                                minHeight: 8,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              SizedBox(height: 8),
                              Text(
                                '조금씩이라도\n매일 해내는 네가 대단해',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF7A634B),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 24),

                    // 하단 성장 배경 그림
                    Container(
                      width: double.infinity,
                      height: 400,
                      decoration: BoxDecoration(
                        color: Color(0xFFFAFAFA),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Color(0xFFB0A18E)),
                      ),
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: Image.asset(
                              'assets/images/grow_background_two.png', // 배경 그림
                              fit: BoxFit.cover,
                            ),
                          ),
                          // (원형 캐릭터 5개 정도 추가 가능)
                        ],
                      ),
                    ),
                    SizedBox(height: 100),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showLevelUpDialog() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            padding: EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Color(0xFFFFF7DC),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Color(0xFFB0A18E)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Icon(Icons.close, size: 24, color: Color(0xFF7A634B)),
                  ),
                ),
                SizedBox(height: 8),
                Image.asset(
                  'assets/images/character_without_cushion.png',
                  width: 120,
                  height: 120,
                ),
                SizedBox(height: 24),
                Text(
                  '활발한 거북이 님,\n레벨업 축하해요!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF7A634B),
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