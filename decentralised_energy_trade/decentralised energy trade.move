module send_message::hello_blockchain{
    //structs
    struct Message has key{
        my_msg:String}
        module 0x1::UserAuth {

    use 0x1::Signer;
    use 0x1::Account;

   
    // Define the structure to hold user credentials
    struct User has store {
        address: address,
        password_hash: vector<u8>,
    }
 //functions
    public entry fun create_message() acquires message{}
    // Function to sign up a new user
    public fun sign_up(
        signer: &signer,
        password_hash: vector<u8>
    ) {
        let user_address = Signer::address_of(signer);
        
        // Ensure the user isn't already registered
        if (exists<User>(user_address)) {
            abort 1; // User already exists
        }

        let user = User {
            address: user_address,
            password_hash,
        };

        move_to(&signer, user);
    }

    // Function to validate user credentials
    public fun sign_in(
        signer: &signer,
        password_hash: vector<u8>
    ) {
        let user_address = Signer::address_of(signer);
        
        let user = borrow_global<User>(user_address);

        if (user.password_hash != password_hash) {
            abort 2; // Password does not match
        }
        
        // Additional logic upon successful sign-in
    }

    // Helper function to check if a user exists
    module UserModule {
    use 0x1::Option;
    use 0x1::Signer;

    // Define a struct for the user
    struct User has store {
        id: u64,
        name: vector<u8>,
    }

    // Function to get a user, returning an Option<User>
    public fun get_user(id: u64): Option<User> {
        // Logic to fetch user or return None if not found
        // Placeholder logic: returning None if id is 0
        if (id == 0) {
            return Option::none<User>();
        }

        let user = User { id, name: b"Example User".to_vec() };
        Option::some(user)
    }

    // Function to demonstrate handling of Option<User>
    public fun print_user_info(id: u64) {
        let user_option = Self::get_user(id);

        // Match on the Option to handle both Some and None cases
        match user_option {
            Option::Some(user) => {
                // Safely access the user fields
                // Convert vector<u8> to a string for printing
                let user_name = Vector::string_from_utf8(user.name).expect("Invalid UTF-8");
                // Print the user's name
                Debug::print(&user_name);
            },
            Option::None => {
                // Handle the case where the user is not found
                Debug::print(&b"User not found".to_vec());
            }
        }
    }
}
 {

    use 0x1::Signer;
    use 0x1::Vector;
    use 0x1::String;

    // Define a struct to store user data
    struct User {
        password: vector<u8>,
        fname: vector<u8>,
        lname: vector<u8>,
        age: u8,
        gender: vector<u8>,
        email: vector<u8>,
    }

    // Resource to manage user data
    struct UserResource has store {
        users: vector<User>,
    }

    public fun initialize_account(signer: &signer) {
        let user_resource = UserResource { users: Vector::empty() };
        move_to(signer, user_resource);
    }

    public fun register_user(
        signer: &signer,
        password: vector<u8>,
        fname: vector<u8>,
        lname: vector<u8>,
        age: u8,
        gender: vector<u8>,
        email: vector<u8>,
    ) {
        let user_resource = borrow_global_mut<UserResource>(Signer::address_of(signer));
        let new_user = User {
            password,
            fname,
            lname,
            age,
            gender,
            email,
     
        };
        Vector::push_back(&mut user_resource.users, new_user);
    }

    public fun get_user_info(
        signer: &signer
    ): vector<User> {
        let user_resource = borrow_global<UserResource>(Signer::address_of(signer));
        user_resource.users.clone()
    }
}
module UserDetails {

    use 0x1::Signer;
    use 0x1::Vector;
    use 0x1::String;

    // Define a struct to store user details
    struct UserDetails has store {
        fname: vector<u8>,
        age: u8,
        gender: vector<u8>,
        email: vector<u8>,
        ethereum_address: vector<u8>,
    }

    // Resource to manage user details
    struct UserDetailsResource has store {
        user_details: UserDetails,
    }

    // Initialize the user's details
    public fun initialize_account(signer: &signer) {
        let user_details = UserDetails {
            fname: Vector::empty(),
            age: 0,
            gender: Vector::empty(),
            email: Vector::empty(),
            ethereum_address: Vector::empty(),
        };
        let user_details_resource = UserDetailsResource { user_details };
        move_to(signer, user_details_resource);
    }

    // Update user details
    public fun update_user_details(
        signer: &signer,
        fname: vector<u8>,
        age: u8,
        gender: vector<u8>,
        email: vector<u8>,
        ethereum_address: vector<u8>,
    ) {
        let user_details_resource = borrow_global_mut<UserDetailsResource>(Signer::address_of(signer));
        user_details_resource.user_details = UserDetails {
            fname,
            age,
            gender,
            email,
            ethereum_address,
        };
    }

    // Retrieve user details
    public fun get_user_details(signer: &signer): UserDetails {
        let user_details_resource = borrow_global<UserDetailsResource>(Signer::address_of(signer));
        user_details_resource.user_details.clone()
    }

    // Optional: Delete user details
    public fun delete_user_details(signer: &signer) {
        let user_details_resource = borrow_global_mut<UserDetailsResource>(Signer::address_of(signer));
        move_from<UserDetailsResource>(Signer::address_of(signer));
    }
}
module TransactionDetails {

    use 0x1::Signer;
    use 0x1::Vector;
    use 0x1::String;

    // Define a struct to store transaction details
    struct Transaction has store {
        txn_from: vector<u8>,
        txn_to: vector<u8>,
        txn_contract: vector<u8>,
        txn_hash: vector<u8>,
        txn_gas: vector<u8>,
        txn_nonce: vector<u8>,
        eth_bal: vector<u8>,
    }

    // Resource to manage transaction details
    struct TransactionResource has store {
        transactions: vector<Transaction>,
    }

    // Initialize the transaction resource
    public fun initialize_account(signer: &signer) {
        let transactions = Vector::empty<Transaction>();
        let transaction_resource = TransactionResource { transactions };
        move_to(signer, transaction_resource);
    }

    // Add a new transaction
    public fun add_transaction(
        signer: &signer,
        txn_from: vector<u8>,
        txn_to: vector<u8>,
        txn_contract: vector<u8>,
        txn_hash: vector<u8>,
        txn_gas: vector<u8>,
        txn_nonce: vector<u8>,
        eth_bal: vector<u8>,
    ) {
        let transaction_resource = borrow_global_mut<TransactionResource>(Signer::address_of(signer));
        let new_transaction = Transaction {
            txn_from,
            txn_to,
            txn_contract,
            txn_hash,
            txn_gas,
            txn_nonce,
            eth_bal,
        };
        Vector::push_back(&mut transaction_resource.transactions, new_transaction);
    }

    // Retrieve transaction details
    public fun get_transactions(signer: &signer): vector<Transaction> {
        let transaction_resource = borrow_global<TransactionResource>(Signer::address_of(signer));
        transaction_resource.transactions.clone()
    }

    // Optional: Delete a transaction
    public fun delete_transactions(signer: &signer) {
        let transaction_resource = borrow_global_mut<TransactionResource>(Signer::address_of(signer));
        move_from<TransactionResource>(Signer::address_of(signer));
    }
}
[14:25, 8/9/2024] aadityaagour: module TransactionDetails {

    use 0x1::Signer;
    use 0x1::Vector;
    use 0x1::String;

    // Define a struct to store transaction details
    struct Transaction has store {
        txn_from: vector<u8>,
        txn_to: vector<u8>,
        txn_contract: vector<u8>,
        txn_hash: vector<u8>,
        txn_gas: vector<u8>,
        txn_nonce: vector<u8>,
        eth_bal: vector<u8>,
    }

    // Resource to manage transaction details
    struct TransactionResource has store {
        transactions: vector<Transaction>,
    }

    // Initialize the transaction resource
    public fun initialize_account(signer: &signer) {
        let transactions = Vector::empty<Transaction>();
        let transaction_resource = TransactionResource { transactions };
        move_to(signer, transaction_resource);
    }

    // Add a new transaction
    public fun add_transaction(
        signer: &signer,
        txn_from: vector<u8>,
        txn_to: vector<u8>,
        txn_contract: vector<u8>,
        txn_hash: vector<u8>,
        txn_gas: vector<u8>,
        txn_nonce: vector<u8>,
        eth_bal: vector<u8>,
    ) {
        let transaction_resource = borrow_global_mut<TransactionResource>(Signer::address_of(signer));
        let new_transaction = Transaction {
            txn_from,
            txn_to,
            txn_contract,
            txn_hash,
            txn_gas,
            txn_nonce,
            eth_bal,
        };
        Vector::push_back(&mut transaction_resource.transactions, new_transaction);
    }

    // Retrieve transaction details
    public fun get_transactions(signer: &signer): vector<Transaction> {
        let transaction_resource = borrow_global<TransactionResource>(Signer::address_of(signer));
        transaction_resource.transactions.clone()
    }

    // Optional: Delete a transaction
    public fun delete_transactions(signer: &signer) {
        let transaction_resource = borrow_global_mut<TransactionResource>(Signer::address_of(signer));
        move_from<TransactionResource>(Signer::address_of(signer));
    }
}
[14:26, 8/9/2024] aadityaagour: module InputValidation {

    use 0x1::Signer;
    use 0x1::Vector;
    use 0x1::String;

    // Define a struct to store input data and an error message
    struct InputData has store {
        data: vector<u8>,
        error_message: vector<u8>,
    }

    // Resource to manage input data
    struct InputResource has store {
        input_data: InputData,
    }

    // Initialize the input resource
    public fun initialize_account(signer: &signer) {
        let initial_data = InputData {
            data: Vector::empty(),
            error_message: Vector::empty(),
        };
        let input_resource = InputResource { input_data: initial_data };
        move_to(signer, input_resource);
    }

    // Set input data and validate it
    public fun set_input(
        signer: &signer,
        input: vector<u8>,
    ) {
        let input_resource = borrow_global_mut<InputResource>(Signer::address_of(signer));
        
        // Basic validation: Check if input is non-empty
        if (Vector::length(&input) == 0) {
            let error_message = b"Please enter valid information".to_vec();
            input_resource.input_data.error_message = error_message;
        } else {
            input_resource.input_data.data = input;
            input_resource.input_data.error_message = Vector::empty(); // Clear error message if valid
        }
    }

    // Retrieve input data and error message
    public fun get_input_data(signer: &signer): InputData {
        let input_resource = borrow_global<InputResource>(Signer::address_of(signer));
        input_resource.input_data.clone()
    }

    // Optional: Clear input data
    public fun clear_input_data(signer: &signer) {
        let input_resource = borrow_global_mut<InputResource>(Signer::address_of(signer));
        input_resource.input_data = InputData {
            data: Vector::empty(),
            error_message: Vector::empty(),
        };
    }
}
