# Bitaqwa — Emerald Glass UI

Pembaruan folder Flutter dari proyek asli (November 2026).

## Fitur

- Dashboard: mempertahankan **semua file ikon asli** `assets/images/ic_menu_*.png` dan tampilan sapaan hijau.
- Doa-doa: 13 bacaan (Arab, latin, arti, referensi), pencarian, filter kategori, layar detail, salin bacaan.
- Jadwal Shalat: pilihan kota wilayah WIB dan jadwal **hari berjalan** dari AlAdhan API (metode 20, perhitungan Kemenag); state loading, refresh, error, dan hitung waktu menuju shalat selanjutnya. **Tidak menggantikan jadwal resmi masjid/Kemenag setempat**.
- Video Kajian: lima video pilihan dari kanal Yufid.TV, thumbnail online, pemutar YouTube di dalam aplikasi, tombol membuka halaman YouTube asli.
- Zakat: logo dan kotak menu masih ada, tetapi **belum ada implementasi**; menampilkan pesan "segera hadir" saat ditekan.

## Jalankan

```bash
flutter pub get
flutter run
```

Untuk menjalankan Chrome:

```bash
flutter run -d chrome
```

> Pastikan terhubung ke internet untuk mendapatkan jadwal shalat, thumbnail, pemutaran YouTube.

## Lokasi file utama

- `lib/main.dart` — tema & route
- `lib/ui/bi_theme.dart` — glass card, header, warna, latar
- `lib/dashboard/basicdashboard_screen.dart`
- `lib/doa_harian/{doa_data,doa_screen}.dart`
- `lib/jadwal_sholat/jadwal_sholat_screen.dart`
- `lib/kajian_online/video_kajian_screen.dart`

## Sumber eksternal

- AlAdhan API: https://aladhan.com/prayer-times-api
- Metode perhitungan 20: Kementerian Agama Indonesia (di dalam AlAdhan, bukan token API resmi Kemenag).
- Video: https://www.youtube.com/@yufid (konten hak cipta milik kanal).

## Catatan

Belum dilakukan `flutter analyze` atau eksekusi perangkat di lingkungan pembuatan ini karena Flutter SDK tidak tersedia. Jalankan perintah di atas di komputer dengan Flutter SDK, lalu uji pemutaran video pada platform tujuan. Ketersediaan video tersemat dan data daring bergantung pada server eksternal.
