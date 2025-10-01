XipserCloud Minecraft Server - PaperMC 1.20.4 (Survival Canggih & Stabil)
Server Minecraft Survival modern yang dioptimalkan untuk performa tertinggi di Termux/Android. Server ini plug-and-play dan otomatis menangani semua instalasi dan konfigurasi.
⚙️ Fitur Utama yang Disempurnakan
 * Anti-Error Robust: Skrip start.sh menjamin Ngrok (tunneling) berhasil terhubung 100% dan IP didapatkan.
 * Voice Chat: Menggunakan Simple Voice Chat (memerlukan MOD Klien, Lihat Panduan Penuh di bawah).
 * Dungeon & Hadiah: Sistem MobArena dan Crazy Crates dengan 5 tingkat hadiah.
 * Fondasi Ekonomi (Vault): Fondasi untuk sistem uang di masa depan sudah siap.
 * Proteksi World: GriefPrevention untuk Claim Wilayah dan Player Grave untuk item saat mati.
🗣️ PANDUAN VOICE CHAT (WAJIB KLIEN)
Agar Voice Chat berfungsi, semua pemain WAJIB menginstal 3 file di sisi KLIEN (Minecraft PC/Laptop 1.20.4).
| Kebutuhan Klien | Link Download (Versi 1.20.4) |
|---|---|
| Fabric Loader | https://fabricmc.net/use/installer/ |
| Fabric API | https://www.google.com/search?q=https://modrinth.com/mod/fabric-api/versions%3Fl%3Dfabric |
| Simple Voice Chat Mod | https://modrinth.com/mod/simple-voice-chat/versions?l=fabric |
Langkah Klien: Instal Fabric Loader, lalu masukkan Fabric API dan Simple Voice Chat (.jar) ke folder .minecraft/mods/.
🛠️ Langkah Instalasi di Termux (Menggunakan Git Clone)
Ikuti 3 langkah mudah ini untuk mengaktifkan server di ponsel Anda:
 * Clone Repository:
   pkg install git -y
git clone [ALAMAT REPO ANDA] XipserCloud
cd XipserCloud

 * Beri Izin Eksekusi:
   chmod +x start.sh

 * Jalankan Server (Otomatis Setup Penuh):
   termux-wake-lock  # Jaga ponsel tetap aktif
nohup ./start.sh &

🔑 Cara Mendapatkan IP Server
Setelah menjalankan start.sh, tunggu 1 menit untuk stabilitas Ngrok, lalu ketik:
cat nohup.out

Alamat IP/Port Ngrok akan muncul di kotak hijau.
