# Bitaqwa App — Emerald Pro Responsive

Versi penyegaran desain semua halaman Flutter, berdasarkan source **Bitaqwa Emerald Glass + Zakat**.

## Yang diubah

- **Dashboard:** greeting header lebih rapi dan responsif, kartu 2 kolom dipadatkan agar tidak memiliki ruang kosong berlebihan, ikon asli tetap digunakan, serta catatan motivasi dengan hierarki lebih jelas.
- **Doa:** pencarian, filter, daftar doa, dan detail bacaan mengikuti margin/bentuk baru; metadata dan tombol salin mudah dipakai.
- **Zakat:** data & perhitungan dari proyek sebelumnya dipertahankan, jarak elemen form, poin fakta, dan ringkasan diselaraskan dengan tema global.
- **Jadwal Shalat:** baris kota/tanggal diperjelas; status waktu shalat berikutnya dan waktu tiap shalat mudah dibaca.
- **Video Kajian:** daftar video dibuat lebih ringkas dengan thumbnail samping, pemutar video dan link YouTube tetap tersedia.
- **Tema:** palette emerald-sage-ivory, surface glass lembut, konsistensi border, bayangan, tombol, input, serta batas lebar 640px supaya rapi di layar besar.

## Cara menjalankan

1. Buka folder `bitaqwa_starter` pada VS Code.
2. Jalankan `flutter pub get` dan `flutter run`.
3. Jika aplikasi lama sedang aktif, lakukan **Hot Restart**.
4. Pengujian rumus zakat dapat dilakukan lewat `flutter test`.

## Berkas utama yang diperbarui

- `lib/ui/bi_theme.dart`
- `lib/main.dart`
- `lib/dashboard/basicdashboard_screen.dart`
- `lib/doa_harian/doa_screen.dart`
- `lib/zakat/zakat_screen.dart`
- `lib/jadwal_sholat/jadwal_sholat_screen.dart`
- `lib/kajian_online/video_kajian_screen.dart`

Tidak ada perubahan pada file gambar ikon menu, rumus zakat, data doa, daftar video, atau route navigasi. Paket ini memakai font sistem Flutter dan tidak membundel berkas font tambahan.

**Catatan:** pemeriksaan struktur kode dan berkas telah dilakukan, tetapi belum dilakukan `flutter analyze` atau uji tampil langsung karena Flutter SDK tidak tersedia pada lingkungan pembuat paket. Jadwal shalat dan video YouTube memerlukan internet.
