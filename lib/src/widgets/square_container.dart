import 'package:flutter/material.dart';

class SquareContainer extends StatelessWidget {
  final Color backgroundColor;
  final Color progressColor;
  final double progress;
  final double size;
  final String text;

  const SquareContainer({
    Key? key,
    this.backgroundColor = const Color(0xFF476bb4),
    this.progressColor = Colors.green,
    required this.progress,
    required this.size,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(size / 2),
      child: SizedBox(
        height: size,
        width: size,
        child: Stack(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              margin: const EdgeInsets.all(6.0),
              alignment: Alignment.center,
              color: backgroundColor,
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                margin: const EdgeInsets.all(6.0),
                alignment: Alignment.bottomCenter,
                height: size * progress,
                color: progressColor,
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              margin: const EdgeInsets.all(6.0),
              child: Align(
                alignment: Alignment.topCenter,
                child: Text(
                  text,
                  style: const TextStyle(color: Color(0xFFFAFAFA)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}