import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Custom input field that matches the Kyozo Next.js design
/// Features: fully rounded, gradient borders on focus, thin font weights
class KyozoInput extends StatefulWidget {
  final TextEditingController? controller;
  final String? labelText;
  final String? hintText;
  final bool obscureText;
  final TextInputType keyboardType;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final bool enabled;
  final int maxLines;

  const KyozoInput({
    super.key,
    this.controller,
    this.labelText,
    this.hintText,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.prefixIcon,
    this.suffixIcon,
    this.validator,
    this.onChanged,
    this.enabled = true,
    this.maxLines = 1,
  });

  @override
  State<KyozoInput> createState() => _KyozoInputState();
}

class _KyozoInputState extends State<KyozoInput> {
  final FocusNode _focusNode = FocusNode();
  bool _isFocused = false;
  bool _hasError = false;
  String? _errorMessage;
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    });
    
    // Listen to text changes
    widget.controller?.addListener(() {
      setState(() {
        _hasText = widget.controller?.text.isNotEmpty ?? false;
      });
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool labelFloating = _isFocused || _hasText;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Input container with floating label and gradient border
        Container(
          height: 48, // Reduced height for more compact design
          constraints: const BoxConstraints(maxWidth: 350), // Limit width
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50), // Fully rounded
            gradient: _isFocused || _hasError
                ? LinearGradient(
                    colors: _hasError 
                        ? [AppTheme.errorColor, AppTheme.errorColor]
                        : [AppTheme.accentPink, AppTheme.accentBlue],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  )
                : null,
          ),
          child: Container(
            margin: _isFocused || _hasError 
                ? const EdgeInsets.all(1) // Space for gradient border
                : EdgeInsets.zero,
            decoration: BoxDecoration(
              color: AppTheme.inputBackgroundColor,
              borderRadius: BorderRadius.circular(50),
              border: _isFocused || _hasError 
                  ? null 
                  : Border.all(
                      color: AppTheme.borderColor,
                      width: 0.5,
                    ),
            ),
            child: Stack(
              children: [
                // Text input
                TextFormField(
                  controller: widget.controller,
                  focusNode: _focusNode,
                  obscureText: widget.obscureText,
                  keyboardType: widget.keyboardType,
                  enabled: widget.enabled,
                  maxLines: widget.maxLines,
                  onChanged: widget.onChanged,
                  validator: (value) {
                    final error = widget.validator?.call(value);
                    setState(() {
                      _hasError = error != null;
                      _errorMessage = error;
                    });
                    return error;
                  },
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.textPrimaryColor,
                    fontWeight: FontWeight.w300,
                    fontSize: 14,
                  ),
                  decoration: InputDecoration(
                    prefixIcon: widget.prefixIcon != null
                        ? Padding(
                            padding: const EdgeInsets.only(left: 12, right: 6),
                            child: widget.prefixIcon,
                          )
                        : null,
                    prefixIconConstraints: const BoxConstraints(
                      minWidth: 0,
                      minHeight: 0,
                    ),
                    suffixIcon: widget.suffixIcon,
                    contentPadding: EdgeInsets.only(
                      left: widget.prefixIcon != null ? 8 : 16,
                      right: 16,
                      top: labelFloating ? 16 : 12, // Adjusted for smaller height
                      bottom: labelFloating ? 4 : 12,
                    ),
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    focusedErrorBorder: InputBorder.none,
                    errorStyle: const TextStyle(height: 0),
                  ),
                ),
                
                // Floating label
                if (widget.labelText != null)
                  Positioned(
                    left: widget.prefixIcon != null ? 48 : 16,
                    top: labelFloating ? -8 : 12, // Position on top edge when floating
                    child: AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: 200),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: labelFloating 
                            ? (_isFocused ? AppTheme.accentPink : AppTheme.textSecondaryColor)
                            : AppTheme.textSecondaryColor.withValues(alpha: 0.7),
                        fontWeight: FontWeight.w300,
                        fontSize: labelFloating ? 11 : 14, // Smaller sizes for compact design
                      ) ?? const TextStyle(),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: labelFloating 
                            ? const EdgeInsets.symmetric(horizontal: 6, vertical: 2)
                            : EdgeInsets.zero,
                        decoration: labelFloating
                            ? BoxDecoration(
                                color: AppTheme.backgroundColor, // Use main background color
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(
                                  color: AppTheme.backgroundColor,
                                  width: 1,
                                ),
                              )
                            : null,
                        child: Text(widget.labelText!),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
        
        // Compact error message
        if (_hasError && _errorMessage != null)
          Padding(
            padding: const EdgeInsets.only(top: 4, left: 12),
            child: Text(
              _errorMessage!,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppTheme.errorColor,
                fontSize: 11,
                fontWeight: FontWeight.w300,
              ),
            ),
          ),
      ],
    );
  }
}
