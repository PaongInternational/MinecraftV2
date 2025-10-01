# Skrip Utama XipserCloud Server oleh Paongdev
# Versi 3.0: Fast-Start Ngrok & Pengecekan Lebih Agresif

# --- KONFIGURASI NGROK DAN SERVER ---
# TOKEN NGROK ANDA SUDAH DIPASANG DI BAWAH INI
NGROK_TOKEN="33RKXoLi8mLMccvpJbo1LoN3fCg_4AEGykdpBZeXx2TFHaCQj" 
SERVER_RAM=${SERVER_RAM:-4G} 
SHUTDOWN_TIME=43200 
PLUGIN_DIR="plugins"

# --- FUNGSI UTILITY ---
display_banner() {
    clear
    echo "========================================================"
    echo "  XIPSERCLOUD MINECRAFT SERVER by PAONGDEV"
    echo "========================================================"
    echo "  RAM: $SERVER_RAM | Shutdown Otomatis: 12 Jam"
    echo "========================================================"
}

auto_shutdown_timer() {
    if command -v screen > /dev/null; then
        sleep $SHUTDOWN_TIME 
        screen -p 0 -S xipsercloud -X stuff 'say [Server] PEMBERITAHUAN: Server akan mati dalam 5 MENIT untuk istirahat dan stabilitas.^M'
        sleep 240
        screen -p 0 -S xipsercloud -X stuff 'say [Server] PEMBERITAHUAN: Server akan mati dalam 1 MENIT! Mulai save dunia...^M'
        sleep 60
        screen -p 0 -S xipsercloud -X stuff 'stop^M'
        
        echo "========================================================"
        echo "🛑 SHUTDOWN OTOMATIS BERHASIL! Dunia sudah tersimpan."
        echo "========================================================"
    else
        echo "🛑 SHUTDOWN TIMER AKTIF. Server akan mati setelah 12 jam."
        sleep $SHUTDOWN_TIME 
    fi
    killall java 2>/dev/null
    killall ngrok 2>/dev/null
}

# --- FUNGSI INSTALASI PAKET WAJIB TERMUX ---
install_dependencies() {
    echo "1. Memeriksa dan Menginstal Dependensi Termux (Java, Screen, Wget, Curl, Git)..."
    pkg install openjdk-17 wget unzip curl screen git -y
    echo "   Dependensi Termux Selesai."
}

