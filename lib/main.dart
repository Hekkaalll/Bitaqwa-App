import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:bitaqwa/dashboard/basicdashboard_screen.dart';
import 'package:bitaqwa/doa_harian/doa_screen.dart';
import 'package:bitaqwa/jadwal_sholat/jadwal_sholat_screen.dart';
import 'package:bitaqwa/kajian_online/video_kajian_screen.dart';
import 'package:bitaqwa/zakat/zakat_screen.dart';
import 'package:bitaqwa/ui/bi_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id_ID', null);
  runApp(const BitaqwaApp());
}

class BitaqwaApp extends StatelessWidget {
  const BitaqwaApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Bitaqwa App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          scaffoldBackgroundColor: BiColors.cream,
          colorScheme: ColorScheme.fromSeed(
            seedColor: BiColors.emerald,
            primary: BiColors.forest,
            surface: BiColors.cream,
          ),
          appBarTheme: const AppBarTheme(surfaceTintColor: Colors.transparent),
          filledButtonTheme: FilledButtonThemeData(
            style: FilledButton.styleFrom(
              backgroundColor: BiColors.forest,
              foregroundColor: Colors.white,
              minimumSize: const Size(0, 48),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          ),
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: Colors.white.withValues(alpha: .93),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14, vertical: 13,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: BiColors.line),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: BiColors.line),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: BiColors.emerald, width: 1.5),
            ),
          ),
          snackBarTheme: SnackBarThemeData(
            backgroundColor: BiColors.deep,
            contentTextStyle: const TextStyle(color: Colors.white),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(13),
            ),
          ),
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => const BasicDashboardScreen(),
          'doa': (context) => const DoaScreen(),
          'jadwal-sholat': (context) => const JadwalSholatScreen(),
          'video-kajian': (context) => const VideoKajianScreen(),
          'zakat': (context) => const ZakatScreen(),
        },
      );
}
