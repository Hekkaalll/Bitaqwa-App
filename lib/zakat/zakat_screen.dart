import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:bitaqwa/ui/bi_theme.dart';
import 'package:bitaqwa/zakat/zakat_logic.dart';
import 'package:bitaqwa/zakat/zakat_result_card.dart';

/// Halaman Kalkulator Zakat Mal.
/// Rumus mengikuti berkas yang diberikan: nisab 85g emas, kadar 2,5%.
class ZakatScreen extends StatefulWidget {
  const ZakatScreen({super.key});

  @override
  State<ZakatScreen> createState() => _ZakatScreenState();
}

class _ZakatScreenState extends State<ZakatScreen> {
  final MoneyMaskedTextController _totalHartaController =
      MoneyMaskedTextController(
    thousandSeparator: '.',
    decimalSeparator: '',
    precision: 0,
  );

  // Tidak menggunakan default harga emas: user mengisi nilai yang berlaku.
  final MoneyMaskedTextController _hargaEmasController =
      MoneyMaskedTextController(
    thousandSeparator: '.',
    decimalSeparator: '',
    precision: 0,
  );

  bool _sudahDihitung = false;
  bool _wajibZakat = false;
  double _batasNisab = 0;
  double _nominalZakat = 0;
  double _totalHarta = 0;

  void _batalkanHasilLama(String _) {
    if (_sudahDihitung) setState(() => _sudahDihitung = false);
  }

  void _hitungZakat() {
    FocusScope.of(context).unfocus();
    final totalHarta = _totalHartaController.numberValue;
    final hargaEmas = _hargaEmasController.numberValue;

    if (!totalHarta.isFinite || !hargaEmas.isFinite ||
        totalHarta <= 0 || hargaEmas <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Isi total harta dan harga emas per gram dengan nominal yang benar.'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: BiColors.forest,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
      return;
    }

    final batas = ZakatLogic.hitungNisabRupiah(hargaEmas);
    if (!batas.isFinite || batas <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nominal harga emas terlalu besar. Periksa lagi input Anda.')),
      );
      return;
    }
    final memenuhiNisab = ZakatLogic.apakahWajibZakat(
      totalHarta: totalHarta,
      hargaEmasPerGram: hargaEmas,
    );
    final nilaiZakat = memenuhiNisab ? ZakatLogic.hitungZakat(totalHarta) : 0.0;