# --- FUNGSI AUTO KONFIGURASI DAN DOWNLOAD PLUGIN ---
create_config_files() {
    echo "4. Membuat konfigurasi file plugin..."
    mkdir -p $PLUGIN_DIR/Essentials
    mkdir -p $PLUGIN_DIR/CrazyCrates/Crates
    
    # Menyalin konfigurasi dari file referensi
    if [ -f book.txt ]; then cp book.txt $PLUGIN_DIR/Essentials/book.txt; fi
    if [ -f EssentialsX_config_reference.yml ]; then cp EssentialsX_config_reference.yml $PLUGIN_DIR/Essentials/config.yml; fi
    if [ -f GriefPrevention_config_reference.yml ]; then mkdir -p $PLUGIN_DIR/GriefPrevention; cp GriefPrevention_config_reference.yml $PLUGIN_DIR/GriefPrevention/config.yml; fi

    # Crazy Crate - Dungeon.yml
    cat <<EOF > $PLUGIN_DIR/CrazyCrates/Crates/Dungeon.yml
CrateName: Dungeon
CrateType: cs
Preview:
  Name: "&6&lHadiah Dungeon"
  Glass: black_stained_glass_pane
  Display: diamond_block
  Slot: 10
  Starting-Chance: 100
Prizes:
  Sangat_Langka:
    DisplayName: "&4&lSANGAT LANGKA"
    Chance: 2.0 
    MaxRange: 1
    DisplayItem: netherite_block
    DisplayEnchanted: true
    Items:
      - 'elytra 1'
      - 'netherite_ingot 4'
      - 'diamond_block 16'
      - 'spawner 1'
  Langka:
    DisplayName: "&c&lLANGKA"
    Chance: 8.0 
    MaxRange: 1
    DisplayItem: diamond
    Items:
      - 'diamond 32'
      - 'beacon 1'
      - 'diamond_pickaxe 1 sharpness:5 efficiency:5 unbreaking:3'
      - 'experience_bottle 32'
  Lumayan:
    DisplayName: "&6&lLUMAYAN"
    Chance: 20.0 
    MaxRange: 1
    DisplayItem: gold_ingot
    Items:
      - 'gold_ingot 64'
      - 'iron_ingot 64'
      - 'enchanting_table 1'
  Biasa:
    DisplayName: "&e&lBIASA"
    Chance: 35.0 
    MaxRange: 1
    DisplayItem: cooked_beef
    Items:
      - 'cooked_beef 64'
      - 'leather 16'
      - 'arrow 32'
  Dasar:
    DisplayName: "&a&lDASAR"
    Chance: 35.0 
    MaxRange: 1
    DisplayItem: coal
    Items:
      - 'coal 64'
      - 'torch 64'
      - 'stick 32'
EOF

    echo "5. Menyetel eula.txt dan ngrok.yml..."
    echo "eula=true" > eula.txt
    
    # Konfigurasi ngrok.yml menggunakan token yang sudah diverifikasi
    cat <<EOF > ngrok.yml
version: "2"
authtoken: $NGROK_TOKEN
tunnels:
  minecraft:
    proto: tcp
    addr: 25565
    region: ap
EOF
}

initial_setup_download() {
    # 2. DOWNLOAD SERVER & NGROK
    if [ ! -f paper.jar ]; then
        echo "2. Mendownload PaperMC 1.20.4..."
        wget -q -O paper.jar "https://api.papermc.io/v2/projects/paper/versions/1.20.4/builds/514/downloads/paper-1.20.4-514.jar"
        echo "   PaperMC berhasil diunduh."
    fi

    if [ ! -f ngrok ]; then
        echo "3. Mendownload dan menginstall Ngrok (AArch64)..."
        wget -q -O ngrok.zip "https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-arm64.zip"
        unzip -q ngrok.zip
        rm ngrok.zip
        # FIX: MEMBERIKAN CHMOD +x LANGSUNG KE NGROK DI SINI
        chmod +x ngrok
        echo "   Ngrok berhasil diunduh dan siap digunakan."
    fi
    
    # 3. DOWNLOAD PLUGINS
    if [ ! -d $PLUGIN_DIR ]; then
        echo "3. Mendownload Plugin Canggih (Vault, Voice Chat, Grave, Arena, Crates, Anti-Grief)..."
        mkdir -p $PLUGIN_DIR
        wget -q -O $PLUGIN_DIR/Vault.jar "https://github.com/Vault/Vault/releases/download/1.7.3/Vault-1.7.3.jar" 
        wget -q -O $PLUGIN_DIR/EssentialsX.jar "https://github.com/EssentialsX/EssentialsX/releases/download/2.20.1/EssentialsX-2.20.1.jar"
        wget -q -O $PLUGIN_DIR/GriefPrevention.jar "https://github.com/TechFortress/GriefPrevention/releases/download/16.18/GriefPrevention-16.18.jar"
        wget -q -O $PLUGIN_DIR/MobArena.jar "https://github.com/MobArena/MobArena/releases/download/0.109.1/MobArena-0.109.1.jar"
        wget -q -O $PLUGIN_DIR/CrazyCrates.jar "https://github.com/CrazyCrates/CrazyCrates/releases/download/3.3.0/CrazyCrates-3.3.0.jar"
        wget -q -O $PLUGIN_DIR/PlayerGrave.jar "https://github.com/PlayerGrave/PlayerGrave/releases/download/2.0.0/PlayerGrave-2.0.0.jar"
        wget -q -O $PLUGIN_DIR/SimpleVoiceChat.jar "https://github.com/acmc/simple-voice-chat/releases/download/v2.4.0/Simple-Voice-Chat-2.4.0-fabric.jar"
        echo "   Semua plugin berhasil diunduh."
    fi

    if [ ! -d $PLUGIN_DIR/Essentials ]; then
        create_config_files
        echo "   Konfigurasi Plugin Otomatis Selesai."
    fi
}

