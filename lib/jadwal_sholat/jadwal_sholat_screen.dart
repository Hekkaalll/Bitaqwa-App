import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:bitaqwa/ui/bi_theme.dart';

/// Jadwal online AlAdhan (metode hitung 20: Kementerian Agama RI).
/// Bukan API resmi Kemenag; cocokkan waktu dengan masjid setempat.
class JadwalSholatScreen extends StatefulWidget {
  const JadwalSholatScreen({super.key});
  @override
  State<JadwalSholatScreen> createState() => _JadwalSholatScreenState();
}

class _JadwalSholatScreenState extends State<JadwalSholatScreen> {
  // Daftar kota WIB untuk memastikan tanggal/waktu relatif yang ditampilkan sesuai zona.
  static const cities = <String>[
    'Bogor', 'Jakarta', 'Bandung', 'Depok', 'Bekasi', 'Tangerang',
    'Yogyakarta', 'Semarang', 'Surabaya', 'Malang', 'Medan',
  ];
  static const prayers = <(String, String, IconData)>[
    ('Subuh', 'Fajr', Icons.nights_stay_rounded),
    ('Terbit', 'Sunrise', Icons.wb_twilight_outlined),
    ('Zuhur', 'Dhuhr', Icons.wb_sunny_outlined),
    ('Asar', 'Asr', Icons.wb_cloudy_outlined),
    ('Magrib', 'Maghrib', Icons.wb_twilight_rounded),
    ('Isya', 'Isha', Icons.dark_mode_outlined),
  ];
  static const obligatoryKeys = ['Fajr', 'Dhuhr', 'Asr', 'Maghrib', 'Isha'];

  String _city = 'Bogor';
  Map<String, String>? _times;
  bool _loading = true;
  String? _error;
  late DateTime _date;
  Timer? _clock;

  /// Komponen jam lokal WIB (tanpa mengandalkan zona waktu HP pengguna).
  DateTime _wibNow() => DateTime.now().toUtc().add(const Duration(hours: 7));

  @override
  void initState() {
    super.initState();
    _date = _wibNow();
    _load();
    _clock = Timer.periodic(const Duration(minutes: 1), (_) {
      if (!mounted) return;
      final current = _wibNow();
      if (DateUtils.isSameDay(current, _date)) {
        setState(() {});
      } else {
        _load();
      }
    });
  }

  @override
  void dispose() {
    _clock?.cancel();
    super.dispose();
  }

  Future<void> _load() async {
    final city = _city;
    final date = _wibNow();
    setState(() {
      _loading = true;
      _error = null;
      _times = null;
      _date = date;
    });
    try {
      final uri = Uri.https(
        'api.aladhan.com',
        '/v1/timingsByCity/${DateFormat('dd-MM-yyyy').format(date)}',
        {
          'city': city,
          'country': 'Indonesia',
          'method': '20',
          'school': '0',
          'timezonestring': 'Asia/Jakarta',
        },
      );
      final response = await http.get(uri).timeout(const Duration(seconds: 14));
      if (response.statusCode != 200) {
        throw Exception('Server jadwal tidak dapat dihubungi.');
      }
      final decoded = jsonDecode(response.body) as Map<String, dynamic>;
      if (decoded['code'] != 200) throw Exception('Data waktu shalat tidak tersedia.');
      final body = decoded['data'] as Map<String, dynamic>;
      final raw = body['timings'] as Map<String, dynamic>;
      final result = <String, String>{};
      for (final entry in raw.entries) {
        final match = RegExp(r'^\d{2}:\d{2}').firstMatch('${entry.value}');
        if (match != null) result[entry.key] = match.group(0)!;
      }
      if (obligatoryKeys.any((key) => !result.containsKey(key))) {
        throw Exception('Jadwal dari server belum lengkap.');
      }
      if (!mounted || _city != city || !DateUtils.isSameDay(_date, date)) return;
      setState(() { _times = result; _loading = false; });
    } catch (_) {
      if (!mounted || _city != city) return;
      setState(() {
        _loading = false;
        _error = 'Gagal mengambil jadwal shalat. Periksa koneksi internet lalu coba lagi.';
      });
    }
  }

  int? _minutes(String? hhmm) {
    if (hhmm == null || hhmm.length < 5) return null;
    final hour = int.tryParse(hhmm.substring(0, 2));
    final minute = int.tryParse(hhmm.substring(3, 5));
    if (hour == null || minute == null) return null;
    return hour * 60 + minute;
  }

  String? _nextKey() {
    final today = _times;
    if (today == null) return null;
    final now = _wibNow();
    final current = now.hour * 60 + now.minute;
    for (final key in obligatoryKeys) {
      final start = _minutes(today[key]);
      if (start != null && start > current) return key;
    }
    return null;
  }

  String _label(String key) => switch (key) {
        'Fajr' => 'Subuh',
        'Dhuhr' => 'Zuhur',
        'Asr' => 'Asar',
        'Maghrib' => 'Magrib',
        'Isha' => 'Isya',
        _ => key,
      };

  String _countdown(String? key) {
    if (key == null || _times == null) return 'Periksa kembali jadwal besok';
    final target = _minutes(_times![key]);
    if (target == null) return 'Waktu belum tersedia';
    final now = _wibNow();
    final diff = target - now.hour * 60 - now.minute;
    if (diff <= 0) return 'Waktu telah tiba';
    final hour = diff ~/ 60;
    final minute = diff % 60;
    return hour == 0 ? '$minute menit lagi' : '$hour jam $minute menit lagi';
  }

