import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_styles.dart';

/// A standardized primary button component for the MeetMaxi app.
///
/// This component provides consistent styling and behavior for primary action buttons
/// throughout the app, based on the design used in the authentication screens.
class AppPrimaryButton extends StatelessWidget {
  /// The text to display on the button
  final String text;
  
  /// Callback when the button is pressed
  final VoidCallback? onPressed;
  
  /// Whether the button is in a loading state
  final bool isLoading;
  
  /// Optional icon to display before the text
  final IconData? icon;
  
  /// Button width (defaults to double.infinity for full width)
  final double? width;
  
  /// Button height (defaults to standard height)
  final double height;

  /// Optional custom button style that overrides the default style
  final ButtonStyle? style;

  const AppPrimaryButton({
    Key? key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.icon,
    this.width,
    this.height = 48,
    this.style,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      height: height,
      child: ElevatedButton(
        style: style ?? AppStyles.primaryButtonStyle,
        onPressed: isLoading ? null : onPressed,
        child: isLoading
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : _buildButtonContent(),
      ),
    );
  }

  Widget _buildButtonContent() {
    if (icon != null) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 18),
          const SizedBox(width: 8),
          Text(text, style: AppStyles.buttonText),
        ],
      );
    }
    return Text(text, style: AppStyles.buttonText);
  }
}

/// A standardized secondary button component for the MeetMaxi app.
///
/// This component provides consistent styling and behavior for secondary action buttons
/// throughout the app, with an outlined style.
class AppSecondaryButton extends StatelessWidget {
  /// The text to display on the button
  final String text;
  
  /// Callback when the button is pressed
  final VoidCallback? onPressed;
  
  /// Whether the button is in a loading state
  final bool isLoading;
  
  /// Optional icon to display before the text
  final IconData? icon;
  
  /// Button width (defaults to double.infinity for full width)
  final double? width;
  
  /// Button height (defaults to standard height)
  final double height;

  const AppSecondaryButton({
    Key? key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.icon,
    this.width,
    this.height = 48,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      height: height,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primaryPurple,
          side: const BorderSide(color: AppColors.primaryPurple),
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        onPressed: isLoading ? null : onPressed,
        child: isLoading
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  color: AppColors.primaryPurple,
                  strokeWidth: 2,
                ),
              )
            : _buildButtonContent(),
      ),
    );
  }

  Widget _buildButtonContent() {
    if (icon != null) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 18),
          const SizedBox(width: 8),
          Text(
            text,
            style: AppStyles.bodyMedium.copyWith(
              color: AppColors.primaryPurple,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      );
    }
    return Text(
      text,
      style: AppStyles.bodyMedium.copyWith(
        color: AppColors.primaryPurple,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}

/// A standardized text button component for the MeetMaxi app.
///
/// This component provides consistent styling and behavior for text buttons
/// throughout the app, typically used for secondary actions or links.
class AppTextButton extends StatelessWidget {
  /// The text to display on the button
  final String text;
  
  /// Callback when the button is pressed
  final VoidCallback? onPressed;
  
  /// Optional icon to display before the text
  final IconData? icon;
  
  /// Text color (defaults to primary purple)
  final Color? color;

  const AppTextButton({
    Key? key,
    required this.text,
    this.onPressed,
    this.icon,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      child: _buildButtonContent(),
    );
  }

  Widget _buildButtonContent() {
    final textColor = color ?? AppColors.primaryPurple;
    
    if (icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: textColor),
          const SizedBox(width: 4),
          Text(
            text,
            style: AppStyles.bodyMedium.copyWith(
              color: textColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      );
    }
    return Text(
      text,
      style: AppStyles.bodyMedium.copyWith(
        color: textColor,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}

/// A standardized icon button component for the MeetMaxi app.
///
/// This component provides consistent styling and behavior for icon buttons
/// throughout the app.
class AppIconButton extends StatelessWidget {
  /// The icon to display
  final IconData icon;
  
  /// Callback when the button is pressed
  final VoidCallback? onPressed;
  
  /// Icon color (defaults to text primary)
  final Color? color;
  
  /// Icon size
  final double size;
  
  /// Background color (defaults to transparent)
  final Color? backgroundColor;
  
  /// Whether to show a circular background
  final bool circular;

  const AppIconButton({
    Key? key,
    required this.icon,
    this.onPressed,
    this.color,
    this.size = 24,
    this.backgroundColor,
    this.circular = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final iconColor = color ?? AppColors.textPrimary;
    
    if (circular) {
      return Container(
        decoration: BoxDecoration(
          color: backgroundColor ?? Colors.transparent,
          shape: BoxShape.circle,
        ),
        child: IconButton(
          icon: Icon(icon, color: iconColor, size: size),
          onPressed: onPressed,
          padding: EdgeInsets.all(size / 3),
          constraints: BoxConstraints(
            minWidth: size * 2,
            minHeight: size * 2,
          ),
        ),
      );
    }
    
    return IconButton(
      icon: Icon(icon, color: iconColor, size: size),
      onPressed: onPressed,
      padding: const EdgeInsets.all(8),
      constraints: const BoxConstraints(),
      splashRadius: 24,
    );
  }
}
