# 🤝 Proyek Bantu.In — Platform On-Demand Service Berbasis Mobile
> **Tugas Akhir UAS Mata Kuliah Pemrograman Mobile (PMO)** > *Fakultas Ilmu Komputer, Universitas Amikom Purwokerto (2026)*

---

## 📌 1. Gambaran Umum & Filosofi Repositori (Berdasarkan Proposal)
Aplikasi **Bantu.In** adalah platform *on-demand service* berbasis mobile yang dirancang taktis untuk mempermudah proses penyediaan dan pemenuhan kebutuhan jasa atau tenaga bantuan harian secara langsung antara pencari bantuan (**Requester**) dan penyedia jasa (**Helper**). 

Mengadopsi model **Ekosistem Tertutup**, platform ini berfokus pada pemenuhan kebutuhan jasa di lingkup internal yang terkontrol (khususnya untuk tugas-tugas fisik langsung di lapangan / *on-site job*), tanpa melibatkan kompleksitas logistik pengantaran barang (*delivery*).

### Standarisasi Desain Repositori:
* **Psikologi Warna Utama:** Repositori ini mengunci tema warna global menggunakan **Warna Biru** (`#1E3A8A` & `#3B82F6`) sesuai dengan rancangan proposal kelompok yang melambangkan keamanan (*safety*), rasa percaya (*trust*), dan profesionalitas. Konfigurasi ini terpusat di `ThemeData` pada file `main.dart`.
* **Arsitektur Keamanan Alur:** Logika program diatur agar *room chat* diisolasi ketat secara real-time dan otomatis menutup permanen saat transaksi dinyatakan selesai atau dibatalkan untuk menjaga privasi pasca-transaksi.

---

## 👥 2. Matriks Pembagian Kerja (Jobdesk Anggota Kelompok)
Sesuai dengan ketentuan regulasi perkuliahan, setiap anggota tim memiliki kontribusi adil dan setara yang mencakup **minimal 1 fitur Frontend (Flutter) dan minimal 1 fitur Backend (API)**.

### TABEL KONTRIBUSI ANGGOTA KELOMPOK (SINKRON FILE REVISI 1)

