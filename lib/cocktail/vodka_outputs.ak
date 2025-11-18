use aiken/collection/list
use cardano/address.{Address}
use cardano/assets.{AssetName, PolicyId, flatten, quantity_of}
use cardano/transaction.{InlineDatum, Output}

/// Extracts the inline datum from an output.
/// ```aiken
/// expect inline_datum: MyDatumType = output_inline_datum(output)
/// ```
pub fn output_inline_datum(output: Output) {
  expect InlineDatum(raw_datum) = output.datum
  raw_datum
}

/// Filters outputs by Address.
/// ```aiken
/// let filtered_outputs = outputs_at(outputs, address)
/// ```
pub fn outputs_at(outputs: List<Output>, address: Address) -> List<Output> {
  list.filter(outputs, o_at(address))
}

pub fn o_at(address: Address) -> fn(Output) -> Bool {
  fn(o: Output) { o.address == address }
}

/// Filters outputs by PolicyId and AssetName.
/// ```aiken
/// let filtered_outputs = outputs_with(outputs, policy, name)
/// ```
pub fn outputs_with(
  outputs: List<Output>,
  policy: PolicyId,
  name: AssetName,
) -> List<Output> {
  list.filter(outputs, o_with(policy, name))
}

pub fn o_with(policy: PolicyId, name: AssetName) -> fn(Output) -> Bool {
  fn(o: Output) { quantity_of(o.value, policy, name) == 1 }
}

/// Filters outputs by token policy.
/// ```aiken
/// let filtered_outputs = outputs_with_policy(outputs, policy)
/// ```
pub fn outputs_with_policy(
  outputs: List<Output>,
  policy: PolicyId,
) -> List<Output> {
  list.filter(outputs, o_with_policy(policy))
}

pub fn o_with_policy(policy: PolicyId) -> fn(Output) -> Bool {
  fn(o: Output) {
    list.any(flatten(o.value), fn(token) { token.1st == policy })
  }
}

/// Filters outputs by Address, PolicyId, and AssetName.
/// ```aiken
/// let filtered_outputs = outputs_at_with(outputs, address, policy, name)
/// ```
pub fn outputs_at_with(
  outputs: List<Output>,
  address: Address,
  policy: PolicyId,
  name: AssetName,
) -> List<Output> {
  list.filter(outputs, o_at_with(address, policy, name))
}

pub fn o_at_with(
  address: Address,
  policy: PolicyId,
  name: AssetName,
) -> fn(Output) -> Bool {
  fn(o: Output) {
    o.address == address && quantity_of(o.value, policy, name) == 1
  }
}

/// Filters outputs by Address and PolicyId.
/// ```aiken
/// let filtered_outputs = outputs_at_with_policy(outputs, address, policy)
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

pub fn o_at_with_policy(
  address: Address,
  policy: PolicyId,
) -> fn(Output) -> Bool {
  fn(o: Output) {
    o.address == address && list.any(
      flatten(o.value),
      fn(token) { token.1st == policy },
    )
  }
}

pub fn group_outputs(
  outputs: List<Output>,
  group: fn(Output) -> Bool,
) -> (List<Output>, List<Output>) {
  outputs
    |> list.foldr(
        ([], []),
        fn(output, acc) {
          if group(output) {
            (acc.1st |> list.push(output), acc.2nd)
          } else {
            (acc.1st, acc.2nd |> list.push(output))
          }
        },
      )
}

pub fn group_outputs_2(
  outputs: List<Output>,
  group1: fn(Output) -> Bool,
  group2: fn(Output) -> Bool,
) -> (List<Output>, List<Output>, List<Output>) {
  outputs
    |> list.foldr(
        ([], [], []),
        fn(output, acc) {
          if group1(output) {
            (acc.1st |> list.push(output), acc.2nd, acc.3rd)
          } else if group2(output) {
            (acc.1st, acc.2nd |> list.push(output), acc.3rd)
          } else {
            (acc.1st, acc.2nd, acc.3rd |> list.push(output))
          }
        },
      )
}
