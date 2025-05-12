#[test_only]
module iap::payment_tests {
    use sui::test_scenario::{Self as ts};
    use sui::test_utils::assert_eq;
    use sui::coin::{Self, Coin};
    use sui::sui::SUI;
    use sui::tx_context::TxContext;
    use sui::object::ID;
    use iap::payment::{Self, Treasury, AdminCap};

    // Test addresses
    const ADMIN: address = @0xAD;
    const USER: address = @0xB0B;
    const USER2: address = @0xC0C;
    const NEW_TREASURY: address = @0xD0D;

    // Test helper function to create a test coin
    fun create_test_coin(amount: u64, ctx: &mut TxContext): Coin<SUI> {
        coin::mint_for_testing(amount, ctx)
    }

    #[test]
    fun test_init() {
        let scenario = ts::begin(ADMIN);
        
        // Initialize the contract
        payment::init_for_testing(ts::ctx(&mut scenario));
        
        // Finalize the init transaction
        ts::next_tx(&mut scenario, ADMIN);

        // Verify admin cap exists for the sender
        let admin_cap = ts::take_from_sender<AdminCap>(&scenario);
        // Return it immediately as we just needed to check existence
        ts::return_to_sender(&scenario, admin_cap);
        
        // Verify treasury was created and shared by taking it
        let treasury = ts::take_shared<Treasury>(&scenario);
        assert_eq(payment::get_treasury(&treasury), ADMIN); // Check initial address
        ts::return_shared(treasury);
        
        ts::end(scenario);
    }

    #[test]
    fun test_process_payment() {
        let scenario = ts::begin(ADMIN);
        
        // Initialize the contract
        payment::init_for_testing(ts::ctx(&mut scenario));
        
        // Finalize the init transaction before taking shared object
        ts::next_tx(&mut scenario, ADMIN);

        // Get treasury object (now possible after next_tx)
        let treasury = ts::take_shared<Treasury>(&scenario);

        // Switch to user context for payment
        ts::next_tx(&mut scenario, USER);
        
        // Create test payment
        let min_amount = payment::get_min_payment_amount();
        let payment_amount = min_amount + 1_000_000; // 0.002 SUI
        let payment_coin = create_test_coin(payment_amount, ts::ctx(&mut scenario));
        
        // Process payment
        payment::process_payment(
            &treasury, // Pass treasury by reference
            b"test_payment_id",
            b"test_data",
            payment_coin,
            ts::ctx(&mut scenario)
        );
        
        // Return treasury (must be done in the user's tx)
        ts::return_shared(treasury);
        
        ts::end(scenario);
    }

    #[test]
    #[expected_failure(abort_code = payment::EInvalidAmount)]
    fun test_process_payment_below_minimum() {
        let scenario = ts::begin(ADMIN);
        
        // Initialize the contract
        payment::init_for_testing(ts::ctx(&mut scenario));
        
        // Finalize the init transaction
        ts::next_tx(&mut scenario, ADMIN);

        // Get treasury object
        let treasury = ts::take_shared<Treasury>(&scenario);

        // Switch to user context
        ts::next_tx(&mut scenario, USER);
        
        // Create test payment below minimum
        let min_amount = payment::get_min_payment_amount();
        let payment_coin = create_test_coin(min_amount - 1, ts::ctx(&mut scenario));
        
        // This should fail
        payment::process_payment(
            &treasury, // Pass treasury by reference
            b"test_payment_id",
            b"test_data",
            payment_coin,
            ts::ctx(&mut scenario)
        );
        
        // Return treasury (must be done in the user's tx)
        ts::return_shared(treasury);
        
        ts::end(scenario);
    }

    #[test]
    fun test_update_treasury() {
        let scenario = ts::begin(ADMIN);
        
        // Initialize the contract
        payment::init_for_testing(ts::ctx(&mut scenario));
        
        // Finalize the init transaction
        ts::next_tx(&mut scenario, ADMIN);

        // Get admin cap (now possible after next_tx)
        let admin_cap = ts::take_from_sender<AdminCap>(&scenario);
        
        // Get treasury (now possible after next_tx)
        let treasury = ts::take_shared<Treasury>(&scenario);
        
        // Update treasury address
        payment::update_treasury(&admin_cap, &mut treasury, NEW_TREASURY);
        
        // Verify new treasury address
        assert_eq(payment::get_treasury(&treasury), NEW_TREASURY);
        
        // Return objects
        ts::return_to_sender(&scenario, admin_cap);
        ts::return_shared(treasury);
        
        ts::end(scenario);
    }