| Nama Anggota & NIM | Kontribusi Fitur Frontend (Flutter) | Kontribusi Fitur Backend (API) |
| :--- | :--- | :--- |
| [cite_start]**Ida Feriani Nurya** <br> *(24SA11A013)* [cite: 7] | [cite_start]• Halaman *Splash Screen* dengan visual filosofis jabat tangan membentuk hati [cite: 7][cite_start].<br>• Halaman *Single Login Gateway* terintegrasi untuk semua *role* (Admin, Requester, Helper) [cite: 10][cite_start].<br>• Halaman pendaftaran mandiri khusus untuk peran *Requester* beserta *checkbox* Syarat & Ketentuan [cite: 11][cite_start].<br>• Halaman pemulihan akun (Lupa/Ganti Kata Sandi)[cite: 12]. | [cite_start]• API Autentikasi berbasis token keamanan (JWT) [cite: 13][cite_start].<br>• CRUD API Manajemen data pengguna untuk tabel `users` [cite: 15][cite_start].<br>• Logika *Cross-Table Validation* saat pendaftaran guna menjamin *Strict Single-Role Account*[cite: 16]. |
| [cite_start]**Bagus Setiawan** <br> *(24SA11A028)* <br> **[Git Leader]** [cite: 17] | [cite_start]• Halaman Beranda Utama untuk *Requester* [cite: 17][cite_start].<br>• Formulir pembuatan permohonan bantuan harian oleh *Requester* (input judul, deskripsi, lokasi, kategori) [cite: 20][cite_start].<br>• Papan utama eksplorasi pekerjaan (*Task Feed Board*) di halaman utama akun *Helper* + filter kategori dinamis[cite: 21]. | [cite_start]• CRUD API transaksional utama untuk pengelolaan tabel `tasks` [cite: 22][cite_start].<br>• Sistem otomatisasi penguncian kolom `nominal_pembayaran` berdasarkan *fixed price* kategori layanan [cite: 24][cite_start].<br>• API distribusi papan tugas (*Task Feed*) untuk menyajikan permohonan bantuan baru berstatus `'mencari_helper'`[cite: 25]. |
| [cite_start]**Danela Ayu Monika** <br> *(24SA11A114)* [cite: 26] | [cite_start]• Halaman Detail Tugas bagi *Helper* sebelum mengambil pekerjaan (deskripsi, foto lokasi, jarak, info *Requester*, tombol aksi) [cite: 26][cite_start].<br>• Halaman Status Pengerjaan untuk memantau status aktif tugas berjalan secara *real-time* [cite: 27][cite_start].<br>• Antarmuka ruang obrolan (*Chat Room Interaction*) eksklusif antara *Requester* dan *Helper*[cite: 28]. | [cite_start]• API pembaruan status penugasan (transisi status dari `'mencari_helper'` menjadi `'berjalan'`) [cite: 29][cite_start].<br>• Logika pengelolaan tabel `chat_rooms` dan tabel `chat_messages` (pengiriman riwayat pesan) [cite: 33][cite_start].<br>• Implementasi logika *Two-Way Handshake Cancellation* (mekanisme pengajuan pembatalan tugas sepihak)[cite: 34]. |
| [cite_start]**Nalendra Alamsyah Sutomo** <br> *(24SA11A021)* [cite: 36] | [cite_start]• Antarmuka unggah dokumen bukti transaksi bagi *Helper* (input foto struk QRIS dan kode referensi unik perbankan) [cite: 36][cite_start].<br>• Halaman Panel Kendali / *Web Dashboard* khusus untuk peran Admin [cite: 37][cite_start].<br>• Antarmuka verifikasi Admin untuk melakukan pengecekan data pengajuan upah dari *Helper*[cite: 38]. | [cite_start]• Arsitektur dan relasi kunci tamu (*Foreign Key Constraints*) untuk menjamin integritas data antar 6 tabel wajib database [cite: 39][cite_start].<br>• CRUD API pengajuan rekonsiliasi finansial nontunai pada tabel `payments` [cite: 40][cite_start].<br>• Logika validasi transaksi oleh Admin untuk mengubah status pembayaran (`'valid'` / `'tidak_valid'`)[cite: 40]. |
| [cite_start]**Dava Hamid Rosyid** <br> *(24SA11A053)* [cite: 42] | [cite_start]• Halaman Profil Saya komprehensif (kartu identitas, status verifikasi akun, kontak, alamat, data tambahan) [cite: 44][cite_start].<br>• Halaman pusat Pengaturan Akun & Keamanan (manajemen alamat, ubah sandi, preferensi notifikasi, FAQ, tombol hapus akun) [cite: 47, 48][cite_start].<br>• Implementasi animasi mikro, transisi halaman, penyelarasan psikologi warna biru, dan standarisasi komponen UI aplikasi[cite: 49]. | [cite_start]• API manipulasi data profil pengguna, modifikasi preferensi notifikasi, serta fungsi penghapusan data akun secara permanen[cite: 50]. |
| [cite_start]**Yuliana** <br> *(24SA11A043)* [cite: 51] | [cite_start]• Halaman tata kelola rekrutmen internal pada panel kendali Admin untuk pendaftaran akun *Helper* baru secara manual [cite: 52][cite_start].<br>• Halaman statis informasi aplikasi (About Bantu.In, syarat operasional, kebijakan privasi, kontak bantuan)[cite: 53]. | [cite_start]• API filter pencarian data riwayat transaksi penugasan masa lalu (*History* Penugasan) baik bagi sisi *Requester* maupun *Helper* [cite: 54][cite_start].<br>• API verifikasi silang pendaftaran *Helper* baru oleh Admin (anti-overlap email di tabel *Requester*)[cite: 55]. |
---

## 📂 3. Arsitektur Struktur Folder (`lib/`)
Untuk mengeliminasi risiko terjadinya kegagalan konflik penggabungan kode (*merge conflict*), repositori ini menerapkan struktur **Isolasi Berbasis Kontributor**. Setiap anggota kelompok memegang hak penuh eksklusif di dalam direktori folder namanya masing-masing:

```text
lib/
├── main.dart               # Entry point utama, global routing (Named Routes), & skema tema aplikasi
├── ida/                    # Kawasan Fitur Auth, Multi-Role & User Management
│   ├── screens/            # Splash, Login Gateway, Register, Lupa Sandi
│   └── controllers/        # Logic Auth & integrasi JWT
├── bagus/                  # Kawasan Fitur Main Business Logic & Task Feed System
│   ├── screens/            # Dashboard Feed, Detail Lowongan, Form Pembuatan Tugas
│   └── controllers/        # CRUD controller postingan bantuan & pencarian lokasi
├── dava/                   # Kawasan Fitur Core Interaction & Order State Machine
│   ├── screens/            # Track Progress Status Pekerjaan & Upload Struk Bukti
│   └── controllers/        # Validasi state alur penugasan lapangan
├── danela/                 # Kawasan Fitur Real-time Communication Room
│   ├── screens/            # Room Obrolan Eksklusif Helper-Requester
│   └── controllers/        # Logic chat stream & enkripsi pesan teks
├── danelas/                # Kawasan Fitur Profile Management & Security Center
│   ├── screens/            # Detail Identitas, Manajemen Akun, FAQ, S&K
│   └── controllers/        # Update profil data & eliminasi akun pengguna
└── yuliana/                # Kawasan Fitur Admin Dashboard & Audit System
    ├── screens/            # Panel Verifikasi Helper Baru, Profil Statis Aplikasi
    └── controllers/        # Audit mutasi silang data & filter pencarian history
