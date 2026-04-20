# Evidence Collection

Folder `evidance/` dipakai untuk mengambil bukti hasil konfigurasi dari server
peserta. Singkatnya, kalau `autograding/` dipakai untuk memberi nilai, maka folder
ini dipakai untuk menyimpan “jejak kerja” peserta.

Ini penting karena dalam lomba atau ujian praktik, panitia kadang perlu menyimpan
bukti konfigurasi sebelum VM dimatikan, dihapus, atau dipakai ulang.

## Isi Folder

```text
evidance/
|- README.md
|- ansible.cfg
|- inventory.ini
`- collect_evidence.yml
```

## Kenapa Evidence Itu Penting

Misalnya ada peserta yang nilainya perlu dicek ulang. Akan jauh lebih mudah kalau
panitia masih punya:

- file konfigurasi,
- log service,
- status port,
- rules firewall,
- dump database,
- snapshot kondisi server saat itu.

Itulah fungsi utama folder ini.

## Penjelasan File

### `ansible.cfg`

File ini adalah pengaturan Ansible untuk proses pengambilan evidence. Fungsinya
mirip dengan `ansible.cfg` di folder `autograding/`, misalnya:

- memakai `inventory.ini` sebagai daftar host,
- mematikan host key checking,
- mengaktifkan paralelisme,
- mempercepat koneksi SSH dengan pipelining.

### `inventory.ini`

File ini berisi daftar server peserta yang akan diambil evidencenya. Formatnya
sama seperti inventory autograding, jadi setiap peserta tetap punya 4 node:

- `gateway`
- `node1`
- `node2`
- `nfs`

Karena file ini juga berisi data login dan alamat IP, sebaiknya tetap dianggap
sebagai file internal.

### `collect_evidence.yml`

Ini adalah playbook utama di folder `evidance/`. Tugasnya bukan memberi skor,
melainkan mengumpulkan data dari server peserta lalu menyimpannya ke mesin lokal.

Secara umum, playbook ini melakukan langkah berikut:

1. membuat folder sementara di masing-masing VM,
2. menyalin file dan data penting ke folder sementara itu,
3. mengarsipkan hasilnya menjadi `tar.gz`,
4. mengambil arsip tersebut ke mesin lokal,
5. mengekstrak hasilnya dan membuat ringkasan.

## Data Yang Dikumpulkan

Playbook ini mengumpulkan cukup banyak hal, di antaranya:

- konfigurasi Nginx, HAProxy, BIND9, Postfix, Dovecot, MariaDB, NFS, Samba, dan
  vsftpd,
- file `fstab`, `hosts`, `hostname`, dan cron,
- isi `/etc/ansible` jika ada,
- sertifikat dan file CA,
- dump database `app_db`,
- log layanan dan log SSH,
- status service,
- rules iptables,
- port TCP dan UDP yang sedang listening,
- data user, grup, PAM, disk, mount, dan timezone,
- file `wp-config.php` WordPress yang sudah disensor untuk password database.

Jadi hasilnya bukan sekadar salinan beberapa file, tetapi cukup mendekati snapshot
kondisi server saat proses evidence dijalankan.

## Hasil Akhir

Output playbook akan disimpan ke:

```text
evidance/evidence/
```

Strukturnya kurang lebih seperti ini:

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

Di dalam tiap role biasanya ada folder seperti:

- `configs/`
- `ansible/`
- `certs/`
- `database/`
- `logs/`
- `status/`
- `wordpress/`

## Cara Menjalankan

### Mengambil Evidence Dari Semua Host

```bash
cd evidance
ansible-playbook collect_evidence.yml
```

### Melihat Ringkasan Hasil

```bash
cd evidance
cat evidence/SUMMARY.txt
```

## Hal Yang Menarik Untuk Dipelajari

Buat siswa SMK, folder ini bagus untuk dipelajari karena menunjukkan satu hal yang
sering terlupakan: pekerjaan admin Linux tidak berhenti setelah konfigurasi selesai.

Dalam praktik nyata, kamu juga perlu:

- menyimpan bukti konfigurasi,
- bisa melakukan audit,
- bisa menelusuri error dari log,
- bisa membuktikan bahwa layanan memang pernah berjalan.

Itu sebabnya evidence collection sangat penting dalam lingkungan server.

## Catatan

- Nama folder repository adalah `evidance`, sedangkan folder output yang dibuat oleh
  playbook bernama `evidence`.
- Di bagian WordPress, password database disensor sebelum hasilnya disimpan.
- Blok cleanup file sementara di VM sudah ada, tetapi masih dinonaktifkan dengan
  komentar. Jadi saat ini playbook fokus pada pengambilan data, bukan pembersihan.
