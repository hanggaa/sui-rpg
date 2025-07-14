// my_rpg_game.move
module my_sui_rpg::my_rpg_game {

    use sui::sui::SUI;
    use sui::coin::{Self, Coin};
    use sui::transfer;
    use sui::tx_context::{TxContext};
    use std::string::{String, utf8};
    use sui::url::{Url, Self};
    use sui::object::{Self, UID};
    use my_sui_rpg::gold_token::{GOLD_TOKEN};

    // Menambahkan 'public' di depan setiap struct
    public struct Weapon has key, store {
        id: UID,
        name: String,
        image_url: Url,
        rarity: String,
        damage: u64
    }

    public struct Armor has key, store {
        id: UID,
        name: String,
        image_url: Url,
        rarity: String,
        defense: u64
    }

    public struct Trinket has key, store {
        id: UID,
        name: String,
        image_url: Url,
        rarity: String,
        effect_description: String
    }

    public struct AdminCap has key, store {
        id: UID
    }

    const STARTER_PACK_PRICE: u64 = 60_000_000;
    const ADMIN_ADDRESS: address = @0x399b1a8685d397bdd4debfb3182079ef4e9ab7931595ce756eb69500dd3d8c11;

    fun init(ctx: &mut TxContext) {
        transfer::transfer(AdminCap {
            id: object::new(ctx)
        }, tx_context::sender(ctx))
    }

    public entry fun buy_starter_pack(payment: Coin<SUI>, ctx: &mut TxContext) {
        assert!(coin::value(&payment) >= STARTER_PACK_PRICE, 1);
        transfer::public_transfer(payment, ADMIN_ADDRESS);

        let weapon = Weapon {
            id: object::new(ctx),
            name: utf8(b"Pedang Kayu"),
            image_url: url::new_unsafe_from_bytes(b"https://raw.githubusercontent.com/hanggaa/sui-rpg/main/gambar/Wood-Sword.webp"),
            rarity: utf8(b"Common"),
            damage: 5
        };
        let armor = Armor {
            id: object::new(ctx),
            name: utf8(b"Baju Kain"),
            image_url: url::new_unsafe_from_bytes(b"https://raw.githubusercontent.com/hanggaa/sui-rpg/main/gambar/Wood-Armor.webp"),
            rarity: utf8(b"Common"),
            defense: 2
        };
        let trinket = Trinket {
            id: object::new(ctx),
            name: utf8(b"Jimat Keberuntungan"),
            image_url: url::new_unsafe_from_bytes(b"https://raw.githubusercontent.com/hanggaa/sui-rpg/main/gambar/Wood-Trinket.jpg"),
            rarity: utf8(b"Common"),
            effect_description: utf8(b"Sebuah jimat biasa.")
        };
        let buyer = tx_context::sender(ctx);
        transfer::public_transfer(weapon, buyer);
        transfer::public_transfer(armor, buyer);
        transfer::public_transfer(trinket, buyer);
    }

    public entry fun fight_monster_and_claim_reward(
        _admin_cap: &AdminCap,
        _treasury_cap: &mut sui::coin::TreasuryCap<GOLD_TOKEN>,
        _ctx: &mut TxContext
    ) {
        // TODO: Isi logika untuk memberikan hadiah GOLD.
    }
}