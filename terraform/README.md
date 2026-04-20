# Terraform Provisioning

Folder `terraform/` dipakai untuk membuat VM peserta secara otomatis di Linode.
Kalau dikerjakan manual, panitia harus membuat banyak server satu per satu. Dengan
Terraform, proses itu bisa ditulis sebagai kode lalu dijalankan berulang dengan
hasil yang konsisten.

Kalau kamu siswa yang sedang belajar Linux dan infrastruktur, folder ini cocok
untuk mengenal konsep Infrastructure as Code.

## Isi Folder

```text
terraform/
|- README.md
|- main.tf
`- terraform.tfvars
```

## Gambaran Besarnya

Konfigurasi yang ada sekarang dibuat untuk:

- `8` peserta,
- masing-masing `4` VM,
- total `32` VM.

Jadi folder ini pada dasarnya adalah mesin pembuat lab lomba.

## Penjelasan File

### `main.tf`

Ini adalah file utama Terraform. Dari file ini, kita bisa melihat beberapa hal:

- provider yang dipakai adalah `linode/linode`,
- image default yang dipakai adalah `linode/debian13`,
- region yang dipakai adalah `id-cgk`,
- tipe instance yang dipakai adalah `g6-standard-2`,
- jumlah VM dihitung otomatis dari jumlah peserta dikali jumlah VM per peserta.

Label VM juga dibuat otomatis dengan pola seperti:

```text
peserta-1-node-1
peserta-1-node-2
peserta-1-node-3
peserta-1-node-4
```

Pola seperti ini sangat membantu karena nama VM jadi rapi dan mudah dipetakan ke
peserta.

Selain membuat instance, file ini juga menyiapkan output bernama
`daftar_ip_peserta` supaya panitia bisa melihat IP publik dari semua VM yang sudah
dibuat.

### `terraform.tfvars`

File ini berisi nilai variabel yang dipakai oleh `main.tf`. Di sini panitia bisa
mengubah parameter tanpa perlu menyentuh logika utama Terraform.

Nilai yang saat ini dipakai antara lain:

- token API Linode,
- password root VM,
- jumlah peserta,
- jumlah VM per peserta.

Secara sederhana, kalau `main.tf` adalah resep, maka `terraform.tfvars` adalah
bahan-bahan yang dipakai oleh resep itu.

## Cara Kerja Singkat

Begini alur sederhananya:

1. isi token Linode di `terraform.tfvars`,
2. jalankan `terraform init`,
3. cek rencana resource dengan `terraform plan`,
4. kalau sudah benar, jalankan `terraform apply`,
5. ambil daftar IP hasil pembuatan VM.

## Cara Menjalankan

### Inisialisasi

```bash
cd terraform
terraform init
```

### Melihat Rencana Pembuatan VM

```bash
cd terraform
terraform plan
```

### Membuat VM

```bash
cd terraform
terraform apply
```

### Melihat Daftar IP

```bash
cd terraform
terraform output daftar_ip_peserta
```

## Kenapa Folder Ini Menarik Untuk Dipelajari

Banyak siswa belajar Linux hanya dari sisi konfigurasi di dalam server. Folder ini
menunjukkan sisi lain yang tidak kalah penting, yaitu cara menyiapkan server itu
sendiri secara otomatis.

Dengan mempelajari folder ini, kamu bisa mulai memahami:

- kenapa provisioning manual tidak efisien saat jumlah server banyak,
- bagaimana infrastruktur bisa ditulis sebagai kode,
- kenapa penamaan resource yang konsisten sangat penting,
- bagaimana cloud dan administrasi Linux saling terhubung.

## Catatan

- Password root saat ini dibuat sama untuk semua VM karena kebutuhan operasional
  lomba. Untuk lingkungan produksi, pola seperti ini tentu perlu ditinjau ulang.
- Kalau jumlah peserta berubah, panitia cukup mengubah nilainya di
  `terraform.tfvars` tanpa perlu mengubah struktur besar di `main.tf`.
