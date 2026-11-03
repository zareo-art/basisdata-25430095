-- =============================================================================
-- Nama Berkas : p06_data_25430095.sql
-- Praktikan   : Ridho Naufal Farras Siddik (NIM: 25430095)
-- Modul 6     : Data Sampel dan Skenario Uji (Proyek Mandiri)
-- Basis Data  : akad_095
-- Organisasi  : Institut Perlindungan Rakyat RN
-- Tema Proyek : Sistem Informasi Akademik (Kode: akad)
-- Parameter P : P = (95 mod 9) + 1 = 6
-- Target Data : Tabel Master >= 5 baris, Transaksi Utama >= 10 x P = 60 baris
-- Standar     : MariaDB 10.4.32 / InnoDB / utf8mb4_unicode_ci
-- =============================================================================

USE akad_095;

-- -----------------------------------------------------------------------------
-- 1. PEMBERSIHAN DATA SEBELUM PENGISIAN ULANG (IDEMPOTENT RE-RUNNABLE)
-- Urutan penghapusan: detail transaksi -> kepala transaksi -> master anak -> master induk
-- -----------------------------------------------------------------------------
DELETE FROM detail_krs;
DELETE FROM krs;
DELETE FROM kelas;
DELETE FROM mata_kuliah;
DELETE FROM dosen;
DELETE FROM mahasiswa;

ALTER TABLE mahasiswa AUTO_INCREMENT = 1;
ALTER TABLE dosen AUTO_INCREMENT = 1;
ALTER TABLE mata_kuliah AUTO_INCREMENT = 1;
ALTER TABLE kelas AUTO_INCREMENT = 1;
ALTER TABLE krs AUTO_INCREMENT = 1;

-- -----------------------------------------------------------------------------
-- 2. PENGISIAN DATA MASTER INDUK (Minimal 5 Baris per Tabel)
-- -----------------------------------------------------------------------------

-- Tabel: mahasiswa (12 baris: aktif, cuti, lulus)
INSERT INTO mahasiswa (nim_mahasiswa, nama_mahasiswa, prodi_mahasiswa, no_hp_mahasiswa, email_mahasiswa, status_mahasiswa, tgl_daftar_mahasiswa) VALUES
    ('25430095', 'Ridho Naufal Farras Siddik', 'Ilmu Komputer', '081298765430', 'ridho.25430095@student.ipr-rn.ac.id', 'aktif', '2025-08-15'),
    ('25430001', 'Ahmad Fauzi Rahman', 'Ilmu Komputer', '081298765431', 'ahmad.fauzi@student.ipr-rn.ac.id', 'aktif', '2025-08-15'),
    ('25430002', 'Bunga Citra Lestari', 'Ilmu Komputer', '081298765432', 'bunga.citra@student.ipr-rn.ac.id', 'aktif', '2025-08-15'),
    ('25430003', 'Cahyo Hadi Pratama', 'Sistem Informasi', '081298765433', 'cahyo.hadi@student.ipr-rn.ac.id', 'aktif', '2025-08-16'),
    ('25430004', 'Dina Amelia Safitri', 'Sistem Informasi', '081298765434', 'dina.amelia@student.ipr-rn.ac.id', 'aktif', '2025-08-16'),
    ('25430005', 'Eko Prasetyo Utomo', 'Teknik Informatika', '081298765435', 'eko.prasetyo@student.ipr-rn.ac.id', 'aktif', '2025-08-17'),
    ('25430006', 'Fani Rahmawati', 'Teknik Informatika', '081298765436', 'fani.rahma@student.ipr-rn.ac.id', 'aktif', '2025-08-17'),
    ('25430007', 'Gilang Ramadhan', 'Ilmu Komputer', '081298765437', 'gilang.r@student.ipr-rn.ac.id', 'aktif', '2025-08-18'),
    ('25430008', 'Hesti Nur Aini', 'Sistem Informasi', '081298765438', 'hesti.nur@student.ipr-rn.ac.id', 'aktif', '2025-08-18'),
    ('25430009', 'Indra Setiawan', 'Teknik Informatika', '081298765439', 'indra.s@student.ipr-rn.ac.id', 'aktif', '2025-08-19'),
    ('24430010', 'Joko Susanto', 'Ilmu Komputer', '081298765440', 'joko.s@student.ipr-rn.ac.id', 'cuti', '2024-08-20'),
    ('22430011', 'Kartika Putri Dewanti', 'Sistem Informasi', '081298765441', 'kartika.p@student.ipr-rn.ac.id', 'lulus', '2022-08-20');

