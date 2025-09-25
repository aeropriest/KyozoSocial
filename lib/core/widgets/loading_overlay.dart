import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

/// A widget that displays a loading indicator overlay on top of its child.
class LoadingOverlay extends StatelessWidget {
  final bool isLoading;
  final Widget child;
  final Color? color;
  final double opacity;

  const LoadingOverlay({
    Key? key,
    required this.isLoading,
    required this.child,
    this.color,
    this.opacity = 0.5,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (isLoading)
          Positioned.fill(
            child: Container(
              color: (color ?? Colors.black).withOpacity(opacity),
              child: Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryPurple),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
