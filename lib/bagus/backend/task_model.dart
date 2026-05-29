class TaskModel {
  final String? idTask;
  final String? idRequester;
  final String? idHelper;
  final String? namaHelper;
  final String? judulTugas;
  final String? deskripsi;
  final String? lokasiTugas;
  final String? nominalPembayaran;
  final String? statusTask;
  final String? kategoriLayanan;

  TaskModel({
    this.idTask,
    this.idRequester,
    this.idHelper,
    this.namaHelper,
    this.judulTugas,
    this.deskripsi,
    this.lokasiTugas,
    this.nominalPembayaran,
    this.statusTask,
    this.kategoriLayanan,
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      idTask: json['id_task']?.toString(),
      idRequester: json['id_requester']?.toString(),
      idHelper: json['id_helper']?.toString(),
      namaHelper: json['nama_helper'],
      judulTugas: json['judul_tugas'],
      deskripsi: json['deskripsi'],
      lokasiTugas: json['lokasi_tugas'],
      nominalPembayaran: json['nominal_pembayaran']?.toString(),
      statusTask: json['status_task'],
      kategoriLayanan: json['kategori_layanan'],
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
