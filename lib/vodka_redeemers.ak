use aiken/bytearray
use aiken/pairs
use aiken/transaction.{
  Input, OutputReference, Redeemer, ScriptPurpose, Spend, WithdrawFrom,
  find_input,
}
use aiken/transaction/credential.{Address, Inline, ScriptCredential}

/// Obtain the redeemer for a given output reference and address
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
pub fn withdrawal_redeemer(
  redeemers: Pairs<ScriptPurpose, Redeemer>,
  withdrawal_script_hash: ByteArray,
) -> Option<Data> {
  redeemers
    |> pairs.get_first(
        WithdrawFrom(Inline(ScriptCredential(withdrawal_script_hash))),
      )
}

/// Compare the output reference of two spend transactions
pub fn compare_output_reference(x, y) {
  expect Spend(out_ref_x) = x
  expect Spend(out_ref_y) = y
  bytearray.compare(
    out_ref_x.transaction_id.hash,
    out_ref_y.transaction_id.hash,
  )
}
