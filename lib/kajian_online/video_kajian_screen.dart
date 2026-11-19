import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
import 'package:bitaqwa/ui/bi_theme.dart';

/// ID video diverifikasi berasal dari kanal Yufid.TV di YouTube.
class KajianVideo {
  final String id;
  final String title;
  final String speaker;
  final String category;
  final String description;
  const KajianVideo({
    required this.id,
    required this.title,
    required this.speaker,
    required this.category,
    required this.description,
  });
  String get youtubeUrl => 'https://www.youtube.com/watch?v=$id';
  String get thumbnailUrl => 'https://i.ytimg.com/vi/$id/hqdefault.jpg';
}

const List<KajianVideo> kajianVideos = [
  KajianVideo(
    id: 'XaZ_UEkHHSk',
    title: 'Keutamaan Shalat',
    speaker: 'Yufid.TV • Seri Cara Shalat Nabi',
    category: 'Ibadah',
    description: 'Memahami keutamaan shalat dan pentingnya menjaganya dalam kehidupan sehari-hari.',
  ),
  KajianVideo(
    id: '2noOsmSBbmQ',
    title: 'Tips Jitu untuk Istiqomah',
    speaker: 'Ustadz Ahmad Zainuddin • Yufid.TV',
    category: 'Motivasi',
    description: 'Nasihat agar tetap teguh dalam beramal dan menjaga hati.',
  ),
  KajianVideo(
    id: 'ztfq4QIuuDU',
    title: 'Adab Menuntut Ilmu dalam Islam',
    speaker: 'Ustadz Abdullah Roy • Yufid.TV',
    category: 'Ilmu',
    description: 'Belajar adab yang penting saat menuntut dan mengamalkan ilmu.',
  ),
  KajianVideo(
    id: 'ju9z5rT8Y3c',
    title: 'Keutamaan Doa',
    speaker: 'Syaikh Dr. Ibrahim bin Muhammad • Yufid.TV',
    category: 'Ibadah',
    description: 'Kajian tentang makna doa dan keutamaannya dalam ibadah.',
  ),
  KajianVideo(
    id: 'FIZqIkRgs88',
    title: 'Tata Cara Puasa Daud Lengkap',
    speaker: 'Yufid.TV • Panduan Ibadah',
    category: 'Ibadah',
    description: 'Pelajari tuntunan dan gambaran pelaksanaan puasa Daud.',
  ),
];

class VideoKajianScreen extends StatefulWidget {
  const VideoKajianScreen({super.key});
  @override
  State<VideoKajianScreen> createState() => _VideoKajianScreenState();
}

class _VideoKajianScreenState extends State<VideoKajianScreen> {
  String _selected = 'Semua';
  static const categories = ['Semua', 'Ibadah', 'Motivasi', 'Ilmu'];

  void _open(KajianVideo video) {
    Navigator.push(context, MaterialPageRoute(
      builder: (_) => VideoDetailScreen(video: video),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final items = kajianVideos.where((v) =>
        _selected == 'Semua' || v.category == _selected).toList();
    return BiScreen(
      title: 'Video Kajian',
      child: ListView(
        padding: const EdgeInsets.fromLTRB(18, 13, 18, 32),
        children: [
          const BiPageHeader(
            eyebrow: 'Menuntut ilmu setiap hari',
            title: 'Satu kajian,\nbanyak pelajaran.',
            subtitle: 'Tonton langsung di aplikasi atau lanjutkan di YouTube.',
            icon: Icons.ondemand_video_outlined,
          ),
          const SizedBox(height: 23),
          const BiSectionTitle(
            title: 'Kajian Pilihan',
            subtitle: 'Video dari kanal YouTube Yufid.TV.',
          ),
          const SizedBox(height: 13),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(children: categories.map((category) {
              final active = category == _selected;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ChoiceChip(
                  selected: active,
                  label: Text(category),
                  showCheckmark: false,
                  selectedColor: BiColors.forest,
                  backgroundColor: const Color(0xDFFFFFFF),
                  side: BorderSide(color: active ? BiColors.forest : BiColors.line),
                  labelStyle: TextStyle(
                    color: active ? Colors.white : BiColors.deep,
                    fontWeight: FontWeight.w700, fontSize: 11.5,
                  ),
                  onSelected: (_) => setState(() => _selected = category),
                ),
              );
            }).toList()),
          ),
          const SizedBox(height: 17),
          Row(children: [
            Text('${items.length} video tersedia', style: const TextStyle(
              color: BiColors.deep, fontSize: 12,
              fontWeight: FontWeight.w800,
            )),
            const Spacer(),
            const Icon(Icons.play_circle_outline_rounded,
                color: BiColors.forest, size: 18),
          ]),
          const SizedBox(height: 10),
          for (final video in items) ...[
            BiGlassCard(
              padding: const EdgeInsets.all(10),
              onTap: () => _open(video),
              child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: SizedBox(
                    width: 126,
                    height: 100,
                    child: Stack(fit: StackFit.expand, children: [
                      Image.network(
                        video.thumbnailUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) => Container(
                          color: BiColors.mint,
                          child: const Icon(Icons.ondemand_video_rounded,
                            size: 36, color: BiColors.forest),
                        ),
                      ),
                      Container(color: const Color(0x28071913)),
                      Center(child: Container(
                        width: 38, height: 38,
                        decoration: BoxDecoration(
                          color: BiColors.forest.withValues(alpha: .94),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 1.5),
                        ),
                        child: const Icon(Icons.play_arrow_rounded,
                          size: 23, color: Colors.white),
                      )),
                    ]),
                  ),
                ),
                const SizedBox(width: 13),
                Expanded(child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(video.category.toUpperCase(),
                      style: const TextStyle(color: BiColors.emerald,
                        fontSize: 9.5, fontWeight: FontWeight.w800,
                        letterSpacing: 1)),
                    const SizedBox(height: 6),
                    Text(video.title, maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: BiColors.deep,
                        fontWeight: FontWeight.w800, fontSize: 12.5,
                        height: 1.32)),
                    const SizedBox(height: 5),
                    Text(video.speaker, maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: BiColors.muted,
                        fontSize: 10)),
                    const SizedBox(height: 7),
                    const Row(children: [
                      Text('Tonton', style: TextStyle(
                        color: BiColors.forest,
                        fontSize: 10.5, fontWeight: FontWeight.w800)),
                      SizedBox(width: 3),
                      Icon(Icons.arrow_forward_rounded,
                        color: BiColors.forest, size: 16),
                    ]),
                  ],
                )),
              ]),
            ),
            const SizedBox(height: 11),
          ],
          const SizedBox(height: 9),
          const Text('Video menggunakan YouTube dan memerlukan koneksi internet. '
            'Sebagian video mungkin membatasi pemutaran dalam aplikasi; tombol YouTube tetap tersedia.',
            style: TextStyle(color: BiColors.muted, fontSize: 10.8, height: 1.55)),
        ],
      ),
    );
  }
}

