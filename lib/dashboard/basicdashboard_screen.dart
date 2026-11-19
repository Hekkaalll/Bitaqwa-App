import 'package:flutter/material.dart';
import 'package:bitaqwa/dashboard/menu_data.dart';
import 'package:bitaqwa/ui/bi_theme.dart';

/// Beranda baru: kartu lebih proporsional, ikon menu ASLI tidak dimodifikasi.
class BasicDashboardScreen extends StatelessWidget {
  const BasicDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: BiColors.cream,
        body: SafeArea(
          child: BiBackground(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 640),
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(18, 8, 18, 28),
                  children: [
                    Row(children: [
                      Container(
                        width: 32, height: 32,
                        decoration: BoxDecoration(
                          color: BiColors.mint,
                          borderRadius: BorderRadius.circular(11),
                        ),
                        child: const Icon(Icons.auto_awesome_rounded,
                            size: 18, color: BiColors.forest),
                      ),
                      const SizedBox(width: 9),
                      const Expanded(child: Text('bitaqwa App',
                          style: TextStyle(color: BiColors.deep,
                              fontSize: 19, fontWeight: FontWeight.w800))),
                      IconButton(
                        tooltip: 'Tentang aplikasi',
                        icon: const Icon(Icons.info_outline_rounded,
                            color: BiColors.deep),
                        onPressed: () => showAboutDialog(
                          context: context,
                          applicationName: 'Bitaqwa App',
                          applicationVersion: '1.0.0',
                          children: [const Text('Teman ibadah harian Anda.')],
                        ),
                      ),
                    ]),
                    const SizedBox(height: 12),
                    const BiPageHeader(
                      eyebrow: "Assalamu'alaikum",
                      title: 'Mulai hari dengan kebaikan.',
                      subtitle: 'Temukan panduan ibadah dalam satu tempat.',
                      icon: Icons.mosque_outlined,
                    ),
                    const SizedBox(height: 25),
                    Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
                      const Expanded(child: BiSectionTitle(
                        title: 'Aplikasi Ibadah Harian',
                        subtitle: 'Semua kebutuhan ibadah di satu tempat.',
                      )),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 9, vertical: 6),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE0F0E7),
                          borderRadius: BorderRadius.circular(9),
                        ),
                        child: const Text('4 FITUR', style: TextStyle(
                          color: BiColors.forest,
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          letterSpacing: .6,
                        )),
                      ),
                    ]),
                    const SizedBox(height: 15),
                    LayoutBuilder(builder: (context, box) {
                      final compact = box.maxWidth < 350;
                      final tileHeight = compact ? 174.0 : 154.0;
                      return GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: menus.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          mainAxisExtent: tileHeight,
                        ),
                        itemBuilder: (context, index) {
                          final item = menus[index];
                          return BiGlassCard(
                            radius: BorderRadius.circular(23),
                            tint: const Color(0xEAFDFFFD),
                            padding: const EdgeInsets.all(13),
                            onTap: () => Navigator.pushNamed(context, item.route),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(children: [
                                  Container(
                                    width: 47, height: 47,
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFE4F2E9),
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: Image.asset(
                                      item.image, fit: BoxFit.contain,
                                      errorBuilder: (_, _, _) => const Icon(
                                        Icons.image_outlined,
                                        color: BiColors.forest,
                                      ),
                                    ),
                                  ),
                                  const Spacer(),
                                  Container(
                                    width: 28, height: 28,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFF1F7F1),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: const Icon(Icons.arrow_outward_rounded,
                                        size: 17, color: BiColors.forest),
                                  ),
                                ]),
                                const Spacer(),
                                Text(item.title,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: BiColors.deep,
                                    fontSize: 13.5,
                                    fontWeight: FontWeight.w800,
                                    height: 1.22,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(_subtitle(item.route),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: BiColors.muted,
                                    fontSize: 10,
                                    height: 1.3,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    }),
                    const SizedBox(height: 18),
                    const BiGlassCard(
                      padding: EdgeInsets.all(16),
                      tint: Color(0xE7E0F0E7),
                      child: Row(children: [
                        Icon(Icons.favorite_border_rounded,
                            color: BiColors.forest, size: 23),
                        SizedBox(width: 13),
                        Expanded(child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Kebaikan kecil, makna besar',
                              style: TextStyle(fontSize: 12.5,
                                  color: BiColors.deep,
                                  fontWeight: FontWeight.w800)),
                            SizedBox(height: 3),
                            Text('Jalani ibadah dengan tenang, satu hari setiap waktu.',
                              style: TextStyle(fontSize: 10.7,
                                  color: BiColors.muted, height: 1.5)),
                          ],
                        )),
                      ]),
                    ),
                    const SizedBox(height: 20),
                    const Center(child: Text('B I T A Q W A  •  TEMAN IBADAH HARIAN',
                      style: TextStyle(fontSize: 9,
                          color: BiColors.muted, letterSpacing: 1.1))),
                  ],
                ),
              ),
            ),
          ),
        ),
      );

  String _subtitle(String route) => switch (route) {
        'doa' => 'Bacaan doa sehari-hari',
        'zakat' => 'Hitung zakat mal',
        'jadwal-sholat' => 'Waktu shalat sesuai kota',
        'video-kajian' => 'Tonton kajian pilihan',
        _ => 'Teman ibadah Anda',
      };
}