-- Tabel: dosen (7 baris: status aktif, studi_lanjut, cuti)
INSERT INTO dosen (nidn_dosen, nama_dosen, gelar_dosen, no_hp_dosen, email_dosen, status_dosen) VALUES
    ('0215088201', 'Dedi Irawan', 'S.Kom., M.T.I.', '081379112233', 'dedi.irawan@ipr-rn.ac.id', 'aktif'),
    ('0220038502', 'Dr. Hendra Gunawan', 'S.Si., M.Kom.', '081379112234', 'hendra.gunawan@ipr-rn.ac.id', 'aktif'),
    ('0211118803', 'Nurul Hidayati', 'S.T., M.Cs.', '081379112235', 'nurul.hidayati@ipr-rn.ac.id', 'aktif'),
    ('0204058904', 'Bambang Tri Atmojo', 'S.Kom., M.M.S.I.', '081379112236', 'bambang.tri@ipr-rn.ac.id', 'aktif'),
    ('0217079005', 'Siti Maryam', 'S.Pd., M.Pd.', '081379112237', 'siti.maryam@ipr-rn.ac.id', 'aktif'),
    ('0225129106', 'Rian Kurniawan', 'S.Kom., M.Kom.', '081379112238', 'rian.k@ipr-rn.ac.id', 'studi_lanjut'),
    ('0218088707', 'Dewi Anggraini', 'S.Si., M.Sc.', '081379112239', 'dewi.a@ipr-rn.ac.id', 'cuti');

-- Tabel: mata_kuliah (8 baris katalog kurikulum)
INSERT INTO mata_kuliah (kode_mk, nama_mk, sks_mk, semester_rekomendasi) VALUES
    ('MK301', 'Basis Data', 3, 3),
    ('MK302', 'Praktikum Basis Data', 1, 3),
    ('MK303', 'Struktur Data & Algoritma', 3, 3),
    ('MK304', 'Pemrograman Berorientasi Objek', 3, 3),
    ('MK305', 'Jaringan Komputer', 3, 3),
    ('MK306', 'Rekayasa Perangkat Lunak', 3, 5),
    ('MK307', 'Kecerdasan Buatan', 3, 5),
    ('MK308', 'Kewarganegaraan & Etika Profesi', 2, 1);

