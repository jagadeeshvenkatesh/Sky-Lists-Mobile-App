import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final brightTheme = _buildLightTheme();

final primaryColor = Color(0xFF152837);
final accentColor = Color(0xFFd62f54);
final backgroundColor = Color(0xFFFFFFFF);
final primaryTextColor = Color(0xFF212121);
final secondaryTextColor = Color(0xFF3e5061);

ThemeData _buildLightTheme() {
  final ThemeData base = ThemeData.light();
  return base.copyWith(
    primaryColor: primaryColor,
    accentColor: accentColor,
    buttonColor: primaryColor,
    scaffoldBackgroundColor: backgroundColor,
    cardColor: backgroundColor,
    textSelectionColor: primaryColor,
    errorColor: Colors.red[500],
    primaryIconTheme: base.primaryIconTheme.copyWith(
      color: primaryTextColor,
    ),
    textTheme: _buildAppTextTheme(base.textTheme),
    primaryTextTheme: _buildAppTextTheme(base.primaryTextTheme),
    accentTextTheme: _buildAppTextTheme(base.accentTextTheme),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.all(
          Radius.elliptical(
            20,
            20,
          ),
        ),
        gapPadding: 10.0,
      ),
    ),
    appBarTheme: base.appBarTheme.copyWith(
      elevation: 0.0,
      color: backgroundColor,
    ),
    bottomAppBarTheme: base.bottomAppBarTheme.copyWith(
      elevation: 0.0,
      color: backgroundColor,
    ),
    splashColor: accentColor,
    buttonTheme: base.buttonTheme.copyWith(
      textTheme: ButtonTextTheme.primary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
    ),
    dialogTheme: base.dialogTheme.copyWith(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(20.0),
        ),
      ),
    ),
  );
}

TextTheme _buildAppTextTheme(TextTheme base) {
  return GoogleFonts.latoTextTheme()
      .copyWith(
        headline4: base.headline4.copyWith(
          fontWeight: FontWeight.w200,
        ),
        headline3: base.headline3.copyWith(
          fontWeight: FontWeight.w200,
        ),
        headline5: base.headline5.copyWith(
          fontWeight: FontWeight.w500,
        ),
        headline6: base.headline6.copyWith(
          fontWeight: FontWeight.w400,
        ),
        caption: base.caption.copyWith(
          fontWeight: FontWeight.w400,
        ),
      )
      .apply(
        displayColor: primaryTextColor,
        bodyColor: primaryTextColor,
      )
      .copyWith(
        subtitle2: base.subtitle2.copyWith(
          fontWeight: FontWeight.w400,
          color: secondaryTextColor,
        ),
      );
}
