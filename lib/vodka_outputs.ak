use aiken/list
use aiken/transaction.{InlineDatum, Output}
use aiken/transaction/credential.{Address}
use aiken/transaction/value.{AssetName, PolicyId, flatten, quantity_of}

pub fn output_inline_datum(output: Output) {
  expect InlineDatum(raw_datum) = output.datum
  raw_datum
}

pub fn outputs_at(outputs: List<Output>, address: Address) -> List<Output> {
  list.filter(outputs, fn(output) { output.address == address })
}

pub fn outputs_with(outputs: List<Output>, policy: PolicyId, name: AssetName) {
  list.filter(
    outputs,
    fn(output) { quantity_of(output.value, policy, name) == 1 },
  )
}

pub fn outputs_at_with(
  outputs: List<Output>,
  address: Address,
  policy: PolicyId,
  name: AssetName,
) -> List<Output> {
  list.filter(
    outputs,
    fn(output) {
      output.address == address && quantity_of(output.value, policy, name) == 1
    },
  )
}

pub fn outputs_at_with_policy(
  outputs: List<Output>,
  address: Address,
  policy: PolicyId,
) -> List<Output> {
  list.filter(
    outputs,
    fn(output) {
      output.address == address && list.any(
        flatten(output.value),
        fn(token) { token.1st == policy },
      )
    },
  )
}
