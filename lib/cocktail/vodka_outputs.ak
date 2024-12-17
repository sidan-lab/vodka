use aiken/collection/list
use cardano/address.{Address}
use cardano/assets.{AssetName, PolicyId, flatten, quantity_of}
use cardano/transaction.{InlineDatum, Output}

/// Extracts the inline datum from an output.
/// ```aiken
/// expect inline_datum: MyDatumType = output_inline_datum(output);
/// ```
pub fn output_inline_datum(output: Output) {
  expect InlineDatum(raw_datum) = output.datum
  raw_datum
}

/// Filters outputs by Address.
/// ```aiken
/// let filtered_outputs = outputs_at(outputs, address);
/// ```
pub fn outputs_at(outputs: List<Output>, address: Address) -> List<Output> {
  list.filter(outputs, fn(output) { output.address == address })
}

/// Filters outputs by PolicyId and AssetName.
/// ```aiken
/// let filtered_outputs = outputs_with(outputs, policy, name);
/// ```
pub fn outputs_with(
  outputs: List<Output>,
  policy: PolicyId,
  name: AssetName,
) -> List<Output> {
  list.filter(
    outputs,
    fn(output) { quantity_of(output.value, policy, name) == 1 },
  )
}

/// Filters outputs by token policy.
/// ```aiken
/// let filtered_outputs = outputs_with_policy(outputs, policy);
/// ```
pub fn outputs_with_policy(
  outputs: List<Output>,
  policy: PolicyId,
) -> List<Output> {
  list.filter(
    outputs,
    fn(output) {
      list.any(flatten(output.value), fn(token) { token.1st == policy })
    },
  )
}

/// Filters outputs by Address, PolicyId, and AssetName.
/// ```aiken
/// let filtered_outputs = outputs_at_with(outputs, address, policy, name);
/// ```
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
/// ```aiken
/// let filtered_outputs = outputs_at_with_policy(outputs, address, policy);
/// ```
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
