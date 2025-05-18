import 'package:flutter/material.dart';
import 'package:flutter_inner_shadow/flutter_inner_shadow.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'dart:math' as math;
import 'dart:async';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart'; // 키보드 관련 패키지
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:http_parser/http_parser.dart'; // for image upload

import '../falling_petal.dart';
import '../onboarding/onboarding_main.dart';
import '../widgets.dart';
import 'routine_screen_two.dart';
import '../after_onboarding_main.dart';

// 여긴 루틴의 1일차만 기준으로 코딩! -> 그러면 안 됨...시발 어떡하냐 나???
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
  final TextEditingController _reflectionController = TextEditingController();
  bool isButtonEnabled = false;
  final ImagePicker _picker = ImagePicker();
  List<File> _selectedImageFiles = []; // XFile 대신 File 객체 사용
  String routineName = '';
  String goalDate = "1";

  final ScrollController _scrollController = ScrollController();
  final GlobalKey _textFieldKey = GlobalKey();
  late final KeyboardVisibilityController _keyboardVisibilityController;
  late final StreamSubscription<bool> _keyboardSubscription;

  @override
  void initState() {
    super.initState();
    routineName = '${widget.genesisRoutine[2]} ${widget.genesisRoutine[3]}';
    _reflectionController.addListener(() {
      setState(() {
        // 사진이 선택되었고 텍스트가 입력되었을 때만 버튼 활성화
        isButtonEnabled = _reflectionController.text.trim().isNotEmpty && _selectedImageFiles.isNotEmpty;
      });
    });
    _keyboardVisibilityController = KeyboardVisibilityController();
    _keyboardSubscription = _keyboardVisibilityController.onChange.listen((visible) {
      if (visible) {
        // 키보드가 올라오면 TextFormField 위치로 스크롤
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _scrollToTextField();
        });
      }
    });
    _loadGoalDate();
  }

  @override
  void dispose() {
    //_autoMoveTimer?.cancel(); // 타이머 정리
    _reflectionController.dispose();
    _keyboardSubscription.cancel();
    _scrollController.dispose();
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
      CustomSnackBar.show(context, '이미지를 처리하는 중입니다...');

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
          CustomSnackBar.show(context, '이미지를 가져올 수 없습니다. 다른 이미지를 선택해주세요.');
        } else {
          setState(() {
            // 3장 초과 선택 시 처음 3장만 사용
            _selectedImageFiles = validFiles.length > 3 ? validFiles.sublist(0, 3) : validFiles;
            isButtonEnabled = _reflectionController.text.trim().isNotEmpty && _selectedImageFiles.isNotEmpty;
          });
          ScaffoldMessenger.of(context).clearSnackBars();

          // 3장 초과 선택된 경우 알림
          if (validFiles.length > 3) {
            CustomSnackBar.show(context, '최대 3장까지만 선택 가능합니다.\n처음 3장이 선택되었습니다.');
          }
        }
      }
    } catch (e) {
      if (mounted) {
        CustomSnackBar.show(context, '사진 선택 중 오류가 발생했습니다: $e');
        
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
        CustomSnackBar.show(context, '권한 요청 중 오류가 발생했습니다: $e');
      }
    }
  }

  // 왜 이게 잘 작동이 안되나...?
  void _scrollToTextField() {
    final RenderBox? renderBox = _textFieldKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox != null) {
      final position = renderBox.localToGlobal(Offset.zero);
      final textFieldBottom = position.dy + renderBox.size.height;
      final screenHeight = MediaQuery.of(context).size.height;
      final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

      // 키보드가 올라온 상태에서 TextFormField의 하단이 키보드 위 20px에 오도록 스크롤
      final overlap = textFieldBottom - (screenHeight - keyboardHeight) + 20;
      if (overlap > 0) {
        _scrollController.animateTo(
          _scrollController.offset + overlap,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    }
  }

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
    }

    // 사진 업로드 하는 곳
    final uriForImageUpload = Uri.parse('https://haruitfront.vercel.app/api/img-upload');
    final request = http.MultipartRequest('POST', uriForImageUpload);

    for (int i = 0; i < _selectedImageFiles.length; i++) {
      final file = await http.MultipartFile.fromPath(
        'img',
        _selectedImageFiles[i].path,
        contentType: MediaType('image', 'png'),
      );
      request.files.add(file);
    }

    List<String> imageUrl = ["https://i.imgur.com/Ot5DWAW.png"]; // 기본값으로 더미 이미지 설정
    final streamedResponse = await request.send();
    final imgResponse = await http.Response.fromStream(streamedResponse);

    if (imgResponse.statusCode == 200) {
      final result = jsonDecode(imgResponse.body);
      print("result: ${result['data']}");
      if (result['data'] != null && result['data'].isNotEmpty) {
        if(result['data'].first is List) {
          // List<List<String>>을 List<String>으로 변환
          imageUrl = (result['data'] as List).map((innerList) => innerList[0] as String).toList();
        } else if (result['data'].first is String) {
          imageUrl = (result['data'] as List).cast<String>();
        }

        print("업로드된 이미지 URL: $imageUrl");
        print('업로드용 이미지 url string 버전: ${imageUrl.join(", ")}');
      }
    } else {
      print('이미지 업로드 실패: ${imgResponse.statusCode}');
      print('response.body: ${imgResponse.body}');
    }

    // 여기까지 이미지 관련 코드

    // 에러났을 때 왜 에러났나 보게
    print('fetchResponse.statusCode: ${fetchResponse.statusCode}');
    print('imgResponse.statusCode: ${imgResponse.statusCode}');

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
          "imgSrc": imageUrl.join(", "), // List<String>을 컴마로 구분된 문자열로 변환
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
          "logImg" :imageUrl.join(", "), // List<String>을 컴마로 구분된 문자열로 변환
          "reflection" : sogam,
        }),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        print('responseData: $responseData');
        print('로그 추가 성공');
      } else {
        print('로그 추가 실패: ${response.statusCode}');
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFF7DC),
      body: GestureDetector(
        onTap: () {
          // TextFormField 바깥쪽 누르면, unfocus.
          FocusScope.of(context).unfocus();
        },
        child: Stack(
          children: [
            // 꽃 떨어지는 부분
            ...List.generate(45, (index) => FallingPetal(
              indexForPositionX: index % 5,
              fallDelay: Duration(milliseconds: 500 * index),
            )),
            SingleChildScrollView(
              controller: _scrollController,
              child: SafeArea(
                child: Stack(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 32),
                      child: Column(
                        children: [
                          SizedBox(height: 40),
                          titleAndCharacter(), // 제목과 캐릭터
                          SizedBox(height: 20),
                          routineExplanation(), // 루틴 제목 + 루틴 설명 + 인증 방법
                          SizedBox(height: 20),
                          uploadingPics(), // 사진 업로드 칸
                          SizedBox(height: 20),
                          commentTextFormField(), // 소감 TextFormField
                          SizedBox(height: 20),
                          submitButton(), // 다했어요 버튼
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        // 이전 화면으로 돌아가는 기능
                        Navigator.of(context).pop(
                          Routing.customPageRouteBuilder(OnboardingMain(
                            pageIndex: 3,
                          ), 1000),
                        );
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
                          ClipRRect(
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
        key: _textFieldKey,
      ),
    );
  }

  GestureDetector submitButton() {
    return GestureDetector(
      onTap: () async {
        if (isButtonEnabled) {
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