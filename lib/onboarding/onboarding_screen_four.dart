import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inner_shadow/flutter_inner_shadow.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../routine/routine_screen_one.dart';

class OnboardingScreenFour extends StatefulWidget {
  const OnboardingScreenFour({super.key, required this.dayCount, required this.selectedCategory});

  final int dayCount;
  final String selectedCategory;

  @override
  State<OnboardingScreenFour> createState() => _OnboardingScreenFourState();
}

class _OnboardingScreenFourState extends State<OnboardingScreenFour> {
  bool _showInitialText = true;
  Timer? _textChangeTimer;
  List<List<String>> filteredRoutines = []; 
  final fsStorage = FlutterSecureStorage();
  String? nickname;

  // 루틴 데이터 구조 변경: ['루틴 태그', '태그 내 번호', '루틴 제목1', '루틴 제목2', '수행방법', '이미지']
  final List<List<String>> allRoutines = [
    // 생활습관
    ['생활습관', '1', '아침 물 한잔', '마시기', '매일 일어나자마자 물 한잔을 마시며 상쾌한 아침을 시작해요.', 'assets/images/suggested_routine/life_habit/one.png'],
    //['생활습관', '2', '5분', '스트레칭 하기', '아침 기상 후 자리에서 할 수 있는 간단한 목, 어깨 스트레칭을 5분 간 해봐요.', 'assets/images/suggested_routine/life_habit/two.png'],
    ['생활습관', '3', '기상 또는', '취침 시간 지키기', '비슷한 시간에 일어나고 잠들어봐요. 하루의 흐름을 건강하게 만드는 작은 약속이에요. (±30분 이내)', 'assets/images/suggested_routine/life_habit/three.png'],
    //['생활습관', '4', '나를 위한', '건강식 한 끼', '나를 위해 정성껏 준비한 건강한 한 끼를 먹고 기록해요.', 'assets/images/suggested_routine/life_habit/four.png'],
    ['생활습관', '5', '내 공간', '1개 정돈하기', '하루에 하나, 침대나 책상 등 내 공간 중 한 곳을 정리해봐요. 공간이 정리되면 마음도 정리돼요.', 'assets/images/suggested_routine/life_habit/five.png'],
    ['생활습관', '6', '바람 따라', '걷기 20분', '바쁜 하루 중 잠시 멈추고, 주변을 둘러보며 산책해요. 몸도 마음도 한결 가벼워져요.', 'assets/images/suggested_routine/life_habit/six.png'],
    
    // 감정돌봄
    ['감정돌봄', '1', '오늘의 기분', '한 줄 남기기', '하루를 마무리하며, 내 감정이나 기분을 한 문장으로 기록해요. 조금 어설퍼도 괜찮아요.', 'assets/images/suggested_routine/emotion_control/one.png'],
    ['감정돌봄', '2', '고요한 숨,', '3분 호흡하기', '잠시 눈을 감고, 조용히 숨을 들이쉬고 내쉬어봐요. 3분 간 생각을 내려놓아요.', 'assets/images/suggested_routine/emotion_control/two.png'],
    //['감정돌봄', '3', '1년 뒤의 나에게', '보내는 편지', '1년 뒤의 나에게 전하고 싶은 말을 솔직하고 자유롭게 적어봐요.', 'assets/images/suggested_routine/emotion_control/three.png'],
    //['감정돌봄', '4', '마음에 새기는', '한 문장', '오늘의 기분과 닮은 명언이나 글귀를 찾아 읽고, 내 마음속에 새겨봐요.', 'assets/images/suggested_routine/emotion_control/four.png'],
    ['감정돌봄', '5', '나에게 보내는', '칭찬 한마디', '오늘의 나를 스스로 칭찬해요. 타인과 비교하지 않고, 나 자신을 온전히 바라봐요.', 'assets/images/suggested_routine/emotion_control/five.png'],
    ['감정돌봄', '6', '나를 위한', '선물 사보기', '나를 위한 선물을 고민하고 골라봐요. 오로지 나를 위한 소비를 하며, 스스로를 돌보는 시간을 가질 수 있을 거예요.', 'assets/images/suggested_routine/emotion_control/six.png'],
    
    // 대인관계
    ['대인관계', '1', '일일 간단한', '대화하기', '소중한 사람과 하루 한 번, 짧지만 진심이 담긴 10분 대화를 나눠요.', 'assets/images/suggested_routine/human_relationship/one.png'],
    ['대인관계', '2', '3분', '경청하기', '가족이나 친구와 눈을 맞추며 3분 동안 상대의 목소리에 귀기울여봐요.', 'assets/images/suggested_routine/human_relationship/two.png'],
    ['대인관계', '3', '작은 응원', '한마디', '라운지에서 다른 하루잇러들의 게시글에 댓글을 달아보고, 따뜻한 응원을 전해봐요.', 'assets/images/suggested_routine/human_relationship/three.png'],
    ['대인관계', '4', '고마운 사람에게', '마음 전하기', '오늘 고마운 사람에게 진심을 담은 한마디를 전해봐요. 사소한 말도 힘이 될 거예요.', 'assets/images/suggested_routine/human_relationship/four.png'],
    //['대인관계', '5', '닮고 싶은', '배울 점 찾기', '내 주변의 소중한 사람을 떠올리며, 닮고 싶은 점이나 존경하는 점을 한 줄로 적어봐요.', 'assets/images/suggested_routine/human_relationship/five.png'],
    //['대인관계', '6', '한 장의', '손편지 쓰기', '마음을 전하고 싶은 사람에게 손편지를 써서 전해봐요. 나의 진심이 잘 전해질 거예요.', 'assets/images/suggested_routine/human_relationship/six.png'],
    
    // 자기계발
    //['자기계발', '1', '마음에 닿는', '한 줄 소개하기', '책이나 인터넷에서 마음에 드는 문장을 따라 써봐요. 글이 주는 힘을 믿어봐요.', 'assets/images/suggested_routine/personal_development/one.png'],
    //['자기계발', '2', '멘토와의', '작은 만남', '멘토 한 분을 정해서 인터뷰해요. 닮고 싶은 사람의 얘기를 듣다 보면, 나도 성장해있을 거예요.', 'assets/images/suggested_routine/personal_development/two.png'],
    ['자기계발', '3', '내 관심 분야의', '글 읽기', '궁금한 분야의 기사나 책, 글을 읽고 인상 깊었던 부분이나 느낀 점을 차곡차곡 기록해요.', 'assets/images/suggested_routine/personal_development/three.png'],
    ['자기계발', '4', '오늘의 흥미', '저장하기', '요즘 끌리는 단어나 사물, 영상을 생각해보고, 어떤 부분이 흥미로웠는지 적어봐요.', 'assets/images/suggested_routine/personal_development/four.png'],
    ['자기계발', '5', '새로운 취미', '한 걸음', '그림, 요리, 언어 배우기 등 평소 해보고 싶었던 새로운 것들에 도전하며 새로운 즐거움을 느껴봐요.', 'assets/images/suggested_routine/personal_development/five.png'],
    ['자기계발', '6', '내가', '꿈꾸는 나', '10년 뒤의 나를 상상해보고, 되고 싶은 나를 마음껏 표현해요.', 'assets/images/suggested_routine/personal_development/six.png'],
    
    // 작은도전
    ['작은도전', '1', '스스로 음식', '주문해보기', '카페, 음식점 등에서 키오스크 없이 스스로 직접 주문을 해보며, 내 안의 작은 용기를 꺼내봐요.', 'assets/images/suggested_routine/small_trial/one.png'],
    ['작은도전', '2', '오늘의 랜덤 이동', '기록하기', '목적지를 정하지 않고 흘러가듯 이동해봐요. 새로운 풍경과 만남이 나를 기다리고 있을 거예요.', 'assets/images/suggested_routine/small_trial/two.png'],
    ['작은도전', '3', '오늘의 하늘', '기록하기', '고개를 들어 하늘을 바라보고, 햇살을 천천히 느껴봐요. 일상에 휴식을 선사해요.', 'assets/images/suggested_routine/small_trial/three.png'],
    ['작은도전', '4', '목적 없는', '가벼운 산책', '발길 닿는 대로 10분, 20분 걸어봐요. 걷고 나면 마음이 가벼워지는 걸 느낄지도 몰라요.', 'assets/images/suggested_routine/small_trial/four.png'],
  ];

