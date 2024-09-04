use aiken/crypto.{ScriptHash}
use cardano/address.{Address}
use cardano/assets.{Value}
use cardano/transaction.{Datum, NoDatum, Output}

/// Mock an output
pub fn mock_output(
  address: Address,
  value: Value,
  datum: Datum,
  reference_script: Option<ScriptHash>,
) -> Output {
  Output { address, value, datum, reference_script }
}

/// Mock an output with a public key address
/// `datum` and `reference_script` is omitted as it is seldom used in practice
pub fn mock_pub_key_output(address: Address, value: Value) -> Output {
  mock_output(address, value, NoDatum, reference_script: None)
}

/// Mock an output with a script address
/// `reference_script` is omitted as it is seldom used in practice
pub fn mock_script_output(
  address: Address,
  value: Value,
  datum: Datum,
) -> Output {
  mock_output(address, value, datum, reference_script: None)
}
