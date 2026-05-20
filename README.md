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

| Nama Anggota & NIM | Kontribusi Fitur Frontend (Flutter) | Kontribusi Fitur Backend (API) |
| :--- | :--- | :--- |
| **Ida Feriani Nurya** <br> *(24SA11A013)* | • Splash Screen dengan visual filosofis jabat tangan membentuk hati.<br>• Single Login Gateway terintegrasi untuk semua role.<br>• Form registrasi mandiri khusus peran *Requester*.<br>• Antarmuka pemulihan akun (Lupa Sandi). | • API Autentikasi berbasis token keamanan (**JWT**).<br>• CRUD Manajemen data pengguna untuk tabel `users`.<br>• Logika *Cross-Table Validation* saat pendaftaran (anti-duplikasi email/HP). |
| **Bagus Setiawan** <br> *(24SA11A028)* <br> **[Git Leader]** | • Halaman Dashboard / Feed utama lowongan bantuan.<br>• Antarmuka detail visual informasi tugas.<br>• Form pembuatan postingan lowongan tugas baru. | • Core API Bisnis: Pemrosesan data CRUD postingan penugasan.<br>• Algoritma filtering pencarian *feed* dinamis berbasis lokasi dan kategori tugas. |
| **Dava Hamid Rosyid** <br> *(24SA11A053)* | • Alur pelacakan status tugas real-time (*Diambil* &rarr; *Berjalan* &rarr; *Selesai*).<br>• Antarmuka unggah dokumen bukti/struk transaksi. | • State Machine penugasan di database.<br>• Sistem otomatisasi penguncian data transaksi.<br>• Logika penyerahan tugas (serah terima lapangan). |
| **Danela Ayu Monika** <br> *(24SA11A114)* | • Antarmuka ruang obrolan langsung (*Room Chat*) interaktif antara Helper dan Requester. | • Sinkronisasi pesan instan stream teks.<br>• Enkripsi string teks data obrolan.<br>• Fungsi otomatisasi penutupan ruang obrolan (*auto-close room chat*). |
| **Nalendra Alamsyah Sutomo** <br> *(Anggota 5)* | • Halaman Profil Pengguna komprehensif (kartu identitas, status verifikasi, data kontak).<br>• Panel Pengaturan Akun & Keamanan (ubah sandi, preferensi notifikasi, FAQ, legalitas). | • API manipulasi data profil entitas pengguna.<br>• Modifikasi preferensi notifikasi.<br>• Engine penghapusan data akun secara permanen dari sistem basis data. |
| **Yuliana** <br> *(24SA11A043)* | • Control Center / Panel Admin untuk tata kelola pendaftaran akun Helper baru pasca-seleksi offline.<br>• Halaman informasi statis (*About*, Syarat Operasional, Kebijakan Privasi). | • API filter pencarian data riwayat transaksi penugasan masa lalu (*History* lintas peran).<br>• Kueri verifikasi silang email pendaftaran Helper baru (anti-overlap role). |

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