  @override
  Widget build(BuildContext context) {
    final next = _nextKey();
    final dateText = DateFormat('EEEE, d MMMM yyyy', 'id_ID').format(_date);
    return BiScreen(
      title: 'Jadwal Shalat',
      child: RefreshIndicator(
        color: BiColors.forest,
        onRefresh: _load,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(18, 13, 18, 32),
          children: [
            const BiPageHeader(
              eyebrow: 'Jaga waktu ibadah',
              title: 'Tepat waktu,\nlebih tenang.',
              subtitle: 'Lihat jadwal shalat harian sesuai kota pilihan.',
              icon: Icons.mosque_outlined,
            ),
            const SizedBox(height: 22),
            const BiSectionTitle(title: 'Lokasi & Tanggal', subtitle: 'Pilih kota untuk menyesuaikan waktu shalat.'),
            const SizedBox(height: 12),
            BiGlassCard(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Row(children: [
                const Icon(Icons.location_on_outlined, color: BiColors.forest),
                const SizedBox(width: 12),
                Expanded(child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: _city,
                    dropdownColor: const Color(0xFFF3F9F4),
                    items: cities.map((city) => DropdownMenuItem(
                      value: city,
                      child: Text(city, style: const TextStyle(
                        fontSize: 13.5, fontWeight: FontWeight.w700,
                        color: BiColors.deep,
                      )),
                    )).toList(),
                    onChanged: (city) {
                      if (city == null || city == _city) return;
                      setState(() => _city = city);
                      _load();
                    },
                  ),
                )),
                IconButton(
                  tooltip: 'Muat ulang jadwal',
                  onPressed: _loading ? null : _load,
                  icon: const Icon(Icons.refresh_rounded, color: BiColors.forest),
                ),
              ]),
            ),
            const SizedBox(height: 10),
            Row(children: [
              const Icon(Icons.event_available_outlined,
                  color: BiColors.forest, size: 17),
              const SizedBox(width: 7),
              Expanded(child: Text(dateText, style: const TextStyle(
                color: BiColors.muted, fontSize: 11.5,
                fontWeight: FontWeight.w600,
              ))),
              const Text('WIB', style: TextStyle(
                color: BiColors.forest, fontSize: 10.5,
                fontWeight: FontWeight.w800, letterSpacing: 1,
              )),
            ]),
            const SizedBox(height: 18),
            if (_loading) ...[
              const SizedBox(height: 65),
              const Center(child: CircularProgressIndicator(color: BiColors.forest)),
              const SizedBox(height: 18),
              const Center(child: Text('Mengambil jadwal terbaru...', style: TextStyle(color: BiColors.muted))),
            ] else if (_error != null) ...[
              BiGlassCard(child: Column(children: [
                const Icon(Icons.wifi_off_rounded, color: BiColors.forest, size: 34),
                const SizedBox(height: 14),
                Text(_error!, textAlign: TextAlign.center,
                    style: const TextStyle(color: BiColors.deep, height: 1.5)),
                const SizedBox(height: 13),
                OutlinedButton.icon(onPressed: _load,
                    icon: const Icon(Icons.refresh_rounded), label: const Text('Coba lagi')),
              ])),
            ] else if (_times != null) ...[
              BiGlassCard(
                tint: const Color(0xE7DBF0E3),
                padding: const EdgeInsets.all(17),
                child: Row(children: [
                  Container(
                    width: 50, height: 50,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: .73),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: const Icon(Icons.notifications_active_outlined,
                        color: BiColors.forest, size: 26),
                  ),
                  const SizedBox(width: 14),
                  Expanded(child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(next == null ? 'Waktu shalat hari ini selesai' : 'Shalat berikutnya: ${_label(next)}',
                          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800,
                              color: BiColors.deep)),
                      const SizedBox(height: 5),
                      Text(_countdown(next), style: const TextStyle(
                          color: BiColors.forest, fontSize: 12, fontWeight: FontWeight.w700)),
                    ],
                  )),
                  if (next != null) Text(_times![next] ?? '--:--',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800,
                          color: BiColors.deep)),
                ]),
              ),
              const SizedBox(height: 23),
              const BiSectionTitle(title: 'Waktu Shalat Hari Ini', subtitle: 'Waktu menggunakan zona WIB (UTC+7).'),
              const SizedBox(height: 12),
              for (final item in prayers) ...[
                BiGlassCard(
                  tint: next == item.$2
                      ? const Color(0xE1DDF3E5) : const Color(0xCFFBFFFC),
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                  child: Row(children: [
                    Container(
                      width: 44, height: 44,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE4F1E8),
                        borderRadius: BorderRadius.circular(13),
                      ),
                      child: Icon(item.$3, color: BiColors.forest, size: 22),
                    ),
                    const SizedBox(width: 12),
                    Expanded(child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(item.$1, style: TextStyle(
                          color: BiColors.deep, fontSize: 13.5,
                          fontWeight: next == item.$2
                              ? FontWeight.w800 : FontWeight.w600,
                        )),
                        if (next == item.$2) ...[
                          const SizedBox(height: 3),
                          const Text('BERIKUTNYA', style: TextStyle(
                            color: BiColors.forest,
                            fontSize: 9,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1,
                          )),
                        ],
                      ],
                    )),
                    Text(_times![item.$2] ?? '--:--', style: const TextStyle(
                      color: BiColors.forest, fontSize: 17, fontWeight: FontWeight.w800,
                    )),
                  ]),
                ),
                const SizedBox(height: 9),
              ],
              const SizedBox(height: 10),
              const Text(
                'Sumber: AlAdhan API, metode perhitungan Kementerian Agama RI (20). '
                'Jadwal ini merupakan hasil perhitungan pihak ketiga, bukan tabel resmi Kemenag. '
                'Perbedaan beberapa menit mungkin terjadi; utamakan jadwal masjid setempat.',
                style: TextStyle(color: BiColors.muted, fontSize: 10.7, height: 1.55),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
