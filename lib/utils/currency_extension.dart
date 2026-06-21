import 'package:intl/intl.dart';

extension RupiahNumExtension on num {
  String toRupiah() {
    return NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    ).format(this);
  }
}

extension RupiahStringExtension on String? {
  String toRupiah() {
    if (this == null || this!.isEmpty) return 'Rp 0';
    final angka = num.tryParse(this!) ?? 0;
    return angka.toRupiah();
  }
}
