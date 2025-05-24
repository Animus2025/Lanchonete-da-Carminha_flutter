import 'package:flutter/material.dart';

class AppColors {
  // Cores principais
  static const Color laranja = Color(0xFFF6C484);       // Laranja
  static const Color preto = Color(0xFF000000);     // Preto
  static const Color branco = Color(0xFFF6F6F6);     // Fundo claro
  static const Color pretoClaro = Color(0xFF1B1B1B); // Fundo escuro

  // Cores de texto
  static const Color textPrimary = preto;   // Preto (Texto padrão no modo claro)
  static const Color darkTextPrimary = laranja;         // Laranja (Texto primário no modo escuro)
  static const Color textSecondary = laranja;           // Laranja (Texto secundário no modo claro)
  static const Color darkTextSecondary = preto;     // Preto (Texto secundário no modo escuro)
  static const Color cinza = Colors.grey;

  // Outros
  static const Color vermelho = Colors.redAccent;
  static const Color azulClaro = Color(0xFFAAEFEF);
  static const Color verde = Colors.green;     // Azul claro
}

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: AppColors.laranja,
    scaffoldBackgroundColor: AppColors.branco,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.preto, // Fundo preto
      foregroundColor: AppColors.laranja, // Texto e ícones na cor laranja
      titleTextStyle: TextStyle(
        color: AppColors.laranja,
        fontWeight: FontWeight.bold,
        fontSize: 20,
        fontFamily: 'BebasNeue', // Fonte BebasNeue para o AppBar
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.laranja, // Fundo laranja
        foregroundColor: AppColors.preto, // Texto preto
        textStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          fontFamily: 'BebasNeue', // Fonte BebasNeue para botões
        ),
      ),
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(
        color: AppColors.textPrimary,
        fontFamily: 'BebasNeue', // Fonte BebasNeue para textos grandes
      ), // Texto primário no modo claro
      bodyMedium: TextStyle(
        color: AppColors.textSecondary,
        fontFamily: 'BebasNeue', // Fonte BebasNeue para textos médios
      ), // Texto secundário no modo claro
      bodySmall: TextStyle(
        color: AppColors.textPrimary,
        fontFamily: 'BebasNeue', // Fonte BebasNeue para textos pequenos
      ),
    ),
    colorScheme: ColorScheme.fromSwatch().copyWith(
      secondary: AppColors.preto,
    ),
    fontFamily: 'BebasNeue', // Fonte padrão para todo o aplicativo
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: AppColors.laranja,
    scaffoldBackgroundColor: AppColors.pretoClaro,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.preto,
      foregroundColor: AppColors.laranja,
      titleTextStyle: TextStyle(
        color: AppColors.laranja,
        fontWeight: FontWeight.bold,
        fontSize: 20,
        fontFamily: 'BebasNeue', // Fonte BebasNeue para o AppBar
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.laranja,
        foregroundColor: AppColors.preto,
        textStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          fontFamily: 'BebasNeue', // Fonte BebasNeue para botões
        ),
      ),
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(
        color: AppColors.darkTextPrimary,
        fontFamily: 'BebasNeue', // Fonte BebasNeue para textos grandes
      ), // Texto primário no modo escuro
      bodyMedium: TextStyle(
        color: AppColors.darkTextSecondary,
        fontFamily: 'BebasNeue', // Fonte BebasNeue para textos médios
      ), // Texto secundário no modo escuro
      bodySmall: TextStyle(
        color: AppColors.darkTextPrimary,
        fontFamily: 'BebasNeue', // Fonte BebasNeue para textos pequenos
      ),
    ),
    colorScheme: ColorScheme.dark().copyWith(
      secondary: AppColors.preto,
    ),
    fontFamily: 'BebasNeue', // Fonte padrão para todo o aplicativo
  );
}
