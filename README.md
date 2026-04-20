# LKS SMK ITNSA Kota Bekasi 2026 - Linux Environment

Repository ini berisi bahan yang dipakai untuk lomba LKS SMK bidang IT Network
System Administration bagian Linux Environment. Kalau dilihat secara sederhana,
repo ini punya tiga fungsi utama:

- menyimpan soal lomba,
- membantu panitia menyiapkan server peserta,
- membantu proses penilaian dan pengambilan bukti konfigurasi.

Kalau kamu siswa yang sedang belajar Linux, repo ini juga menarik karena isinya
menunjukkan gambaran dunia kerja yang cukup nyata: ada provisioning server,
otomatisasi dengan Ansible, penilaian layanan Linux, sampai pengumpulan evidence.

## Isi Repository

```text
.
|- LKS_ITNSA_Linux_Environment_Bekasi_2026.pdf
|- Grading Sheet LKS Linux Environment Bekasi 2026.xlsx
|- README.md
|- autograding/
|- evidence/
`- terraform/
```

## Penjelasan File Dan Folder

### `LKS_ITNSA_Linux_Environment_Bekasi_2026.pdf`

Ini adalah dokumen soal utama lomba. Di dalamnya biasanya ada daftar tugas yang
harus dikerjakan peserta, misalnya konfigurasi DNS, web server, mail server,
firewall, backup, atau layanan lain yang umum di Linux server.

Kalau kamu ingin memahami tujuan akhir dari repo ini, mulai dari file ini dulu.
Soalnya semua proses lain di repo pada dasarnya dibuat untuk mendukung isi soal.

### `Grading Sheet LKS Linux Environment Bekasi 2026.xlsx`

File ini adalah lembar penilaian. Hasil penilaian otomatis dari folder
`autograding/` nantinya bisa dimasukkan ke sini agar nilai peserta lebih mudah
direkap.

Dari isi workbook yang ada, sheet ini sudah menyiapkan kolom untuk:

- nilai tiap bagian soal,
- total nilai inti,
- bonus Ansible,
- skor akhir.

Jadi singkatnya, kalau `grade_all.yml` menghasilkan data mentah penilaian,
file Excel ini dipakai untuk melihat hasil akhirnya dengan lebih rapi.

### `README.md`

File yang sedang kamu baca sekarang. Tujuannya sebagai peta awal supaya pembaca
tidak langsung bingung melihat banyak file dan folder.

### `autograding/`

Folder ini berisi sistem penilaian otomatis berbasis Ansible. Tugasnya adalah
mengecek kondisi server peserta, lalu memberi skor berdasarkan layanan yang
berhasil dikonfigurasi.

Kalau kamu baru belajar Linux, folder ini menarik untuk dipelajari karena kamu
bisa melihat layanan apa saja yang dianggap penting dalam sebuah server Linux dan
bagaimana layanan itu dicek secara otomatis.

Penjelasan lebih lengkap ada di [autograding/README.md](autograding/README.md).

### `evidence/`

Folder ini dipakai untuk mengambil bukti konfigurasi dari server peserta.
Misalnya file konfigurasi, log layanan, dump database, status service, rules
iptables, dan sebagainya.

Fungsi folder ini penting saat panitia ingin menyimpan jejak hasil pekerjaan
peserta sebelum VM dimatikan atau dihapus.

Penjelasan lebih lengkap ada di [evidence/README.md](evidence/README.md).

### `terraform/`

Folder ini dipakai untuk menyiapkan VM peserta secara otomatis di Linode.
Daripada membuat server satu per satu secara manual, panitia bisa memakai
Terraform untuk membuat banyak VM sekaligus dengan pola yang konsisten.

Kalau kamu sedang belajar cloud atau infrastruktur, folder ini memberi contoh
sederhana tentang konsep Infrastructure as Code.

Penjelasan lebih lengkap ada di [terraform/README.md](terraform/README.md).

## Alur Kerja Repository Ini

Supaya lebih mudah dipahami, begini alurnya:

1. Panitia menyiapkan VM peserta lewat folder `terraform/`.
2. Peserta mengerjakan soal sesuai dokumen PDF.
3. Panitia menjalankan `autograding/grade_all.yml` untuk mengecek hasil kerja.
4. Nilai yang dihasilkan dimasukkan ke grading sheet Excel.
5. Jika perlu, panitia menjalankan `evidence/collect_evidence.yml` untuk menyimpan
   bukti konfigurasi dari semua server.

Dengan kata lain, repo ini tidak hanya berisi soal, tapi juga seluruh alur
pendukung lomba dari awal sampai akhir.

## Kenapa Repo Ini Cocok Untuk Belajar

Kalau kamu siswa SMK yang sedang belajar Linux, ada beberapa hal bagus yang bisa
dipelajari dari repo ini:

- kamu bisa melihat layanan Linux yang sering dipakai di dunia server,
- kamu bisa belajar bahwa administrasi server tidak berhenti di instalasi, tapi
  juga mencakup verifikasi, dokumentasi, keamanan, dan backup,
- kamu bisa memahami bahwa otomatisasi seperti Ansible dan Terraform sangat
  membantu saat jumlah server sudah banyak,
- kamu bisa belajar membaca kebutuhan sistem dari soal, lalu mencocokkannya dengan
  cara pengecekan otomatis.

## Catatan Penting

- Folder evidence sekarang memakai nama `evidence/`, jadi penamaan folder README,
  path contoh, dan perintah terminal sudah disesuaikan dengan nama baru ini.
- File `inventory.ini` dan `terraform.tfvars` berisi data sensitif seperti IP dan
  password. Jadi repo ini lebih cocok dipakai sebagai dokumen operasional internal.
- Di dokumentasi lama sempat disebut file `grade_one.yml`, tetapi file tersebut
  memang belum ada di repository saat ini.

## Saran Kalau Ingin Mulai Belajar Dari Repo Ini

Kalau kamu ingin mempelajari repo ini sebagai bahan belajar, urutan yang paling
enak adalah:

1. baca PDF soal terlebih dahulu,
2. lihat folder `autograding/` untuk memahami aspek apa saja yang dinilai,
3. lihat folder `evidence/` untuk memahami bukti apa saja yang penting disimpan,
4. terakhir pelajari `terraform/` untuk melihat bagaimana server peserta dibuat.

Urutan ini biasanya lebih mudah dipahami daripada langsung membaca semua file
secara acak.
