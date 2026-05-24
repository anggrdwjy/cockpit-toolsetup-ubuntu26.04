#!/bin/bash

# Pastikan script dijalankan sebagai root/sudo
if [ "$EUID" -ne 0 ]; then
  echo "Silakan jalankan script ini dengan hak akses sudo: sudo $0"
  exit 1
fi

echo "=================================================================="
echo "Memulai instalasi Cockpit, QEMU/KVM, dan Podman di Ubuntu 26.04..."
echo "=================================================================="

# 1. Update indeks repositori sistem
echo "-> Memperbarui repositori sistem..."
apt update -y

# 2. Instal QEMU, KVM, dan tools manajemen Virtual Machine
echo "-> Menginstal QEMU, KVM, dan komponen pendukung..."
# - qemu-kvm & libvirt-daemon-system: Hypervisor dan core virtualisasi
# - virtinst: Tool untuk membuat VM via CLI yang dibutuhkan backend Cockpit
apt install -y qemu-system libvirt-daemon-system libvirt-clients virtinst bridge-utils

# 3. Instal Podman (Mesin Kontainer)
echo "-> Menginstal Podman..."
apt install -y podman

# 4. Instal Cockpit beserta modul web untuk VM dan Kontainer
echo "-> Menginstal Cockpit dan dashboard modular..."
# - cockpit-machines: UI Web Cockpit untuk mengelola VM QEMU/KVM
# - cockpit-podman: UI Web Cockpit untuk mengelola kontainer Podman
apt install -y cockpit cockpit-storaged cockpit-pcp cockpit-files cockpit-packagekit cockpit-networkmanager cockpit-machines cockpit-podman

# 5. Memastikan semua layanan aktif dan berjalan saat booting
echo "-> Mengaktifkan layanan Cockpit dan Virtualisasi..."
systemctl enable --now cockpit.socket
systemctl enable --now libvirtd

# 6. Konfigurasi Firewall (UFW) jika aktif
if systemctl is-active --quiet ufw; then
  echo "-> Mendeteksi UFW aktif. Membuka port Cockpit (9090)..."
  ufw allow 9090/tcp
  ufw reload
else
  echo "-> UFW tidak aktif. Melewati konfigurasi firewall."
fi

# 7. Selesai dan menampilkan informasi akses
IP_ADDRESS=$(hostname -I | awk '{print $1}')

echo "=================================================================="
echo "Instalasi Berhasil Selesai!"
echo "=================================================================="
echo "Akses Dashboard Web Cockpit Anda di:"
echo "👉 URL: https://$IP_ADDRESS:9090"
echo "👉 Gunakan username dan password user Ubuntu Anda untuk login."
echo "=================================================================="
