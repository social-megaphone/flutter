import 'package:flutter/material.dart';
import 'package:flutter_inner_shadow/flutter_inner_shadow.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'dart:math' as math;
import 'dart:async';

import '../after_onboarding_main.dart';
import '../falling_petal.dart';
import 'routine_screen_two.dart';
class RoutineScreenOne extends StatefulWidget {
  const RoutineScreenOne({super.key, required this.genesisRoutine});

  final List<String> genesisRoutine;

  @override
  State<RoutineScreenOne> createState() => _RoutineScreenOneState();
}

class _RoutineScreenOneState extends State<RoutineScreenOne> {
  final TextEditingController _reflectionController = TextEditingController();
  bool isButtonEnabled = false;
  final ImagePicker _picker = ImagePicker();
  List<File> _selectedImageFiles = []; // XFile 대신 File 객체 사용

  @override
  void initState() {
    super.initState();
    _reflectionController.addListener(() {
      setState(() {
        // 사진이 선택되었거나 텍스트가 입력되었을 때 버튼 활성화
        isButtonEnabled = _reflectionController.text.trim().isNotEmpty || _selectedImageFiles.isNotEmpty;
      });
    });
  }

  @override
  void dispose() {
    _reflectionController.dispose();
    super.dispose();
  }

  // 임시 파일 생성 함수
  Future<File> _createTempFile(String extension) async {
    final Directory tempDir = await getTemporaryDirectory();
    final String tempPath = tempDir.path;
    final String randomFileName = '${math.Random().nextInt(10000)}_${DateTime.now().millisecondsSinceEpoch}.$extension';
    return File('$tempPath/$randomFileName');
  }

  // 이미지 선택 메서드
  Future<void> _pickImages() async {
    try {
      // 갤러리에서 이미지 선택
      final List<XFile> pickedImages = await _picker.pickMultiImage(
        imageQuality: 80,
        maxWidth: 1200,
        maxHeight: 1200,
        requestFullMetadata: false,
      );

      if (pickedImages.isEmpty || !mounted) return;

      // 로딩 표시
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('이미지를 처리하는 중입니다...')),
      );

      final List<File> validFiles = [];
      
      for (final XFile pickedImage in pickedImages) {
        try {
          // 임시 파일 생성 (확장자 추출)
          final String extension = pickedImage.path.split('.').last.toLowerCase();
          final File tempFile = await _createTempFile(extension);
          
          // 원본 파일 내용을 임시 파일로 복사
          final File originalFile = File(pickedImage.path);
          if (await originalFile.exists()) {
            await originalFile.copy(tempFile.path);
            validFiles.add(tempFile);
          }
        } catch (e) {
          print('개별 이미지 처리 오류: $e');
        }
      }

