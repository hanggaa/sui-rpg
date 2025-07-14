// my_rpg_game.move
module my_sui_rpg::my_rpg_game {

    use sui::sui::SUI;
    use sui::coin::{Self, Coin};
    use sui::transfer;
    use sui::tx_context::{Self, TxContext};
    use std::string::{String, utf8};
    use sui::url::{Url, Self};
    use sui::object::{Self, ID, UID};

    struct Weapon has key, store {
        id: UID,
        name: String,
        image_url: Url,
        rarity: String,
        damage: u64
    }

    struct Armor has key, store {
        id: UID,
        name: String,
        image_url: Url,
        rarity: String,
        defense: u64
    }

    struct Trinket has key, store {
        id: UID,
        name: String,
        image_url: Url,
        rarity: String,
        effect_description: String
    }

    struct AdminCap has key, store {
        id: UID
    }

    fun init(ctx: &mut TxContext) {
        transfer::transfer(AdminCap {
            id: object::new(ctx)
        }, tx_context::sender(ctx))
    }

    // ... (kode di atasnya biarkan saja) ...

    // === Konstanta ===
    // Mendefinisikan konstanta agar mudah diubah nanti.
    // Harga dalam MIST (1 SUI = 1,000,000,000 MIST)
    const STARTER_PACK_PRICE: u64 = 60_000_000; // 0.06 SUI

    // === Fungsi-fungsi Publik (bisa dipanggil oleh pemain) ===

    /// Fungsi untuk membeli 1 set item pemula.
    public entry fun buy_starter_pack(payment: Coin<SUI>, ctx: &mut TxContext) {
        // 1. Dapatkan alamat admin (orang yang mendeploy kontrak).
        // Untuk V1, kita asumsikan alamat admin adalah alamat yang sama
        // dengan alamat deployer kontrak ini.
        let admin_address = tx_context::sender(ctx); // Nanti bisa kita buat lebih canggih

        // 2. Pastikan pembayaran cukup.
        // Jika tidak, transaksi akan gagal dengan pesan error.
        assert!(coin::value(&payment) >= STARTER_PACK_PRICE, 1); // Angka '1' adalah kode error sederhana

        // 3. Transfer pembayaran ke alamat admin.
        transfer::public_transfer(payment, admin_address);

        // 4. Buat 1 set item Common.
        let weapon = Weapon {
            id: object::new(ctx),
            name: utf8(b"Pedang Kayu"),
            image_url: url::new_unsafe_from_bytes(b"https://example.com/stick_sword.png"),
            rarity: utf8(b"Common"),
            damage: 5
        };

        let armor = Armor {
            id: object::new(ctx),
            name: utf8(b"Baju Kain"),
            image_url: url::new_unsafe_from_bytes(b"https://example.com/stick_armor.png"),
            rarity: utf8(b"Common"),
            defense: 2
        };

        let trinket = Trinket {
            id: object::new(ctx),
            name: utf8(b"Jimat Keberuntungan"),
            image_url: url::new_unsafe_from_bytes(b"https://example.com/stick_trinket.png"),
            rarity: utf8(b"Common"),
            effect_description: utf8(b"Sebuah jimat biasa.")
        };

        // 5. Transfer item ke pembeli (orang yang memanggil fungsi ini).
        let buyer = tx_context::sender(ctx);
        transfer::public_transfer(weapon, buyer);
        transfer::public_transfer(armor, buyer);
        transfer::public_transfer(trinket, buyer);
    }

    // ... (kode di bawahnya jika ada) ...
}