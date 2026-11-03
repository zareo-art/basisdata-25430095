-- =============================================================================
-- Nama Berkas : p06_data_kopma_25430095.sql
-- Praktikan   : Ridho Naufal Farras Siddik (NIM: 25430095)
-- Modul 6     : Mengisi, Mengubah, dan Menguji Data dengan DML (Kasus Kopma)
-- Basis Data  : kopma_095
-- Standar     : MariaDB 10.4.32 / InnoDB / utf8mb4_unicode_ci
-- =============================================================================

USE kopma_095;

-- -----------------------------------------------------------------------------
-- D.1 PENGISIAN DATA INDUK (MASTER)
-- -----------------------------------------------------------------------------

-- 1. Mengisi Tabel: petugas (5 baris sesuai modul)
INSERT INTO petugas (kode_petugas, nama_petugas, peran_petugas) VALUES
    ('K01', 'Dimas', 'kasir'),
    ('K02', 'Sari', 'kasir'),
    ('K03', 'Rina', 'kasir'),
    ('G01', 'Joko', 'gudang'),
    ('P01', 'Ketua Kopma', 'ketua');

-- 2. Mengisi Tabel: barang (4 baris katalog utama)
INSERT INTO barang (kode_barang, nama_barang, kategori_barang, harga_jual_barang, stok_barang, stok_min_barang) VALUES
    ('ATK-001', 'Pulpen Gel 0.5', 'ATK', 4000.00, 120, 20),
    ('ATK-002', 'Buku Tulis 58', 'ATK', 6500.00, 80, 20),
    ('MNM-001', 'Air Mineral 600', 'minuman', 4000.00, 48, 24),
    ('MKN-001', 'Roti Cokelat', 'makanan', 5000.00, 6, 10);

-- 3. Mengisi Tabel: anggota (minimal 3, satu nonaktif & mendaftar sebelum 2025)
INSERT INTO anggota (no_anggota, nim_anggota, nama_anggota, prodi_anggota, no_hp_anggota, status_anggota, tgl_daftar_anggota) VALUES
    ('A-0457', '2301010123', 'Budi Santoso', 'Ilmu Komputer', '081234567890', 'aktif', '2024-02-15'),
    ('A-0458', '2301010124', 'Citra Lestari', 'Sistem Informasi', '081234567891', 'aktif', '2024-03-10'),
    ('A-0459', '2201010050', 'Doni Pratama', 'Teknik Informatika', '081234567892', 'nonaktif', '2023-09-01'),
    ('A-0460', '2401010011', 'Eko Wahyudi', 'Pendidikan Matematika', '081234567893', 'aktif', '2024-10-05');

-- 4. Mengisi Tabel: pemasok (minimal 2)
INSERT INTO pemasok (nama_pemasok, telepon_pemasok, alamat_pemasok) VALUES
    ('CV Sumber ATK', '081122334455', 'Jl. Sudirman No. 12, Metro'),
    ('UD Segar Pangan', '082233445566', 'Jl. Ahmad Yani No. 45, Metro'),
    ('PT Graha Distribusi', '083344556677', 'Jl. Teuku Umar No. 88, Metro');

-- -----------------------------------------------------------------------------
-- D.2 PENCATATAN NOTA PENJUALAN (Studi Kasus Modul 2: PJ-2609-0142)
-- -----------------------------------------------------------------------------

-- 1. Menyisipkan kepala transaksi penjualan (dilayani Rina id_petugas=3, pembeli Budi id_anggota=1)
INSERT INTO penjualan (no_nota_penjualan, tgl_penjualan, id_petugas, id_anggota, bayar_penjualan)
VALUES ('PJ-2609-0142', '2026-09-24 10:15:00', 3, 1, 30000.00);

-- 2. Mengisi baris detail penjualan menggunakan INSERT ... SELECT (AB-04)
-- Item 1: Pulpen Gel 0.5 (qty: 3)
INSERT INTO detail_penjualan (id_penjualan, id_barang, qty_detail_penjualan, harga_satuan_detail_penjualan)
SELECT 1, id_barang, 3, harga_jual_barang 
FROM barang 
WHERE kode_barang = 'ATK-001';