      if (mounted) {
        if (validFiles.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('이미지를 가져올 수 없습니다. 다른 이미지를 선택해주세요.')),
          );
        } else {
          setState(() {
            _selectedImageFiles = validFiles;
            isButtonEnabled = true;
          });
          ScaffoldMessenger.of(context).clearSnackBars();
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('사진 선택 중 오류가 발생했습니다: $e')),
        );
        
        // 권한 관련 오류라면 수동으로 권한 요청
        if (e.toString().contains('permission')) {
          _requestPermissionManually();
        }
      }
    }
  }
  
  // 수동 권한 요청
  Future<void> _requestPermissionManually() async {
    try {
      if (Platform.isIOS) {
        await openAppSettings();
      } else {
        await [
          Permission.storage,
          Permission.photos,
          Permission.camera,
        ].request();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('권한 요청 중 오류가 발생했습니다: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFF7DC),
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          // 꽃 떨어지는 부분
          ...List.generate(45, (index) => FallingPetal(
            indexForPositionX: index % 5,
            fallDelay: Duration(milliseconds: 500 * index),
            //fallDelay: _fallDelay(index),
          )),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 32,
              ),
              child: Column(
                children: [
                  SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '내 첫 루틴을\n시작 해볼까요?',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF7A634B),
                        ),
                      ),
                      SizedBox(width: 12),
                      // 방석 아이콘 (width < height 이므로, height만 설정)
                      Column(
                        children: [
                          SizedBox(height: 12),
                          Image.asset('assets/images/character_with_cushion.png', height: 130),
                        ],
                      ), 
                    ],
                  ),
                  SizedBox(height: 20), // 텍스트와 이미지 간 간격
                  InnerShadow(
                    shadows: [
                      Shadow(
                        color: Colors.grey,
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                        vertical: 20,
                        horizontal: 20,
                      ),
                      decoration: BoxDecoration(
                        color: Color(0xFFFAFAFA),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1), // 아주 연한 그림자
                            blurRadius: 20, // 퍼짐 정도
                            spreadRadius: 0, // 그림자 크기 확장 없음
                            offset: Offset(0, 8), // 아래쪽으로 살짝 이동
                          ),
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1), // 아주 연한 그림자
                            blurRadius: 20, // 퍼짐 정도
                            spreadRadius: 0, // 그림자 크기 확장 없음
                            offset: Offset(0, -8), // 아래쪽으로 살짝 이동
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Text(
                            // 0번째 -> routine name
                            widget.genesisRoutine[0],
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF121212),
                              height: 1.5, // 줄 간격 조금 띄우기
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 12),
                          Text(
                            // 2번째 -> routine explanation
                            widget.genesisRoutine[2],
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: Color(0xFF121212),
                              height: 1.5, // 줄 간격 조금 띄우기
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 20),
                          Container(
                            width: 100,
                            padding: EdgeInsets.symmetric(
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Color(0xFFFCE9B2),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Center(
                              child: Text(
                                '인증 방법',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF8C7154),
                                  height: 1.5, // 줄 간격 조금 띄우기
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 12),
                          Text(
                            '백에서 받아올\n텍스트',
                            //'물을 마신 컵 또는 잔의 사진을 찍고\n상쾌한 기분에 대한 한 줄 소감을 적어요',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: Color(0xFF121212),
                              height: 1.5, // 줄 간격 조금 띄우기
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20), // 텍스트와 이미지 간 간격
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: 16,
                    ),
                    decoration: BoxDecoration(
                      color: Color(0xFFFAFAFA),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1), // 아주 연한 그림자
                          blurRadius: 20, // 퍼짐 정도
                          spreadRadius: 0, // 그림자 크기 확장 없음
                          offset: Offset(0, 8), // 아래쪽으로 살짝 이동
                        ),
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1), // 아주 연한 그림자
                          blurRadius: 20, // 퍼짐 정도
                          spreadRadius: 0, // 그림자 크기 확장 없음
                          offset: Offset(0, -8), // 아래쪽으로 살짝 이동
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Text(
                          '오늘 실천할 순간을\n사진으로 남겨주세요!',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF121212),
                            height: 1.5, // 줄 간격 조금 띄우기
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 12),
                        GestureDetector(
                          onTap: _pickImages,
                          child: Container(
                            width: 100,
                            padding: EdgeInsets.symmetric(
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Color(0xFFFCE9B2),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Center(
                              child: Text(
                                '사진 업로드',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF8C7154),
                                  height: 1.5, // 줄 간격 조금 띄우기
                                ),
                              ),
                            ),
                          ),
                        ),
                        if (_selectedImageFiles.isNotEmpty) ...[
                          SizedBox(height: 16),
                          Container(
                            height: 100,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: _selectedImageFiles.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.file(
                                      _selectedImageFiles[index],
                                      width: 100,
                                      height: 100,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) {
                                        print('이미지 로드 오류: $error');
                                        return Container(
                                          width: 100,
                                          height: 100,
                                          color: Colors.grey[300],
                                          child: Icon(Icons.broken_image, color: Colors.grey[600]),
                                        );
                                      },
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            '${_selectedImageFiles.length}장의 사진이 선택되었습니다',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF8C7154),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  SizedBox(height: 20), // 텍스트와 이미지 간 간격
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 16,
                    ),
                    decoration: BoxDecoration(
                      color: Color(0xFFFAFAFA),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1), // 아주 연한 그림자
                          blurRadius: 20, // 퍼짐 정도
                          spreadRadius: 0, // 그림자 크기 확장 없음
                          offset: Offset(0, 8), // 아래쪽으로 살짝 이동
                        ),
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1), // 아주 연한 그림자
                          blurRadius: 20, // 퍼짐 정도
                          spreadRadius: 0, // 그림자 크기 확장 없음
                          offset: Offset(0, -8), // 아래쪽으로 살짝 이동
                        ),
                      ],
                    ),
                    child: TextFormField(
                      controller: _reflectionController,
                      decoration: InputDecoration(
                        hintText: '실천 후 소감을 솔직하게 적어봐요',
                        hintStyle: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF828282),
                        ),
                        contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                        border: InputBorder.none,
                      ),
                      maxLines: null,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF121212),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // 넘어가는 버튼
          Positioned(
            left: 40,
            right: 40,
            bottom: 40, // 40이나 넣는 이유는, SafeArea 밖이라 그래.
            child: GestureDetector(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  isDismissible: false,
                  enableDrag: false,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (context) {
                    // 3초 후 자동으로 화면 전환
                    Timer(Duration(seconds: 3), () {
                      Navigator.pop(context); // BottomSheet 닫기
                      
                      Navigator.of(context).pushReplacement(
                        PageRouteBuilder(
                          pageBuilder: (context, animation, secondaryAnimation) => RoutineScreenTwo(),
                          transitionsBuilder: (context, animation, secondaryAnimation, child) {
                            return FadeTransition(
                              opacity: animation,
                              child: child,
                            );
                          },
                          transitionDuration: const Duration(milliseconds: 500),
                        ),
                      );
                    });
                    
                    return Container(
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height * 0.5,
                      padding: EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Color(0xFFFFF2CD),
                        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                      ),
                      child: Column(
                        children: [
                          Text(
                            '축하해요,\n루틴을 완료했어요!',
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF7A634B),
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 24),
                          Image.asset('assets/images/badge_example.png', height: 100),
                          SizedBox(height: 24),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).pushReplacement(
                                PageRouteBuilder(
                                  pageBuilder: (context, animation, secondaryAnimation) => AfterOnboardingMain(
                                    pageIndex: 2,
                                  ),
                                  transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                    return FadeTransition(
                                      opacity: animation,
                                      child: child,
                                    );
                                  },
                                  transitionDuration: const Duration(milliseconds: 1500),
                                ),
                              );
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 32),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(30),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 8,
                                    offset: Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Text(
                                '뱃지 받기',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF7A634B),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
              child: Container(
                padding: EdgeInsets.symmetric(
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: isButtonEnabled ? Color(0xFF8C7154) : Color(0xFFD6C5B4),
                  borderRadius: BorderRadius.circular(1000),
                ),
                child: Center(
                  child: Text(
                    '다 했어요!',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFFFFF2CD),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}