-- -----------------------------------------------------------------------------
-- 3. PENGISIAN DATA OPERASIONAL KELAS PERKULIAHAN (12 Rombongan Belajar)
-- -----------------------------------------------------------------------------
INSERT INTO kelas (kode_kelas, nama_kelas, id_mata_kuliah, id_dosen, semester_ta, tahun_akademik, hari_kelas, jam_mulai_kelas, ruang_kelas, kuota_kelas) VALUES
    ('IF301-A', 'Basis Data - Kelas A', 1, 1, 'Ganjil', '2026/2027', 'Senin', '08:00:00', 'Lab Komputer 1', 40),
    ('IF301-B', 'Basis Data - Kelas B', 1, 1, 'Ganjil', '2026/2027', 'Senin', '10:30:00', 'Lab Komputer 1', 40),
    ('IF302-A', 'Praktikum Basis Data - A', 2, 1, 'Ganjil', '2026/2027', 'Selasa', '13:00:00', 'Lab Basis Data', 35),
    ('IF302-B', 'Praktikum Basis Data - B', 2, 1, 'Ganjil', '2026/2027', 'Rabu', '13:00:00', 'Lab Basis Data', 35),
    ('IF303-A', 'Struktur Data - Kelas A', 3, 2, 'Ganjil', '2026/2027', 'Selasa', '08:00:00', 'Ruang Kuliah 201', 45),
    ('IF303-B', 'Struktur Data - Kelas B', 3, 2, 'Ganjil', '2026/2027', 'Kamis', '08:00:00', 'Ruang Kuliah 202', 45),
    ('IF304-A', 'PBO - Kelas A', 4, 3, 'Ganjil', '2026/2027', 'Rabu', '08:00:00', 'Lab Komputer 2', 40),
    ('IF304-B', 'PBO - Kelas B', 4, 3, 'Ganjil', '2026/2027', 'Jumat', '08:00:00', 'Lab Komputer 2', 40),
    ('IF305-A', 'Jaringan Komputer - A', 5, 4, 'Ganjil', '2026/2027', 'Kamis', '10:30:00', 'Lab Jaringan', 35),
    ('IF306-A', 'Rekayasa Perangkat Lunak', 6, 4, 'Ganjil', '2026/2027', 'Senin', '13:30:00', 'Ruang Kuliah 301', 40),
    ('IF307-A', 'Kecerdasan Buatan', 7, 2, 'Ganjil', '2026/2027', 'Selasa', '10:30:00', 'Ruang Kuliah 302', 40),
    ('IF308-A', 'Kewarganegaraan', 8, 5, 'Ganjil', '2026/2027', 'Jumat', '13:30:00', 'Auditorium Utama', 60);

-- -----------------------------------------------------------------------------
-- 4. PENGISIAN DOKUMEN TRANSAKSI KRS (10 Dokumen KRS, Tersebar 4 Tanggal Berbeda)
-- -----------------------------------------------------------------------------
INSERT INTO krs (no_krs, id_mahasiswa, id_dosen_pa, semester_krs, tahun_akademik, tgl_pengajuan_krs, status_krs) VALUES
    ('KRS-20261-0001', 1, 1, 'Ganjil', '2026/2027', '2026-09-01 08:30:00', 'Disetujui'), -- Mahasiswa 1 (Ridho Naufal)
    ('KRS-20261-0002', 2, 1, 'Ganjil', '2026/2027', '2026-09-01 09:15:00', 'Disetujui'), -- Mahasiswa 2 (Ahmad)
    ('KRS-20261-0003', 3, 1, 'Ganjil', '2026/2027', '2026-09-01 10:45:00', 'Disetujui'), -- Mahasiswa 3 (Bunga)
    ('KRS-20261-0004', 4, 2, 'Ganjil', '2026/2027', '2026-09-02 08:00:00', 'Disetujui'), -- Mahasiswa 4 (Cahyo)
    ('KRS-20261-0005', 5, 2, 'Ganjil', '2026/2027', '2026-09-02 11:20:00', 'Disetujui'), -- Mahasiswa 5 (Dina)
    ('KRS-20261-0006', 6, 3, 'Ganjil', '2026/2027', '2026-09-02 13:40:00', 'Disetujui'), -- Mahasiswa 6 (Eko)
    ('KRS-20261-0007', 7, 3, 'Ganjil', '2026/2027', '2026-09-03 09:00:00', 'Disetujui'), -- Mahasiswa 7 (Fani)
    ('KRS-20261-0008', 8, 4, 'Ganjil', '2026/2027', '2026-09-03 14:10:00', 'Disetujui'), -- Mahasiswa 8 (Gilang)
    ('KRS-20261-0009', 9, 4, 'Ganjil', '2026/2027', '2026-09-04 10:30:00', 'Diajukan'),  -- Mahasiswa 9 (Hesti)
    ('KRS-20261-0010', 10, 5, 'Ganjil', '2026/2027', '2026-09-04 15:00:00', 'Draft');    -- Mahasiswa 10 (Indra)

