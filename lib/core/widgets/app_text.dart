import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_styles.dart';

/// A standardized heading text component for the MeetMaxi app.
///
/// This component provides consistent styling for headings
/// throughout the app, based on the design used in the authentication screens.
class AppHeading extends StatelessWidget {
  /// The text to display
  final String text;
  
  /// The heading size (large, medium, small)
  final HeadingSize size;
  
  /// Optional color override
  final Color? color;
  
  /// Text alignment
  final TextAlign? textAlign;
  
  /// Whether to allow the text to wrap to multiple lines
  final bool wrap;
  
  /// Maximum number of lines (null for unlimited)
  final int? maxLines;
  
  /// How to handle overflow
  final TextOverflow? overflow;

  const AppHeading({
    Key? key,
    required this.text,
    this.size = HeadingSize.medium,
    this.color,
    this.textAlign,
    this.wrap = true,
    this.maxLines,
    this.overflow,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextStyle style;
    
    switch (size) {
      case HeadingSize.large:
        style = AppStyles.headingLarge;
        break;
      case HeadingSize.medium:
        style = AppStyles.headingMedium;
        break;
      case HeadingSize.small:
        style = AppStyles.headingSmall;
        break;
    }
    
    if (color != null) {
      style = style.copyWith(color: color);
    }
    
    return Text(
      text,
      style: style,
      textAlign: textAlign,
      softWrap: wrap,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}

/// The available heading sizes
enum HeadingSize {
  large,
  medium,
  small,
}

/// A standardized body text component for the MeetMaxi app.
///
/// This component provides consistent styling for body text
/// throughout the app, based on the design used in the authentication screens.
class AppBodyText extends StatelessWidget {
  /// The text to display
  final String text;
  
  /// The body text size (large, medium, small)
  final BodyTextSize size;
  
  /// Optional color override
  final Color? color;
  
  /// Text alignment
  final TextAlign? textAlign;
  
  /// Whether to allow the text to wrap to multiple lines
  final bool wrap;
  
  /// Maximum number of lines (null for unlimited)
  final int? maxLines;
  
  /// How to handle overflow
  final TextOverflow? overflow;
  
  /// Font weight
  final FontWeight? fontWeight;

  const AppBodyText({
    Key? key,
    required this.text,
    this.size = BodyTextSize.medium,
    this.color,
    this.textAlign,
    this.wrap = true,
    this.maxLines,
    this.overflow,
    this.fontWeight,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextStyle style;
    
    switch (size) {
      case BodyTextSize.large:
        style = AppStyles.bodyLarge;
        break;
      case BodyTextSize.medium:
        style = AppStyles.bodyMedium;
        break;
      case BodyTextSize.small:
        style = AppStyles.bodySmall;
        break;
    }
    
    if (color != null || fontWeight != null) {
      style = style.copyWith(
        color: color,
        fontWeight: fontWeight,
      );
    }
    
    return Text(
      text,
      style: style,
      textAlign: textAlign,
      softWrap: wrap,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}

/// The available body text sizes
enum BodyTextSize {
  large,
  medium,
  small,
}

/// A standardized label text component for the MeetMaxi app.
///
/// This component provides consistent styling for labels
/// throughout the app, typically used for form fields and sections.
class AppLabel extends StatelessWidget {
  /// The text to display
  final String text;
  
  /// Optional color override
  final Color? color;
  
  /// Whether the label is required (adds a red asterisk)
  final bool required;
  
  /// Text alignment
  final TextAlign? textAlign;

  const AppLabel({
    Key? key,
    required this.text,
    this.color,
    this.required = false,
    this.textAlign,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          text,
          style: AppStyles.bodyMedium.copyWith(
            color: color ?? AppColors.textPrimary,
            fontWeight: FontWeight.w500,
          ),
          textAlign: textAlign,
        ),
        if (required) 
          Text(
            ' *',
            style: AppStyles.bodyMedium.copyWith(
              color: AppColors.error,
              fontWeight: FontWeight.w500,
            ),
          ),
      ],
    );
  }
}

/// A standardized error text component for the MeetMaxi app.
///
/// This component provides consistent styling for error messages
/// throughout the app.
class AppErrorText extends StatelessWidget {
  /// The error message to display
  final String text;
  
  /// Text alignment
  final TextAlign? textAlign;

  const AppErrorText({
    Key? key,
    required this.text,
    this.textAlign,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: AppStyles.bodySmall.copyWith(
        color: AppColors.error,
      ),
      textAlign: textAlign ?? TextAlign.start,
    );
  }
}
