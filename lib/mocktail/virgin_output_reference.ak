use aiken/cbor.{serialise}
use aiken/crypto.{Blake2b_256, Hash, blake2b_256}
use aiken/primitive/bytearray.{concat}
use cardano/transaction.{OutputReference, Transaction}

const root_hash =
  #"5a077cbcdffb88b104f292aacb9687ce93e2191e103a30a0cc5505c18b719f98"

pub fn mock_tx_hash(variation: Int) -> Hash<Blake2b_256, Transaction> {
  serialise(variation) |> concat(root_hash) |> blake2b_256()
}

/// Mock an output reference
pub fn mock_utxo_ref(variation: Int, output_index: Int) -> OutputReference {
  OutputReference { transaction_id: mock_tx_hash(variation), output_index }
}
