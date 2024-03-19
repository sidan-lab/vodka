use aiken/bytearray
use aiken/dict.{Dict}
use aiken/transaction.{
  Input, OutputReference, Redeemer, ScriptPurpose, Spend, find_input,
}
use aiken/transaction/credential.{Address}

pub fn redeemer_from(
  redeemers: Dict<ScriptPurpose, Redeemer>,
  inputs: List<Input>,
  output_reference: OutputReference,
  input_address: Address,
) -> Option<Data> {
  expect Some(redeemer) = dict.get(redeemers, Spend(output_reference))
  expect Some(input) = find_input(inputs, output_reference)
  if input.output.address == input_address {
    Some(redeemer)
  } else {
    None
  }
}

pub fn compare_output_reference(x, y) {
  expect Spend(out_ref_x) = x
  expect Spend(out_ref_y) = y
  bytearray.compare(
    out_ref_x.transaction_id.hash,
    out_ref_y.transaction_id.hash,
  )
}
