# Dokumen Kebutuhan Data Sistem Informasi Akademik
**Organisasi Fiktif:** Institut Perlindungan Rakyat RN  
**Penyusun:** [Nama Lengkap Anda] (NIM: [NIM Lengkap Anda, misal 2301010095])  
**Tema:** Akademik (Kode: `akad`)  
**Parameter Personal NIM ($P$):** 6  

---

## 1. Latar Belakang dan Aktivitas Organisasi
Institut Perlindungan Rakyt merupakan institusi perguruan tinggi yang menyelenggarakan pendidikan vokasi dan sarjana demi memeratakan pendidikan agar penyetaraan pendidikan. Pengelolaan akademik sebelumnya menggunakan pencatatan formulir kertas dan lembar kerja spreadsheet yang terpisah antar-fakultas, sehingga sering memicu bentrok jadwal ruang, mahasiswa mengambil mata kuliah melebihi beban SKS maksimum, serta keterlambatan distribusi nilai akhir semester.

Aktivitas utama organisasi yang dikelola basis data meliputi:
1. Pendaftaran dan pemutakhiran data mahasiswa baru dan aktif.
2. Pengelolaan penugasan dosen dan pembukaan katalog kurikulum/mata kuliah.
3. Penjadwalan kelas perkuliahan reguler dan alokasi ruang.
4. Pengisian dan validasi Kartu Rencana Studi (KRS) oleh mahasiswa dan dosen pembimbing akademik (PA).
5. Input nilai hasil belajar mahasiswa dan penerbitan Kartu Hasil Studi (KHS).

---

## 2. Aktor dan Proses Bisnis

| Kode | Proses Bisnis | Aktor Utama | Pemicu (Trigger) |
| :--- | :--- | :--- | :--- |
| **PB-01** | Mengelola Data Mahasiswa & Dosen | Bagian Administrasi Akademik (BAAK) | Penerimaan mahasiswa baru atau pengangkatan dosen pengampu |
| **PB-02** | Membuka Mata Kuliah & Jadwal Kelas | Program Studi / Jurusan | Awal semester sebelum masa perkuliahan dimulai |
| **PB-03** | Mengajukan dan Memvalidasi KRS | Mahasiswa & Dosen Pembimbing Akademik | Awal semester (masa registrasi akademik aktif) |
| **PB-04** | Menginput Nilai Perkuliahan | Dosen Pengampu | Akhir semester setelah ujian semester selesai |
| **PB-05** | Menerbitkan KHS & Evaluasi IPK | Mahasiswa & Kepala Bagian Akademik | Nilai akhir perkuliahan telah terkunci |

---

## 3. Dokumen Sumber yang Dianalisis
Dokumen sumber yang dibedah adalah formulir cetak resmi **Kartu Rencana Studi (KRS)**:
+-----------------------------------------------------------------------------------+
|                           Institut Perlindungan Rakyat RN                         |
|                             KARTU RENCANA STUDI (KRS)                             |
|                                                                                   |
| No. Registrasi : KRS-20261-0095               Semester / TA : Ganjil 2026/2027    |
| Tanggal KRS    : 07-09-2026 09:30             Program Studi : Ilmu Komputer (S1)  |
| NIM            : 2301010095                   Dosen PA      : Dr. Surya, M.Kom.   |
| Nama Mahasiswa : [Nama Lengkap Anda]          Status Regist : Disetujui           |
+----+-------------+-------------------------+-----+-------+---------------+--------+
| No | Kode Kelas  | Nama Mata Kuliah        | SKS | Hari  | Jam & Ruang   | Dosen  |
+----+-------------+-------------------------+-----+-------+---------------+--------+
| 1  | IF301-A     | Basis Data              |  3  | Senin | 08.00 (Lab 2) | DI, MTI|
| 2  | IF302-A     | Pendidikan pancasila    |  3  | Rabu  | 10.00 (R.301) | AS, MT |
| 3  | IF303-B     | Dasar Pemograman        |  3  | Kamis | 13.00 (Lab 1) | YP, Kom|
+----+-------------+-------------------------+-----+-------+---------------+--------+
| Total Mata Kuliah : 3                          Total SKS Rencana : 9 SKS          |
| Batas Pengambilan : Maks. 8 Mata Kuliah (P+2)               Maks. 24 SKS          |
+-----------------------------------------------------------------------------------+
| Tanda Tangan Mahasiswa,                            Tanda Tangan Dosen PA,         |
|                                                                                   |
| (....................)                             ( Dr. Surya, M.Kom. )          |
+-----------------------------------------------------------------------------------+


