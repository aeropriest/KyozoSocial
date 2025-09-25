import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

/// A consistent loading indicator for the app using SpinKitPulse
/// This widget should be used instead of CircularProgressIndicator throughout the app
class AppLoadingIndicator extends StatelessWidget {
  final double size;
  final Color? color;
  final Color? backgroundColor;
  
  /// Creates a consistent loading indicator for the app
  /// 
  /// [size] controls the size of the pulse animation (default: 80.0)
  /// [color] overrides the default app purple color
  /// [backgroundColor] sets a background color for the indicator
  const AppLoadingIndicator({
    Key? key,
    this.size = 80.0,
    this.color,
    this.backgroundColor,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor ?? Colors.white,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Stack to position pulse animation behind Maxi image
            Stack(
              alignment: Alignment.center,
              children: [
                // Pulse animation (behind)
                SpinKitPulse(
                  color: color ?? const Color(0xFF5A4C8E), // App's purple theme color
                  size: size * 2, // Make it larger to be visible behind the image
                ),
                
                // Blue Maxi image (in front) - no circle or border
                SizedBox(
                  width: 150, // Increased size to match splash screen
                  height: 150, // Increased size to match splash screen
                  child: Image.asset(
                    'assets/images/maxi_blue.png',
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      // Fallback if the image can't be loaded
                      return Container(
                        color: const Color(0xFF5A4C8E).withOpacity(0.2),
                        child: const Icon(
                          Icons.person,
                          size: 60,
                          color: Color(0xFF5A4C8E),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),            
            // const SizedBox(height: 30),
            
            // const SizedBox(height: 20),
            
            // // Warming up text
            // Text(
            //   'Wait please, I am warming up...',
            //   style: TextStyle(
            //     fontSize: 16,
            //     fontWeight: FontWeight.w500,
            //     color: color ?? const Color(0xFF5A4C8E),
            //   ),
            //   textAlign: TextAlign.center,
            // ),
          ],
        ),
      ),
    );
  }
}
