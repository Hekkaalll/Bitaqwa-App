import 'package:flutter_test/flutter_test.dart';
import 'package:bitaqwa/zakat/zakat_logic.dart';

void main() {
  group('Zakat Mal - rumus folder asli', () {
    test('Nisab = 85 gram emas dikali harga per gram', () {
      expect(ZakatLogic.hitungNisabRupiah(1000000), 85000000);
    });

    test('Total harta tepat sebesar nisab termasuk mencapai nisab', () {
      expect(
        ZakatLogic.apakahWajibZakat(
          totalHarta: 85000000,
          hargaEmasPerGram: 1000000,
        ),
        isTrue,
      );
    });

    test('Total harta kurang dari nisab belum mencapai nisab', () {
      expect(
        ZakatLogic.apakahWajibZakat(
          totalHarta: 84000000,
          hargaEmasPerGram: 1000000,
        ),
        isFalse,
      );
    });

    test('Kadar zakat adalah 2,5 persen', () {
      expect(ZakatLogic.hitungZakat(100000000), 2500000);
    });

    test('Hasil ditampilkan dalam format rupiah', () {
      expect(ZakatLogic.formatRupiah(2500000), contains('Rp'));
    });
  });
}