## 4. Entitas Kandidat dan Elemen Data
* **Mahasiswa**: `id_mahasiswa`, `nim_mahasiswa`, `nama_mahasiswa`, `prodi_mahasiswa`, `no_hp_mahasiswa`, `email_mahasiswa`, `status_mahasiswa`, `tgl_daftar_mahasiswa`
* **Dosen**: `id_dosen`, `nidn_dosen`, `nama_dosen`, `gelar_dosen`, `no_hp_dosen`, `status_dosen`
* **Mata Kuliah**: `id_mata_kuliah`, `kode_mata_kuliah`, `nama_mata_kuliah`, `sks_mata_kuliah`, `semester_rekomendasi`
* **Kelas Perkuliahan**: `id_kelas`, `kode_kelas`, `id_mata_kuliah`, `id_dosen`, `semester_ta`, `hari_kelas`, `jam_mulai_kelas`, `ruang_kelas`, `kuota_kelas`
* **KRS (Kepala Dokumen)**: `id_krs`, `no_krs`, `id_mahasiswa`, `id_dosen_pa`, `semester_krs`, `tgl_pengajuan_krs`, `status_krs`
* **Detail KRS / Nilai**: `id_krs`, `id_kelas`, `nilai_angka`, `nilai_huruf`, `tgl_input_nilai`

---

## 5. Aturan Bisnis (AB)
* **AB-01**: Nomor registrasi KRS berformat unik (`KRS-YYYY[1/2]-NNNN`) dan hanya diterbitkan satu kali per mahasiswa pada semester berjalan.
* **AB-02**: Mahasiswa yang berhak mengisi dan mengajukan KRS wajib memiliki status akademik `aktif`.
* **AB-03**: Jumlah mata kuliah yang diambil mahasiswa dalam satu semester dibatasi paling banyak P + 2 = 8 mata kuliah (berdasarkan parameter P = 6).
* **AB-04**: Total beban studi per semester dibatasi maksimal 24 SKS.
* **AB-05**: Pendaftaran ke suatu kelas perkuliahan ditolak bila kuota kelas sudah terpenuhi (`kuota_kelas >= 0`).
* **AB-06**: Setiap rombongan belajar/kelas dibina oleh tepat satu dosen pengampu dan merujuk tepat satu mata kuliah.
* **AB-07**: Nilai angka evaluasi hasil studi berada pada rentang valid 0.00 hingga 100.00, yang dikonversikan ke huruf mutu A, B, C, D, atau E.
* **AB-08**: NIM mahasiswa dan NIDN dosen unik serta tidak boleh terduplikasi di seluruh basis data.

---

## 6. Kebutuhan Informasi (KI)
* **KI-01**: Rekapitulasi jumlah mahasiswa aktif dan total SKS yang diambil per Program Studi pada semester berjalan.
* **KI-02**: Daftar mata kuliah dengan peminat tertinggi serta daftar kelas yang kuotanya telah penuh.
* **KI-03**: Daftar pengajuan KRS yang statusnya masih menunggu validasi dosen pembimbing akademik menjelang batas akhir registrasi.
* **KI-04**: Kartu Hasil Studi (KHS) mahasiswa yang memuat rincian nilai angka, huruf mutu, dan perhitungan Indeks Prestasi Semester (IPS).
* **KI-05**: Rekapitulasi beban mengajar dosen (jumlah kelas dan total SKS yang diampu) pada semester berjalan.

---

## 7. Matriks CRUD
| Proses Bisnis | Mahasiswa | Dosen | Mata Kuliah | Kelas | KRS | Detail KRS |
| :--- | :---: | :---: | :---: | :---: | :---: | :---: |
| **PB-01** Mengelola Data Mahasiswa & Dosen | C, R, U | C, R, U | - | - | - | - |
| **PB-02** Membuka Mata Kuliah & Jadwal Kelas | - | R | C, R, U | C, R, U | - | - |
| **PB-03** Mengajukan dan Memvalidasi KRS | R | R | R | R, U | C, R, U | C, R |
| **PB-04** Menginput Nilai Perkuliahan | - | R | - | R | R | U |
| **PB-05** Menerbitkan KHS & Evaluasi IPK | R | - | R | R | R | R |

---

