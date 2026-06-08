List<Map<String, dynamic>> tasks = [
  {
    "id": 0,
    "judul_tugas": "Perbaiki Kran Air Bocor",
    "nama_helper": "Dika",
    "nama_requester": "Rian",
    "deskripsi":
        "Kran di kamar mandi utama bocor terus mendidih, perlu diganti seal atau kran baru.",
    "lokasi_tugas": "Jl. Pemuda No. 12, sebelah fotokopi",
    "nominal_pembayaran": "Rp 45.000",
    "status": "Berjalan",
    "kategori_layanan": "BantuFix",
  },
  {
    "id": 1,
    "judul_tugas": "Belanja Sembako Mingguan",
    "nama_helper": "",
    "nama_requester": "Ahmad",
    "deskripsi":
        "Tolong belikan beras 5kg, minyak goreng 2L, dan telur 1kg di toko kelontong makmur.",
    "lokasi_tugas": "Pasar Wage, Los Blok A",
    "nominal_pembayaran": "Rp 30.000",
    "status": "Mencari helper",
    "kategori_layanan": "BantuShop",
  },
  {
    "id": 2,
    "judul_tugas": "Ganti Oli Motor Beat",
    "nama_helper": "Andi",
    "nama_requester": "Bagus",
    "deskripsi":
        "Bawa motor ke AHASS terdekat buat ganti oli mesin sama oli gardan, uang oli terpisah.",
    "lokasi_tugas": "Mekarsari RT 02 RW 05",
    "nominal_pembayaran": "Rp 35.000",
    "status": "Selesai",
    "kategori_layanan": "BantuFix",
  },
  {
    "id": 3,
    "judul_tugas": "Cuci Air Conditioner (AC)",
    "nama_helper": "Fahmi",
    "nama_requester": "Siti",
    "deskripsi":
        "AC di kamar depan sudah kurang dingin dan agak berisik, butuh dicuci/servis ringan.",
    "lokasi_tugas": "Jl. Gatot Subroto Gang 3 No. 45",
    "nominal_pembayaran": "Rp 90.000",
    "status": "Menunggu validasi",
    "kategori_layanan": "BantuFix",
  },
  {
    "id": 4,
    "judul_tugas": "Belikan Kuota Internet & Token",
    "nama_helper": "Surya",
    "nama_requester": "Bagus",
    "deskripsi":
        "Belikan token listrik Rp 100.000 di konter pulsa, nomor meteran nanti saya chat.",
    "lokasi_tugas": "Kost Amanah, Kamar No. 7",
    "nominal_pembayaran": "Rp 15.000",
    "status": "Berjalan",
    "kategori_layanan": "BantuShop",
  },
  {
    "id": 5,
    "judul_tugas": "Bersihkan Kaca Jendela Ruko",
    "nama_helper": "",
    "nama_requester": "Dewi",
    "deskripsi":
        "Membersihkan kaca lantai 1 dan lantai 2 ruko biar bersih menjelang grand opening.",
    "lokasi_tugas": "Ruko Kaliwiro Jaya No. 3B",
    "nominal_pembayaran": "Rp 150.000",
    "status": "Mencari helper",
    "kategori_layanan": "BantuClean",
  },
  {
    "id": 6,
    "judul_tugas": "Ajarkan Matematika Kelas 4 SD",
    "nama_helper": "Lia",
    "nama_requester": "Budi",
    "deskripsi":
        "Bantu anak saya belajar persiapan UTS matematika bab pecahan dan perkalian susun.",
    "lokasi_tugas": "Jl. Cendrawasih No. 14, Purwokerto",
    "nominal_pembayaran": "Rp 50.000",
    "status": "Berjalan",
    "kategori_layanan": "BantuStudy",
  },
  {
    "id": 7,
    "judul_tugas": "Bantu Pindahan Kosan",
    "nama_helper": "",
    "nama_requester": "Roni",
    "deskripsi":
        "Angkat-angkat kardus baju dan kasur lantai dari kosan lama ke kosan baru jarak 500m.",
    "lokasi_tugas": "Gang Serayu 2, belakang kampus",
    "nominal_pembayaran": "Rp 80.000",
    "status": "Mencari helper",
    "kategori_layanan": "BantuStudy",
  },
  // --- TAMBAHAN MOCK DATA DENGAN STATUS DIBATALKAN ---
  {
    "id": 8,
    "judul_tugas": "Antar Paket ke J&T Express",
    "nama_helper": "Riko",
    "nama_requester": "Sania",
    "deskripsi":
        "Tolong ambil paket dropship di rumah saya lalu antarkan ke konter J&T terdekat, resi sudah otomatis.",
    "lokasi_tugas": "Perum Griya Indah Blok C-12",
    "nominal_pembayaran": "Rp 10.000",
    "status": "Dibatalkan",
    "kategori_layanan": "BantuShop",
  },
  {
    "id": 9,
    "judul_tugas": "Cabut Rumput Halaman Depan",
    "nama_helper": "Fajar",
    "nama_requester": "Hendra",
    "deskripsi":
        "Membersihkan rumput liar yang sudah tinggi di pekarangan depan rumah, peralatan sudah disediakan.",
    "lokasi_tugas": "Jl. Merdeka No. 88",
    "nominal_pembayaran": "Rp 60.000",
    "status": "Dibatalkan",
    "kategori_layanan": "BantuClean",
  },
];

final List<Map<String, dynamic>> helperList = [
  {
    "name": "Sarah Mitchell",
    "role": "Helper Bantu.In",
    "status": "ACTIVE",
    "tasks": 142,
  },
  {
    "name": "Marcus Chen",
    "role": "Helper Bantu.In",
    "status": "SUSPENDED",
    "tasks": 89,
  },
  {
    "name": "Elena Rodriguez",
    "role": "Helper Bantu.In",
    "status": "PENDING",
    "tasks": 0,
  },
];

final List<Map<String, dynamic>> notifikasi = [
  {
    "judul_notifikasi": "Pembayaran Valid",
    "tasks_id": 3,
    "waktu": "Baru saja",
    "deskripsi":
        "Admin telah memvalidasi bukti pembayaran untuk tugas ID3 Status tugas berubah dari 'Menunggu Validasi' menjadi 'Selesai'.",
  },
  {
    "judul_notifikasi": "Pembayaran Valid",
    "tasks_id": 2,
    "waktu": "2 menit lalu",
    "deskripsi":
        "Admin telah memvalidasi bukti pembayaran untuk tugas ID1 Status tugas berubah dari 'Menunggu Validasi' menjadi 'Selesai'.",
  },
  {
    "judul_notifikasi": "Pembayaran Gagal",
    "tasks_id": 0,
    "waktu": "5 menit lalu",
    "deskripsi":
        "Admin telah memvalidasi bukti pembayaran untuk tugas ID0. pastikan nomor referensi sama dengan yang ada di foto dan submit ulang",
  },
];