-- Item 2: Buku Tulis 58 (qty: 2)
INSERT INTO detail_penjualan (id_penjualan, id_barang, qty_detail_penjualan, harga_satuan_detail_penjualan)
SELECT 1, id_barang, 2, harga_jual_barang 
FROM barang 
WHERE kode_barang = 'ATK-002';

-- Item 3: Air Mineral 600 (qty: 1)
INSERT INTO detail_penjualan (id_penjualan, id_barang, qty_detail_penjualan, harga_satuan_detail_penjualan)
SELECT 1, id_barang, 1, harga_jual_barang 
FROM barang 
WHERE kode_barang = 'MNM-001';

-- 3. Memperbarui stok fisik barang di gudang sesuai qty penjualan
UPDATE barang SET stok_barang = stok_barang - 3 WHERE kode_barang = 'ATK-001';
UPDATE barang SET stok_barang = stok_barang - 2 WHERE kode_barang = 'ATK-002';
UPDATE barang SET stok_barang = stok_barang - 1 WHERE kode_barang = 'MNM-001';

-- -----------------------------------------------------------------------------
-- D.3 PENGUJIAN UBAH DAN HAPUS DENGAN MODE AMAN (sql_safe_updates)
-- -----------------------------------------------------------------------------

-- 1. Mengaktifkan mode aman pembaruan SQL
SET SESSION sql_safe_updates = 1;

-- Perintah berikut DITOLAK server (ERROR 1175) bila dijalankan tanpa klausa WHERE berkunci:
-- UPDATE barang SET harga_jual_barang = harga_jual_barang * 1.1;

-- Perintah aman yang DITERIMA server (menyertakan kolom kunci primer):
UPDATE barang 
SET harga_jual_barang = harga_jual_barang * 1.1 
WHERE kategori_barang = 'ATK' AND id_barang > 0;

-- 2. Simulasi Nota Uji Kedua untuk Pembuktian ON DELETE CASCADE
INSERT INTO penjualan (no_nota_penjualan, tgl_penjualan, id_petugas, id_anggota, bayar_penjualan)
VALUES ('PJ-2609-0143', '2026-09-24 11:00:00', 3, NULL, 15000.00);

SET @id_nota_uji := LAST_INSERT_ID();

INSERT INTO detail_penjualan (id_penjualan, id_barang, qty_detail_penjualan, harga_satuan_detail_penjualan)
SELECT @id_nota_uji, id_barang, 2, harga_jual_barang 
FROM barang 
WHERE kode_barang = 'MKN-001';

-- Menghapus nota uji kedua: membuktikan detail_penjualan ikut terhapus otomatis (CASCADE)
DELETE FROM penjualan WHERE id_penjualan = @id_nota_uji;

-- Pembuktian RESTRICT: Perintah berikut DITOLAK (ERROR 1451) karena Rina memiliki riwayat nota
-- DELETE FROM petugas WHERE id_petugas = 3;

-- -----------------------------------------------------------------------------
-- E. LATIHAN DAN MODIFIKASI
-- -----------------------------------------------------------------------------

-- E.1 Pemindahan Anggota Nonaktif yang Mendaftar Sebelum 2025 ke Tabel Arsip
CREATE TABLE IF NOT EXISTS anggota_arsip LIKE anggota;

-- Memindahkan data anggota nonaktif yang mendaftar sebelum 2025 dan belum memiliki transaksi penjualan
INSERT INTO anggota_arsip
SELECT * FROM anggota
WHERE status_anggota = 'nonaktif' 
  AND tgl_daftar_anggota < '2025-01-01'
  AND id_anggota NOT IN (SELECT DISTINCT id_anggota FROM penjualan WHERE id_anggota IS NOT NULL);

-- Menghapus data anggota tersebut dari tabel utama
DELETE FROM anggota
WHERE status_anggota = 'nonaktif' 
  AND tgl_daftar_anggota < '2025-01-01'
  AND id_anggota NOT IN (SELECT DISTINCT id_anggota FROM penjualan WHERE id_anggota IS NOT NULL);

-- E.2 Pembaruan Harga Makanan Naik 5% Dibulatkan ke Ratusan Terdekat
UPDATE barang
SET harga_jual_barang = ROUND(harga_jual_barang * 1.05, -2)
WHERE kategori_barang = 'makanan' AND id_barang > 0;