## 8. Kamus Data Awal
| Elemen Data | Deskripsi | Contoh Nilai | Aturan / Validasi | Penanggung Jawab |
| :--- | :--- | :--- | :--- | :--- |
| `nim_mahasiswa` | Nomor Induk Mahasiswa | 25430095 | Unik, 8 digit numerik | BAAK |
| `nama_mahasiswa` | Nama lengkap mahasiswa | [Ridho Naufal Farras Siddik] | Teks, NOT NULL | BAAK |
| `prodi_mahasiswa` | Program studi mahasiswa | Ilmu Komputer | Teks, NOT NULL | BAAK |
| `no_hp_mahasiswa` | Nomor kontak mahasiswa | 081234567890 | Format 08..., Data Pribadi | BAAK |
| `status_mahasiswa` | Status keaktifan | aktif | ENUM('aktif','cuti','lulus') | BAAK |
| `tgl_daftar_mahasiswa` | Tanggal registrasi awal | 2024-08-15 | DATE, NOT NULL | BAAK |
| `nidn_dosen` | Nomor Induk Dosen Nasional | 0012058001 | Unik, 10 digit numerik | Bagian Kepegawaian |
| `nama_dosen` | Nama lengkap dosen | Dr. Surya | Teks, NOT NULL | Bagian Kepegawaian |
| `gelar_dosen` | Gelar akademik dosen | M.Kom. | Teks singkat | Bagian Kepegawaian |
| `status_dosen` | Status keaktifan mengajar | aktif | ENUM('aktif','studi_lanjut','cuti') | Bagian Kepegawaian |
| `kode_mata_kuliah` | Kode katalog kurikulum | IF301 | Unik, teks format baku | Program Studi |
| `nama_mata_kuliah` | Nama mata kuliah | Basis Data | Teks, NOT NULL | Program Studi |
| `sks_mata_kuliah` | Beban kredit semester | 3 | Bilangan bulat 1 sampai 6 | Program Studi |
| `kode_kelas` | Identitas rombel perkuliahan | IF301-A | Unik per semester | Bagian Penjadwalan |
| `hari_kelas` | Hari perkuliahan | Senin | ENUM('Senin'..'Sabtu') | Bagian Penjadwalan |
| `jam_mulai_kelas` | Waktu sesi kuliah dimulai | 08:00:00 | TIME, format HH:MM:SS | Bagian Penjadwalan |
| `ruang_kelas` | Kode lokasi ruang kelas/lab | Lab Komputer 2 | Teks | Bagian Penjadwalan |
| `kuota_kelas` | Kapasitas kursi mahasiswa | 40 | Integer non-negatif | Bagian Penjadwalan |
| `no_krs` | Nomor dokumen registrasi | KRS-20261-0095 | Unik, format YYYYS-NNNN | BAAK |
| `status_krs` | Status persetujuan Dosen PA | Disetujui | ENUM('Draft','Diajukan','Disetujui') | Dosen PA |
| `nilai_angka` | Nilai akhir hasil evaluasi | 88.50 | DECIMAL(5,2), rentang 0-100 | Dosen Pengampu |
| `nilai_huruf` | Huruf mutu hasil belajar | A | ENUM('A','B','C','D','E') | Dosen Pengampu |

---

## 9. Kebutuhan Non-Fungsional Data
### Perhitungan Parameter Personal ($P$):
* **Rumus**: $P = (\text{2 digit terakhir NIM} \pmod 9) + 1$
* **Perhitungan**: $P = (95 \pmod 9) + 1 = 5 + 1 = \mathbf{6}$
* **Batas Maksimal Item (Mata Kuliah) per Transaksi KRS**: $P + 2 = 6 + 2 = \mathbf{8\text{ mata kuliah}}$
* **Tarif Denda Keterlambatan Administrasi**: $P \times 1.000 = \mathbf{\text{Rp}6.000/\text{hari}}$
* **Estimasi Volume Transaksi KRS Harian**: $40 + (5 \times P) = 40 + (5 \times 6) = \mathbf{70\text{ transaksi/hari}}$

### Kebutuhan Non-Fungsional Sistem:
* **Retensi Data**: Riwayat pengambilan KRS dan nilai kelulusan disimpan permanen minimal 7 tahun setelah mahasiswa berstatus lulus untuk keperluan audit transkrip dan ijazah.
* **Privasi Data Pribadi**: Kolom `no_hp_mahasiswa` dan `no_hp_dosen` bersifat rahasia dan hanya dapat diakses oleh staf berwenang di BAAK serta pimpinan program studi. Dosen pengampu biasa hanya dapat melihat daftar nama serta NIM mahasiswa di kelasnya.

---

## 10. Isu Kualitas Data yang Diantisipasi
* **NIM dan NIDN Tidak Valid**: Input nomor induk yang memuat spasi, tanda hubung, atau panjangnya bukan 10 digit. Diantisipasi dengan pembersihan karakter non-numerik dan validasi format regex.
* **Jadwal Kelas Bentrok**: Mahasiswa mendaftar pada dua kelas berbeda yang berjalan pada hari dan jam yang sama. Diantisipasi dengan aturan validasi jadwal sebelum penyimpanan KRS.
* **Nilai Di Luar Batas Standar**: Potensi kekeliruan ketik oleh dosen (misalnya nilai negatif atau di atas 100.00). Diantisipasi dengan constraint `CHECK (nilai_angka BETWEEN 0 AND 100)`.
EOF