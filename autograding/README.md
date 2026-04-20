# Autograding LKS Linux Environment

Folder ini berisi playbook Ansible untuk melakukan penilaian otomatis terhadap VM
peserta dan menghasilkan file CSV yang format kolomnya sudah cocok untuk grading
sheet lomba.

## Isi Folder

```text
autograding/
|- README.md
|- ansible.cfg
|- inventory.ini
`- grade_all.yml
```

## Penjelasan Masing-Masing File

### `ansible.cfg`

Konfigurasi lokal Ansible untuk proses grading. Beberapa pengaturan penting yang
terlihat di file ini:

- `inventory = inventory.ini`, jadi playbook otomatis memakai inventory di folder ini.
- `host_key_checking = False`, cocok untuk lab/lomba yang banyak instance baru.
- `forks = 10`, memungkinkan pengecekan paralel ke beberapa host.
- `pipelining = True`, mempercepat eksekusi SSH.
- `roles_path = roles`, walaupun saat ini repo belum memiliki folder `roles/`.

### `inventory.ini`

Daftar host semua peserta. Setiap peserta memiliki 4 node:

- `gateway`
- `node1`
- `node2`
- `nfs`

Setiap host juga diberi variabel:

- `peserta`
- `nama`
- `role`

Di bagian `[all:vars]`, file ini mendefinisikan login yang dipakai Ansible:

- `ansible_user=root`
- `ansible_password=LksBekasi2026!`

Karena berisi IP publik dan password operasional, file ini sensitif dan sebaiknya
tidak dibagikan ke luar tim panitia tanpa sanitasi.

### `grade_all.yml`

Playbook utama autograding. File ini panjang dan menjadi inti sistem penilaian.
Secara garis besar, playbook melakukan hal berikut:

1. Menjalankan banyak blok grading ke semua host peserta.
2. Menyimpan skor per host dengan `set_fact`.
3. Mengambil nilai maksimum per bagian untuk setiap peserta dari 4 node yang dimiliki.
4. Menghasilkan CSV akhir di `results/grading_results.csv`.

Bagian penilaian yang diperiksa:

- `P1.1` General Config dan CA
- `P1.2` Email Server
- `P2.1` MariaDB
- `P2.2` File Sharing
- `P3.1` DNS Primary dan Slave
- `P3.2` Web Services dan Database Cluster
- `P3.3` Scheduled Backup
- `P4.1` Firewall iptables
- `P4.2` Load Balancer HAProxy
- `P5` Advanced Automation
- `BONUS` Optional Automation Challenge berbasis Ansible

Karakter implementasinya:

- `gather_facts: no` di mayoritas blok agar grading lebih cepat.
- `ignore_unreachable: yes` dan `ignore_errors: yes` supaya satu host bermasalah tidak
  menghentikan grading seluruh peserta.
- Skor bersifat bertingkat, bukan sekadar pass/fail. Ada partial credit berdasarkan
  kedalaman implementasi.
- Output akhir ditulis sebagai CSV yang siap diimport ke workbook nilai.

## Output Yang Dihasilkan

Saat playbook dijalankan, ia akan membuat folder `results/` dan file:

- `results/grading_results.csv`

Kolom CSV yang ditulis:

- `No`
- `Nama Peserta`
- `P1.1 (8)` sampai `P5 (5)`
- `Total Core (100)`
- `Bonus Ansible (+20)`
- `Skor Akhir (Max 120)`

## Cara Pakai

### 1. Periksa Inventory

Pastikan semua IP host peserta benar:

```bash
cd autograding
sed -n '1,200p' inventory.ini
```

### 2. Jalankan Grading Semua Peserta

```bash
cd autograding
ansible-playbook grade_all.yml
```

### 3. Jalankan Grading Hanya Untuk Satu Peserta

```bash
cd autograding
ansible-playbook grade_all.yml --limit peserta_1
```

### 4. Lihat Hasil CSV

```bash
cd autograding
cat results/grading_results.csv
```

## Catatan Penting

- README lama menyebut `grade_one.yml`, tetapi file itu tidak ada di folder ini saat
  repository discan.
- Penggabungan nilai dilakukan dengan mengambil skor maksimum tiap bagian dari seluruh
  host milik peserta. Ini cocok untuk topologi 4 node, tetapi perlu dipahami agar
  panitia tahu bahwa skor tidak dikunci pada satu node tertentu.
- Playbook memakai password MariaDB dan SSH yang hard-coded untuk kebutuhan lomba.
  Ini praktis untuk hari-H, tetapi tetap merupakan risiko bila repo dipublikasikan.