  // 태그별 색상 맵
  Map<String, Map<String, Color>> tagColors = {
    '생활습관': {
      'background': Color(0xFFDDECFE),
      'text': Color(0xFF7896FF),
    },
    '감정돌봄': {
      'background': Color(0xFFFFE8F3),
      'text': Color(0xFFEA4793),
    },
    '대인관계': {
      'background': Color(0xFFFFF5E9),
      'text': Color(0xFFFF9E28),
    },
    '자기계발': {
      'background': Color(0xFFF7FFEE),
      'text': Color(0xFF68BA5A),
    },
    '작은도전': {
      'background': Color(0xFFFDF6FE),
      'text': Color(0xFFC262D3),
    },
  };

  @override
  void initState() {
    super.initState();
    _loadNickname();
    _textChangeTimer = Timer(const Duration(seconds: 3), () {
      setState(() {
        _showInitialText = false;
      });
    });
    
    // 선택된 태그에 따라 필터링
    // _filterRoutinesByTag();
    // 선택된 카테고리에 따라 필터링
    _filterRoutinesByCategory();
  }

  Future<void> _loadNickname() async {
    final storedNickname = await fsStorage.read(key: 'randomName');
    setState(() {
      nickname = storedNickname;
    });
  }

  void _filterRoutinesByCategory() {
    for(var routine in allRoutines) {
      if(routine[0] == widget.selectedCategory) {
        filteredRoutines.add(routine);
      }
    }
  }

