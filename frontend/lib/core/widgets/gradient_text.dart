import 'package:flutter/material.dart';

class GradientText extends StatelessWidget {
  final String text;
  final TextStyle style;
  final List<Color> colors;
  final TextAlign? textAlign;

  const GradientText({
    super.key,
    required this.text,
    required this.style,
    this.colors = const [Color(0xFFFFB27A), Color(0xFFE8622C)],
    this.textAlign,
  });

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) => LinearGradient(
        colors: colors,
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(bounds),
      child: Text(
        text,
        style: style.copyWith(color: Colors.white),
        textAlign: textAlign,
      ),
    );
  }
}
