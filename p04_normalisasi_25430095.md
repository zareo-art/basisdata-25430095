# Dokumen Normalisasi Basis Data - Institut Perlindungan Rakyat RN
**Penyusun:** Ridho Naufal Farras Siddik  
**NIM:** 25430095  
**Basis Data:** `akad_095`  
**Parameter $P$:** 6 (Batas maksimal mata kuliah per KRS = $P + 2 = 8$)  

---

## 1. Dokumen Sumber Acuan
Analisis normalisasi ini didasarkan pada formulir **Kartu Rencana Studi (KRS)** mahasiswa pada semester aktif di Institut Perlindungan Rakyat RN.

Dokumen sumber memuat data:
* Identitas KRS: Nomor KRS, Semester, Tahun Akademik, Tanggal Pengajuan, Status Validasi.
* Identitas Mahasiswa: NIM, Nama Mahasiswa, Program Studi, No HP Mahasiswa.
* Dosen Pembimbing Akademik (PA): NIDN Dosen PA, Nama Dosen PA.
* Rincian Rombongan Belajar (Rombel) Kelas & Mata Kuliah: Kode Kelas, Nama Kelas, Jadwal (Hari/Jam), Ruang, Kode Mata Kuliah, Nama Mata Kuliah, SKS, NIDN Dosen Pengampu, Nama Dosen Pengampu.
* Hasil Evaluasi: Nilai Angka, Nilai Huruf.
* Nilai Ringkasan/Turunan: Total Beban SKS Semester, Indeks Prestasi Semester (IPS).

---

## 2. Tahap Unnormalized Form (UNF)
Pada bentuk UNF, satu formulir KRS memuat atribut skalar identitas transaksi dan grup berulang (*repeating group*) berupa daftar kelas/mata kuliah yang diambil:

```text
KRS_UNF (
    no_krs, tgl_pengajuan, semester_krs, tahun_akademik, status_krs,
    nim_mahasiswa, nama_mahasiswa, prodi_mahasiswa, no_hp_mahasiswa,
    nidn_dosen_pa, nama_dosen_pa,
    { kode_kelas, nama_kelas, hari_kelas, jam_kelas, ruang_kelas, kuota_kelas,
      kode_mk, nama_mk, sks_mk, nidn_dosen_pengampu, nama_dosen_pengampu,
      nilai_angka, nilai_huruf },
    total_sks_krs, ips_semester
)
```

---

## 3. Tahap First Normal Form (1NF)
Menghilangkan grup berulang. Setiap baris dijadikan satu nilai tunggal. Kunci primer menjadi gabungan (no_krs, kode_kelas):

```text
KRS_1NF (
    no_krs*, kode_kelas*, tgl_pengajuan, semester_krs, tahun_akademik, status_krs,
    nim_mahasiswa, nama_mahasiswa, prodi_mahasiswa, no_hp_mahasiswa,
    nidn_dosen_pa, nama_dosen_pa,
    nama_kelas, hari_kelas, jam_kelas, ruang_kelas, kuota_kelas,
    kode_mk, nama_mk, sks_mk, nidn_dosen_pengampu, nama_dosen_pengampu,
    nilai_angka, nilai_huruf, total_sks_krs, ips_semester
)
* Primary Key Komposit: (no_krs, kode_kelas)
```

---

## 4. Daftar Dependensi Fungsional (Functional Dependency)
Diturunkan dari aturan bisnis (AB) Pertemuan 2:
* **FD1 (Aturan AB-01, AB-02):**  
  `no_krs` -> `tgl_pengajuan`, `semester_krs`, `tahun_akademik`, `status_krs`, `nim_mahasiswa`, `nidn_dosen_pa`
* **FD2 (Aturan AB-05):**  
  `nim_mahasiswa` -> `nama_mahasiswa`, `prodi_mahasiswa`, `no_hp_mahasiswa`
* **FD3:**  
  `nidn_dosen_pa` -> `nama_dosen_pa`
* **FD4 (Aturan AB-06):**  
  `kode_kelas` -> `nama_kelas`, `hari_kelas`, `jam_kelas`, `ruang_kelas`, `kuota_kelas`, `kode_mk`, `nidn_dosen_pengampu`
