terraform {
  required_providers {
    linode = {
      source  = "linode/linode"
      version = "~> 2.0"
    }
  }
}

provider "linode" {
  token = var.linode_token
}

# --- DEKLARASI VARIABEL ---

variable "linode_token" {
  description = "Linode API Personal Access Token"
  type        = string
  sensitive   = true
}

variable "vm_root_pass" {
  description = "Root password yang sama untuk semua VM"
  type        = string
  sensitive   = true
}

variable "jumlah_peserta" {
  description = "Total jumlah peserta (termasuk kamu)"
  type        = number
  default     = 8
}

variable "vm_per_peserta" {
  description = "Jumlah VM yang didapatkan setiap peserta"
  type        = number
  default     = 4
}

# --- PEMBUATAN RESOURCE ---

resource "linode_instance" "debian_vms" {
  # Total VM = 8 peserta x 4 VM = 32 VM
  count       = var.jumlah_peserta * var.vm_per_peserta
  
  # Logika penamaan otomatis:
  # count.index dimulai dari 0 sampai 31
  # floor(count.index / 4) + 1 -> menghasilkan nomor peserta (1 sampai 8)
  # (count.index % 4) + 1      -> menghasilkan nomor node (1 sampai 4)
  label       = "peserta-${floor(count.index / var.vm_per_peserta) + 1}-node-${(count.index % var.vm_per_peserta) + 1}"
  
  image       = "linode/debian13"
  region      = "id-cgk"
  type        = "g6-standard-2" # Linode 4GB Shared
  root_pass   = var.vm_root_pass
}

# --- OUTPUT ---

# Output ini akan menampilkan list IP Address beserta nama VM-nya agar mudah didata
output "daftar_ip_peserta" {
  description = "Pemetaan Nama VM ke IP Address Publik"
  value = {
    for vm in linode_instance.debian_vms :
    vm.label => vm.ip_address
  }
}
