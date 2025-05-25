import 'package:flutter/material.dart';
import 'package:flutter_inner_shadow/flutter_inner_shadow.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'dart:math' as math;
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:http_parser/http_parser.dart';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:universal_html/html.dart' as html;

import '../falling_petal.dart';
import '../widgets.dart';
import '../onboarding/onboarding_main.dart';
import '../after_onboarding_main.dart';
import 'routine_screen_two.dart';

class RoutineScreenOne extends StatefulWidget {
  const RoutineScreenOne({
    super.key,
    required this.genesisRoutine,
    required this.howToRoutine,
  });

  final List<String> genesisRoutine;
  final String howToRoutine;

  @override
  State<RoutineScreenOne> createState() => _RoutineScreenOneState();
}

class _RoutineScreenOneState extends State<RoutineScreenOne> {

  // TextEditingController for '소감' TextFormField
  final TextEditingController _reflectionController = TextEditingController();

  // enable/disable the '다 했어요!' button
  bool isButtonEnabled = false;

  final ImagePicker _picker = ImagePicker();
  List<Uint8List> _selectedImageFiles = [];


  String routineName = '';
  String goalDate = "1";

  @override
  void initState() {
    super.initState();
    routineName = '${widget.genesisRoutine[2]} ${widget.genesisRoutine[3]}';
    // enable '다 했어요!' button when picture is selected and text is typed
    _reflectionController.addListener(() {
      setState(() {
        isButtonEnabled = _reflectionController.text.trim().isNotEmpty && _selectedImageFiles.isNotEmpty;
      });
    });
    _loadGoalDate();
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
      if (kIsWeb) {
        // 웹 전용 이미지 선택 로직
        final input = html.FileUploadInputElement()
          ..accept = 'image/*'
          ..multiple = true;
        
        input.click();

        await input.onChange.first;
        if (input.files == null || input.files!.isEmpty) return;

        // 로딩 표시
        CustomSnackBar.show(context, '이미지를 처리하는 중입니다...');

        final List<Uint8List> validImages = [];
        
        for (final file in input.files!) {
          try {
            final reader = html.FileReader();
            reader.readAsArrayBuffer(file);
            await reader.onLoad.first;
            
            final Uint8List imageBytes = reader.result as Uint8List;
            print('웹 이미지 크기: ${imageBytes.length} bytes');
            
            if (imageBytes.isNotEmpty) {
              validImages.add(imageBytes);
            }
          } catch (e) {
            print('웹 이미지 처리 오류: $e');
          }
        }

        if (mounted) {
          if (validImages.isEmpty) {
            print('웹: 유효한 이미지가 없음');
            CustomSnackBar.show(context, '이미지를 가져올 수 없습니다. 다른 이미지를 선택해주세요.');
          } else {
            print('웹: 유효한 이미지 수: ${validImages.length}');
            setState(() {
              _selectedImageFiles = validImages.length > 3 ? validImages.sublist(0, 3) : validImages;
              isButtonEnabled = _reflectionController.text.trim().isNotEmpty && _selectedImageFiles.isNotEmpty;
            });
            ScaffoldMessenger.of(context).clearSnackBars();

            if (validImages.length > 3) {
              CustomSnackBar.show(context, '최대 3장까지만 선택 가능합니다.\n처음 3장이 선택되었습니다.');
            }
          }
        }
      } else {
        // 모바일용 기존 이미지 선택 로직
        final List<XFile> pickedImages = await _picker.pickMultiImage(
          imageQuality: 80,
          maxWidth: 1200,
          maxHeight: 1200,
          requestFullMetadata: false,
        );

        print('선택된 이미지 수: ${pickedImages.length}');

        if (pickedImages.isEmpty || !mounted) return;

        CustomSnackBar.show(context, '이미지를 처리하는 중입니다...');

        final List<Uint8List> validImages = [];

        for (final XFile pickedImage in pickedImages) {
          try {
            print('이미지 처리 시작: ${pickedImage.name}');
            final Uint8List imageBytes = await pickedImage.readAsBytes();
            print('이미지 바이트 크기: ${imageBytes.length}');
            validImages.add(imageBytes);
          } catch (e, stackTrace) {
            print('개별 이미지 처리 오류: $e');
            print('스택 트레이스: $stackTrace');
          }
        }

        if (mounted) {
          if (validImages.isEmpty) {
            print('유효한 이미지가 없음');
            CustomSnackBar.show(context, '이미지를 가져올 수 없습니다. 다른 이미지를 선택해주세요.');
          } else {
            print('유효한 이미지 수: ${validImages.length}');
            setState(() {
              _selectedImageFiles = validImages.length > 3 ? validImages.sublist(0, 3) : validImages;
              isButtonEnabled = _reflectionController.text.trim().isNotEmpty && _selectedImageFiles.isNotEmpty;
            });
            ScaffoldMessenger.of(context).clearSnackBars();

            if (validImages.length > 3) {
              CustomSnackBar.show(context, '최대 3장까지만 선택 가능합니다.\n처음 3장이 선택되었습니다.');
            }
          }
        }
      }
    } catch (e, stackTrace) {
      print('이미지 선택 중 오류 발생: $e');
      print('스택 트레이스: $stackTrace');
      
      if (mounted) {
        CustomSnackBar.show(context, '사진 선택 중 오류가 발생했습니다: $e');

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
        CustomSnackBar.show(context, '권한 요청 중 오류가 발생했습니다: $e');
      }
    }
  }

  // create FlutterSecureStorage instance
  final fsStorage = FlutterSecureStorage();

  // 유저 가입 or 루틴 추가 or 루틴 이어가기
  Future<void> registerUser() async {
    print('registerUser 시작');

    // 과거의 데이터 불러오는 부분
    final nickname = await fsStorage.read(key: 'randomName');
    final goalDateString = await fsStorage.read(key: 'goalDate') ?? "1";
    int goalDate = int.parse(goalDateString);
    final routineName = await fsStorage.read(key: 'routineName');
    final sogam = await fsStorage.read(key: 'sogam');
    
    String routineId = routineIdFinder(routineName!) ?? '';
    
    /*
    // routineId 가져오는 부분
    String routineId = "";
    final fetchUri = Uri.parse('https://haruitfront.vercel.app/api/routine');
    final fetchResponse = await http.get(fetchUri);

    if(fetchResponse.statusCode == 200) {
      print('fetchResponse.statusCode is 200');
      final List<dynamic> jsonData = jsonDecode(fetchResponse.body);

      print('jsonData 출력: $jsonData');

      for(var routine in jsonData) {
        print("routine['title']은 ${routine['title']}");
        if(routine['title'] == routineName) {
          print('routineName은 $routineName');
          print("routine['id']는 ${routine['id']}");
          routineId = routine['id'];
          print('그래서 routineId는 $routineId');
        }
      }
    } else {
      print('/api/routine이 정상작동하지 않음.');
      print('/api/routine에 대한 fetchResponse.statusCode: ${fetchResponse.statusCode}');
    }
    */
    
    /// 여기까진 굉장히 빨리 처리된다.
    /// 이 밑이 문제다.
    /// 이미지 압축?

    // 사진 업로드 하는 곳
    final imageUrls = await _uploadImages(_selectedImageFiles);

    // 여기까지 이미지 관련 코드

    // 에러났을 때 왜 에러났나 보게
    //print('fetchResponse.statusCode: ${fetchResponse.statusCode}');
    print('imgResponse.statusCode: ${imageUrls.length}');

    // 여기서 무조건 POST 해버리면, 항상 새 유저를 만드는 꼴 -> 프로필에서 과거 루틴을 못 불러오게 됨.
    // -> jwt_token이 없으면 지금처럼 (/api/auth/initial),
    // 있으면 /api/routine-log에 post
    // jwtToken이 있는 지 확인
    final jwtToken = await fsStorage.read(key: 'jwt_token');

    if (jwtToken == null) {
      print('jwtToken이 없어서 /api/auth/initial에 post 함.');

      final uri = Uri.parse('https://haruitfront.vercel.app/api/auth/initial');

      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "nickname": nickname,
          "goalDate": goalDate,
          "routine": {
            "id": routineId,
          },
          "reflection": sogam,
          "imgSrc": imageUrls.join(", "), // List<String>을 컴마로 구분된 문자열로 변환
        }),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        print('responseData: $responseData');

        // 회원가입 성공 메시지 출력
        print('회원가입 성공: ${responseData["message"]}');
        // JWT Token 출력
        print('JWT Token: ${responseData["JWT_TOKEN"]}');
        // JWT_TOKEN 저장하는 부분
        fsStorage.write(key: 'jwt_token', value: '${responseData["JWT_TOKEN"]}');
        final saved = fsStorage.read(key: 'jwt_token');
        print('jwt_token of user is saved as $saved');
      } else {
        print('회원가입 실패: ${response.statusCode}');
        print('response.body: ${response.body}');
      }
    } else {
      print('jwtToken이 있어서 /api/routine-log에 post 함.');

      final uri = Uri.parse('https://haruitfront.vercel.app/api/routine-log');

      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $jwtToken',
        },
        body: jsonEncode({
          "routineId" : routineId,
          "logImg" : imageUrls.join(", "), // List<String>을 컴마로 구분된 문자열로 변환
          "reflection" : sogam,
        }),
      );

      // 디버그 로그 추가
      print('routineId: $routineId');
      print('sogam: $sogam');
      print('imageUrls: $imageUrls');
      print('jwtToken: $jwtToken');
      print('요청 헤더: ${response.request?.headers}');

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        print('responseData: $responseData');
        print('로그 추가 성공');
      } else {
        print('로그 추가 실패: ${response.statusCode}');
        print('응답 본문: ${response.body}');
        print('요청 헤더: ${response.request?.headers}');
      }
    }

    // 연속 몇 일 했는지 저장하는 부분
    // streak이 없다면, 1 저장. 있다면 1 증가시켜 저장.
    final previeousStreak = await fsStorage.read(key: 'streak');
    if(previeousStreak == null) {
      await fsStorage.write(key: 'streak', value: '1');
    } else {
      await fsStorage.write(key: 'streak', value: (int.parse(previeousStreak) + 1).toString());
    }

    final updatedStreak = await fsStorage.read(key: 'streak');
    print('updatedStreak: $updatedStreak');

    print('registerUser 끝');
  }

  Future<void> storeSogam(String sogam) async {
    await fsStorage.write(key: 'sogam', value: _reflectionController.text.trim());
    final saved = await fsStorage.read(key: 'sogam');
    print('소감 저장됨: $saved');
  }

  Future<void> _loadGoalDate() async {
    final value = await fsStorage.read(key: 'goalDate') ?? "1";
    setState(() {
      goalDate = value;
    });

    print('goalDate 가져오기: $goalDate');

  }

  String? routineIdFinder(String routineName) {
    switch (routineName) {
      case '아침 물 한잔 마시기':
        return '6822a2cfe908569ba237f27d';
      case '기상 또는 취침 시간 지키기':
        return '6822a2d0e908569ba237f285';
      case '내 공간 1개 정돈하기':
        return '6822a2d1e908569ba237f28f';
      case '바람 따라 걷기 20분':
        return '1effefd7-e1d4-4304-bd46-df9b0f5446f1';
      case '오늘의 기분 한 줄 남기기':
        return '6822a2d2e908569ba237f299';
      case '고요한 숨, 3분 호흡하기':
        return '6822a2d2e908569ba237f29e';
      case '나를 위한 선물 사보기':
        return '6822a2d4e908569ba237f2b7';
      case '나에게 보내는 칭찬 한마디':
        return '6822a2d4e908569ba237f2b0';
      case '일일 간단한 대화하기':
        return '6822a2d5e908569ba237f2bf';
      case '3분 경청하기':
        return '6822a2d5e908569ba237f2c2';
      case '작은 응원 한마디':
        return '6822a2d6e908569ba237f2c5';
      case '고마운 사람에게 마음 전하기':
        return '6822a2d6e908569ba237f2ca';
      case '내 관심 분야의 글 읽기':
        return '6822a2d9e908569ba237f2e5';
      case '오늘의 흥미 저장하기':
        return '6822a2d9e908569ba237f2ea';
      case '새로운 취미 한 걸음':
        return '6822a2dae908569ba237f2f1';
      case '내가 꿈꾸는 나':
        return '6822a2dae908569ba237f2f8';
      case '스스로 음식 주문해보기':
        return '6822a2dbe908569ba237f2fe';
      case '오늘의 랜덤 이동 기록하기':
        return '6822a2dbe908569ba237f303';
      case '오늘의 하늘 기록하기':
        return '6822a2dce908569ba237f308';
      case '목적 없는 가벼운 산책':
        return '6822a2dce908569ba237f30d';
    }
    return null;
  }
  
  
  // 이미지 업로드 메서드
  Future<List<String>> _uploadImages(List<Uint8List> images) async {
    try {
      print('이미지 업로드 시작: ${images.length}개');
      final uriForImageUpload = Uri.parse('https://haruitfront.vercel.app/api/img-upload');
      final request = http.MultipartRequest('POST', uriForImageUpload);

      for (int i = 0; i < images.length; i++) {
        final imageBytes = images[i];
        final fileName = 'image_${DateTime.now().millisecondsSinceEpoch}_$i.jpg';
        
        print('이미지 ${i + 1} 업로드 준비: $fileName (${imageBytes.length} bytes)');
        
        request.files.add(
          http.MultipartFile.fromBytes(
            'img',
            imageBytes,
            filename: fileName,
            contentType: MediaType('image', 'jpeg'),
          ),
        );
      }

      List<String> imageUrl = ["https://i.imgur.com/Ot5DWAW.png"]; // 기본값으로 더미 이미지 설정
      final streamedResponse = await request.send();
      final imgResponse = await http.Response.fromStream(streamedResponse);

      print('이미지 업로드 응답 상태 코드: ${imgResponse.statusCode}');
      print('이미지 업로드 응답 본문: ${imgResponse.body}');

      if (imgResponse.statusCode == 200) {
        final result = jsonDecode(imgResponse.body);
        if (result['data'] != null && result['data'].isNotEmpty) {
          if(result['data'].first is List) {
            imageUrl = (result['data'] as List).map((innerList) => innerList[0] as String).toList();
          } else if (result['data'].first is String) {
            imageUrl = (result['data'] as List).cast<String>();
          }
          print('업로드된 이미지 URL: $imageUrl');
        }
      } else {
        print('이미지 업로드 실패: ${imgResponse.statusCode}');
        print('응답 본문: ${imgResponse.body}');
      }

      return imageUrl;
    } catch (e, stackTrace) {
      print('이미지 업로드 중 오류 발생: $e');
      print('스택 트레이스: $stackTrace');
      return ["https://i.imgur.com/Ot5DWAW.png"]; // 오류 발생 시 기본 이미지 반환
    }
  }

  // 이미지 표시 위젯
  Widget _buildImagePreview(Uint8List imageBytes) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.memory(
        imageBytes,
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
    );
  }

  @override
  Widget build(BuildContext context) {

    print('widget.howToRoutine: ${widget.howToRoutine}');

    return Scaffold(
      backgroundColor: CustomColors.defaultBackgroundColor,
      body: GestureDetector(
        onTap: () {
          // unfocus when user taps outside of '소감' TextFormField
          FocusScope.of(context).unfocus();
        },
        child: Stack(
          children: [
            // background petal falling design
            ...List.generate(45, (index) => FallingPetal(
              indexForPositionX: index % 5,
              fallDelay: Duration(milliseconds: 500 * index),
            )),
            // main content
            SingleChildScrollView(
              child: SafeArea(
                child: Stack(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 32),
                      child: Column(
                        children: [
                          SizedBox(height: 40),
                          titleAndCharacter(),
                          SizedBox(height: 20),
                          routineExplanation(),
                          SizedBox(height: 20),
                          uploadingPics(),
                          SizedBox(height: 20),
                          commentTextFormField(),
                          SizedBox(height: 20),
                          submitButton(),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        // Move to previous screen
                        // Case 1. badge_screen_main.dart
                        // Case 2. onboarding_screen_four.dart
                        Navigator.of(context).pop();
                      },
                      child: Routing.backButton(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Row titleAndCharacter() {
    return Row(
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
    );
  }

  InnerShadow routineExplanation() {
    return InnerShadow(
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
              routineName,
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
              // 4번째 -> routine explanation
              widget.genesisRoutine[4],
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
              widget.howToRoutine,
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
    );
  }

  GestureDetector uploadingPics() {
    return GestureDetector(
      onTap: _pickImages,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Color(0xFFFAFAFA),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              spreadRadius: 0,
              offset: Offset(0, 3),
            ),
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              spreadRadius: 0,
              offset: Offset(0, -3),
            ),
          ],
        ),
        child: Column(
          children: [
            Text(
              '오늘 실천한 순간을\n사진으로 남겨볼까요? (최대 3장)',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Color(0xFF828282),
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 12),
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
                  _selectedImageFiles.isEmpty ? '사진 업로드' : '사진 바꾸기',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF8C7154),
                    height: 1.5,
                  ),
                ),
              ),
            ),
            if (_selectedImageFiles.isNotEmpty) ...[
              SizedBox(height: 16),
              SizedBox(
                height: 100,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _selectedImageFiles.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Stack(
                        children: [
                          _buildImagePreview(_selectedImageFiles[index]),
                          Positioned(
                            top: 4,
                            right: 4,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _selectedImageFiles.removeAt(index);
                                  isButtonEnabled = _reflectionController.text.trim().isNotEmpty && _selectedImageFiles.isNotEmpty;
                                });
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.5),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.close,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                            ),
                          ),
                        ],
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
    );
  }

  Container commentTextFormField() {
    return Container(
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
            blurRadius: 8, // 퍼짐 정도
            spreadRadius: 0, // 그림자 크기 확장 없음
            offset: Offset(0, 3), // 아래쪽으로 살짝 이동
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.1), // 아주 연한 그림자
            blurRadius: 8, // 퍼짐 정도
            spreadRadius: 0, // 그림자 크기 확장 없음
            offset: Offset(0, -3), // 아래쪽으로 살짝 이동
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
    );
  }

  GestureDetector submitButton() {
    return GestureDetector(
      onTap: () async {
        if ((kIsWeb) ? true : isButtonEnabled) {
          final parentContext = context;
          showModalBottomSheet(
            context: parentContext,
            isDismissible: false,
            enableDrag: false,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (sheetContext) {
              return Container(
                width: double.infinity,
                height: MediaQuery.of(parentContext).size.height * 0.5,
                padding: EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Color(0xFFFFF2CD),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                ),
                child: Column(
                  children: [
                    Text(
                      '축하해요,\n루틴을 완료해서\n뱃지를 받았어요!',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF7A634B),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 32),
                    Image.asset('assets/images/badge_example.png', height: 100),
                    SizedBox(height: 32),
                    GestureDetector(
                      onTap: () async {
                        // TextFormField 내용 저장
                        await storeSogam(_reflectionController.text.trim());

                        // 유저 등록.
                        // 근데, 등록이 되어있으면 루틴로그만 등록.
                        await registerUser();

                        if (goalDate == "1") {
                          Navigator.of(parentContext).pushReplacement(
                            Routing.customPageRouteBuilder(RoutineScreenTwo(
                              genesisRoutine: widget.genesisRoutine,
                              howToRoutine: widget.howToRoutine,
                            ), 300),
                          );
                        } else {
                          Navigator.of(parentContext).pushReplacement(
                            Routing.customPageRouteBuilder(AfterOnboardingMain(), 300),
                          );
                        }
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
                          goalDate == "1" ? '회고 적기' : '라운지로 가기',
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
        }
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
    );
  }
}