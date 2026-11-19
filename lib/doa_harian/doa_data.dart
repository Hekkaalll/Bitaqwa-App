/// Koleksi doa ringkas dengan rujukan ayat/hadis pada tiap bacaan.
/// Pelafalan latin adalah panduan, bukan pengganti belajar makhraj.
class DoaItem {
  final String title;
  final String category;
  final String arabic;
  final String latin;
  final String meaning;
  final String reference;
  const DoaItem({
    required this.title,
    required this.category,
    required this.arabic,
    required this.latin,
    required this.meaning,
    required this.reference,
  });
}

const List<DoaItem> doaItems = [
  DoaItem(
    title: 'Sebelum Tidur', category: 'Harian',
    arabic: 'بِاسْمِكَ اللَّهُمَّ أَمُوتُ وَأَحْيَا',
    latin: 'Bismikallāhumma amūtu wa aḥyā.',
    meaning: 'Dengan nama-Mu ya Allah, aku mati dan aku hidup.',
    reference: 'HR. Bukhari',
  ),
  DoaItem(
    title: 'Bangun Tidur', category: 'Harian',
    arabic: 'الْحَمْدُ لِلَّهِ الَّذِي أَحْيَانَا بَعْدَ مَا أَمَاتَنَا وَإِلَيْهِ النُّشُورُ',
    latin: 'Alḥamdulillāhilladzī aḥyānā ba‘da mā amātanā wa ilaihin-nusyūr.',
    meaning: 'Segala puji bagi Allah yang menghidupkan kami setelah mematikan kami, dan kepada-Nya kebangkitan.',
    reference: 'HR. Bukhari',
  ),
  DoaItem(
    title: 'Sebelum Makan', category: 'Harian',
    arabic: 'بِسْمِ اللَّهِ',
    latin: 'Bismillāh.',
    meaning: 'Dengan nama Allah.',
    reference: 'HR. Abu Dawud dan Tirmidzi',
  ),
  DoaItem(
    title: 'Masuk Kamar Mandi', category: 'Harian',
    arabic: 'اللَّهُمَّ إِنِّي أَعُوذُ بِكَ مِنَ الْخُبُثِ وَالْخَبَائِثِ',
    latin: 'Allāhumma innī a‘ūdzu bika minal-khubutsi wal-khabā’its.',
    meaning: 'Ya Allah, aku berlindung kepada-Mu dari setan laki-laki dan perempuan.',
    reference: 'HR. Bukhari dan Muslim',
  ),
  DoaItem(
    title: 'Keluar Rumah', category: 'Harian',
    arabic: 'بِسْمِ اللَّهِ، تَوَكَّلْتُ عَلَى اللَّهِ، وَلَا حَوْلَ وَلَا قُوَّةَ إِلَّا بِاللَّهِ',
    latin: 'Bismillāh, tawakkaltu ‘alallāh, wa lā ḥaula wa lā quwwata illā billāh.',
    meaning: 'Dengan nama Allah, aku bertawakal kepada Allah. Tidak ada daya dan kekuatan kecuali dengan pertolongan Allah.',
    reference: 'HR. Abu Dawud dan Tirmidzi',
  ),
  DoaItem(
    title: 'Memohon Ilmu', category: 'Al-Qur’an',
    arabic: 'رَبِّ زِدْنِي عِلْمًا',
    latin: 'Rabbi zidnī ‘ilmā.',
    meaning: 'Ya Tuhanku, tambahkanlah ilmu kepadaku.',
    reference: 'QS. Taha: 114',
  ),
  DoaItem(
    title: 'Dimudahkan Urusan', category: 'Al-Qur’an',
    arabic: 'رَبِّ اشْرَحْ لِي صَدْرِي وَيَسِّرْ لِي أَمْرِي',
    latin: 'Rabbisyraḥ lī ṣadrī, wa yassir lī amrī.',
    meaning: 'Ya Tuhanku, lapangkanlah dadaku dan mudahkanlah urusanku.',
    reference: 'QS. Taha: 25–26',
  ),
  DoaItem(
    title: 'Kebaikan Dunia & Akhirat', category: 'Al-Qur’an',
    arabic: 'رَبَّنَا آتِنَا فِي الدُّنْيَا حَسَنَةً وَفِي الْآخِرَةِ حَسَنَةً وَقِنَا عَذَابَ النَّارِ',
    latin: 'Rabbanā ātinā fid-dunyā ḥasanah, wa fil-ākhirati ḥasanah, wa qinā ‘adzāban-nār.',
    meaning: 'Ya Tuhan kami, berilah kami kebaikan di dunia dan di akhirat, dan lindungilah kami dari azab neraka.',
    reference: 'QS. Al-Baqarah: 201',
  ),
  DoaItem(
    title: 'Memohon Ampunan', category: 'Al-Qur’an',
    arabic: 'رَبَّنَا ظَلَمْنَا أَنْفُسَنَا وَإِنْ لَمْ تَغْفِرْ لَنَا وَتَرْحَمْنَا لَنَكُونَنَّ مِنَ الْخَاسِرِينَ',
    latin: 'Rabbanā ẓalamnā anfusanā, wa illam taghfir lanā wa tarḥamnā lanakūnanna minal-khāsirīn.',
    meaning: 'Ya Tuhan kami, kami telah menzalimi diri sendiri. Jika Engkau tidak mengampuni dan merahmati kami, niscaya kami termasuk orang-orang yang rugi.',
    reference: 'QS. Al-A’raf: 23',
  ),
  DoaItem(
    title: 'Untuk Kedua Orang Tua', category: 'Keluarga',
    arabic: 'رَبِّ ارْحَمْهُمَا كَمَا رَبَّيَانِي صَغِيرًا',
    latin: 'Rabbirḥamhumā kamā rabbayānī ṣaghīrā.',
    meaning: 'Ya Tuhanku, sayangilah keduanya sebagaimana mereka menyayangiku ketika kecil.',
    reference: 'QS. Al-Isra: 24',
  ),
  DoaItem(
    title: 'Keluarga yang Menyejukkan', category: 'Keluarga',
    arabic: 'رَبَّنَا هَبْ لَنَا مِنْ أَزْوَاجِنَا وَذُرِّيَّاتِنَا قُرَّةَ أَعْيُنٍ وَاجْعَلْنَا لِلْمُتَّقِينَ إِمَامًا',
    latin: 'Rabbanā hab lanā min azwājinā wa dzurriyyātinā qurrata a‘yun, waj‘alnā lil-muttaqīna imāmā.',
    meaning: 'Ya Tuhan kami, anugerahkanlah kepada kami pasangan dan keturunan sebagai penyejuk mata, serta jadikanlah kami teladan bagi orang bertakwa.',
    reference: 'QS. Al-Furqan: 74',
  ),
  DoaItem(
    title: 'Menjaga Shalat', category: 'Ibadah',
    arabic: 'رَبِّ اجْعَلْنِي مُقِيمَ الصَّلَاةِ وَمِنْ ذُرِّيَّتِي رَبَّنَا وَتَقَبَّلْ دُعَاءِ',
    latin: 'Rabbij‘alnī muqīmaṣ-ṣalāti wa min dzurriyyatī, rabbanā wa taqabbal du‘ā’.',
    meaning: 'Ya Tuhanku, jadikanlah aku dan keturunanku orang yang tetap mendirikan shalat. Ya Tuhan kami, kabulkanlah doaku.',
    reference: 'QS. Ibrahim: 40',
  ),
  DoaItem(
    title: 'Perlindungan dari Godaan', category: 'Perlindungan',
    arabic: 'رَبِّ أَعُوذُ بِكَ مِنْ هَمَزَاتِ الشَّيَاطِينِ وَأَعُوذُ بِكَ رَبِّ أَنْ يَحْضُرُونِ',
    latin: 'Rabbi a‘ūdzu bika min hamazātisy-syayāṭīn, wa a‘ūdzu bika rabbi ay yaḥḍurūn.',
    meaning: 'Ya Tuhanku, aku berlindung kepada-Mu dari bisikan setan dan dari kedatangan mereka kepadaku.',
    reference: 'QS. Al-Mu’minun: 97–98',
  ),
];
