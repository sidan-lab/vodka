use aiken/list
use aiken/transaction.{InlineDatum, Output}
use aiken/transaction/credential.{Address}
use aiken/transaction/value.{AssetName, PolicyId, flatten, quantity_of}

/// Extracts the inline datum from an output.
pub fn output_inline_datum(output: Output) {
  expect InlineDatum(raw_datum) = output.datum
  raw_datum
}

/// Filters outputs by Address.
pub fn outputs_at(outputs: List<Output>, address: Address) -> List<Output> {
  list.filter(outputs, fn(output) { output.address == address })
}

/// Filters outputs by PolicyId and AssetName.
pub fn outputs_with(outputs: List<Output>, policy: PolicyId, name: AssetName) {
  list.filter(
    outputs,
    fn(output) { quantity_of(output.value, policy, name) == 1 },
  )
}

/// Filters outputs by token policy.
pub fn outputs_with_policy(outputs: List<Output>, policy: PolicyId) {
  list.filter(
    outputs,
    fn(output) {
      list.any(flatten(output.value), fn(token) { token.1st == policy })
    },
  )
}

/// Filters outputs by Address, PolicyId, and AssetName.
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

/// Filters outputs by Address and PolicyId.
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
