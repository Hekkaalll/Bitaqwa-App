# Bitaqwa App – Zakat Mal (Emerald Glass)

Fitur baru dipasang ke proyek **Bitaqwa Emerald Glass** tanpa mengganti keempat ikon asli di dashboard. File dari ZIP `zakat/` dijadikan dasar untuk tiga file pada `lib/zakat/`:

- `zakat_logic.dart`: nisab 85 gram emas, periksa total harta terhadap nisab, dan zakat sebesar 2,5% (rumus dipertahankan).
- `zakat_screen.dart`: halaman emerald/glass dengan input nominal, validasi, kalkulasi, reset, dan tombol salin hasil.
- `zakat_result_card.dart`: ringkasan hasil, nilai nisab, nominal zakat, indikator pencapaian nisab, dan catatan syarat.

Integrasi:
- `lib/main.dart` menambahkan route bernama `zakat`.
- `lib/dashboard/basicdashboard_screen.dart` mengaktifkan tombol Zakat dan memperbarui subjudulnya.
- `pubspec.yaml` **tidak memerlukan paket tambahan**; `intl` dan `flutter_masked_text2` sudah ada.
- Halaman Doa, Jadwal Shalat, dan Video Kajian tidak diganti.

## Jalankan dari VS Code

```bash
flutter pub get
flutter run
```

Pengujian perhitungan (jika Flutter SDK sudah terpasang):

```bash
flutter test test/zakat_logic_test.dart
```

## Cara menggunakan

1. Buka menu **Zakat** dari beranda.
2. Isi total harta dalam Rupiah dan **harga emas murni per gram secara manual**. Tidak ada harga emas otomatis atau harga contoh yang dianggap berlaku saat ini.
3. Ketuk **Hitung Zakat**. Hasil memperlihatkan apakah total harta mencapai nisab (85 × harga emas), serta estimasi zakat 2,5% jika mencapai nisab.
4. Gunakan tombol salin untuk menyimpan ringkasan atau tombol reset untuk menghitung ulang.

**Batasan:** Form ini mengikuti perhitungan sederhana dari berkas sumber. Memenuhi nisab saja belum otomatis menjamin kewajiban zakat: perhatikan haul (masa kepemilikan), jenis harta, dan syarat terkait. Konsultasikan kepada lembaga zakat yang berwenang untuk penetapan akhir. Tidak ada integrasi harga emas real-time atau transaksi pembayaran.
