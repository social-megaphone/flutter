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
  late Animation<double> _positionY; // 변해야할 y값

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
      duration: const Duration(seconds: 15), // 꽃잎이 한 번 떨어지는 데 걸리는 시간
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final screenWidth = MediaQuery.of(context).size.width;
      setState(() {
        _positionX = positionXCalculator(screenWidth, widget.indexForPositionX);
      });

      _positionY = Tween<double>(begin: -50, end: MediaQuery.of(context).size.height + 50)
          .animate(CurvedAnimation(parent: _controller, curve: Curves.linear))
        ..addStatusListener((status) {
          if (status == AnimationStatus.completed) {
            _controller.reset();
            setState(() {
              _positionX = positionXCalculator(screenWidth, widget.indexForPositionX);
            });
            _controller.forward();
          }
        });

      Future.delayed(widget.fallDelay, () {
        _controller.forward();
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return AnimatedBuilder(
      animation: _positionY,
      builder: (context, child) {
        return Positioned(
          top: _positionY.value,
          left: _positionX,
          child: Opacity(
            opacity: 1.0,
            child: Image.asset(
              // 정사각형 사이즈로 준비
              'assets/images/petal.png',
              width: 37,
              height: 37,
            ),
          ),
        );
      },
    );
  }
}