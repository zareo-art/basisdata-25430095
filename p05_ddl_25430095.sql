-- =============================================================================
-- Nama Berkas : p05_ddl_25430095.sql
-- Praktikan   : Ridho Naufal Farras Siddik (NIM: 25430095)
-- Modul 5     : Membangun Struktur dengan DDL dan Constraint (Proyek Mandiri)
-- Basis Data  : akad_095
-- Organisasi  : Institut Perlindungan Rakyat RN
-- Tema Proyek : Akademik (Kode: akad)
-- Parameter P : P = (95 mod 9) + 1 = 6 | Batas Maks. Mata Kuliah = P + 2 = 8
-- Standar     : MariaDB 10.4.32 / InnoDB / utf8mb4_unicode_ci
-- =============================================================================

CREATE DATABASE IF NOT EXISTS akad_095
    CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

USE akad_095;

-- -----------------------------------------------------------------------------
-- 1. DROP TABLE IF EXISTS (Urutan Terbalik: Anak ke Induk)
-- Menghindari galat foreign key constraint saat skrip dijalankan ulang
-- -----------------------------------------------------------------------------
DROP TABLE IF EXISTS detail_krs;
DROP TABLE IF EXISTS krs;
DROP TABLE IF EXISTS kelas;
DROP TABLE IF EXISTS mata_kuliah;
DROP TABLE IF EXISTS dosen;
DROP TABLE IF EXISTS mahasiswa;

-- -----------------------------------------------------------------------------
-- 2. TABEL INDUK / MASTER ENTITY
-- -----------------------------------------------------------------------------

-- Tabel: mahasiswa
-- Menyimpan data pokok mahasiswa terdaftar di Institut Perlindungan Rakyat RN
CREATE TABLE mahasiswa (
    id_mahasiswa INT NOT NULL AUTO_INCREMENT,
    nim_mahasiswa VARCHAR(10) NOT NULL,
    nama_mahasiswa VARCHAR(100) NOT NULL,
    prodi_mahasiswa VARCHAR(60) NOT NULL,
    no_hp_mahasiswa VARCHAR(15) NULL, -- Data pribadi (UU No. 27/2022 PDP)
    email_mahasiswa VARCHAR(100) NULL,
    status_mahasiswa ENUM('aktif', 'cuti', 'lulus') NOT NULL DEFAULT 'aktif', -- AB-02: syarat isi KRS
    tgl_daftar_mahasiswa DATE NOT NULL,
    PRIMARY KEY (id_mahasiswa),
    UNIQUE KEY uq_mahasiswa_nim (nim_mahasiswa), -- AB-08: NIM unik
    UNIQUE KEY uq_mahasiswa_email (email_mahasiswa)
) ENGINE=InnoDB;

-- Tabel: dosen
-- Menyimpan data tenaga pendidik (dosen pengampu dan dosen PA)
CREATE TABLE dosen (
    id_dosen INT NOT NULL AUTO_INCREMENT,
    nidn_dosen CHAR(10) NOT NULL,
    nama_dosen VARCHAR(100) NOT NULL,
    gelar_dosen VARCHAR(30) NULL,
    no_hp_dosen VARCHAR(15) NULL, -- Data pribadi (UU No. 27/2022 PDP)
    email_dosen VARCHAR(100) NULL,
    status_dosen ENUM('aktif', 'studi_lanjut', 'cuti') NOT NULL DEFAULT 'aktif',
    PRIMARY KEY (id_dosen),
    UNIQUE KEY uq_dosen_nidn (nidn_dosen) -- AB-08: NIDN unik
) ENGINE=InnoDB;

-- Tabel: mata_kuliah
-- Katalog kurikulum dan beban kredit akademik
CREATE TABLE mata_kuliah (
    id_mata_kuliah INT NOT NULL AUTO_INCREMENT,
    kode_mk VARCHAR(10) NOT NULL,
    nama_mk VARCHAR(100) NOT NULL,
    sks_mk TINYINT NOT NULL,
    semester_rekomendasi TINYINT NOT NULL,
    PRIMARY KEY (id_mata_kuliah),
    UNIQUE KEY uq_mk_kode (kode_mk),
    CONSTRAINT ck_mk_sks CHECK (sks_mk BETWEEN 1 AND 6), -- Batas beban SKS wajar per mata kuliah
    CONSTRAINT ck_mk_semester CHECK (semester_rekomendasi BETWEEN 1 AND 8)
) ENGINE=InnoDB;

-- -----------------------------------------------------------------------------
-- 3. TABEL OPERASIONAL PERKULIAHAN & TRANSAKSI KRS
-- -----------------------------------------------------------------------------

