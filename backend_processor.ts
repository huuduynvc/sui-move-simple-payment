import {
    SuiClient,
    getFullnodeUrl,
    SuiEvent,
    PaginatedEvents,
    EventId // Assuming EventId is exported from the root
} from '@mysten/sui';

// --- Configuration ---
const PACKAGE_ID = '0x88640e3410b1feaefa3e6a56e97699b8efbe4cd1f15297632e17c879b0a532ba';
const MODULE_NAME = 'payment';
const EVENT_NAME = 'PaymentProcessed';
const SUI_NETWORK: 'testnet' | 'mainnet' | 'devnet' | 'localnet' = 'testnet';

const client = new SuiClient({ url: getFullnodeUrl(SUI_NETWORK) });

const EVENT_TYPE = `${PACKAGE_ID}::${MODULE_NAME}::${EVENT_NAME}`;

// Define an interface for the expected event data structure
interface PaymentProcessedEventData {
    payment_id: string;
    sender: string;
    amount: string; // Event amounts are often strings
    additional_data: string;
    treasury: string;
    timestamp: string; // Event timestamps are often strings
}

async function processPaymentEvents() {
    console.log(`Querying for ${EVENT_TYPE} events...`);

    try {
        let hasNextPage = true;
        // Let TypeScript infer the cursor type from the result
        let nextCursor: EventId | null | undefined = null; // Keep explicit type for clarity if EventId is available
        let totalEventsProcessed = 0;

        while (hasNextPage) {
            // Type the result for better autocompletion
            const result: PaginatedEvents = await client.queryEvents({
                query: {
                    MoveEventType: EVENT_TYPE,
                },
                limit: 50,
                order: 'ascending',
                cursor: nextCursor,
            });

            if (result.data.length === 0) {
                console.log('No more events found.');
                break;
            }

            console.log(`--- Processing batch of ${result.data.length} events ---`);

            // Type the event for better property access
            result.data.forEach((event: SuiEvent) => {
                totalEventsProcessed++;
                console.log(`\nEvent #${totalEventsProcessed}:`);
                console.log(`  Transaction Digest: ${event.id.txDigest}`);
                console.log(`  Timestamp: ${new Date(parseInt(event.timestampMs || '0')).toISOString()}`);

                const parsedData = event.parsedJson as PaymentProcessedEventData | undefined;

                if (parsedData) {
                    console.log('  Parsed Data:');
                    console.log(`    Payment ID: ${parsedData.payment_id}`);
                    console.log(`    Sender: ${parsedData.sender}`);
                    console.log(`    Amount (MIST): ${parsedData.amount}`);
                    console.log(`    Additional Data: ${parsedData.additional_data}`);
                    console.log(`    Treasury: ${parsedData.treasury}`);
                } else {
                    console.log('  Could not parse event data.');
                }
            });

            // Assign the cursor for the next iteration
            nextCursor = result.nextCursor;
            hasNextPage = result.hasNextPage;

            if (hasNextPage) {
                 console.log(`\nFetching next page (Cursor: ${nextCursor?.txDigest}_${nextCursor?.eventSeq})...`);
            } else {
                 console.log('\nNo more pages.');
            }
        }

        console.log(`\nFinished processing. Total events found: ${totalEventsProcessed}`);

    } catch (error) {
        console.error('Error processing payment events:', error);
    }
}

// Run the event processing function
processPaymentEvents(); 