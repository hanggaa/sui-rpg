// app.js

// Dengan 'defer' di HTML, kita bisa langsung menggunakan variabel global ini
// karena skrip kita dijamin berjalan setelah sui.js dan wallet-kit.js.
const { SuiClient } = sui;
const { WalletProvider, renderWalletSelector } = walletKit;

// === KONFIGURASI PENTING ===
const CONFIG = {
    PACKAGE_ID: "0x35d64f0176fd714ce5abdd178464bde4962c9bba7cbad64527acef3f96cdb72d",
    ADMIN_CAP_ID: "0xfbbd3400593bc7379a7dff6a87d380340d42c1e3bd399c968fcf4887a0eebba8",
    TREASURY_CAP_ID: "0x642b408aab5d0c2749508b39c82683129b04eb04e892c13029d5d7fea1888e40",
};

// Fungsi utama
function App() {
    console.log("Aplikasi Ninja Demit dimulai!");

    const suiClient = new SuiClient({ url: 'https://fullnode.testnet.sui.io:443' });
    const wallet = new WalletProvider();

    // Render tombol wallet selector
    renderWalletSelector(
        { type: 'button' },
        document.querySelector('#wallet-button-container')
    );

    // Mendengarkan perubahan status koneksi wallet
    wallet.on('change', (walletState) => {
        console.log('Wallet state changed', walletState);
        handleWalletChange(walletState);
    });

    // Cek status awal saat halaman dimuat
    handleWalletChange(wallet.get());
}

// Fungsi untuk menangani perubahan status wallet
function handleWalletChange(walletState) {
    const statusEl = document.getElementById('connection-status');
    const addressEl = document.getElementById('player-address');
    const buyBtn = document.getElementById('buy-starter-pack-btn');

    if (walletState.accounts.length > 0) {
        // Jika terhubung
        const playerAddress = walletState.accounts[0].address;
        statusEl.textContent = 'Terhubung';
        addressEl.textContent = `${playerAddress.slice(0, 6)}...${playerAddress.slice(-4)}`;
        
        // TODO: Tambahkan logika untuk memeriksa apakah user sudah punya item
        buyBtn.style.display = 'block';

    } else {
        // Jika tidak terhubung
        statusEl.textContent = 'Belum Terhubung';
        addressEl.textContent = '-';
        buyBtn.style.display = 'none';
    }
}

// Menjalankan aplikasi
App();