    #[test]
    fun test_different_payment_ids() {
        let scenario = ts::begin(ADMIN);
        
        // Initialize the contract
        payment::init_for_testing(ts::ctx(&mut scenario));
        
        // Finalize the init transaction
        ts::next_tx(&mut scenario, ADMIN);

        // Get treasury object
        let treasury = ts::take_shared<Treasury>(&scenario);

        // Capture treasury ID for verification
        let treasury_id = payment::get_treasury_id(&treasury);

        // Switch to user context for first payment
        ts::next_tx(&mut scenario, USER);
        
        // Create first payment
        let min_amount = payment::get_min_payment_amount();
        let payment_coin1 = create_test_coin(min_amount * 2, ts::ctx(&mut scenario));
        
        // Process first payment with unique ID
        payment::process_payment(
            &treasury,
            b"payment_id_1",
            b"first_payment",
            payment_coin1,
            ts::ctx(&mut scenario)
        );
        
        // Switch to user context for second payment
        ts::next_tx(&mut scenario, USER);
        
        // Create second payment
        let payment_coin2 = create_test_coin(min_amount * 3, ts::ctx(&mut scenario));
        
        // Process second payment with different ID
        payment::process_payment(
            &treasury,
            b"payment_id_2",
            b"second_payment",
            payment_coin2,
            ts::ctx(&mut scenario)
        );
        
        // Verify treasury ID remains the same after payments
        assert_eq(payment::get_treasury_id(&treasury), treasury_id);
        
        // Return treasury
        ts::return_shared(treasury);
        
        ts::end(scenario);
    }

    #[test]
    fun test_multiple_users_payments() {
        let scenario = ts::begin(ADMIN);
        
        // Initialize the contract
        payment::init_for_testing(ts::ctx(&mut scenario));
        
        // Finalize the init transaction
        ts::next_tx(&mut scenario, ADMIN);

        // Get treasury object
        let treasury = ts::take_shared<Treasury>(&scenario);
        
        // First payment from USER
        ts::next_tx(&mut scenario, USER);
        let min_amount = payment::get_min_payment_amount();
        let payment_from_user1 = create_test_coin(min_amount * 2, ts::ctx(&mut scenario));
        
        payment::process_payment(
            &treasury,
            b"user1_payment",
            b"data_from_user1",
            payment_from_user1,
            ts::ctx(&mut scenario)
        );
        
        // Second payment from USER2
        ts::next_tx(&mut scenario, USER2);
        let payment_from_user2 = create_test_coin(min_amount * 3, ts::ctx(&mut scenario));
        
        payment::process_payment(
            &treasury,
            b"user2_payment",
            b"data_from_user2",
            payment_from_user2,
            ts::ctx(&mut scenario)
        );
        
        // Return treasury
        ts::return_shared(treasury);
        
        ts::end(scenario);
    }

    #[test]
    fun test_treasury_id_consistency() {
        let scenario = ts::begin(ADMIN);
        
        // Initialize the contract
        payment::init_for_testing(ts::ctx(&mut scenario));
        
        // Finalize the init transaction
        ts::next_tx(&mut scenario, ADMIN);

        // Get admin cap
        let admin_cap = ts::take_from_sender<AdminCap>(&scenario);
        
        // Get treasury
        let treasury = ts::take_shared<Treasury>(&scenario);
        
        // Capture the initial treasury ID
        let treasury_id = payment::get_treasury_id(&treasury);
        
        // Update treasury address
        payment::update_treasury(&admin_cap, &mut treasury, NEW_TREASURY);
        
        // Verify treasury ID remains unchanged after address update
        assert_eq(payment::get_treasury_id(&treasury), treasury_id);
        
        // Return objects
        ts::return_to_sender(&scenario, admin_cap);
        ts::return_shared(treasury);
        
        ts::end(scenario);
    }

    #[test]
    fun test_payment_with_special_characters() {
        let scenario = ts::begin(ADMIN);
        
        // Initialize the contract
        payment::init_for_testing(ts::ctx(&mut scenario));
        
        // Finalize the init transaction
        ts::next_tx(&mut scenario, ADMIN);

        // Get treasury
        let treasury = ts::take_shared<Treasury>(&scenario);
        
        // Payment with special characters in ID and data
        ts::next_tx(&mut scenario, USER);
        let min_amount = payment::get_min_payment_amount();
        let payment_coin = create_test_coin(min_amount * 2, ts::ctx(&mut scenario));
        
        payment::process_payment(
            &treasury,
            b"payment@#$%^&*()_id+{}[]|:'<>?,./",
            b"additional~!@#$%^&*()_+{}[]|:'<>?,./",
            payment_coin,
            ts::ctx(&mut scenario)
        );
        
        // Return treasury
        ts::return_shared(treasury);
        
        ts::end(scenario);
    }
} 