    setState(() {
      _sudahDihitung = true;
      _wajibZakat = memenuhiNisab;
      _batasNisab = batas;
      _nominalZakat = nilaiZakat;
      _totalHarta = totalHarta;
    });
  }

  void _reset() {
    FocusScope.of(context).unfocus();
    setState(() {
      _totalHartaController.updateValue(0);
      _hargaEmasController.updateValue(0);
      _sudahDihitung = false;
      _wajibZakat = false;
      _batasNisab = 0;
      _nominalZakat = 0;
      _totalHarta = 0;
    });
  }

  Future<void> _salinHasil() async {
    final label = _wajibZakat ? 'Harta mencapai nisab' : 'Harta belum mencapai nisab';
    final ringkasan = 'Bitaqwa · Kalkulator Zakat Mal\n'
        '$label\n'
        'Total harta: ${ZakatLogic.formatRupiah(_totalHarta)}\n'
        'Nisab (85g emas): ${ZakatLogic.formatRupiah(_batasNisab)}\n'
        'Estimasi zakat (2,5%): ${ZakatLogic.formatRupiah(_nominalZakat)}\n'
        'Catatan: Pastikan syarat haul dan ketentuan zakat lainnya.';
    await Clipboard.setData(ClipboardData(text: ringkasan));
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Hasil perhitungan disalin.')),
    );
  }

  @override
  void dispose() {
    _totalHartaController.dispose();
    _hargaEmasController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => BiScreen(
        title: 'Kalkulator Zakat',
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 640),
            child: ListView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              padding: const EdgeInsets.fromLTRB(18, 13, 18, 32),
              children: [
                const BiPageHeader(
                  eyebrow: 'ZAKAT MAL · BERSIHKAN HARTA',
                  title: 'Berbagi kebaikan,\nmenumbuhkan berkah.',
                  subtitle: 'Hitung estimasi zakat mal dengan mudah dan transparan.',
                  icon: Icons.volunteer_activism_outlined,
                ),
                const SizedBox(height: 18),
                const Row(
                  children: [
                    Expanded(
                      child: _FactChip(
                        icon: Icons.scale_rounded,
                        value: '85 gram',
                        label: 'Nisab emas',
                      ),
                    ),
                    SizedBox(width: 11),
                    Expanded(
                      child: _FactChip(
                        icon: Icons.percent_rounded,
                        value: '2,5%',
                        label: 'Kadar zakat',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 22),
                const BiSectionTitle(
                  title: 'Hitung zakat Anda',
                  subtitle: 'Masukkan nominal harta dan harga emas murni per gram.',
                ),
                const SizedBox(height: 14),
                BiGlassCard(
                  tint: const Color(0xE4F7FFF9),
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          _StepBadge('01'),
                          SizedBox(width: 10),
                          Text('DATA PERHITUNGAN',
                              style: TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 11,
                                letterSpacing: 1.15,
                                color: BiColors.forest,
                              )),
                        ],
                      ),
                      const SizedBox(height: 22),
                      _CurrencyField(
                        label: 'Total harta yang dihitung',
                        hint: 'Contoh: 150.000.000',
                        helper: 'Jumlah tabungan, emas, dan aset yang diperhitungkan dalam zakat mal.',
                        controller: _totalHartaController,
                        icon: Icons.account_balance_wallet_outlined,
                        onChanged: _batalkanHasilLama,
                      ),
                      const SizedBox(height: 17),
                      _CurrencyField(
                        label: 'Harga emas murni / gram',
                        hint: 'Masukkan harga emas terbaru',
                        helper: 'Isi secara manual sesuai harga emas yang Anda jadikan acuan.',
                        controller: _hargaEmasController,
                        icon: Icons.diamond_outlined,
                        onChanged: _batalkanHasilLama,
                      ),
                      const SizedBox(height: 18),
                      Row(
                        children: [
                          Expanded(
                            child: FilledButton.icon(
                              onPressed: _hitungZakat,
                              icon: const Icon(Icons.calculate_outlined, size: 19),
                              label: const Text('Hitung Zakat'),
                              style: FilledButton.styleFrom(
                                backgroundColor: BiColors.forest,
                                foregroundColor: Colors.white,
                                textStyle: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w800,
                                ),
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15)),
                              ),
                            ),
                          ),
                          const SizedBox(width: 11),
                          IconButton.filledTonal(
                            tooltip: 'Reset semua input',
                            onPressed: _reset,
                            style: IconButton.styleFrom(
                              backgroundColor: const Color(0xFFE2F0E6),
                              foregroundColor: BiColors.forest,
                              padding: const EdgeInsets.all(15),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15)),
                            ),
                            icon: const Icon(Icons.restart_alt_rounded),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 22),
                const BiSectionTitle(
                  title: 'Hasil perhitungan',
                  subtitle: 'Ringkasan estimasi berdasarkan data yang Anda masukkan.',
                ),
                const SizedBox(height: 13),
                ZakatResultCard(
                  sudahDihitung: _sudahDihitung,
                  wajibZakat: _wajibZakat,
                  batasNisab: _batasNisab,
                  nominalZakat: _nominalZakat,
                  totalHarta: _totalHarta,
                  onCopy: _sudahDihitung ? _salinHasil : null,
                ),
                const SizedBox(height: 23),
                const BiSectionTitle(
                  title: 'Cara menghitungnya',
                  subtitle: 'Rumus sederhana sesuai modul yang Anda kirim.',
                ),
                const SizedBox(height: 13),
                const BiGlassCard(
                  padding: EdgeInsets.all(18),
                  tint: Color(0xD9ECF8F0),
                  child: Column(
                    children: [
                      _FormulaLine(
                        index: '01',
                        title: 'Hitung batas nisab',
                        detail: '85 gram × harga emas per gram',
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 19),
                        child: Divider(height: 27, color: Color(0xFFD6E8DC)),
                      ),
                      _FormulaLine(
                        index: '02',
                        title: 'Periksa nilai total harta',
                        detail: 'Bandingkan total harta dengan nilai nisab.',
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 19),
                        child: Divider(height: 27, color: Color(0xFFD6E8DC)),
                      ),
                      _FormulaLine(
                        index: '03',
                        title: 'Hitung zakat 2,5%',
                        detail: 'Jika telah memenuhi nisab, 2,5% × total harta.',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 17),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.info_outline_rounded,
                          size: 17, color: BiColors.forest),
                      SizedBox(width: 9),
                      Expanded(
                        child: Text(
                          'Bitaqwa tidak mengambil harga emas otomatis. '
                          'Perhitungan ini hanya membantu estimasi zakat mal; '
                          'pastikan syarat haul dan ketentuan zakat lain sebelum membayar.',
                          style: TextStyle(
                            fontSize: 11,
                            color: BiColors.muted,
                            height: 1.6,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}

class _StepBadge extends StatelessWidget {
  final String text;
  const _StepBadge(this.text);

  @override
  Widget build(BuildContext context) => Container(
        width: 32,
        height: 32,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: const Color(0xFFDAEFE3),
        ),
        child: Text(text, style: const TextStyle(
          color: BiColors.forest, fontSize: 11, fontWeight: FontWeight.w800,
        )),
      );
}

class _FactChip extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  const _FactChip({required this.icon, required this.value, required this.label});

  @override
  Widget build(BuildContext context) => BiGlassCard(
        tint: const Color(0xDFF0FAF3),
        padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 15),
        child: Row(
          children: [
            Icon(icon, color: BiColors.forest, size: 21),
            const SizedBox(width: 9),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(value, style: const TextStyle(
                    fontSize: 14, fontWeight: FontWeight.w800, color: BiColors.deep,
                  )),
                  const SizedBox(height: 2),
                  Text(label, style: const TextStyle(
                    color: BiColors.muted, fontSize: 10, height: 1.3,
                  )),
                ],
              ),
            ),
          ],
        ),
      );
}