-- -----------------------------------------------------------------------------
-- 5. PENGISIAN BARIS TRANSAKSI UTAMA: detail_krs (Total: 65 Baris)
-- Memenuhi syarat: Minimal 10 x P = 60 baris, tiap KRS <= P + 2 = 8 mata kuliah.
-- Tersebar pada tanggal input nilai: 2026-10-25, 2026-10-26, dan 2026-10-27
-- -----------------------------------------------------------------------------

-- KRS 1 (Mahasiswa 1: Ridho Naufal) - 6 mata kuliah
INSERT INTO detail_krs (id_krs, id_kelas, nilai_angka, nilai_huruf, tgl_input_nilai) VALUES
    (1, 1, 92.50, 'A', '2026-10-25 14:00:00'),
    (1, 3, 95.00, 'A', '2026-10-25 14:05:00'),
    (1, 5, 88.00, 'A', '2026-10-25 14:10:00'),
    (1, 7, 85.50, 'B', '2026-10-25 14:15:00'),
    (1, 9, 87.00, 'A', '2026-10-25 14:20:00'),
    (1, 12, 90.00, 'A', '2026-10-25 14:25:00');

-- KRS 2 (Mahasiswa 2: Ahmad Fauzi) - 6 mata kuliah
INSERT INTO detail_krs (id_krs, id_kelas, nilai_angka, nilai_huruf, tgl_input_nilai) VALUES
    (2, 1, 84.00, 'B', '2026-10-25 14:00:00'),
    (2, 3, 89.00, 'A', '2026-10-25 14:05:00'),
    (2, 5, 78.50, 'B', '2026-10-25 14:10:00'),
    (2, 8, 82.00, 'B', '2026-10-25 14:15:00'),
    (2, 9, 79.00, 'B', '2026-10-25 14:20:00'),
    (2, 12, 85.00, 'B', '2026-10-25 14:25:00');

-- KRS 3 (Mahasiswa 3: Bunga Citra) - 7 mata kuliah
INSERT INTO detail_krs (id_krs, id_kelas, nilai_angka, nilai_huruf, tgl_input_nilai) VALUES
    (3, 1, 91.00, 'A', '2026-10-25 14:00:00'),
    (3, 3, 94.00, 'A', '2026-10-25 14:05:00'),
    (3, 6, 88.50, 'A', '2026-10-25 14:10:00'),
    (3, 7, 90.00, 'A', '2026-10-25 14:15:00'),
    (3, 9, 86.00, 'A', '2026-10-25 14:20:00'),
    (3, 10, 83.50, 'B', '2026-10-25 14:25:00'),
    (3, 12, 92.00, 'A', '2026-10-25 14:30:00');

-- KRS 4 (Mahasiswa 4: Cahyo Hadi) - 6 mata kuliah
INSERT INTO detail_krs (id_krs, id_kelas, nilai_angka, nilai_huruf, tgl_input_nilai) VALUES
    (4, 2, 76.00, 'B', '2026-10-26 09:00:00'),
    (4, 4, 80.50, 'B', '2026-10-26 09:05:00'),
    (4, 5, 74.00, 'C', '2026-10-26 09:10:00'),
    (4, 7, 85.00, 'B', '2026-10-26 09:15:00'),
    (4, 9, 81.00, 'B', '2026-10-26 09:20:00'),
    (4, 12, 88.00, 'A', '2026-10-26 09:25:00');

-- KRS 5 (Mahasiswa 5: Dina Amelia) - 7 mata kuliah
INSERT INTO detail_krs (id_krs, id_kelas, nilai_angka, nilai_huruf, tgl_input_nilai) VALUES
    (5, 2, 88.00, 'A', '2026-10-26 09:00:00'),
    (5, 4, 91.50, 'A', '2026-10-26 09:05:00'),
    (5, 6, 85.00, 'B', '2026-10-26 09:10:00'),
    (5, 8, 87.50, 'A', '2026-10-26 09:15:00'),
    (5, 9, 84.00, 'B', '2026-10-26 09:20:00'),
    (5, 11, 89.00, 'A', '2026-10-26 09:25:00'),
    (5, 12, 93.00, 'A', '2026-10-26 09:30:00');

