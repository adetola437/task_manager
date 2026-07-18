import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

/// Design tokens for the app.
///
/// Palette: an indigo/violet core (the "focus" color) against a soft
/// lavender-white surface, with three accent colors that stand in for
/// task states rather than decoration — amber for "due soon", green for
/// "done", rose for anything that needs attention.
///
/// Type: Sora carries headings and numerals (it has a slightly geometric,
/// confident look that suits a progress percentage or a greeting), Inter
/// carries body copy and captions where legibility at small sizes matters
/// more than character.
class AppColors {
  AppColors._();

  static const Color indigo = Color(0xFF5B5FEF);
  static const Color indigoDeep = Color(0xFF3E36B5);
  static const Color background = Color(0xFFF5F5FC);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color textPrimary = Color(0xFF1E1B3A);
  static const Color textMuted = Color(0xFF8A8AA3);
  static const Color amber = Color(0xFFF5A524);
  static const Color green = Color(0xFF22C55E);
  static const Color rose = Color(0xFFF43F5E);
  static const Color track = Color(0xFFE7E7F5);
}

class AppTheme {
  AppTheme._();

  static TextTheme _textTheme() {
    final base = ThemeData.light().textTheme;
    return GoogleFonts.interTextTheme(base).copyWith(
      displaySmall: GoogleFonts.sora(fontSize: 28.sp, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
      headlineSmall: GoogleFonts.sora(fontSize: 20.sp, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
      titleMedium: GoogleFonts.sora(fontSize: 16.sp, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
      titleSmall: GoogleFonts.sora(fontSize: 14.sp, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
      bodyLarge: GoogleFonts.inter(fontSize: 15.sp, color: AppColors.textPrimary),
      bodyMedium: GoogleFonts.inter(fontSize: 13.5.sp, color: AppColors.textMuted),
      bodySmall: GoogleFonts.inter(fontSize: 12.sp, color: AppColors.textMuted),
      labelLarge: GoogleFonts.inter(fontSize: 13.sp, fontWeight: FontWeight.w600),
      labelSmall: GoogleFonts.inter(fontSize: 11.sp, fontWeight: FontWeight.w600, letterSpacing: 0.4),
    );
  }

  static ThemeData light() {
    final textTheme = _textTheme();
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.indigo,
        primary: AppColors.indigo,
        surface: AppColors.surface,
        error: AppColors.rose,
      ),
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        centerTitle: false,
        elevation: 0,
        backgroundColor: AppColors.background,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: textTheme.headlineSmall,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.r),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: AppColors.surface,
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: AppColors.indigo,
        foregroundColor: Colors.white,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.indigo,
          minimumSize: Size(double.infinity, 52.h),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
          textStyle: textTheme.labelLarge,
        ),
      ),
      checkboxTheme: CheckboxThemeData(
        shape: const CircleBorder(),
        fillColor: MaterialStateProperty.resolveWith(
          (states) => states.contains(MaterialState.selected) ? AppColors.indigo : Colors.transparent,
        ),
        side: const BorderSide(color: AppColors.textMuted, width: 1.5),
      ),
      dividerTheme: const DividerThemeData(color: AppColors.track, space: 1),
    );
  }
}