class _CurrencyField extends StatelessWidget {
  final String label;
  final String hint;
  final String helper;
  final MoneyMaskedTextController controller;
  final IconData icon;
  final ValueChanged<String> onChanged;

  const _CurrencyField({
    required this.label,
    required this.hint,
    required this.helper,
    required this.controller,
    required this.icon,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(
            fontWeight: FontWeight.w800, fontSize: 12.5, color: BiColors.deep,
          )),
          const SizedBox(height: 8),
          TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            onChanged: onChanged,
            textInputAction: TextInputAction.done,
            style: const TextStyle(
                color: BiColors.deep, fontSize: 16, fontWeight: FontWeight.w700),
            decoration: InputDecoration(
              prefixIcon: Icon(icon, color: BiColors.forest, size: 19),
              prefixText: 'Rp  ',
              hintText: hint,
              hintStyle: const TextStyle(
                color: Color(0xFF96A99E), fontSize: 12.5,
                fontWeight: FontWeight.w400,
              ),
              filled: true,
              fillColor: Colors.white.withValues(alpha: .88),
              contentPadding: const EdgeInsets.symmetric(
                  horizontal: 13, vertical: 18),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: const BorderSide(color: Color(0xFFD8E9DD)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: const BorderSide(color: BiColors.emerald, width: 1.7),
              ),
            ),
          ),
          const SizedBox(height: 7),
          Text(helper, style: const TextStyle(
            color: BiColors.muted, fontSize: 10.7, height: 1.5,
          )),
        ],
      );
}

class _FormulaLine extends StatelessWidget {
  final String index;
  final String title;
  final String detail;
  const _FormulaLine({required this.index, required this.title, required this.detail});

  @override
  Widget build(BuildContext context) => Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 34,
            height: 34,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFFDDF0E4),
            ),
            child: Text(index,
                style: const TextStyle(
                  color: BiColors.forest,
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                )),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(
                  color: BiColors.deep, fontSize: 12.2,
                  fontWeight: FontWeight.w800,
                )),
                const SizedBox(height: 4),
                Text(detail, style: const TextStyle(
                  color: BiColors.muted, fontSize: 11.2, height: 1.45,
                )),
              ],
            ),
          ),
        ],
      );
}
