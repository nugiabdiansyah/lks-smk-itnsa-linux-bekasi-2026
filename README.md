# LKS SMK ITNSA Kota Bekasi 2026 - Linux Environment

Repository ini berisi bahan soal, sheet penilaian, otomasi provisioning VM, playbook
autograding, dan playbook pengambilan evidence untuk lomba LKS SMK Tingkat Kota
Bekasi 2026 bidang IT Network System Administration bagian A Linux Environment.

## Ringkasan Struktur

```text
.
|- LKS_ITNSA_Linux_Environment_Bekasi_2026.pdf
|- Grading Sheet LKS Linux Environment Bekasi 2026.xlsx
|- README.md
|- autograding/
|- evidance/
`- terraform/
```

## Penjelasan File Dan Folder Di Root

### `LKS_ITNSA_Linux_Environment_Bekasi_2026.pdf`

Dokumen soal utama lomba dalam format PDF. Dari metadata file terlihat dokumen ini
memiliki 7 halaman, dan string internal PDF menunjukkan judul kerja
`LKS_Linux_Environment_2026 V3`. File ini menjadi acuan requirement teknis yang
kemudian diperiksa ulang oleh playbook autograding.

### `Grading Sheet LKS Linux Environment Bekasi 2026.xlsx`

Workbook Excel untuk rekap nilai akhir. Isi workbook menunjukkan ada 2 sheet:

- `Grading Sheet LKS Linux Environ`
- `Grading`

Shared strings di workbook memperlihatkan kolom nilai yang selaras dengan playbook
autograding, yaitu:

- `P1.1 (8)` sampai `P5 (5)`
- `Total Core (100)`
- `Bonus Ansible (+20)`
- `Skor Akhir (Max 120)`

File ini dipakai sebagai tujuan import hasil `results/grading_results.csv` dari folder
`autograding/`.

### `README.md`

Dokumentasi utama repository. README ini menjelaskan fungsi setiap file/folder utama,
hubungan antar komponen, dan catatan implementasi yang perlu diketahui panitia.

### `autograding/`

Folder sistem penilaian otomatis berbasis Ansible. Isinya membaca kondisi VM peserta,
memberi skor per bagian soal, lalu menulis CSV yang bisa diimport ke grading sheet.

Detail file per file ada di [autograding/README.md](/Users/nugiabdiansyah/Documents/Develop/lks-smk-itnsa-linux-bekasi-2026/autograding/README.md).

### `evidance/`

Folder playbook pengambilan evidence dari semua VM peserta sebelum instance dimatikan
atau dibersihkan. Folder ini memang bernama `evidance`, tetapi playbook di dalamnya
membuat output ke subfolder `evidence/`.

Detail file per file ada di [evidance/README.md](/Users/nugiabdiansyah/Documents/Develop/lks-smk-itnsa-linux-bekasi-2026/evidance/README.md).

### `terraform/`

Folder provisioning infrastruktur lomba di Linode. Konfigurasi default membuat 4 VM
per peserta untuk total 8 peserta.

Detail file per file ada di [terraform/README.md](/Users/nugiabdiansyah/Documents/Develop/lks-smk-itnsa-linux-bekasi-2026/terraform/README.md).

## Hubungan Antar Komponen

1. `terraform/` dipakai untuk menyiapkan VM peserta.
2. Peserta mengerjakan konfigurasi sesuai soal PDF.
3. `autograding/grade_all.yml` mengecek hasil konfigurasi dan membuat CSV nilai.
4. CSV diimport ke workbook Excel.
5. `evidance/collect_evidence.yml` dipakai untuk mengarsipkan bukti konfigurasi dari
   semua VM sebelum VM dihapus atau direbuild.

## Temuan Penting Saat Scan Repository

- `autograding/README.md` versi lama menyebut `grade_one.yml`, tetapi file tersebut
  belum ada di repository saat ini.
- Folder bernama `evidance/`, sementara output playbook dikirim ke path
  `evidance/evidence/`. Ini bukan error otomatis, tetapi mudah membingungkan jika
  tidak didokumentasikan.
- `inventory.ini` pada folder `autograding/` dan `evidance/` berisi kredensial root
  dan daftar IP peserta. Karena itu repository ini sebaiknya diperlakukan sebagai
  dokumen operasional internal, bukan repo publik tanpa sanitasi.

## Saran Penggunaan

- Mulai dari README tiap folder sebelum menjalankan playbook.
- Pastikan IP, password, dan jumlah peserta sesuai kondisi hari lomba.
- Simpan hasil evidence sebelum destroy VM agar ada jejak audit penilaian.
