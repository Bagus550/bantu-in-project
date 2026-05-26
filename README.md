# Proyek Bantu.In — Platform On-Demand Service Berbasis Mobile
> **Tugas Akhir UAS Mata Kuliah Pemrograman Mobile (PMO)** > *Fakultas Ilmu Komputer, Universitas Amikom Purwokerto (2026)*

---

## 📌 1. Gambaran Umum & Filosofi Repositori
Aplikasi **Bantu.In** adalah platform *on-demand service* berbasis mobile yang dirancang taktis untuk mempermudah proses penyediaan dan pemenuhan kebutuhan jasa atau tenaga bantuan harian secara langsung antara pencari bantuan (**Requester**) dan penyedia jasa (**Helper**). 

Mengadopsi model **Ekosistem Tertutup**, platform ini berfokus pada pemenuhan kebutuhan jasa di lingkup internal yang terkontrol (khususnya untuk tugas-tugas fisik langsung di lapangan / *on-site job*), tanpa melibatkan kompleksitas logistik pengantaran barang (*delivery*).

### Standarisasi Desain Repositori:
* **Psikologi Warna Utama:** Repositori ini mengunci tema warna global menggunakan **Warna Biru** (`#1E3A8A` & `#3B82F6`) sesuai dengan rancangan proposal kelompok yang melambangkan keamanan (*safety*), rasa percaya (*trust*), dan profesionalitas. Konfigurasi ini terpusat di `ThemeData` pada file `main.dart`.
* **Arsitektur Keamanan Alur:** Logika program diatur agar *room chat* diisolasi ketat secara real-time dan otomatis menutup permanen saat transaksi dinyatakan selesai atau dibatalkan untuk menjaga privasi pasca-transaksi.

---

## 👥 2. Matriks Pembagian Kerja (Jobdesk Anggota Kelompok)
Sesuai dengan ketentuan regulasi perkuliahan, setiap anggota tim memiliki kontribusi adil dan setara yang mencakup **minimal 1 fitur Frontend (Flutter) dan minimal 1 fitur Backend (API)**.

| Nama Anggota & NIM | Kontribusi Fitur Frontend (Flutter) | Kontribusi Fitur Backend (API) |
| :--- | :--- | :--- |
| **Ida Feriani Nurya** <br> *(24SA11A013)* | • Halaman *Splash Screen* dengan visual filosofis jabat tangan membentuk hati .<br>• Halaman *Single Login Gateway* terintegrasi untuk semua *role* (Admin, Requester, Helper).<br>• Halaman pendaftaran mandiri khusus untuk peran *Requester* beserta *checkbox* Syarat & Ketentuan.<br>• Halaman pemulihan akun (Lupa/Ganti Kata Sandi). | • API Autentikasi berbasis token keamanan (JWT).<br>• CRUD API Manajemen data pengguna untuk tabel `users`.<br>• Logika *Cross-Table Validation* saat pendaftaran guna menjamin *Strict Single-Role Account*. |
| **Bagus Setiawan** <br> *(24SA11A028)* <br> **[Git Leader]**  | • Halaman Beranda Utama untuk *Requester*.<br>• Formulir pembuatan permohonan bantuan harian oleh *Requester* (input judul, deskripsi, lokasi, kategori).<br>• Papan utama eksplorasi pekerjaan (*Task Feed Board*) di halaman utama akun *Helper* + filter kategori dinamis. | • CRUD API transaksional utama untuk pengelolaan tabel `tasks`.<br>• Sistem otomatisasi penguncian kolom `nominal_pembayaran` berdasarkan *fixed price* kategori layanan.<br>• API distribusi papan tugas (*Task Feed*) untuk menyajikan permohonan bantuan baru berstatus `'mencari_helper'`. |
| **Danela Ayu Monika** <br> *(24SA11A114)*  | • Halaman Detail Tugas bagi *Helper* sebelum mengambil pekerjaan (deskripsi, foto lokasi, jarak, info *Requester*, tombol aksi).<br>• Halaman Status Pengerjaan untuk memantau status aktif tugas berjalan secara *real-time*.<br>• Antarmuka ruang obrolan (*Chat Room Interaction*) eksklusif antara *Requester* dan *Helper*. | • API pembaruan status penugasan (transisi status dari `'mencari_helper'` menjadi `'berjalan'`).<br>• Logika pengelolaan tabel `chat_rooms` dan tabel `chat_messages` (pengiriman riwayat pesan).<br>• Implementasi logika *Two-Way Handshake Cancellation* (mekanisme pengajuan pembatalan tugas sepihak). |
| **Nalendra Alamsyah Sutomo** <br> *(24SA11A021)*  | • Antarmuka unggah dokumen bukti transaksi bagi *Helper* (input foto struk QRIS dan kode referensi unik perbankan).<br>• Halaman Panel Kendali / *Web Dashboard* khusus untuk peran Admin.<br>• Antarmuka verifikasi Admin untuk melakukan pengecekan data pengajuan upah dari *Helper*. | • Arsitektur dan relasi kunci tamu (*Foreign Key Constraints*) untuk menjamin integritas data antar 6 tabel wajib database.<br>• CRUD API pengajuan rekonsiliasi finansial nontunai pada tabel `payments`.<br>• Logika validasi transaksi oleh Admin untuk mengubah status pembayaran (`'valid'` / `'tidak_valid'`). |
| **Dava Hamid Rosyid** <br> *(24SA11A053)*  | • Halaman Profil Saya komprehensif (kartu identitas, status verifikasi akun, kontak, alamat, data tambahan) .<br>• Halaman pusat Pengaturan Akun & Keamanan (manajemen alamat, ubah sandi, preferensi notifikasi, FAQ, tombol hapus akun).<br>• Implementasi animasi mikro, transisi halaman, penyelarasan psikologi warna biru, dan standarisasi komponen UI aplikasi. | • API manipulasi data profil pengguna, modifikasi preferensi notifikasi, serta fungsi penghapusan data akun secara permanen. |
| **Yuliana** <br> *(24SA11A043)*  | • Halaman tata kelola rekrutmen internal pada panel kendali Admin untuk pendaftaran akun *Helper* baru secara manual.<br>• Halaman statis informasi aplikasi (About Bantu.In, syarat operasional, kebijakan privasi, kontak bantuan). | • API filter pencarian data riwayat transaksi penugasan masa lalu (*History* Penugasan) baik bagi sisi *Requester* maupun *Helper*.<br>• API verifikasi silang pendaftaran *Helper* baru oleh Admin (anti-overlap email di tabel *Requester*). |
---