* **FD5:**  
  `kode_mk` -> `nama_mk`, `sks_mk`
* **FD6:**  
  `nidn_dosen_pengampu` -> `nama_dosen_pengampu`
* **FD7 (Aturan AB-04):**  
  `(no_krs, kode_kelas)` -> `nilai_angka`, `nilai_huruf`
* **FD8 (Nilai Turunan):**  
  Kumpulan `sks_mk` per `no_krs` -> `total_sks_krs`
* **FD9 (Nilai Turunan):**  
  Kumpulan `(sks_mk, nilai_angka)` per `no_krs` -> `ips_semester`

---

## 5. Tahap Second Normal Form (2NF)
Menghilangkan ketergantungan parsial pada kunci komposit `(no_krs, kode_kelas)`:
* Atribut yang hanya bergantung pada `no_krs` (FD1) dipisah ke relasi **KRS**.
* Atribut yang hanya bergantung pada `kode_kelas` (FD4) dipisah ke relasi **KELAS**.
* Atribut yang bergantung penuh pada kunci gabungan `(no_krs, kode_kelas)` (FD7) tetap berada di relasi **DETAIL_KRS**.
* Nilai turunan `total_sks_krs` dan `ips_semester` dikeluarkan dari tabel operasional.

```text
KRS (no_krs, tgl_pengajuan, semester_krs, tahun_akademik, status_krs, nim_mahasiswa, nama_mahasiswa, prodi_mahasiswa, no_hp_mahasiswa, nidn_dosen_pa, nama_dosen_pa)

DETAIL_KRS (no_krs*, kode_kelas*, nilai_angka, nilai_huruf)

KELAS (kode_kelas, nama_kelas, hari_kelas, jam_kelas, ruang_kelas, kuota_kelas, kode_mk, nama_mk, sks_mk, nidn_dosen_pengampu, nama_dosen_pengampu)
```

---

## 6. Tahap Third Normal Form (3NF)
Menghilangkan ketergantungan transitif pada atribut bukan kunci:
1. Pada tabel **KRS**:
   * Rantai transitif: `no_krs` -> `nim_mahasiswa` -> `(nama_mahasiswa, prodi_mahasiswa, no_hp_mahasiswa)`.
   * Rantai transitif: `no_krs` -> `nidn_dosen_pa` -> `nama_dosen_pa`.
   * **Solusi:** Pisahkan data mahasiswa ke tabel **MAHASISWA** dan dosen ke tabel **DOSEN**.
2. Pada tabel **KELAS**:
   * Rantai transitif: `kode_kelas` -> `kode_mk` -> `(nama_mk, sks_mk)`.
   * Rantai transitif: `kode_kelas` -> `nidn_dosen_pengampu` -> `nama_dosen_pengampu`.
   * **Solusi:** Pisahkan data mata kuliah ke tabel **MATA_KULIAH** dan tautkan dosen pengampu ke master **DOSEN**.

### Skema Relasional 3NF (Kunci Alami):
```text
MAHASISWA (nim_mahasiswa, nama_mahasiswa, prodi_mahasiswa, no_hp_mahasiswa)

DOSEN (nidn_dosen, nama_dosen, email_dosen)

MATA_KULIAH (kode_mk, nama_mk, sks_mk)

KELAS (kode_kelas, nama_kelas, hari_kelas, jam_kelas, ruang_kelas, kuota_kelas, kode_mk*, nidn_dosen*)

KRS (no_krs, tgl_pengajuan, semester_krs, tahun_akademik, status_krs, nim_mahasiswa*, nidn_dosen_pa*)

DETAIL_KRS (no_krs*, kode_kelas*, nilai_angka, nilai_huruf)
```

---

## 7. Pemeriksaan Boyce-Codd Normal Form (BCNF)
Sebuah relasi memenuhi BCNF jika untuk setiap dependensi fungsional X -> Y, determinan X merupakan superkey (kandidat kunci).

