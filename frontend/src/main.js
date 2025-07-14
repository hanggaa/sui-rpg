// main.js - Sekarang kita bisa menggunakan import dengan aman!
import { SuiClient } from '@mysten/sui.js/client';
import { TransactionBlock } from '@mysten/sui.js/transactions';
import { WalletProvider, renderWalletSelector } from '@suiet/wallet-kit';

const CONFIG = {
    PACKAGE_ID: "0x35d64f0176fd714ce5abdd178464bde4962c9bba7cbad64527acef3f96cdb72d",
    ADMIN_CAP_ID: "0xfbbd3400593bc7379a7dff6a87d380340d42c1e3bd399c968fcf4887a0eebba8",
    TREASURY_CAP_ID: "0x642b408aab5d0c2749508b39c82683129b04eb04e892c13029d5d7fea1888e40",
};

function App() {
    console.log("Aplikasi Ninja Demit dimulai dengan Vite!");
    const suiClient = new SuiClient({ url: 'https://fullnode.testnet.sui.io:443' });
    const wallet = new WalletProvider();
    renderWalletSelector({ type: 'button' }, document.querySelector('#wallet-button-container'));
    wallet.on('change', (walletState) => handleWalletChange(walletState));
    handleWalletChange(wallet.get());
}

function handleWalletChange(walletState) {
    const statusEl = document.getElementById('connection-status');
    const addressEl = document.getElementById('player-address');
    const buyBtn = document.getElementById('buy-starter-pack-btn');
    if (walletState.accounts.length > 0) {
        const playerAddress = walletState.accounts[0].address;
        statusEl.textContent = 'Terhubung';
        addressEl.textContent = `${playerAddress.slice(0, 6)}...${playerAddress.slice(-4)}`;
        buyBtn.style.display = 'block';
    } else {
        statusEl.textContent = 'Belum Terhubung';
        addressEl.textContent = '-';
        buyBtn.style.display = 'none';
    }
}

App();