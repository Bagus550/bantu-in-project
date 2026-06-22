extension TaskMapExtension on Map<String, dynamic> {
  String toProfessionalId() {
    final id = this['id'] ?? this['id_task'] ?? '0';
    final kategori = this['kategori_layanan'] ?? '';

    switch (kategori.toString()) {
      case 'BantuFix':
        return 'BF$id';
      case 'BantuClean':
        return 'BC$id';
      case 'BantuShop':
        return 'BS$id';
      case 'BantuStudy':
        return 'BT$id';
      default:
        return 'TGS-$id';
    }
  }
}