| Tabel | Dependensi Fungsional (X -> Y) | Apakah Penentu (X) Kandidat Kunci? | Status BCNF |
| :--- | :--- | :---: | :---: |
| `mahasiswa` | `nim_mahasiswa` -> semua atribut | Ya (`nim_mahasiswa` adalah PK) | **Memenuhi BCNF** |
| `dosen` | `nidn_dosen` -> semua atribut | Ya (`nidn_dosen` adalah PK) | **Memenuhi BCNF** |
| `mata_kuliah` | `kode_mk` -> semua atribut | Ya (`kode_mk` adalah PK) | **Memenuhi BCNF** |
| `kelas` | `kode_kelas` -> semua atribut | Ya (`kode_kelas` adalah PK) | **Memenuhi BCNF** |
| `krs` | `no_krs` -> semua atribut | Ya (`no_krs` adalah PK) | **Memenuhi BCNF** |
| `detail_krs` | `(no_krs, kode_kelas)` -> `nilai_angka`, `nilai_huruf` | Ya (`(no_krs, kode_kelas)` adalah PK komposit) | **Memenuhi BCNF** |

**Kesimpulan:** Seluruh tabel telah memenuhi syarat BCNF karena tidak ada determinan non-kunci yang menentukan atribut lain.

---

## 8. Keputusan Penyimpanan Nilai Turunan
1. **Total SKS per KRS (`total_sks_krs`):**  
   * **Keputusan:** **Tidak Disimpan** di tabel fisik operasional.  
   * **Alasan:** Nilai total SKS dapat dihitung secara dinamis melalui kueri agregasi `SUM(mk.sks_mk)`. Menyimpannya di tabel `krs` rawan menimbulkan anomali inkonsistensi data ketika mahasiswa melakukan pembatalan kelas (batal/tambah KRS).
2. **Indeks Prestasi Semester (`ips_semester`):**  
   * **Keputusan:** **Tidak Disimpan** di tabel fisik operasional.  
   * **Alasan:** Merupakan hasil kalkulasi bobot nilai terhadap SKS (`SUM(sks * bobot) / SUM(sks)`). Nilai ini baru bersifat final setelah seluruh dosen pengampu menginputkan nilai dan dapat dihitung saat pencetakan KHS.
3. **Nilai Huruf Mutu (`nilai_huruf`):**  
   * **Keputusan:** **Disimpan** di tabel `detail_krs`.  
   * **Alasan:** Nilai huruf merupakan konversi skala institusi yang menjadi ketetapan resmi pengesahan nilai akhir dan berfungsi sebagai bukti rekam mutasi akademik tetap.

---

## 9. Skema Relasional Akhir (Implementasi Kunci Pengganti / Surrogate Key)
Sesuai standar buku praktikum (Tabel P.3 & Modul 5), seluruh tabel menggunakan surrogate key `id_*` berjenis integer sebagai *Primary Key*, sedangkan kode alami diberi indeks *UNIQUE*:

1. **`mahasiswa`**: `id_mahasiswa` (PK), `nim_mahasiswa` (UQ), `nama_mahasiswa`, `prodi_mahasiswa`, `no_hp_mahasiswa`, `status_mahasiswa`, `tgl_daftar_mahasiswa`
2. **`dosen`**: `id_dosen` (PK), `nidn_dosen` (UQ), `nama_dosen`, `email_dosen`, `no_hp_dosen`
3. **`mata_kuliah`**: `id_mata_kuliah` (PK), `kode_mk` (UQ), `nama_mk`, `sks_mk`, `semester_paket`
4. **`kelas`**: `id_kelas` (PK), `kode_kelas` (UQ), `nama_kelas`, `tahun_akademik`, `semester`, `id_mata_kuliah` (FK), `id_dosen` (FK), `kuota_kelas`, `hari_kelas`, `jam_kelas`, `ruang_kelas`
5. **`krs`**: `id_krs` (PK), `no_krs` (UQ), `tgl_pengajuan`, `semester_krs`, `tahun_akademik`, `id_mahasiswa` (FK), `id_dosen_pa` (FK), `status_krs`
6. **`detail_krs`**: `(id_krs, id_kelas)` (PK Komposit & FK), `nilai_angka`, `nilai_huruf`, `tgl_input_nilai`