# Terraform Provisioning

Folder ini berisi konfigurasi Terraform untuk membuat VM lomba di Linode. Dari isi
file saat ini, default deployment adalah 8 peserta dengan 4 VM per peserta, sehingga
total resource yang dibuat berjumlah 32 instance.

## Isi Folder

```text
terraform/
|- README.md
|- main.tf
`- terraform.tfvars
```

## Penjelasan Masing-Masing File

### `main.tf`

File utama Terraform. Fungsinya:

- mendeklarasikan provider `linode/linode` versi `~> 2.0`,
- mendefinisikan variabel input untuk token API, password root, jumlah peserta, dan
  jumlah VM per peserta,
- membuat resource `linode_instance` dengan `count` berbasis
  `jumlah_peserta * vm_per_peserta`,
- membangun label VM otomatis dengan pola:
  `peserta-<nomor>-node-<nomor>`,
- memilih image `linode/debian13`,
- menempatkan VM di region `id-cgk`,
- memakai plan `g6-standard-2`,
- mengeluarkan output `daftar_ip_peserta` berupa mapping label VM ke IP publik.

Secara operasional, file ini adalah pondasi provisioning seluruh lab lomba.

### `terraform.tfvars`

File nilai variabel untuk deployment. Nilai default yang terlihat saat scan:

- `linode_token = "<set-your-linode-token></set-your-linode-token>"`
- `vm_root_pass = "LksBekasi2026!"`
- `jumlah_peserta = 8`
- `vm_per_peserta = 4`

File ini memudahkan panitia mengubah kapasitas lomba tanpa mengedit `main.tf`.
Karena mengandung password root bersama, file ini sensitif.

## Cara Pakai

### 1. Isi Token Linode

Edit `terraform.tfvars` dan ganti placeholder token:

```bash
cd terraform
sed -n '1,120p' terraform.tfvars
```

### 2. Inisialisasi Terraform

```bash
cd terraform
terraform init
```

### 3. Preview Resource

```bash
cd terraform
terraform plan
```

### 4. Buat VM

```bash
cd terraform
terraform apply
```

### 5. Ambil Mapping IP

```bash
cd terraform
terraform output daftar_ip_peserta
```

## Catatan Penting

- Password root saat ini dibuat seragam untuk semua VM. Ini praktis untuk lab lomba,
  tetapi harus diperlakukan sebagai kredensial internal.
- Label VM memakai logika berbasis `count.index`, sehingga urutan node konsisten:
  node-1 sampai node-4 untuk setiap peserta.
- Jika jumlah peserta berubah, cukup ubah `jumlah_peserta` di `terraform.tfvars`,
  selama struktur lomba tetap 4 VM per peserta.