  @override
  void dispose() {
    _textChangeTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: (kIsWeb) ? 10 : 60),
        // 방석 아이콘 (width < height 이므로, height만 설정)
        Image.asset('assets/images/character_with_cushion.png', height: 175),
        SizedBox(height: 12),
        // 메인 텍스트
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
            margin: EdgeInsets.symmetric(
              horizontal: 32,
            ),
            padding: EdgeInsets.symmetric(
              vertical: 20,
              horizontal: 20,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.transparent,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 5,
                  spreadRadius: 1,
                  offset: Offset(0, 2),
                ),
                BoxShadow(
                  color: Colors.white.withOpacity(0.9),
                  blurRadius: 0,
                  spreadRadius: -1,
                  offset: Offset(0, 0),
                ),
              ],
            ),
            child: _showInitialText
                ? Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: '${widget.dayCount}일',
                          style: TextStyle(
                            color: Color(0xFF8C7154),
                          ),
                        ),
                        TextSpan(
                          text: ' 뒤, 건강한 사람이 되고 싶은\n',
                        ),
                        TextSpan(
                          text: '${nickname ?? "활발한 거북이"}님',
                          style: TextStyle(
                            color: Color(0xFF8C7154),
                          ),
                        ),
                        TextSpan(
                          text: '에게 도움이 될\n',
                        ),
                        TextSpan(
                          text: widget.selectedCategory,
                          style: TextStyle(
                            color: Color(0xFF8C7154),
                          ),
                        ),
                        TextSpan(
                          text: ' 루틴을 추천할게요.',
                        ),
                      ],
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF121212),
                        height: 1.5, // 줄 간격 조금 띄우기
                      ),
                    ),
                    textAlign: TextAlign.center,
                  )
                : Column(
                    children: [
                      Text(
                        '가장 해보고 싶은 루틴을\n1개 선택해볼까요?',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF121212),
                          height: 1.5, // 줄 간격 조금 띄우기
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 8),
                      Text(
                        '루틴을 누르면 자세한 설명을 볼 수 있어요.',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF828282),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
          ),
        ),
        SizedBox(height: 20),
        // 추천 루틴
        Container(
          height: 360,
          decoration: BoxDecoration(
            color: Color(0xFFFFF7DC),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1), // 아주 연한 그림자
                blurRadius: 20, // 퍼짐 정도
                spreadRadius: 0, // 그림자 크기 확장 없음
                offset: Offset(0, -8), // 아래쪽으로 살짝 이동
              ),
            ],
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 24),
                // 추천 루틴
                Container(
                  margin: EdgeInsets.symmetric(
                    horizontal: 120,
                  ),
                  padding: EdgeInsets.symmetric(
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Color(0xFF8C7154),
                    borderRadius: BorderRadius.circular(1000),
                  ),
                  child: Center(
                    child: Text(
                      '추천 루틴',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFFFAFAFA),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                // 추천 루틴 목록
                Container(
                  margin: EdgeInsets.symmetric(
                    horizontal: 32,
                  ),
                  child: ListView.separated(
                    shrinkWrap: true,
                    physics: BouncingScrollPhysics(),
                    itemCount: filteredRoutines.length,
                    itemBuilder: (BuildContext context, int index) {
                      return _buildGridItem(index);
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return SizedBox(height: 10);
                    },
                  ),
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGridItem(int index) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          barrierDismissible: true, // 바깥 터치시 닫힘
          builder: (BuildContext context) {
            return routineDialog(index);
          },
        );
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 20,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // 루틴 아이콘
            Image.asset(
              // 5번: 이미지 경로
              filteredRoutines[index][5],
              width: 20,
            ),
            Spacer(),
            // 루틴 제목 (한 줄로 표시)
            Text(
              "${filteredRoutines[index][2]} ${filteredRoutines[index][3]}",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
            ),
            Spacer(),
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 15,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> storeRoutineName(String routineName) async {
    await fsStorage.write(key: 'routineName', value: routineName);
    final saved = await fsStorage.read(key: 'routineName');
    print('루틴 이름 저장됨: $saved');
  }

  Future<String> fetchHowToRoutine(int index) async {
    print('fetchHowToRoutine 시작');
    final routineName = '${filteredRoutines[index][2]} ${filteredRoutines[index][3]}';

    String howToRoutine = '';
    switch (routineName) {
      case '아침 물 한잔 마시기':
        howToRoutine = '아침에 물을 마신 컵 또는 잔의 사진을 찍고, 실천해본 한 줄 소감을 적어요.';
      case '기상 또는 취침 시간 지키기':
        howToRoutine = '기상 시간과 취침 시간이 보이도록 사진을 찍고, 실천한 소감을 간단히 남겨요.';
      case '내 공간 1개 정돈하기':
        howToRoutine = '정리한 공간, 물건의 전후 비교 사진 또는 정리 후 결과 사진을 찍고, 소감을 적어요.';
      case '바람 따라 걷기 20분':
        howToRoutine = '산책 중 찍은 거리, 나무, 하늘 등의 사진과 만보기 사진을 함께 남기고, 산책에 대한 소감을 남겨요.';
      case '오늘의 기분 한 줄 남기기':
        howToRoutine = '내 감정을 떠올리게 하는 사진을 찍거나, 감정을 표현한 이미지를 올려요. 한 문장으로 오늘의 기분을 기록해요.';
      case '고요한 숨, 3분 호흡하기':
        howToRoutine = '창가, 방 한 켠 등 실천한 장소의 사진을 찍고, 짧은 소감을 남겨요.';
      case '나를 위한 선물 사보기':
        howToRoutine = '가격과 상관없이 나를 위한 선물을 구매 후 사진을 찍고, 선물을 고른 이유나 소감을 적어요.';
      case '나에게 보내는 칭찬 한마디':
        howToRoutine = '칭찬하고 싶은 장면이나 순간을 사진으로 찍고, 나를 위한 칭찬과 짧은 소감을 적어요.';
      case '일일 간단한 대화하기':
        howToRoutine = '대화 중인 공간(예: 식탁, 산책길 등) 사진 또는 함께한 사람과의 사진을 찍어요. 오늘 대화에서 인상 깊었던 한 마디나 느낀 점을 한 줄로 기록해요.';
      case '3분 경청하기':
        howToRoutine = '대화한 공간의 사진을 찍고, 경청하며 느낀 점을 한 줄로 남겨요.';
      case '작은 응원 한마디':
        howToRoutine = '매일 1회 라운지 댓글을 남기고, 작성 화면을 캡처해요. 간단한 소감을 함께 남겨요.';
      case '고마운 사람에게 마음 전하기':
        howToRoutine = '고마운 마음을 표현한 메모지, 메시지, 또는 답변 내용을 캡쳐해요. 고마운 마음을 전한 이유와 소감을 한 줄로 기록해요.';
      case '내 관심 분야의 글 읽기':
        howToRoutine = '책에서 마음에 드는 문장이나 기사 글 화면을 캡쳐하고, 소감을 글로 정리해요.';
      case '오늘의 흥미 저장하기':
        howToRoutine = '저장한 영상이나 사물의 사진을 캡쳐하고, 이유와 소감을 작성해요.';
      case '새로운 취미 한 걸음':
        howToRoutine = '새로운 활동에 도전하는 모습을 담은 사진을 업로드하고, 도전을 통해 변화한 나의 소감을 적어요.';
      case '내가 꿈꾸는 나':
        howToRoutine = '해보고 싶은 일을 그림 일기로 그려보고, 이유와 소감을 함께 기록해요.';
      case '스스로 음식 주문해보기':
        howToRoutine = '실제로 직접 주문해 받은 영수증을 음식과 함께 찍고, 도전 후 느낀 소감과 변화를 적어봐요.';
      case '오늘의 랜덤 이동 기록하기':
        howToRoutine = '대중 교통 (버스, 지하철) 안에서 바라본 풍경을 사진으로 찍고, 인상 깊었던 역, 정류장 풍경, 이동 중 느낀점 등 소감을 적어요.';
      case '오늘의 하늘 기록하기':
        howToRoutine = '하늘을 찍은 사진을 업로드하고, 떠오른 생각이나 느낌을 기록해요.';
      case '목적 없는 가벼운 산책':
        howToRoutine = '산책 중 찍은 사진을 한 장 업로드하고, 걷는 동안 들었던 생각을 소감으로 적어요.';
    }

    print('fetchHowToRoutine 끝');
    return howToRoutine;
  }

  Widget routineDialog(int index) {
    // 태그에 따른 색상 선택
    String tag = filteredRoutines[index][0];
    Color backgroundColor = tagColors[tag]!['background']!;
    Color textColor = tagColors[tag]!['text']!;

    return Dialog(
      backgroundColor: Colors.transparent, // 배경 투명
      insetPadding: EdgeInsets.symmetric(horizontal: 32), // Dialog의 외부 패딩 설정
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // 메인 텍스트 + 취소 버튼
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            // 2번: 루틴 제목1
                            filteredRoutines[index][2],
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.w700,
                              color: textColor,
                            ),
                            textAlign: TextAlign.left,
                            softWrap: true,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            // 3번: 루틴 제목2
                            filteredRoutines[index][3],
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.w700,
                              color: textColor,
                            ),
                            textAlign: TextAlign.left,
                            softWrap: true,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 10),
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Icon(
                          Icons.close,
                          size: 20,
                          color: textColor,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 25),
                // 서브 텍스트
                Text(
                  // 4번: 수행방법
                  filteredRoutines[index][4],
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: textColor,
                    height: 1.5,
                  ),
                  maxLines: 3,
                  textAlign: TextAlign.start,
                ),
                const SizedBox(height: 25),
                // 도전 버튼
                GestureDetector(
                  // RoutineScreen으로 이동하기
                  onTap: () async {
                    String howToRoutine = '인증 방법을 불러오는 중...';
                    
                    try {
                      howToRoutine = await fetchHowToRoutine(index);
                    } catch (e) {
                      howToRoutine = '인증 방법을 불러오는데 오류가 발생했습니다.';
                      print('explanationFinder error: $e');
                    }

                    storeRoutineName('${filteredRoutines[index][2]} ${filteredRoutines[index][3]}');

                    if (!mounted) return;

                    // 이 두 값은, badge_screen_main에서 루틴 이어가기 눌렀을 때, routine_screen_one에 올 때 사용된다!
                    await fsStorage.write(key: 'genesisRoutine', value: jsonEncode(filteredRoutines[index]));
                    await fsStorage.write(key: 'howToRoutine', value: howToRoutine);

                    print('howToRoutine: $howToRoutine');

                    Navigator.of(context).pushReplacement(
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) => RoutineScreenOne(
                          genesisRoutine: filteredRoutines[index],
                          howToRoutine: howToRoutine,
                        ),
                        transitionsBuilder: (context, animation, secondaryAnimation, child) {
                          return FadeTransition(
                            opacity: animation,
                            child: child,
                          );
                        },
                        transitionDuration: const Duration(milliseconds: 500),
                      ),
                    );
                  },
                  child: InnerShadow(
                    shadows: [
                      Shadow(
                        color: Colors.black.withOpacity(0.25),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: Color(0xFFFAFAFA),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '도전 해볼래요!',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF121212),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
          Positioned(
            right: 0,
            bottom: 0,
            child: Image.asset(
              filteredRoutines[index][5],
              width: 130,
              height: 130,
            ),
          ),
        ],
      ),
    );
  }
}