class VideoDetailScreen extends StatefulWidget {
  final KajianVideo video;
  const VideoDetailScreen({super.key, required this.video});
  @override
  State<VideoDetailScreen> createState() => _VideoDetailScreenState();
}

class _VideoDetailScreenState extends State<VideoDetailScreen> {
  late final YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController.fromVideoId(
      videoId: widget.video.id,
      autoPlay: false,
      params: const YoutubePlayerParams(
        showControls: true,
        showFullscreenButton: true,
        interfaceLanguage: 'id',
        privacyEnhancedMode: true,
      ),
    );
  }

  @override
  void dispose() {
    _controller.close();
    super.dispose();
  }

  Future<void> _openYoutube() async {
    final url = Uri.parse(widget.video.youtubeUrl);
    try {
      final opened = await launchUrl(url, mode: LaunchMode.externalApplication);
      if (!opened) throw Exception('Tidak ada aplikasi untuk membuka URL.');
    } catch (_) {
      await Clipboard.setData(ClipboardData(text: widget.video.youtubeUrl));
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('YouTube tidak bisa dibuka otomatis. Link sudah disalin.'),
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) => BiScreen(
        title: 'Tonton Kajian',
        child: ListView(
          padding: const EdgeInsets.fromLTRB(18, 13, 18, 32),
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(22),
              child: YoutubePlayer(
                controller: _controller,
                aspectRatio: 16 / 9,
              ),
            ),
            const SizedBox(height: 18),
            BiGlassCard(
              padding: const EdgeInsets.all(19),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  const Icon(Icons.verified_outlined, size: 17, color: BiColors.forest),
                  const SizedBox(width: 7),
                  Expanded(child: Text(widget.video.speaker,
                    style: const TextStyle(color: BiColors.forest,
                      fontSize: 11.5, fontWeight: FontWeight.w700))),
                ]),
                const SizedBox(height: 11),
                Text(widget.video.title,
                  style: const TextStyle(color: BiColors.deep, fontSize: 21,
                    fontWeight: FontWeight.w800, height: 1.3)),
                const SizedBox(height: 12),
                Text(widget.video.description,
                  style: const TextStyle(color: BiColors.muted, fontSize: 12.5, height: 1.6)),
              ]),
            ),
            const SizedBox(height: 17),
            SizedBox(width: double.infinity, child: FilledButton.icon(
              style: FilledButton.styleFrom(
                backgroundColor: BiColors.forest,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              onPressed: _openYoutube,
              icon: const Icon(Icons.open_in_new_rounded, size: 20),
              label: const Text('Tonton di YouTube'),
            )),
            const SizedBox(height: 12),
            const Text('Konten video milik kreator aslinya. Pemutaran mengikuti kebijakan dan ketersediaan YouTube.',
              textAlign: TextAlign.center,
              style: TextStyle(color: BiColors.muted, fontSize: 11, height: 1.5)),
          ],
        ),
      );
}