-- KRS 6 (Mahasiswa 6: Eko Prasetyo) - 6 mata kuliah
INSERT INTO detail_krs (id_krs, id_kelas, nilai_angka, nilai_huruf, tgl_input_nilai) VALUES
    (6, 1, 79.50, 'B', '2026-10-26 13:00:00'),
    (6, 3, 83.00, 'B', '2026-10-26 13:05:00'),
    (6, 5, 80.00, 'B', '2026-10-26 13:10:00'),
    (6, 7, 75.00, 'C', '2026-10-26 13:15:00'),
    (6, 10, 82.50, 'B', '2026-10-26 13:20:00'),
    (6, 12, 86.00, 'A', '2026-10-26 13:25:00');

-- KRS 7 (Mahasiswa 7: Fani Rahmawati) - 7 mata kuliah
INSERT INTO detail_krs (id_krs, id_kelas, nilai_angka, nilai_huruf, tgl_input_nilai) VALUES
    (7, 2, 90.00, 'A', '2026-10-27 10:00:00'),
    (7, 4, 94.00, 'A', '2026-10-27 10:05:00'),
    (7, 5, 87.00, 'A', '2026-10-27 10:10:00'),
    (7, 8, 89.50, 'A', '2026-10-27 10:15:00'),
    (7, 9, 85.00, 'B', '2026-10-27 10:20:00'),
    (7, 11, 91.00, 'A', '2026-10-27 10:25:00'),
    (7, 12, 95.00, 'A', '2026-10-27 10:30:00');

-- KRS 8 (Mahasiswa 8: Gilang Ramadhan) - 6 mata kuliah
INSERT INTO detail_krs (id_krs, id_kelas, nilai_angka, nilai_huruf, tgl_input_nilai) VALUES
    (8, 1, 81.00, 'B', '2026-10-27 11:00:00'),
    (8, 3, 86.50, 'A', '2026-10-27 11:05:00'),
    (8, 6, 78.00, 'B', '2026-10-27 11:10:00'),
    (8, 7, 80.00, 'B', '2026-10-27 11:15:00'),
    (8, 10, 84.00, 'B', '2026-10-27 11:20:00'),
    (8, 12, 89.00, 'A', '2026-10-27 11:25:00');

-- KRS 9 (Mahasiswa 9: Hesti Nur Aini - Status: Diajukan, nilai belum ada) - 7 mata kuliah
INSERT INTO detail_krs (id_krs, id_kelas, nilai_angka, nilai_huruf, tgl_input_nilai) VALUES
    (9, 2, NULL, NULL, NULL),
    (9, 4, NULL, NULL, NULL),
    (9, 6, NULL, NULL, NULL),
    (9, 8, NULL, NULL, NULL),
    (9, 9, NULL, NULL, NULL),
    (9, 10, NULL, NULL, NULL),
    (9, 12, NULL, NULL, NULL);

-- KRS 10 (Mahasiswa 10: Indra Setiawan - Status: Draft, nilai belum ada) - 7 mata kuliah
INSERT INTO detail_krs (id_krs, id_kelas, nilai_angka, nilai_huruf, tgl_input_nilai) VALUES
    (10, 1, NULL, NULL, NULL),
    (10, 3, NULL, NULL, NULL),
    (10, 5, NULL, NULL, NULL),
    (10, 7, NULL, NULL, NULL),
    (10, 9, NULL, NULL, NULL),
    (10, 11, NULL, NULL, NULL),
    (10, 12, NULL, NULL, NULL);

-- -----------------------------------------------------------------------------
-- VERIFIKASI AKHIR KUANTITAS DATA SAMPEL
-- -----------------------------------------------------------------------------
-- Total Baris detail_krs: 6 + 6 + 7 + 6 + 7 + 6 + 7 + 6 + 7 + 7 = 65 baris (>= 60 baris)