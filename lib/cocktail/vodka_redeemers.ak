use aiken/collection/pairs
use aiken/primitive/bytearray
use cardano/address.{Address, Script}
use cardano/transaction.{
  Input, OutputReference, Redeemer, ScriptPurpose, Spend, Withdraw, find_input,
}

/// Obtain the redeemer for a given output reference and address
/// ```aiken
/// expect Some(redeemer) = redeemer_from(redeemers, inputs, output_reference, input_address);
/// ```
pub fn redeemer_from(
  redeemers: Pairs<ScriptPurpose, Redeemer>,
  inputs: List<Input>,
  output_reference: OutputReference,
  input_address: Address,
) -> Option<Data> {
  expect Some(redeemer) = redeemers |> pairs.get_first(Spend(output_reference))
  expect Some(input) = find_input(inputs, output_reference)
  if input.output.address == input_address {
    Some(redeemer)
  } else {
    None
  }
}

/// Obtain the first redeemer for a given withdrawal script hash
/// ```aiken
/// expect Some(raw_redeemer) = withdrawal_redeemer(redeemers, withdrawal_script_hash);
/// expect my_redeemer: MyRedeemerType = raw_redeemer;
/// ```
pub fn withdrawal_redeemer(
  redeemers: Pairs<ScriptPurpose, Redeemer>,
  withdrawal_script_hash: ByteArray,
) -> Option<Data> {
  redeemers
    |> pairs.get_first(Withdraw(Script(withdrawal_script_hash)))
}

/// Compare the output reference of two spend transactions
pub fn compare_output_reference(x, y) {
  expect Spend(out_ref_x) = x
  expect Spend(out_ref_y) = y
  bytearray.compare(out_ref_x.transaction_id, out_ref_y.transaction_id)
}
