import 'package:flutter/material.dart';

class TopSlideSheet extends StatelessWidget {
  final Widget child;
  final double maxHeight;
  final Color? backgroundColor;
  final BorderRadius? borderRadius;
  final EdgeInsets? padding;
  
  const TopSlideSheet({
    Key? key,
    required this.child,
    this.maxHeight = 0.8, // 80% of screen height by default
    this.backgroundColor,
    this.borderRadius,
    this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: SafeArea(
        child: Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * maxHeight,
          ),
          decoration: BoxDecoration(
            color: backgroundColor ?? Theme.of(context).scaffoldBackgroundColor,
            borderRadius: borderRadius ?? const BorderRadius.only(
              bottomLeft: Radius.circular(16),
              bottomRight: Radius.circular(16),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                spreadRadius: 5,
              ),
            ],
          ),
          child: Padding(
            padding: padding ?? const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Handle bar
                Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                // Content
                Flexible(
                  child: SingleChildScrollView(
                    child: child,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Future<T?> showTopSlideSheet<T>({
  required BuildContext context,
  required Widget child,
  double maxHeight = 0.8,
  Color? backgroundColor,
  BorderRadius? borderRadius,
  EdgeInsets? padding,
  bool isDismissible = true,
  Color barrierColor = Colors.black54,
}) {
  return showGeneralDialog<T>(
    context: context,
    barrierDismissible: isDismissible,
    barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
    barrierColor: barrierColor,
    pageBuilder: (context, animation, secondaryAnimation) {
      return WillPopScope(
        onWillPop: () async => isDismissible,
        child: Stack(
          children: [
            GestureDetector(
              onTap: isDismissible ? () => Navigator.of(context).pop() : null,
              child: Container(color: Colors.transparent),
            ),
            SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, -1),
                end: Offset.zero,
              ).animate(CurvedAnimation(
                parent: animation,
                curve: Curves.easeOutCubic,
                reverseCurve: Curves.easeInCubic,
              )),
              child: TopSlideSheet(
                maxHeight: maxHeight,
                backgroundColor: backgroundColor,
                borderRadius: borderRadius,
                padding: padding,
                child: child,
              ),
            ),
          ],
        ),
      );
    },
    transitionDuration: const Duration(milliseconds: 300),
  );
}
