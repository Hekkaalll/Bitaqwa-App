import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:bitaqwa/ui/bi_theme.dart';
import 'doa_data.dart';

class DoaScreen extends StatefulWidget {
  const DoaScreen({super.key});
  @override
  State<DoaScreen> createState() => _DoaScreenState();
}

class _DoaScreenState extends State<DoaScreen> {
  final TextEditingController _search = TextEditingController();
  String _category = 'Semua';
  static const categories = ['Semua', 'Harian', 'Al-Qur’an', 'Keluarga', 'Ibadah', 'Perlindungan'];

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final keyword = _search.text.trim().toLowerCase();
    final filtered = doaItems.where((d) {
      final categoryMatch = _category == 'Semua' || d.category == _category;
      final searchMatch = '${d.title} ${d.meaning} ${d.reference}'
          .toLowerCase().contains(keyword);
      return categoryMatch && searchMatch;
    }).toList();

    return BiScreen(
      title: 'Kumpulan Doa',
      child: ListView(
        padding: const EdgeInsets.fromLTRB(18, 13, 18, 32),
        children: [
          const BiPageHeader(
            eyebrow: 'Dekatkan diri kepada Allah',
            title: 'Doa untuk setiap\nlangkah kebaikan.',
            subtitle: 'Bacaan Arab, latin, arti, dan sumber dalam satu tempat.',
            icon: Icons.menu_book_outlined,
          ),
          const SizedBox(height: 22),
          const BiSectionTitle(title: 'Temukan Doa', subtitle: 'Cari berdasarkan judul atau pilih kategori.'),
          const SizedBox(height: 15),
          BiGlassCard(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: TextField(
              controller: _search,
              onChanged: (_) => setState(() {}),
              textInputAction: TextInputAction.search,
              style: const TextStyle(fontSize: 13.5),
              decoration: const InputDecoration(
                border: InputBorder.none,
                prefixIcon: Icon(Icons.search_rounded, color: BiColors.forest),
                hintText: 'Cari doa yang Anda butuhkan...',
                hintStyle: TextStyle(color: BiColors.muted, fontSize: 12.5),
              ),
            ),
          ),
          const SizedBox(height: 13),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(children: categories.map((category) {
              final active = _category == category;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ChoiceChip(
                  label: Text(category),
                  selected: active,
                  selectedColor: BiColors.forest,
                  backgroundColor: const Color(0xDBFFFFFF),
                  showCheckmark: false,
                  side: BorderSide(color: active ? BiColors.forest : BiColors.line),
                  labelStyle: TextStyle(
                    color: active ? Colors.white : BiColors.deep,
                    fontWeight: FontWeight.w700, fontSize: 11.5,
                  ),
                  onSelected: (_) => setState(() => _category = category),
                ),
              );
            }).toList()),
          ),
          const SizedBox(height: 19),
          Row(children: [
            Text('${filtered.length} doa ditemukan', style: const TextStyle(
              fontSize: 12, color: BiColors.deep, fontWeight: FontWeight.w800,
            )),
            const Spacer(),
            const Icon(Icons.format_list_bulleted_rounded,
                color: BiColors.forest, size: 17),
          ]),
          const SizedBox(height: 10),
          if (filtered.isEmpty)
            const BiGlassCard(child: Text('Tidak ada doa yang cocok. Coba kata kunci lain.')),
          for (final doa in filtered) ...[
            BiGlassCard(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 13),
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => DoaDetailScreen(doa: doa))),
              child: Row(children: [
                Container(
                  width: 45, height: 45,
                  decoration: BoxDecoration(
                    color: BiColors.mint,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(Icons.auto_stories_outlined,
                      size: 22, color: BiColors.forest),
                ),
                const SizedBox(width: 12),
                Expanded(child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(doa.title, maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: BiColors.deep,
                          fontSize: 13.2, fontWeight: FontWeight.w800)),
                    const SizedBox(height: 4),
                    Text('${doa.category}  •  ${doa.reference}',
                      maxLines: 1, overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: BiColors.muted, fontSize: 10.5)),
                  ],
                )),
                const SizedBox(width: 7),
                const Icon(Icons.arrow_forward_rounded,
                    color: BiColors.forest, size: 18),
              ]),
            ),
            const SizedBox(height: 10),
          ],
          const SizedBox(height: 10),
          const Text('Bacaan latin merupakan bantuan pelafalan. Utamakan pembelajaran bacaan Arab yang benar.',
              style: TextStyle(color: BiColors.muted, fontSize: 11, height: 1.5)),
        ],
      ),
    );
  }
}

class DoaDetailScreen extends StatelessWidget {
  final DoaItem doa;
  const DoaDetailScreen({super.key, required this.doa});

  @override
  Widget build(BuildContext context) => BiScreen(
        title: 'Bacaan Doa',
        child: ListView(
          padding: const EdgeInsets.fromLTRB(18, 13, 18, 32),
          children: [
            BiPageHeader(
              eyebrow: doa.category,
              title: doa.title,
              subtitle: doa.reference,
              icon: Icons.auto_stories_outlined,
            ),
            const SizedBox(height: 18),
            BiGlassCard(
              padding: const EdgeInsets.all(22),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text('BACAAN ARAB', style: TextStyle(
                    color: BiColors.forest, letterSpacing: 1.5,
                    fontWeight: FontWeight.w800, fontSize: 10.5)),
                const SizedBox(height: 18),
                Directionality(
                  textDirection: TextDirection.rtl,
                  child: SizedBox(
                    width: double.infinity,
                    child: Text(doa.arabic, textAlign: TextAlign.right,
                      style: const TextStyle(fontSize: 26, height: 2.05,
                          color: BiColors.deep)),
                  ),
                ),
              ]),
            ),
            const SizedBox(height: 12),
            BiGlassCard(child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('LATIN', style: TextStyle(
                    color: BiColors.forest, fontSize: 10.5,
                    fontWeight: FontWeight.w800, letterSpacing: 1.5)),
                const SizedBox(height: 8),
                Text(doa.latin, style: const TextStyle(
                    color: BiColors.deep, fontSize: 13.5, height: 1.8)),
                const SizedBox(height: 20),
                const Text('ARTI', style: TextStyle(
                    color: BiColors.forest, fontSize: 10.5,
                    fontWeight: FontWeight.w800, letterSpacing: 1.5)),
                const SizedBox(height: 8),
                Text(doa.meaning, style: const TextStyle(
                    color: BiColors.deep, fontSize: 13, height: 1.65)),
                const SizedBox(height: 12),
                Text('Sumber: ${doa.reference}', style: const TextStyle(
                    color: BiColors.muted, fontSize: 11)),
              ],
            )),
            const SizedBox(height: 19),
            SizedBox(width: double.infinity, child: FilledButton.icon(
              onPressed: () async {
                await Clipboard.setData(ClipboardData(
                    text: '${doa.title}\n${doa.arabic}\n${doa.latin}\n${doa.meaning}\n${doa.reference}'));
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Bacaan doa disalin.')));
                }
              },
              icon: const Icon(Icons.copy_rounded, size: 18),
              label: const Text('Salin bacaan doa'),
              style: FilledButton.styleFrom(
                backgroundColor: BiColors.forest,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
            )),
          ],
        ),
      );
}
