module iap::payment {
    use sui::object::{Self, UID, ID};
    use sui::transfer;
    use sui::tx_context::{Self, TxContext};
    use sui::coin::{Self, Coin};
    use sui::sui::SUI;
    use sui::event;
    use std::string::{Self, String};

    // ======== Errors ========
    const EInvalidAmount: u64 = 1;

    // ======== Constants ========
    const MIN_PAYMENT_AMOUNT: u64 = 1_000_000; // 0.001 SUI (SUI has 9 decimals)

    // ======== Events ========
    /// Event emitted when a payment is processed
    struct PaymentProcessed has copy, drop {
        payment_id: String,
        sender: address,
        amount: u64,
        timestamp: u64,
        additional_data: String,
        treasury: address
    }

    /// Event emitted when treasury address is updated
    struct TreasuryUpdated has copy, drop {
        old_treasury: address,
        new_treasury: address
    }

    // ======== Objects ========
    /// The capability that grants administrative rights
    struct AdminCap has key, store {
        id: UID
    }

    /// The shared object that stores the treasury address
    struct Treasury has key {
        id: UID,
        address: address
    }

    // ======== Functions ========
    /// Module initializer creates admin capability and treasury
    fun init(ctx: &mut TxContext) {
        let deployer = tx_context::sender(ctx);
        
        // Create AdminCap for the deployer
        let admin_cap = AdminCap {
            id: object::new(ctx)
        };
        
        // Create Treasury with default address as deployer
        let treasury = Treasury {
            id: object::new(ctx),
            address: deployer
        };

        // Transfer admin capability to deployer
        transfer::transfer(admin_cap, deployer);
        
        // Share treasury object
        transfer::share_object(treasury);
    }

    /// Process a payment with payment ID, sending the SUI directly to treasury 
    /// and emitting an event with all relevant information
    public entry fun process_payment(
        treasury: &Treasury,  // Must be a reference to the actual Treasury object
        payment_id: vector<u8>,
        additional_data: vector<u8>,
        payment: Coin<SUI>,
        ctx: &mut TxContext
    ) {
        // Verify payment amount is above minimum
        let amount = coin::value(&payment);
        assert!(amount >= MIN_PAYMENT_AMOUNT, EInvalidAmount);
        
        // Convert byte vectors to strings
        let payment_id_str = string::utf8(payment_id);
        let additional_data_str = string::utf8(additional_data);
        
        // Get current sender (the user who is making the payment)
        let sender = tx_context::sender(ctx);
        
        // Get the treasury address from the Treasury object
        let treasury_address = treasury.address;
        
        // Transfer payment to treasury address
        transfer::public_transfer(payment, treasury_address);
        
        // Emit event for backend processing
        event::emit(PaymentProcessed {
            payment_id: payment_id_str,
            sender,
            amount,
            timestamp: tx_context::epoch(ctx),
            additional_data: additional_data_str,
            treasury: treasury_address
        });
    }

    /// Update treasury address (admin only)
    public entry fun update_treasury(
        _: &AdminCap,
        treasury: &mut Treasury,
        new_treasury: address
    ) {
        let old_treasury = treasury.address;
        treasury.address = new_treasury;
        
        event::emit(TreasuryUpdated {
            old_treasury,
            new_treasury
        });
    }

    /// Get treasury address
    public fun get_treasury(treasury: &Treasury): address {
        treasury.address
    }
    
    /// Get the object ID of the Treasury
    public fun get_treasury_id(treasury: &Treasury): ID {
        object::id(treasury)
    }

    /// Get the minimum payment amount
    public fun get_min_payment_amount(): u64 {
        MIN_PAYMENT_AMOUNT
    }

    // ======== Test-only Functions ========
    #[test_only]
    public fun init_for_testing(ctx: &mut TxContext) {
        init(ctx)
    }
}