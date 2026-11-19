import 'package:intl/intl.dart';

/// Logika kalkulator zakat mal, diadaptasi dari folder Zakat yang diberikan.
///
/// Perhitungan dasar ini menggunakan nisab 85 gram emas dan kadar zakat 2,5%.
/// Kelayakan zakat secara lengkap juga memerlukan pemeriksaan haul dan syarat
/// lainnya; hasil kalkulator adalah estimasi, bukan penetapan kewajiban final.
class ZakatLogic {
  static const double nisabEmasGram = 85.0;
  static const double kadarZakat = 0.025;

  static double hitungNisabRupiah(double hargaEmasPerGram) {
    return nisabEmasGram * hargaEmasPerGram;
  }

  static bool apakahWajibZakat({
    required double totalHarta,
    required double hargaEmasPerGram,
  }) {
    final batasNisab = hitungNisabRupiah(hargaEmasPerGram);
    return totalHarta >= batasNisab;
  }

  static double hitungZakat(double totalHarta) {
    return totalHarta * kadarZakat;
  }

  static String formatRupiah(double nominal) {
    return NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    ).format(nominal);
  }
}
