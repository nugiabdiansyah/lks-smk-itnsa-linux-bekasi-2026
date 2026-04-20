# Evidence Collection

Folder ini berisi playbook Ansible untuk mengambil bukti konfigurasi dari setiap VM
peserta sebelum instance dihentikan, dihapus, atau direbuild. Nama folder saat ini
ditulis `evidance`, sedangkan output yang dihasilkan playbook akan berada di subfolder
`evidence/`.

## Isi Folder

```text
evidance/
|- README.md
|- ansible.cfg
|- inventory.ini
`- collect_evidence.yml
```

## Penjelasan Masing-Masing File

### `ansible.cfg`

Konfigurasi Ansible lokal untuk proses pengambilan evidence. Nilainya hampir sama
dengan folder `autograding/`, yaitu:

- memakai `inventory.ini` lokal,
- menonaktifkan host key checking,
- mengaktifkan SSH pipelining,
- mengatur `forks = 10` untuk paralelisme.

### `inventory.ini`

Daftar host peserta yang akan diambil evidencenya. Struktur host, variabel, user, dan
password mengikuti format yang sama dengan inventory autograding. Artinya folder ini
juga menyimpan data operasional sensitif.

### `collect_evidence.yml`

Playbook utama untuk arsip evidence. Dari isi file, alurnya terdiri dari 3 tahap utama
yang aktif dan 1 tahap cleanup opsional:

1. Di setiap host peserta, playbook membuat direktori sementara `/tmp/lks_evidence`.
2. Berbagai file penting disalin ke direktori tersebut lalu dipaketkan menjadi
   `tar.gz`.
3. Arsip di-fetch ke mesin lokal Ansible.
4. Arsip diekstrak ke folder lokal, lalu dibuat `SUMMARY.txt`.

Jenis evidence yang dikumpulkan oleh playbook:

- konfigurasi layanan: Nginx, HAProxy, BIND9, Postfix, Dovecot, MariaDB, NFS, Samba,
  vsftpd, `fstab`, `hosts`, `hostname`, dan cron,
- folder `/etc/ansible` jika ada,
- sertifikat dan CA terkait `itnsa`, `lks`, atau `bekasi`,
- dump database `app_db` dan ringkasan grants MariaDB,
- log layanan dan log SSH,
- snapshot status service, rules iptables, port listening, hasil pengecekan DNS,
  ekspor NFS, konfigurasi Samba, daftar user, PAM, timezone, disk, dan mount,
- file `wp-config.php` WordPress yang disensor untuk password database, plus uji
  koneksi database jika PHP tersedia.

## Output Yang Dihasilkan

Karena playbook memakai `{{ playbook_dir }}/evidence`, hasil akhirnya disimpan di:

```text
evidance/evidence/
|- SUMMARY.txt
|- peserta_1/
|  |- gateway/
|  |- node1/
|  |- node2/
|  `- nfs/
|- peserta_2/
`- ...
```

Setiap role biasanya berisi subfolder seperti:

- `configs/`
- `ansible/`
- `certs/`
- `database/`
- `logs/`
- `status/`
- `wordpress/`

## Cara Pakai

### 1. Periksa Inventory

```bash
cd evidance
sed -n '1,200p' inventory.ini
```

### 2. Jalankan Pengambilan Evidence

```bash
cd evidance
ansible-playbook collect_evidence.yml
```

### 3. Baca Ringkasan

```bash
cd evidance
cat evidence/SUMMARY.txt
```

## Catatan Penting

- Folder repository bernama `evidance`, tetapi folder hasil kerja bernama `evidence`.
  Ini valid, namun mudah membingungkan jika tidak dibaca dokumentasinya.
- Pada tahap WordPress, password database di `wp-config.php` disensor sebelum disimpan
  ke arsip lokal.
- Tahap cleanup file sementara di VM sudah disiapkan di bagian bawah playbook, tetapi
  masih di-comment. Jika ingin membersihkan `/tmp/lks_evidence` di semua VM, blok itu
  perlu diaktifkan secara sadar.
