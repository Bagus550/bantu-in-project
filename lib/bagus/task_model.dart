class TaskModel {
  final int? idTask;
  final int idRequester;
  final String kategoriLayanan;
  final String judulTugas;
  final String deskripsi;
  final String lokasiTugas;
  final int? nominalPembayaran;
  final String? statusTask;

  TaskModel({
    this.idTask,
    required this.idRequester,
    required this.kategoriLayanan,
    required this.judulTugas,
    required this.deskripsi,
    required this.lokasiTugas,
    this.nominalPembayaran,
    this.statusTask,
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      idTask: json['id_task'] != null
          ? int.parse(json['id_task'].toString())
          : null,
      idRequester: int.parse(json['id_requester'].toString()),
      kategoriLayanan: json['kategori_layanan'] ?? 'Lainnya',
      judulTugas: json['judul_tugas'] ?? '',
      deskripsi: json['deskripsi'] ?? '',
      lokasiTugas: json['lokasi_tugas'] ?? '',
      nominalPembayaran: json['nominal_pembayaran'] != null
          ? int.parse(json['nominal_pembayaran'].toString())
          : null,
      statusTask: json['status_task'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_requester': idRequester,
      'kategori_layanan': kategoriLayanan,
      'judul_tugas': judulTugas,
      'deskripsi': deskripsi,
      'lokasi_tugas': lokasiTugas,
    };
  }
}
