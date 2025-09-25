import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

/// A standardized card component for the MeetMaxi app.
///
/// This component provides consistent styling for cards
/// throughout the app, based on the design used in the authentication screens.
class AppCard extends StatelessWidget {
  /// The card content
  final Widget child;
  
  /// Padding inside the card
  final EdgeInsetsGeometry padding;
  
  /// Margin around the card
  final EdgeInsetsGeometry? margin;
  
  /// Border radius of the card
  final BorderRadius borderRadius;
  
  /// Background color of the card
  final Color? backgroundColor;
  
  /// Elevation (shadow) of the card
  final double elevation;
  
  /// Border color (if null, no border is shown)
  final Color? borderColor;
  
  /// Border width (only used if borderColor is not null)
  final double borderWidth;
  
  /// Whether to clip the card's content to the border radius
  final bool clipContent;

  const AppCard({
    Key? key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.margin,
    this.borderRadius = const BorderRadius.all(Radius.circular(8)),
    this.backgroundColor,
    this.elevation = 1,
    this.borderColor,
    this.borderWidth = 1,
    this.clipContent = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final content = Padding(
      padding: padding,
      child: child,
    );
    
    return Card(
      margin: margin ?? EdgeInsets.zero,
      elevation: elevation,
      shape: RoundedRectangleBorder(
        borderRadius: borderRadius,
        side: borderColor != null
            ? BorderSide(color: borderColor!, width: borderWidth)
            : BorderSide.none,
      ),
      color: backgroundColor ?? AppColors.cardBackground,
      clipBehavior: clipContent ? Clip.antiAlias : Clip.none,
      child: content,
    );
  }
}

/// A standardized container component for the MeetMaxi app.
///
/// This component provides consistent styling for containers
/// throughout the app, with options for borders, shadows, and background colors.
class AppContainer extends StatelessWidget {
  /// The container content
  final Widget child;
  
  /// Padding inside the container
  final EdgeInsetsGeometry padding;
  
  /// Margin around the container
  final EdgeInsetsGeometry? margin;
  
  /// Border radius of the container
  final BorderRadius? borderRadius;
  
  /// Background color of the container
  final Color? backgroundColor;
  
  /// Whether to show a shadow
  final bool hasShadow;
  
  /// Border color (if null, no border is shown)
  final Color? borderColor;
  
  /// Border width (only used if borderColor is not null)
  final double borderWidth;
  
  /// Width of the container (null for auto)
  final double? width;
  
  /// Height of the container (null for auto)
  final double? height;
  
  /// Alignment of the child within the container
  final Alignment? alignment;

  const AppContainer({
    Key? key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.margin,
    this.borderRadius,
    this.backgroundColor,
    this.hasShadow = false,
    this.borderColor,
    this.borderWidth = 1,
    this.width,
    this.height,
    this.alignment,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: margin,
      padding: padding,
      alignment: alignment,
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.white,
        borderRadius: borderRadius ?? BorderRadius.circular(8),
        border: borderColor != null
            ? Border.all(color: borderColor!, width: borderWidth)
            : null,
        boxShadow: hasShadow
            ? [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: child,
    );
  }
}

/// A standardized list item component for the MeetMaxi app.
///
/// This component provides consistent styling for list items
/// throughout the app, with support for leading and trailing widgets.
class AppListItem extends StatelessWidget {
  /// The title of the list item
  final Widget title;
  
  /// Optional subtitle
  final Widget? subtitle;
  
  /// Optional leading widget (e.g., icon, avatar)
  final Widget? leading;
  
  /// Optional trailing widget (e.g., icon, button)
  final Widget? trailing;
  
  /// Callback when the item is tapped
  final VoidCallback? onTap;
  
  /// Padding inside the list item
  final EdgeInsetsGeometry padding;
  
  /// Background color of the list item
  final Color? backgroundColor;
  
  /// Whether to show a divider below the item
  final bool showDivider;
  
  /// Border radius of the list item
  final BorderRadius? borderRadius;

  const AppListItem({
    Key? key,
    required this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.onTap,
    this.padding = const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
    this.backgroundColor,
    this.showDivider = false,
    this.borderRadius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final content = Padding(
      padding: padding,
      child: Row(
        children: [
          if (leading != null) ...[
            leading!,
            const SizedBox(width: 16),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                title,
                if (subtitle != null) ...[
                  const SizedBox(height: 4),
                  subtitle!,
                ],
              ],
            ),
          ),
          if (trailing != null) ...[
            const SizedBox(width: 16),
            trailing!,
          ],
        ],
      ),
    );

    final item = Material(
      color: backgroundColor ?? Colors.transparent,
      borderRadius: borderRadius,
      child: InkWell(
        onTap: onTap,
        borderRadius: borderRadius,
        child: content,
      ),
    );

    if (showDivider) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          item,
          const Divider(height: 1, thickness: 1, color: AppColors.divider),
        ],
      );
    }

    return item;
  }
}
