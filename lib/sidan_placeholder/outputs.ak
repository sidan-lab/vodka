use aiken/hash.{Blake2b_224, Hash}
use aiken/transaction.{Datum, NoDatum, Output}
use aiken/transaction/credential.{Address, Script}
use aiken/transaction/value.{Value}

pub fn mock_output(
  address: Address,
  value: Value,
  datum: Datum,
  reference_script: Option<Hash<Blake2b_224, Script>>,
) -> Output {
  Output { address, value, datum, reference_script }
}

pub fn mock_pub_key_output(address: Address, value: Value) -> Output {
  mock_output(address, value, NoDatum, reference_script: None)
}

pub fn mock_script_output(
  address: Address,
  value: Value,
  datum: Datum,
) -> Output {
  mock_output(address, value, datum, reference_script: None)
}
