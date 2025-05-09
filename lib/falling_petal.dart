import 'dart:math';

import 'package:flutter/material.dart';

class FallingPetal extends StatefulWidget {
  const FallingPetal({super.key, required this.indexForPositionX, required this.fallDelay});

  final int indexForPositionX;
  final Duration fallDelay;

  @override
  State<FallingPetal> createState() => _FallingPetalState();
}

class _FallingPetalState extends State<FallingPetal> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late double _positionX; // 고정된 x값
  Animation<double>? _positionY; // 변해야할 y값
  late Animation<double> _horizontalWiggle;
  late Animation<double> _rotation;
  double _rotationOffset = 0.0;
  bool _rotateClockwise = true;
  // Future.delayed 참조 저장을 위한 변수
  Future<void>? _delayedForward;

  double positionXCalculator(double screenWidth, int indexForPositionX) {
    if(widget.indexForPositionX == 0) {
      return screenWidth * (-0.05);
    }
    if(widget.indexForPositionX == 1) {
      return screenWidth * 0.20;
    }
    if(widget.indexForPositionX == 2) {
      return screenWidth * 0.45;
    }
    if(widget.indexForPositionX == 3) {
      return screenWidth * 0.70;
    }
    return screenWidth * 0.95;
  }

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10), // 꽃잎이 한 번 떨어지는 데 걸리는 시간
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return; // mounted 체크 추가
      
      final screenWidth = MediaQuery.of(context).size.width;
      setState(() {
        _positionX = positionXCalculator(screenWidth, widget.indexForPositionX);
      });

      _positionY = Tween<double>(begin: -50, end: MediaQuery.of(context).size.height + 50)
          .animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut))
        ..addStatusListener((status) {
          if (status == AnimationStatus.completed && mounted) { // mounted 체크 추가
            _controller.reset();
            setState(() {
              _positionX = positionXCalculator(screenWidth, widget.indexForPositionX) + Random().nextDouble() * 10 - 5;
              _rotationOffset = Random().nextDouble() * 2 * pi;
              _rotateClockwise = Random().nextBool();
            });
            _controller.forward();
          }
        });

      // Add randomness to horizontal wiggle amplitude
      final wiggleAmplitude = 30 + Random().nextDouble() * 20; // 30 to 50

      _horizontalWiggle = Tween<double>(begin: -wiggleAmplitude, end: wiggleAmplitude).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeInOutSine),
      );

      _rotation = Tween<double>(begin: 0, end: _rotateClockwise ? 2 * pi : -2 * pi).animate(
        CurvedAnimation(parent: _controller, curve: Curves.linear),
      );

      // Future.delayed 참조를 저장
      _delayedForward = Future.delayed(widget.fallDelay, () {
        if (mounted) { // mounted 체크 추가
          _controller.forward();
        }
      });
    });
  }

  @override
  void dispose() {
    // 보류 중인 Future.delayed 취소
    _delayedForward?.timeout(Duration.zero, onTimeout: () => null);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_positionY == null) return const SizedBox();

    return AnimatedBuilder(
      animation: _positionY!,
      builder: (context, child) {
        return Positioned(
          top: _positionY!.value,
          left: _positionX + _horizontalWiggle.value,
          child: Opacity(
            opacity: 1.0,
            child: Transform.rotate(
              angle: _rotation.value + _rotationOffset,
              child: Image.asset(
                // 정사각형 사이즈로 준비
                'assets/images/petal.png',
                width: 37,
                height: 37,
              ),
            ),
          ),
        );
      },
    );
  }
}