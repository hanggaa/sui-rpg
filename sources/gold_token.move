// gold_token.move
module my_sui_rpg::gold_token {
    use std::option;
    use sui::coin::{Self, Coin, TreasuryCap};
    use sui::transfer;
    use sui::tx_context::{Self, TxContext};

    /// Struct One-Time-Witness. Namanya HARUS sama dengan nama modul dalam huruf kapital.
    public struct GOLD_TOKEN has drop {}

    fun init(otw: GOLD_TOKEN, ctx: &mut TxContext) {
        let (treasury_cap, metadata) = coin::create_currency(
            otw,
            9,
            b"GOLD",
            b"Gold Token",
            b"Token emas untuk game RPG.",
            option::none(),
            ctx
        );
        transfer::public_freeze_object(metadata);
        transfer::public_transfer(treasury_cap, tx_context::sender(ctx));
    }

    public fun mint(
        treasury_cap: &mut TreasuryCap<GOLD_TOKEN>, amount: u64, ctx: &mut TxContext
    ): Coin<GOLD_TOKEN> {
        coin::mint(treasury_cap, amount, ctx)
    }

    public fun burn(treasury_cap: &mut TreasuryCap<GOLD_TOKEN>, coin: Coin<GOLD_TOKEN>) {
        coin::burn(treasury_cap, coin);
    }
}