-- Tabel: kelas
-- Rombongan belajar perkuliahan per semester beserta jadwal, dosen pengampu, dan ruang
CREATE TABLE kelas (
    id_kelas INT NOT NULL AUTO_INCREMENT,
    kode_kelas VARCHAR(15) NOT NULL, -- Format: IF301-A
    nama_kelas VARCHAR(50) NOT NULL,
    id_mata_kuliah INT NOT NULL,
    id_dosen INT NOT NULL,
    semester_ta ENUM('Ganjil', 'Genap') NOT NULL,
    tahun_akademik CHAR(9) NOT NULL, -- Format YYYY/YYYY (misal 2026/2027)
    hari_kelas ENUM('Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu') NOT NULL,
    jam_mulai_kelas TIME NOT NULL,
    ruang_kelas VARCHAR(30) NOT NULL,
    kuota_kelas INT NOT NULL DEFAULT 40,
    PRIMARY KEY (id_kelas),
    UNIQUE KEY uq_kelas_kode (kode_kelas),
    CONSTRAINT fk_kelas_mk FOREIGN KEY (id_mata_kuliah) REFERENCES mata_kuliah (id_mata_kuliah),
    CONSTRAINT fk_kelas_dosen FOREIGN KEY (id_dosen) REFERENCES dosen (id_dosen), -- AB-06: 1 dosen pengampu per kelas
    CONSTRAINT ck_kelas_kuota CHECK (kuota_kelas >= 0) -- AB-05: kuota tidak boleh bernilai negatif
) ENGINE=InnoDB;

-- Tabel: krs (Kepala Dokumen Kartu Rencana Studi)
-- Satu baris mewakili satu formulir registrasi studi mahasiswa per semester
CREATE TABLE krs (
    id_krs INT NOT NULL AUTO_INCREMENT,
    no_krs VARCHAR(20) NOT NULL, -- Format KRS-YYYY[1/2]-NNNN (AB-01)
    id_mahasiswa INT NOT NULL,
    id_dosen_pa INT NOT NULL,
    semester_krs ENUM('Ganjil', 'Genap') NOT NULL,
    tahun_akademik CHAR(9) NOT NULL,
    tgl_pengajuan_krs DATETIME NOT NULL,
    status_krs ENUM('Draft', 'Diajukan', 'Disetujui', 'Ditolak') NOT NULL DEFAULT 'Draft',
    PRIMARY KEY (id_krs),
    UNIQUE KEY uq_krs_nomor (no_krs), -- AB-01: nomor registrasi unik
    CONSTRAINT fk_krs_mahasiswa FOREIGN KEY (id_mahasiswa) REFERENCES mahasiswa (id_mahasiswa),
    CONSTRAINT fk_krs_dosen_pa FOREIGN KEY (id_dosen_pa) REFERENCES dosen (id_dosen)
) ENGINE=InnoDB;

-- Tabel: detail_krs (Entitas Asosiatif Pengambilan Kelas & Nilai)
-- Menghubungkan KRS dengan kelas perkuliahan serta menyimpan hasil evaluasi belajar
CREATE TABLE detail_krs (
    id_krs INT NOT NULL,
    id_kelas INT NOT NULL,
    nilai_angka DECIMAL(5,2) NULL, -- Rentang nilai 0.00 - 100.00 (AB-07)
    nilai_huruf ENUM('A', 'B', 'C', 'D', 'E') NULL,
    tgl_input_nilai DATETIME NULL,
    PRIMARY KEY (id_krs, id_kelas),
    CONSTRAINT fk_detail_krs_krs FOREIGN KEY (id_krs) REFERENCES krs (id_krs) ON DELETE CASCADE,
    CONSTRAINT fk_detail_krs_kelas FOREIGN KEY (id_kelas) REFERENCES kelas (id_kelas),
    CONSTRAINT ck_detail_krs_nilai CHECK (nilai_angka IS NULL OR (nilai_angka >= 0.00 AND nilai_angka <= 100.00)) -- AB-07
) ENGINE=InnoDB;

-- =============================================================================
-- CATATAN ANALISIS ATURAN BATAS P + 2 (AB-03 & AB-04):
-- 1. Berdasarkan parameter personal P = 6, batas maksimal mata kuliah per KRS 
--    adalah P + 2 = 8 mata kuliah (AB-03), dan beban total maksimal 24 SKS (AB-04).
-- 2. Analisis Implementasi Constraint:
--    - Batasan nilai baris tunggal (seperti kuota_kelas >= 0, sks_mk 1..6, dan 
--      nilai_angka 0..100) berhasil dijaga langsung oleh constraint CHECK.
--    - Batasan kardinalitas transaksi (maksimal 8 mata kuliah per dokumen KRS 
--      serta total beban <= 24 SKS) melibatkan agregasi banyak baris (COUNT/SUM) 
--      pada tabel detail_krs untuk satu id_krs.
--    - MariaDB 10.4 tidak mengizinkan subquery / agregasi di dalam klausa CHECK.
--    - Oleh karena itu, batasan P + 2 ini ditandai sebagai UTANG DESAIN yang akan 
--      dijamin integritasnya pada lapisan transaksi terkelola di Modul 14.
-- =============================================================================