# --- FUNGSI START UTAMA (NGROK FAST-START) ---
start_server() {
    display_banner
    echo "6. Mempersiapkan Ngrok (Fast-Start)..."
    
    # Menjalankan Ngrok di latar belakang
    chmod +x ngrok
    ./ngrok start --all --config ngrok.yml > ngrok.log 2>&1 &
    
    # Waktu tunggu awal dikurangi menjadi 5 detik
    echo "   Memberi waktu 5 detik agar Ngrok API stabil..."
    sleep 5 
    
    ATTEMPTS=0
    IP_ADDRESS=""
    
    while [ -z "$IP_ADDRESS" ] && [ $ATTEMPTS -lt 15 ]; do
        # Pengecekan diulang setiap 3 detik (lebih cepat)
        IP_ADDRESS=$(curl --silent --show-error --retry 3 --connect-timeout 3 http://127.0.0.1:4040/api/tunnels | grep -o 'tcp://[^"]*' | head -n 1)
        if [ -z "$IP_ADDRESS" ]; then
            echo "   ...Menunggu IP Ngrok ($((ATTEMPTS + 1))/15, cek setiap 3 detik)"
            sleep 3
            ATTEMPTS=$((ATTEMPTS + 1))
        fi
    done

    if [ -z "$IP_ADDRESS" ]; then
        echo "--------------------------------------------------------"
        echo "🛑 GAGAL TOTAL MENDAPATKAN IP NGROK setelah 15 percobaan!"
        echo "   SOLUSI: 1. Tunggu 10 menit (rate limit Ngrok)."
        echo "           2. Cek NGROK_TOKEN di start.sh (Baris 13)."
        echo "   LIHAT LOG NGROK DI: cat ngrok.log"
        echo "--------------------------------------------------------"
    fi
    
    CLEAN_IP=$(echo "$IP_ADDRESS" | sed 's/tcp:\/\///')
    
    echo ""
    echo "╔══════════════════════════════════════════════════════════╗"
    echo "║         ✅ ALAMAT SERVER XIPSERCLOUD SUDAH AKTIF!             ║"
    echo "╠══════════════════════════════════════════════════════════╣"
    echo "║ BAGIKAN ALAMAT INI KE TEMAN ANDA:                          ║"
    echo "║   >>>  $CLEAN_IP  <<<                                      ║"
    echo "║                                                          ║"
    echo "║ (Alamat ini adalah Domain:Port gabungan, siap di-copy.)  ║"
    echo "╚══════════════════════════════════════════════════════════╝"
    echo ""

    auto_shutdown_timer &

    echo "7. Memulai Server PaperMC (Konsol berada di sesi screen: xipsercloud)"
    if command -v screen > /dev/null; then
        screen -dmS xipsercloud bash -c "java -Xms1G -Xmx$SERVER_RAM -jar paper.jar --nogui"
        echo "   Server Berhasil Dimulai. Cek konsol dengan: screen -r xipsercloud"
    else
        echo "   [PERINGATAN] Command 'screen' tidak ditemukan! Server dimulai tanpa screen."
        echo "   java -Xms1G -Xmx$SERVER_RAM -jar paper.jar --nogui"
        java -Xms1G -Xmx$SERVER_RAM -jar paper.jar --nogui
    fi
}

# --- PROSES EKSEKUSI ---
killall java 2>/dev/null
killall ngrok 2>/dev/null

install_dependencies
initial_setup_download
start_server
