import 'package:flutter/material.dart';
import 'package:bitaqwa/ui/bi_theme.dart';
import 'package:bitaqwa/zakat/zakat_logic.dart';

/// Kartu hasil: mengikuti rumus dan keluaran folder Zakat asli, tetapi
/// menggunakan warna emerald dan glass-card Bitaqwa.
class ZakatResultCard extends StatelessWidget {
  final bool sudahDihitung;
  final bool wajibZakat;
  final double batasNisab;
  final double nominalZakat;
  final double totalHarta;
  final VoidCallback? onCopy;

  const ZakatResultCard({
    super.key,
    required this.sudahDihitung,
    required this.wajibZakat,
    required this.batasNisab,
    required this.nominalZakat,
    required this.totalHarta,
    this.onCopy,
  });

  @override
  Widget build(BuildContext context) {
    if (!sudahDihitung) {
      return BiGlassCard(
        tint: const Color(0xDDE9F5ED),
        padding: const EdgeInsets.all(19),
        child: Row(
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.74),
                borderRadius: BorderRadius.circular(15),
              ),
              child: const Icon(
                Icons.receipt_long_outlined,
                color: BiColors.forest,
                size: 23,
              ),
            ),
            const SizedBox(width: 13),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Hasil perhitungan Anda',
                      style: TextStyle(
                        color: BiColors.deep,
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                      )),
                  SizedBox(height: 4),
                  Text('Isi nominal harta dan harga emas, lalu ketuk Hitung Zakat.',
                      style: TextStyle(
                        color: BiColors.muted,
                        fontSize: 11.5,
                        height: 1.5,
                      )),
                ],
              ),
            ),
          ],
        ),
      );
    }

    final ratio = batasNisab > 0
        ? (totalHarta / batasNisab).clamp(0.0, 1.0).toDouble()
        : 0.0;

    return BiGlassCard(
      tint: const Color(0xECF6FFF8),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 41,
                height: 41,
                decoration: BoxDecoration(
                  color: wajibZakat
                      ? const Color(0xFFD5EFE0)
                      : const Color(0xFFFFF0D6),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  wajibZakat
                      ? Icons.verified_rounded
                      : Icons.info_outline_rounded,
                  color: wajibZakat ? BiColors.forest : const Color(0xFF966118),
                  size: 22,
                ),
              ),
              const SizedBox(width: 11),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('STATUS PERHITUNGAN',
                        style: TextStyle(
                          color: BiColors.muted,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.15,
                        )),
                    const SizedBox(height: 4),
                    Text(
                      wajibZakat ? 'Harta mencapai nisab' : 'Harta belum mencapai nisab',
                      style: const TextStyle(
                        color: BiColors.deep,
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
              if (onCopy != null)
                IconButton(
                  tooltip: 'Salin hasil perhitungan',
                  onPressed: onCopy,
                  icon: const Icon(Icons.copy_rounded,
                      color: BiColors.forest, size: 20),
                ),
            ],
          ),
          const SizedBox(height: 19),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(19),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [BiColors.emerald, BiColors.forest, Color(0xFF105044)],
              ),
              borderRadius: BorderRadius.circular(19),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(wajibZakat ? 'ESTIMASI ZAKAT MAL · 2,5%' : 'ZAKAT MAL SAAT INI',
                    style: const TextStyle(
                      color: Color(0xFFD7EFE4),
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1,
                    )),
                const SizedBox(height: 8),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    ZakatLogic.formatRupiah(nominalZakat),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.w800,
                      height: 1.25,
                    ),
                  ),
                ),
                const SizedBox(height: 7),
                Text(
                  wajibZakat
                      ? 'Perkiraan zakat jika syarat lain juga terpenuhi.'
                      : 'Belum mencapai ambang nisab pada input ini.',
                  style: const TextStyle(
                      color: Color(0xFFE1F1E9), fontSize: 11, height: 1.45),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          _ResultRow(
            label: 'Total harta',
            value: ZakatLogic.formatRupiah(totalHarta),
          ),
          const SizedBox(height: 12),
          _ResultRow(
            label: 'Nisab · 85 gram emas',
            value: ZakatLogic.formatRupiah(batasNisab),
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Pencapaian nisab',
                  style: TextStyle(color: BiColors.muted, fontSize: 11.5)),
              Text(wajibZakat ? '100% atau lebih' : '${(ratio * 100).toStringAsFixed(1)}%',
                  style: const TextStyle(
                      color: BiColors.deep,
                      fontWeight: FontWeight.w700,
                      fontSize: 11.5)),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: LinearProgressIndicator(
              minHeight: 8,
              value: ratio,
              color: BiColors.emerald,
              backgroundColor: const Color(0xFFDBE9DF),
            ),
          ),
          const SizedBox(height: 13),
          const Text(
            'Catatan: Periksa pula masa kepemilikan (haul), jenis harta, kewajiban terkait, dan ketentuan zakat yang berlaku. Ini adalah estimasi sederhana.',
            style: TextStyle(color: BiColors.muted, fontSize: 11, height: 1.55),
          ),
        ],
      ),
    );
  }
}

class _ResultRow extends StatelessWidget {
  final String label;
  final String value;
  const _ResultRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) => Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(label, style: const TextStyle(
              color: BiColors.muted, fontSize: 11.5, height: 1.4,
            )),
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Text(value,
                textAlign: TextAlign.right,
                style: const TextStyle(
                  color: BiColors.deep,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  height: 1.4,
                )),
          ),
        ],
      );
}
