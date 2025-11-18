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

/// Predicate to filter outputs by Address, can be used as grouping outputs for example.
/// ```aiken
/// let predicate = o_at(address)
/// let (grouped_outputs, other_outputs) = group_outputs(outputs, predicate)
/// ```
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

/// Predicate to filter outputs by PolicyId and AssetName, can be used as grouping outputs for example.
/// ```aiken
/// let predicate = o_with(policy, name)
/// let (grouped_outputs, other_outputs) = group_outputs(outputs, predicate)
/// ```
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

/// Predicate to filter outputs by token policy, can be used as grouping outputs for example.
/// ```aiken
/// let predicate = o_with_policy(policy)
/// let (grouped_outputs, other_outputs) = group_outputs(outputs, predicate)
/// ```
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

/// Predicate to filter outputs by Address, PolicyId, and AssetName, can be used as grouping outputs for example.
/// ```aiken
/// let predicate = o_at_with(address, policy, name)
/// let (grouped_outputs, other_outputs) = group_outputs(outputs, predicate)
/// ```
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

/// Predicate to filter outputs by Address and PolicyId, can be used as grouping outputs for example.
/// ```aiken
/// let predicate = o_at_with_policy(address, policy)
/// let (grouped_outputs, other_outputs) = group_outputs(outputs, predicate)
/// ```
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

/// Group outputs into two lists based on a predicate. First list contains outputs that satisfy the predicate, second list contains the rest.
/// ```aiken
/// let (grouped_outputs, other_outputs) = group_outputs(outputs, predicate)
/// ```
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

/// Group outputs into three lists based on two predicates. First list contains outputs that satisfy the first predicate, second list contains outputs that satisfy the second predicate, third list contains the rest.
/// ```aiken
/// let (group1_outputs, group2_outputs, other_outputs) = group_outputs_2
/// ```
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
