# Autograding

Folder `autograding/` berisi playbook Ansible untuk menilai server peserta secara
otomatis. Tujuannya sederhana: panitia tidak perlu memeriksa satu per satu secara
manual semua layanan di setiap VM.

Kalau kamu siswa yang sedang belajar Linux, folder ini sangat berguna untuk
dipelajari karena di sinilah kamu bisa melihat “apa saja yang sebenarnya dicek”
ketika seseorang mengatakan sebuah server sudah dikonfigurasi dengan benar.

## Isi Folder

```text
autograding/
|- README.md
|- ansible.cfg
|- inventory.ini
`- grade_all.yml
```

## Gambaran Singkat Cara Kerjanya

Secara umum, alurnya seperti ini:

1. Ansible login ke semua host peserta yang ada di `inventory.ini`.
2. Playbook menjalankan banyak pengecekan, misalnya service aktif atau tidak,
   file konfigurasi ada atau tidak, port terbuka atau tidak, dan seterusnya.
3. Hasil pengecekan diubah menjadi skor.
4. Semua skor peserta dirangkum ke file CSV.

Jadi folder ini bukan untuk membangun server, tetapi untuk memeriksa hasil akhir
konfigurasi server.

## Penjelasan File

### `ansible.cfg`

File ini adalah pengaturan Ansible untuk folder `autograding/`. Beberapa bagian
yang penting:

- `inventory = inventory.ini`
  Artinya Ansible otomatis membaca daftar host dari file `inventory.ini`.
- `host_key_checking = False`
  Supaya Ansible tidak berhenti hanya karena host belum pernah diakses sebelumnya.
- `forks = 10`
  Ansible bisa memeriksa beberapa host sekaligus.
- `pipelining = True`
  Membantu eksekusi jadi sedikit lebih cepat.

Kalau kamu baru belajar Ansible, anggap file ini sebagai “pengaturan kerja”
supaya playbook bisa berjalan lebih praktis.

### `inventory.ini`

File ini berisi daftar server peserta. Setiap peserta punya 4 mesin:

- `gateway`
- `node1`
- `node2`
- `nfs`

Setiap host juga punya informasi tambahan seperti:

- nomor peserta,
- nama peserta,
- role host.

Bagian `[all:vars]` dipakai untuk menyimpan user dan password SSH yang dipakai
Ansible saat login ke semua server.

Karena isinya sensitif, file ini sebaiknya tidak dibagikan sembarangan.

### `grade_all.yml`

Inilah file paling penting di folder ini. `grade_all.yml` adalah playbook utama
yang melakukan seluruh proses penilaian otomatis.

Di dalam file ini ada beberapa blok penilaian, di antaranya:

- `P1.1` General Config dan CA
- `P1.2` Email Server
- `P2.1` MariaDB
- `P2.2` File Sharing
- `P3.1` DNS
- `P3.2` Web Services
- `P3.3` Scheduled Backup
- `P4.1` Firewall iptables
- `P4.2` Load Balancer HAProxy
- `P5` Advanced Automation
- bonus Ansible

Setiap bagian tidak selalu dinilai dengan pola “ada = 100, tidak ada = 0”.
Banyak skor di file ini memakai konsep bertahap atau partial credit. Misalnya:

- layanan sudah terpasang, tapi belum aktif,
- layanan aktif, tapi konfigurasi belum lengkap,
- layanan aktif dan konfigurasi lengkap.

Ini bagus untuk lomba maupun pembelajaran, karena usaha peserta tetap terlihat
meskipun hasilnya belum sempurna.

## Output Yang Dihasilkan

Saat playbook dijalankan, sistem akan membuat folder `results/` dan file:

```text
results/grading_results.csv
```

File CSV ini nantinya bisa dimasukkan ke grading sheet Excel.

Kolom yang ditulis antara lain:

- nomor peserta,
- nama peserta,
- skor tiap bagian,
- total core,
- bonus Ansible,
- skor akhir.

## Cara Menjalankan

### Menilai Semua Peserta

```bash
cd autograding
ansible-playbook grade_all.yml
```

### Menilai Satu Peserta Saja

```bash
cd autograding
ansible-playbook grade_all.yml --limit peserta_1
```

### Melihat Hasil Penilaian

```bash
cd autograding
cat results/grading_results.csv
```

## Hal Yang Perlu Dipahami

Ada satu hal penting di playbook ini: nilai peserta dirangkum dari banyak host,
lalu untuk tiap bagian diambil skor tertinggi dari node-node milik peserta itu.

Artinya sistem ini melihat peserta sebagai satu paket infrastruktur, bukan hanya
satu server tunggal.

## Cocok Dipelajari Oleh Siswa SMK Karena

Folder ini membantu kamu memahami bahwa administrasi Linux server itu bukan cuma
soal instalasi paket. Yang benar-benar dinilai biasanya adalah:

- apakah service aktif,
- apakah konfigurasi disimpan di lokasi yang benar,
- apakah port yang dibutuhkan benar-benar listening,
- apakah keamanan dasar sudah diterapkan,
- apakah layanan saling terhubung dengan benar.

Kalau kamu bisa membaca `grade_all.yml` pelan-pelan, kamu akan mendapat gambaran
yang cukup jelas tentang standar kerja server Linux yang baik.

## Catatan

- Di dokumentasi lama pernah disebut `grade_one.yml`, tetapi file itu belum ada di
  folder ini.
- Beberapa password dan parameter penting masih ditulis langsung di file karena repo
  ini memang dipakai untuk kebutuhan operasional lomba.
