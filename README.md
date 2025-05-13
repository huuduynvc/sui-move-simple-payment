# Sui In-App Purchase Smart Contract

This project implements a basic In-App Purchase (IAP) smart contract on the Sui blockchain using Move. It allows processing payments and emits an event when a payment is successful.

## Table of Contents

- [Prerequisites](#prerequisites)
- [Project Setup](#project-setup)
- [Move Contract](#move-contract)
  - [Compiling](#compiling)
  - [Running Local Unit Tests](#running-local-unit-tests)
  - [Deploying to Sui Testnet](#deploying-to-sui-testnet)
- [Interacting with the Deployed Contract (Testnet)](#interacting-with-the-deployed-contract-testnet)
  - [Using Sui CLI](#using-sui-cli)
    - [Setting up Environment Variables](#setting-up-environment-variables)
    - [Splitting Coins for Gas](#splitting-coins-for-gas)
    - [Processing a Payment](#processing-a-payment)
    - [Updating the Treasury](#updating-the-treasury)
  - [Using TypeScript Client](#using-typescript-client)
- [Backend Event Processing](#backend-event-processing)
- [Troubleshooting TypeScript Imports](#troubleshooting-typescript-imports)

## Prerequisites

- **Sui CLI**: Ensure you have the Sui CLI installed and configured. Follow the official [Sui installation guide](https://docs.sui.io/guides/developer/getting-started/sui-install).
  - Verify your installation: `sui --version`
  - Connect to testnet: `sui client switch --env testnet`
  - Ensure you have a testnet address with SUI tokens for gas. You can get some from the [Sui Testnet Faucet](https://faucet.sui.io/).
    `sui client active-address`
    `sui client gas`
- **Node.js and npm/yarn**: Required for running the TypeScript client and backend processor.
  - Download from [Node.js official website](https://nodejs.org/).
  - npm is included with Node.js. To install yarn (optional): `npm install --global yarn`

## Project Setup

1.  **Clone the repository (if you haven't already):**
    ```bash
    # git clone <your-repository-url>
    # cd <your-repository-name>
    ```

2.  **Install TypeScript dependencies:**
    Navigate to the directory containing `package.json` (or create one if it doesn't exist alongside your `.ts` files) and run:
    ```bash
    npm install
    # or
    yarn install
    ```
    If you don't have a `package.json`, create one:
    ```bash
    npm init -y
    # Then install the necessary packages:
    npm install @mysten/sui dotenv typescript ts-node @types/node
    # or
    yarn add @mysten/sui dotenv typescript ts-node @types/node
    ```

3.  **Create a `.env` file:**
    In the root of your project (or where your TypeScript scripts are located), create a `.env` file and add your Sui wallet's 12-word mnemonic phrase:
    ```env
    SUI_MNEMONIC="your 12 word mnemonic phrase here"
    # Example:
    # SUI_MNEMONIC="apple banana cherry date elderberry fig grape honeydew kiwi lemon"
    ```
    **Important**: Make sure this `.env` file is added to your `.gitignore` to avoid committing your private key.

4.  **Create `tsconfig.json`:**
    If you don't have one, create a `tsconfig.json` file in the same directory as your TypeScript files. You can generate a default one by running:
    ```bash
    npx tsc --init
    ```
    A good starting `tsconfig.json` might look like this:
    ```json
    {
      "compilerOptions": {
        "target": "es2020",
        "module": "commonjs",
        "strict": true,
        "esModuleInterop": true,
        "skipLibCheck": true,
        "forceConsistentCasingInFileNames": true,
        "resolveJsonModule": true, // Important for some @mysten/sui imports
        "outDir": "./dist"        // Optional: specify output directory for compiled JS
      },
      "include": ["**/*.ts"],      // Or specify your .ts files/directories
      "exclude": ["node_modules"]
    }
    ```

## Move Contract

The Move contract (`iap/sources/payment.move`) handles the payment logic.

### Compiling

To compile the Move contract:
```bash
sui move build
```
This will check for errors and create a `build` directory.

### Running Local Unit Tests

Unit tests are located in `iap/tests/payment_tests.move`. To run them:
```bash
sui move test
```

### Deploying to Sui Testnet

1.  **Ensure `Move.toml` has correct addresses:**
    Before the first deployment, the `[addresses]` section in `iap/Move.toml` should have `iap = "0x0"`.
    ```toml
    [package]
    name = "iap"
    version = "0.0.1"

    [dependencies]
    Sui = { git = "https://github.com/MystenLabs/sui.git", subdir = "crates/sui-framework/packages/sui-framework", rev = "testnet" }

    [addresses]
    iap = "0x0" # For initial deployment, then replace with actual package ID after publishing
    ```

2.  **Publish the contract:**
    Make sure your Sui CLI is configured for testnet and you have an active address with SUI.
    ```bash
    sui client publish --gas-budget 50000000 ./iap
    ```
    This command will output several important IDs:
    -   **Package ID**: The ID of your deployed contract package.
    -   **AdminCap ID**: The capability object to manage upgrades (if applicable).
    -   **Treasury ID**: The `Treasury` shared object created by the `init` function.

3.  **Update `Move.toml` and environment variables:**
    After successful deployment, update `iap/Move.toml` with the new **Package ID**:
    ```toml
    [addresses]
    iap = "0xYOUR_PACKAGE_ID" # Replace 0xYOUR_PACKAGE_ID with the actual Package ID
    ```
    You will also need this Package ID and the Treasury ID for client-side interactions. It's recommended to store them as environment variables or constants in your scripts.

    Example:
    If your deployment output shows:
    `Package ID: 0x88640e3410b1feaefa3e6a56e97699b8efbe4cd1f15297632e17c879b0a532ba`
    `Treasury ID (from init object changes): 0x9e7c71a9239cf7e7a1b966e18d0bb10636e41fee590f90946aa5fba62bd76aaa`

    Update `Move.toml`:
    ```toml
    [addresses]
    iap = "0x88640e3410b1feaefa3e6a56e97699b8efbe4cd1f15297632e17c879b0a532ba"
    ```

## Interacting with the Deployed Contract (Testnet)

Replace `YOUR_PACKAGE_ID`, `YOUR_TREASURY_ID`, and `YOUR_GAS_COIN_ID` with the actual values from your deployment and `sui client gas` output. The current known deployed Package ID is `0x88640e3410b1feaefa3e6a56e97699b8efbe4cd1f15297632e17c879b0a532ba`.

### Using Sui CLI

#### Setting up Environment Variables
For convenience, you can set these in your shell:
```bash
export SUI_PACKAGE_ID="0x88640e3410b1feaefa3e6a56e97699b8efbe4cd1f15297632e17c879b0a532ba"
# Get your Treasury ID from the deployment output or by querying the AdminCap if needed.
# Example from past deployment:
export SUI_TREASURY_ID="0x9e7c71a9239cf7e7a1b966e18d0bb10636e41fee590f90946aa5fba62bd76aaa" 
# Or the updated one:
# export SUI_TREASURY_ID="0x23c0a23da6735eaea651cccd630065e598950842dd65bf7eb948a832b882ea76"

# Find a gas coin you own:
sui client gas
# Pick one of the Coin IDs from the output
export MY_GAS_COIN="0xYOUR_GAS_COIN_ID_HERE" # Replace with an actual coin ID
```

#### Splitting Coins for Payment
The `process_payment` function expects a `Coin<SUI>` object as payment. You might need to split your existing SUI coins to get one of suitable value.

1.  **Check your available SUI coins:**
    ```bash
    sui client gas
    ```
    Note the ID of a coin with sufficient balance (e.g., `MY_GAS_COIN`).

2.  **Split a coin to create a new payment coin:**
    Let's say you want to create a payment coin of 200,000 MIST (0.0002 SUI).
    ```bash
    sui client split-coin --coin-id $MY_GAS_COIN --amounts 200000 --gas-budget 10000000 --gas $MY_GAS_COIN
    ```
    This command will output a new coin object. Let's call its ID `PAYMENT_COIN_ID`.
    You will use this `PAYMENT_COIN_ID` in the `process_payment` call.

    **Note**: If you get "InsufficientGas" errors, increase `--gas-budget`. If you have only one gas coin, the split will use that coin and return the remainder to you, along with the new smaller coin.

#### Processing a Payment
```bash
export PAYMENT_COIN_ID="0xID_OF_THE_COIN_YOU_JUST_SPLIT_OR_ANOTHER_COIN_FOR_PAYMENT"
export PAYMENT_ID_STRING="cli_payment_$(date +%s)" # Unique payment ID
export ADDITIONAL_DATA_STRING="CLI payment test"

sui client call --package $SUI_PACKAGE_ID \
  --module payment \
  --function process_payment \
  --args $SUI_TREASURY_ID $PAYMENT_COIN_ID "$PAYMENT_ID_STRING" "$ADDITIONAL_DATA_STRING" \
  --gas-budget 20000000 \
  --gas $MY_GAS_COIN
```
After this transaction, the `PAYMENT_COIN_ID` will be transferred to the `SUI_TREASURY_ID`. You can verify this on a Sui explorer like Suiscan by checking the owner of the `PAYMENT_COIN_ID` object or the transactions for the Treasury address.

#### Updating the Treasury
If you need to change the treasury address:
```bash
export ADMIN_CAP_ID="0xYOUR_ADMIN_CAP_ID" # From deployment output
export NEW_TREASURY_ADDRESS="0xNEW_ADDRESS_FOR_TREASURY"

sui client call --package $SUI_PACKAGE_ID \
  --module payment \
  --function update_treasury \
  --args $ADMIN_CAP_ID $SUI_TREASURY_ID $NEW_TREASURY_ADDRESS \
  --gas-budget 10000000 \
  --gas $MY_GAS_COIN
```
The `SUI_TREASURY_ID` object will then have its `beneficiary` field updated.

### Using TypeScript Client

The `client_interaction.ts` script demonstrates how to call the `process_payment` function using the Sui TypeScript SDK.

1.  **Update Constants in `client_interaction.ts`:**
    Ensure the `PACKAGE_ID`, `TREASURY_ID`, and other constants at the top of the file are correct for your deployed contract on Testnet.
    ```typescript
    const PACKAGE_ID = '0x88640e3410b1feaefa3e6a56e97699b8efbe4cd1f15297632e17c879b0a532ba'; // Your actual Package ID
    const TREASURY_ID = '0x23c0a23da6735eaea651cccd630065e598950842dd65bf7eb948a832b882ea76'; // Your actual Treasury object ID
    ```

2.  **Run the script:**
    ```bash
    npx ts-node client_interaction.ts
    ```
    This will attempt to make a payment. The script handles coin selection and splitting if necessary.

## Backend Event Processing

The `backend_processor.ts` script shows how to query for `PaymentProcessed` events emitted by the contract.

1.  **Update Constants in `backend_processor.ts`:**
    Ensure `PACKAGE_ID` is correct.
    ```typescript
    const PACKAGE_ID = '0x88640e3410b1feaefa3e6a56e97699b8efbe4cd1f15297632e17c879b0a532ba'; // Your actual Package ID
    ```

2.  **Run the script:**
    ```bash
    npx ts-node backend_processor.ts
    ```
    This script will subscribe to or query for payment events and print them to the console.

## Troubleshooting TypeScript Imports

If you encounter errors like "Cannot find module '@mysten/sui' or its corresponding type declarations":

1.  **Ensure `@mysten/sui` is installed:**
    ```bash
    npm ls @mysten/sui
    # or
    yarn why @mysten/sui
    ```
    If not listed or there are issues, reinstall:
    ```bash
    npm install @mysten/sui
    # or
    yarn add @mysten/sui
    ```
    Also, ensure `typescript` and `@types/node` are installed as dev dependencies.

2.  **Check `tsconfig.json`:**
    A common issue is the module resolution strategy. Ensure your `tsconfig.json` is correctly configured, especially `module`, `target`, and `esModuleInterop`. Refer to the example `tsconfig.json` in the [Project Setup](#project-setup) section.
    - `moduleResolution` is often implicitly `node` or `classic` depending on `module` option. For CommonJS, it's usually `node`.
    -  `"module": "commonjs"` and `"esModuleInterop": true` are generally good starting points.

3.  **Verify Import Paths:**
    The Sui SDK has evolved. Double-check the import paths used in your `.ts` files against the latest SDK documentation or examples if problems persist.
    Common imports:
    ```typescript
    import { SuiClient, getFullnodeUrl } from '@mysten/sui/client';
    import { Ed25519Keypair } from '@mysten/sui/keypairs/ed25519';
    import { TransactionBlock } from '@mysten/sui/transactions';
    import { fromB64 } from '@mysten/sui/utils'; // Or other specific utils
    ```

4.  **Delete `node_modules` and `package-lock.json`/`yarn.lock`:**
    Then reinstall all dependencies:
    ```bash
    rm -rf node_modules package-lock.json # or yarn.lock
    npm install
    # or
    yarn install
    ```

5.  **Check Node.js and npm/yarn versions:**
    Sometimes, older versions might have compatibility issues.

If problems continue, providing the exact error message, your `tsconfig.json`, `package.json`, and the problematic import statements will be helpful for further diagnosis.
