import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_styles.dart';

/// A standardized text field component for the MeetMaxi app.
/// 
/// This component provides consistent styling and behavior for text input
/// throughout the app, based on the design used in the authentication screens.
class AppTextField extends StatelessWidget {
  /// Controller for the text field
  final TextEditingController? controller;
  
  /// Label text to display
  final String? labelText;
  
  /// Hint text to display when the field is empty
  final String? hintText;
  
  /// Error text to display below the field
  final String? errorText;
  
  /// Whether the text should be obscured (for passwords)
  final bool obscureText;
  
  /// The type of keyboard to use
  final TextInputType keyboardType;
  
  /// Callback when the text changes
  final ValueChanged<String>? onChanged;
  
  /// Validator function for form validation
  final String? Function(String?)? validator;
  
  /// Optional suffix icon
  final Widget? suffixIcon;
  
  /// Whether the field is enabled
  final bool enabled;
  
  /// Maximum number of lines
  final int? maxLines;
  
  /// Minimum number of lines
  final int? minLines;
  
  /// Focus node for controlling focus
  final FocusNode? focusNode;
  
  /// Callback when the field is submitted
  final ValueChanged<String>? onSubmitted;
  
  /// Text input action (e.g., next, done)
  final TextInputAction? textInputAction;

  const AppTextField({
    Key? key,
    this.controller,
    this.labelText,
    this.hintText,
    this.errorText,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.onChanged,
    this.validator,
    this.suffixIcon,
    this.enabled = true,
    this.maxLines = 1,
    this.minLines,
    this.focusNode,
    this.onSubmitted,
    this.textInputAction,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      enabled: enabled,
      maxLines: obscureText ? 1 : maxLines,
      minLines: minLines,
      focusNode: focusNode,
      onChanged: onChanged,
      onFieldSubmitted: onSubmitted,
      textInputAction: textInputAction,
      style: AppStyles.bodyMedium,
      decoration: AppStyles.inputDecoration(
        labelText: labelText,
        hintText: hintText,
      ).copyWith(
        errorText: errorText,
        suffixIcon: suffixIcon,
      ),
      validator: validator,
    );
  }
}

/// A password text field with a toggle to show/hide the password
class AppPasswordField extends StatefulWidget {
  /// Controller for the text field
  final TextEditingController? controller;
  
  /// Label text to display
  final String? labelText;
  
  /// Hint text to display when the field is empty
  final String? hintText;
  
  /// Error text to display below the field
  final String? errorText;
  
  /// Callback when the text changes
  final ValueChanged<String>? onChanged;
  
  /// Validator function for form validation
  final String? Function(String?)? validator;
  
  /// Whether the field is enabled
  final bool enabled;
  
  /// Focus node for controlling focus
  final FocusNode? focusNode;
  
  /// Callback when the field is submitted
  final ValueChanged<String>? onSubmitted;
  
  /// Text input action (e.g., next, done)
  final TextInputAction? textInputAction;

  const AppPasswordField({
    Key? key,
    this.controller,
    this.labelText = 'Password',
    this.hintText,
    this.errorText,
    this.onChanged,
    this.validator,
    this.enabled = true,
    this.focusNode,
    this.onSubmitted,
    this.textInputAction,
  }) : super(key: key);

  @override
  State<AppPasswordField> createState() => _AppPasswordFieldState();
}

class _AppPasswordFieldState extends State<AppPasswordField> {
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      controller: widget.controller,
      labelText: widget.labelText,
      hintText: widget.hintText,
      errorText: widget.errorText,
      obscureText: _obscurePassword,
      keyboardType: TextInputType.visiblePassword,
      onChanged: widget.onChanged,
      validator: widget.validator,
      enabled: widget.enabled,
      focusNode: widget.focusNode,
      onSubmitted: widget.onSubmitted,
      textInputAction: widget.textInputAction,
      suffixIcon: IconButton(
        icon: Icon(
          _obscurePassword ? Icons.visibility_off : Icons.visibility,
          color: AppColors.textSecondary,
        ),
        onPressed: () {
          setState(() {
            _obscurePassword = !_obscurePassword;
          });
        },
      ),
    );
  }
}

/// An email text field with validation
class AppEmailField extends StatelessWidget {
  /// Controller for the text field
  final TextEditingController? controller;
  
  /// Label text to display
  final String? labelText;
  
  /// Hint text to display when the field is empty
  final String? hintText;
  
  /// Error text to display below the field
  final String? errorText;
  
  /// Callback when the text changes
  final ValueChanged<String>? onChanged;
  
  /// Custom validator function for form validation
  final String? Function(String?)? customValidator;
  
  /// Whether the field is enabled
  final bool enabled;
  
  /// Focus node for controlling focus
  final FocusNode? focusNode;
  
  /// Callback when the field is submitted
  final ValueChanged<String>? onSubmitted;
  
  /// Text input action (e.g., next, done)
  final TextInputAction? textInputAction;

  const AppEmailField({
    Key? key,
    this.controller,
    this.labelText = 'Email',
    this.hintText,
    this.errorText,
    this.onChanged,
    this.customValidator,
    this.enabled = true,
    this.focusNode,
    this.onSubmitted,
    this.textInputAction,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      controller: controller,
      labelText: labelText,
      hintText: hintText,
      errorText: errorText,
      keyboardType: TextInputType.emailAddress,
      onChanged: onChanged,
      validator: customValidator ?? _defaultEmailValidator,
      enabled: enabled,
      focusNode: focusNode,
      onSubmitted: onSubmitted,
      textInputAction: textInputAction,
    );
  }

  String? _defaultEmailValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }
}
