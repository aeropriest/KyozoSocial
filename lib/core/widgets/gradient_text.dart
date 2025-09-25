import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// A widget that displays text with a gradient effect
/// Matches the gradient text styling from the Next.js Kyozo design
class GradientText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;
  final List<Color>? gradientColors;
  final AlignmentGeometry begin;
  final AlignmentGeometry end;

  const GradientText(
    this.text, {
    super.key,
    this.style,
    this.textAlign,
    this.gradientColors,
    this.begin = Alignment.topLeft,
    this.end = Alignment.bottomRight,
  });

  @override
  Widget build(BuildContext context) {
    final colors = gradientColors ?? AppTheme.gradientColors;
    
    return ShaderMask(
      shaderCallback: (bounds) => LinearGradient(
        colors: colors,
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        stops: const [0.0, 1.0], // Ensure full gradient coverage
      ).createShader(
        Rect.fromLTWH(0, 0, bounds.width, bounds.height),
      ),
      child: Text(
        text,
        style: style?.copyWith(
          color: Colors.white, // This will be masked by the gradient
          height: 1.1, // Tighter line height for better look
          letterSpacing: -0.5, // Slightly tighter letter spacing
          fontWeight: FontWeight.w500, // Slightly bolder for better gradient visibility
        ) ?? TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.w500,
          height: 1.1,
          letterSpacing: -0.5,
        ),
        textAlign: textAlign,
      ),
    );
  }
}

/// A convenience widget for gradient headings
class GradientHeading extends StatelessWidget {
  final String text;
  final double? fontSize;
  final FontWeight? fontWeight;
  final TextAlign? textAlign;

  const GradientHeading(
    this.text, {
    super.key,
    this.fontSize,
    this.fontWeight,
    this.textAlign,
  });

  @override
  Widget build(BuildContext context) {
    return GradientText(
      text,
      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
        fontSize: fontSize ?? 32,
        fontWeight: fontWeight ?? FontWeight.w500,
        height: 1.1,
        letterSpacing: -0.5,
      ),
      textAlign: textAlign,
    );
  }
}
