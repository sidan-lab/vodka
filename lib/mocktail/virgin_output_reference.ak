use aiken/crypto.{Blake2b_256, Hash}
use cardano/transaction.{OutputReference, Transaction}

pub fn mock_tx_hash(variation: Int) -> Hash<Blake2b_256, Transaction> {
  when variation is {
    1 -> #"5a077cbcdffb88b104f292aacb9687ce93e2191e103a30a0cc5505c18b719f98"
    2 -> #"e325a279c996cd20dd9d01373fef96b83a0ce9ab69d1dd44c14abd90f3b73dcc"
    3 -> #"5a077cbcdffb88b104f292aacb9687ce93e2191e103a30a0cc5505c18b719f98"
    4 -> #"1cd16cb025e37b6fcec77cba7b0572ce5fc035b8576caffd9c1f2e9d8143e151"
    _ -> #"580a225baee136641ba78acdc9a9b0537468db40acad46554834687ff5c18dd0"
  }
}

/// Mock an output reference
pub fn mock_utxo_ref(variation: Int, output_index: Int) -> OutputReference {
  OutputReference { transaction_id: mock_tx_hash(variation), output_index }
}