## 📂 3. Arsitektur Struktur Folder (`lib/`)
Untuk mengeliminasi risiko terjadinya kegagalan konflik penggabungan kode (*merge conflict*), repositori ini menerapkan struktur **Isolasi Berbasis Kontributor**. Setiap anggota kelompok memegang hak penuh eksklusif di dalam direktori folder namanya masing-masing:

```text
lib/
├── main.dart                 # Entry point utama, global routing (Named Routes), & skema tema aplikasi 
│
├── ida/                      # Kawasan Fitur Auth, Multi-Role & User Management 
│   ├── screens/              # Splash Screen, Single Login Gateway, Register Requester, Lupa Sandi 
│   └── controllers/          # Logic Autentikasi JWT & CRUD Manajemen tabel users 
│
├── bagus/                    # Kawasan Fitur Main Business Logic & Task Feed System 
│   ├── screens/              # Beranda Requester, Form Buat Tugas, Task Feed Board (Beranda Helper) 
│   └── controllers/          # CRUD tabel tasks, Auto-lock Tarif Kategori, Distribusi Feed 'mencari_helper' 
│
├── danela/                   # Kawasan Fitur Operational State Handler & Real-Time Communication 
│   ├── screens/              # Detail Tugas Helper, Status Pengerjaan Real-time, Room Chat Eksklusif 
│   └── controllers/          # Status Update ('berjalan'), Logic Stream Chat Rooms/Messages, Two-Way Cancellation 
│
├── nalendra/                 # Kawasan Fitur Database Infrastructure & Payout Verification Link 
│   ├── screens/              # Upload Bukti Struk QRIS, Web Dashboard Admin, Verifikasi Klaim Upah Admin 
│   └── controllers/          # Foreign Key Constraints, CRUD tabel payments, Validasi Finansial Admin 
│
├── dava/                     # Kawasan Fitur UI/UX Specialist & Identity Systems (Support Team) 
│   ├── screens/              # Profil Saya Komprehensif, Pusat Pengaturan Akun & Keamanan 
│   └── controllers/          # Manipulasi Profil, Modifikasi Notifikasi, Fungsi Hapus Akun Permanen 
│
└── yuliana/                  # Kawasan Fitur Admin Panel Management & Filtering (Support Team) 
    ├── screens/              # Rekrutmen Manual Helper (Panel Admin), Halaman Statis Info Aplikasi (About) 
    └── controllers/          # Filter Pencarian History Transaksi, Verifikasi Silang Email Anti-Overlap 
