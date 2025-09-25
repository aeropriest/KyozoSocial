# MeetMaxi Release Notes

This document tracks bug fixes, improvements, and feature additions for the MeetMaxi app across different versions.

## Version 1.1.0 (May 15, 2025)

### Bug Fixes

1. **Persona Selection Issue**: Fixed a critical bug where the app would revert to the default "Space Explorer" persona when using the microphone button, ignoring the user's selection in settings.

### Improvements

1. **UI Enhancements**: Improved the formatting of persona and voice cards in the settings screen:
   - Better text alignment and centering in both persona and voice cards
   - Increased vertical space for persona descriptions to prevent overflow
   - Consistent styling across all UI elements

2. **OpenAI Integration**: Updated to use GPT-4o model for improved response quality and performance.

## Version 1.0.1 (May 14, 2025)

### Bug Fixes

1. **Persona Selection Issue**: Fixed a bug where the app would revert to the default "Space Explorer" persona when using the microphone button, ignoring the user's selection in settings.
   - Root cause: Multiple issues in the persona handling system:
     - The PersonaProvider was automatically saving the first persona from Firestore as the selected persona, overriding the user's selection
     - The app wasn't properly maintaining the selected persona when initializing the speech screen
     - The microphone button in the navigation bar wasn't initializing the persona provider correctly
   - Solution: Comprehensive overhaul of the persona handling system:
     - Completely rewrote the `_loadDefaultPersona` method to respect existing persona selections
     - Enhanced the `initialize` method to avoid unnecessary reloading and maintain selected personas
     - Added initialization of the PersonaProvider in the main navigation screen's microphone button handler
     - Implemented proper persona verification in both the speech screen and navigation screen
   - Additional improvements:
     - Added robust error handling and recovery mechanisms throughout the persona selection flow
     - Implemented direct Firestore updates as a fallback when preferences service fails
     - Enhanced logging throughout the app to better track persona selection and usage
     - Added delays and synchronization to ensure proper initialization order

2. **OpenAI Integration**: Updated the OpenAI service to use GPT-4o instead of GPT-3.5 Turbo for improved response quality.

3. **Math Library Reference**: Fixed an error in the PersonaService where `Math.min()` was incorrectly referenced instead of `math.min()`.

4. **Missing Import**: Added missing import for the Persona model in OpenAIService, fixing compilation errors when referencing Persona.defaultPersona().

### Improvements

1. **Persona Management**: Enhanced the persona fallback system to maintain consistency with the selected persona type, even when using fallbacks.

2. **Debugging**: Added comprehensive logging throughout the persona selection and OpenAI integration process to facilitate future troubleshooting.

## How to Use This Document

When making significant changes to the app, especially bug fixes, please document them in this file following this format:

```
## Version X.X.X (Date)

### Bug Fixes
1. **Issue Name**: Brief description of the issue.
   - Root cause: What caused the issue.
   - Solution: How it was fixed.

### Improvements
1. **Feature Name**: Description of the improvement.

### New Features
1. **Feature Name**: Description of the new feature.
```

This documentation helps track changes over time and provides valuable context for future development and troubleshooting.
