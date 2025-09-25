import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Custom button widget that matches the Kyozo Next.js design
/// Features: fully rounded, pink accent, hover effects, thin font weight
class KyozoButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final KyozoButtonVariant variant;
  final KyozoButtonSize size;
  final bool fullWidth;
  final bool loading;
  final Widget? icon;

  const KyozoButton({
    super.key,
    required this.text,
    this.onPressed,
    this.variant = KyozoButtonVariant.primary,
    this.size = KyozoButtonSize.medium,
    this.fullWidth = false,
    this.loading = false,
    this.icon,
  });

  @override
  State<KyozoButton> createState() => _KyozoButtonState();
}

class _KyozoButtonState extends State<KyozoButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    setState(() => _isPressed = true);
    _animationController.forward();
  }

  void _onTapUp(TapUpDetails details) {
    setState(() => _isPressed = false);
    _animationController.reverse();
  }

  void _onTapCancel() {
    setState(() => _isPressed = false);
    _animationController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final buttonStyle = _getButtonStyle();
    final textStyle = _getTextStyle(context);

    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: GestureDetector(
            onTapDown: widget.onPressed != null ? _onTapDown : null,
            onTapUp: widget.onPressed != null ? _onTapUp : null,
            onTapCancel: widget.onPressed != null ? _onTapCancel : null,
            onTap: widget.loading ? null : widget.onPressed,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: widget.fullWidth ? double.infinity : null,
              padding: _getPadding(),
              decoration: BoxDecoration(
                color: buttonStyle.backgroundColor,
                border: buttonStyle.border,
                borderRadius: BorderRadius.circular(50), // Fully rounded
                boxShadow: _isPressed ? [] : buttonStyle.boxShadow,
              ),
              child: Row(
                mainAxisSize: widget.fullWidth ? MainAxisSize.max : MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (widget.icon != null) ...[
                    widget.icon!,
                    const SizedBox(width: 8),
                  ],
                  if (widget.loading)
                    SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          buttonStyle.textColor,
                        ),
                      ),
                    )
                  else
                    Text(
                      widget.text,
                      style: textStyle,
                      textAlign: TextAlign.center,
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  EdgeInsets _getPadding() {
    switch (widget.size) {
      case KyozoButtonSize.small:
        return const EdgeInsets.symmetric(horizontal: 16, vertical: 8);
      case KyozoButtonSize.medium:
        return const EdgeInsets.symmetric(horizontal: 24, vertical: 12);
      case KyozoButtonSize.large:
        return const EdgeInsets.symmetric(horizontal: 32, vertical: 16);
    }
  }

  _ButtonStyle _getButtonStyle() {
    switch (widget.variant) {
      case KyozoButtonVariant.primary:
        return _ButtonStyle(
          backgroundColor: AppTheme.accentPink,
          textColor: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        );
      case KyozoButtonVariant.outline:
        return _ButtonStyle(
          backgroundColor: Colors.transparent,
          textColor: AppTheme.textPrimaryColor,
          border: Border.all(color: AppTheme.accentPink, width: 1),
        );
      case KyozoButtonVariant.ghost:
        return _ButtonStyle(
          backgroundColor: Colors.transparent,
          textColor: AppTheme.textPrimaryColor,
        );
      case KyozoButtonVariant.secondary:
        return _ButtonStyle(
          backgroundColor: AppTheme.cardBackgroundColor,
          textColor: AppTheme.textPrimaryColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 2,
              offset: const Offset(0, 1),
            ),
          ],
        );
    }
  }

  TextStyle _getTextStyle(BuildContext context) {
    final baseStyle = Theme.of(context).textTheme.bodyMedium?.copyWith(
      fontWeight: FontWeight.w300, // Thin font weight like Next.js
      letterSpacing: 0.5,
    );

    switch (widget.size) {
      case KyozoButtonSize.small:
        return baseStyle?.copyWith(fontSize: 14) ?? const TextStyle(fontSize: 14);
      case KyozoButtonSize.medium:
        return baseStyle?.copyWith(fontSize: 16) ?? const TextStyle(fontSize: 16);
      case KyozoButtonSize.large:
        return baseStyle?.copyWith(fontSize: 18) ?? const TextStyle(fontSize: 18);
    }
  }
}

class _ButtonStyle {
  final Color backgroundColor;
  final Color textColor;
  final Border? border;
  final List<BoxShadow>? boxShadow;

  _ButtonStyle({
    required this.backgroundColor,
    required this.textColor,
    this.border,
    this.boxShadow,
  });
}

enum KyozoButtonVariant {
  primary,
  outline,
  ghost,
  secondary,
}

enum KyozoButtonSize {
  small,
  medium,
  large,
}
