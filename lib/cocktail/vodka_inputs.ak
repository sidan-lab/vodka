use aiken/collection/list
use cardano/address.{Address}
use cardano/assets.{AssetName, PolicyId, flatten, quantity_of, zero}
use cardano/transaction.{InlineDatum, Input}
use mocktail.{complete, mock_pub_key_address, mock_tx_hash, mocktail_tx, tx_in}

/// Extracts the inline datum from an input.
/// ```aiken
/// expect inline_datum: MyDatumType = input_inline_datum(input)
/// ```
pub fn input_inline_datum(input: Input) {
  expect InlineDatum(raw_datum) = input.output.datum
  raw_datum
}

/// Extract the inline datum by locating the first input in a list of inputs by Address and PolicyId.
/// ```aiken
/// expect inline_datum: MyDatumType = only_input_datum_with(inputs, policy, name)
/// ```
pub fn only_input_datum_with(
  inputs: List<Input>,
  policy: PolicyId,
  name: AssetName,
) {
  expect Some(input) = list.find(inputs, i_with(policy, name))
  input_inline_datum(input)
}

/// Filters inputs by Address.
/// ```aiken
/// let filtered_inputs = inputs_at(inputs, address)
/// ```
pub fn inputs_at(inputs: List<Input>, address: Address) -> List<Input> {
  list.filter(inputs, i_at(address))
}

/// Predicate to filter inputs by Address, can be used as grouping inputs for example.
/// ```aiken
/// let predicate = i_at(address)
/// let (grouped_inputs, other_inputs) = group_inputs(inputs, predicate)
/// ```
pub fn i_at(address: Address) -> fn(Input) -> Bool {
  fn(i: Input) { i.output.address == address }
}

/// Filters inputs by PolicyId and AssetName where the asset quantity is exactly one.
/// ```aiken
/// let filtered_inputs = inputs_with(inputs, policy, name)
/// ```
pub fn inputs_with(
  inputs: List<Input>,
  policy: PolicyId,
  name: AssetName,
) -> List<Input> {
  list.filter(inputs, i_with(policy, name))
}

/// Filters inputs by PolicyId and AssetName when the asset quantity is greater than zero.
/// ```aiken
/// let filtered_inputs = inputs_with_any(inputs, policy, name)
/// ```
pub fn inputs_with_any(
  inputs: List<Input>,
  policy: PolicyId,
  name: AssetName,
) -> List<Input> {
  list.filter(inputs, i_with_any(policy, name))
}

/// Deprecated: this predicate matches only singleton assets (quantity == 1). Prefer `i_with_singleton` for explicit singleton checks or `i_with_any` for general presence checks.
/// Predicate to filter inputs by PolicyId and AssetName, can be used as grouping inputs for example.
/// ```aiken
/// let predicate = i_with(policy, name)
/// let (grouped_inputs, other_inputs) = group_inputs(inputs, predicate)
/// ```
pub fn i_with(policy: PolicyId, name: AssetName) -> fn(Input) -> Bool {
  fn(i: Input) { quantity_of(i.output.value, policy, name) == 1 }
}

/// Predicate to filter inputs by PolicyId and AssetName when the asset is present,
/// can be used as grouping inputs for example.
/// ```aiken
/// let predicate = i_with_any(policy, name)
/// let (grouped_inputs, other_inputs) = group_inputs(inputs, predicate)
/// ```
pub fn i_with_any(policy: PolicyId, name: AssetName) -> fn(Input) -> Bool {
  fn(i: Input) { quantity_of(i.output.value, policy, name) > 0 }
}

/// Predicate to filter inputs by PolicyId and AssetName when the asset quantity
/// is exactly one, can be used as grouping inputs for example.
/// ```aiken
/// let predicate = i_with_singleton(policy, name)
/// let (grouped_inputs, other_inputs) = group_inputs(inputs, predicate)
/// ```
pub fn i_with_singleton(policy: PolicyId, name: AssetName) -> fn(Input) -> Bool {
  fn(i: Input) { quantity_of(i.output.value, policy, name) == 1 }
}


/// Filters inputs by token policy.
/// ```aiken
/// let filtered_inputs = inputs_with_policy(inputs, policy)
/// ```
pub fn inputs_with_policy(inputs: List<Input>, policy: PolicyId) -> List<Input> {
  list.filter(inputs, i_with_policy(policy))
}

/// Predicate to filter inputs by token policy, can be used as grouping inputs for example.
/// ```aiken
/// let predicate = i_with_policy(policy)
/// let (grouped_inputs, other_inputs) = group_inputs(inputs, predicate)
/// ```
pub fn i_with_policy(policy: PolicyId) -> fn(Input) -> Bool {
  fn(i: Input) {
    list.any(flatten(i.output.value), fn(token) { token.1st == policy })
  }
}

/// Filters inputs by Address, PolicyId, and AssetName.
/// ```aiken
/// let filtered_inputs = inputs_at_with(inputs, address, policy, name)
/// ```
pub fn inputs_at_with(
  inputs: List<Input>,
  address: Address,
  policy: PolicyId,
  name: AssetName,
) -> List<Input> {
  list.filter(inputs, i_at_with(address, policy, name))
}

/// Predicate to filter inputs by Address, PolicyId, and AssetName, can be used as grouping inputs for example.
/// ```aiken
/// let predicate = i_at_with(address, policy, name)
/// let (grouped_inputs, other_inputs) = group_inputs(inputs, predicate)
/// ```
pub fn i_at_with(
  address: Address,
  policy: PolicyId,
  name: AssetName,
) -> fn(Input) -> Bool {
  fn(i: Input) {
    i.output.address == address && quantity_of(i.output.value, policy, name) == 1
  }
}

/// Filters inputs by Address and PolicyId.
/// ```aiken
/// let filtered_inputs = inputs_at_with_policy(inputs, address, policy)
/// ```
pub fn inputs_at_with_policy(
  inputs: List<Input>,
  address: Address,
  policy: PolicyId,
) -> List<Input> {
  list.filter(inputs, i_at_with_policy(address, policy))
}

pub fn i_at_with_policy(address: Address, policy: PolicyId) -> fn(Input) -> Bool {
  fn(i: Input) {
    i.output.address == address && list.any(
      flatten(i.output.value),
      fn(token) { token.1st == policy },
    )
  }
}

/// Calculate the total quantity of a token in a list of inputs.
/// ```aiken
/// let total_quantity = inputs_token_quantity(inputs, token)
/// ```
pub fn inputs_token_quantity(
  inputs: List<Input>,
  token: (PolicyId, AssetName),
) -> Int {
  list.map(
    inputs,
    fn(input) { quantity_of(input.output.value, token.1st, token.2nd) },
  )
    |> list.foldr(0, fn(n, total) { n + total })
}

/// Group inputs into two lists based on a predicate. First list contains inputs that satisfy the predicate, second list contains the rest.
/// ```aiken
/// let (grouped_inputs, other_inputs) = group_inputs(inputs, predicate)
/// ```
pub fn group_inputs(
  inputs: List<Input>,
  group: fn(Input) -> Bool,
) -> (List<Input>, List<Input>) {
  inputs
    |> list.foldr(
        ([], []),
        fn(input, acc) {
          if group(input) {
            (acc.1st |> list.push(input), acc.2nd)
          } else {
            (acc.1st, acc.2nd |> list.push(input))
          }
        },
      )
}

/// Group inputs into three lists based on two predicates. First list contains inputs that satisfy the first predicate, second list contains inputs that satisfy the second predicate, third list contains the rest.
/// ```aiken
/// let (group1_inputs, group2_inputs, other_inputs) = group_inputs_2
/// ```
pub fn group_inputs_2(
  inputs: List<Input>,
  group1: fn(Input) -> Bool,
  group2: fn(Input) -> Bool,
) -> (List<Input>, List<Input>, List<Input>) {
  inputs
    |> list.foldr(
        ([], [], []),
        fn(input, acc) {
          if group1(input) {
            (acc.1st |> list.push(input), acc.2nd, acc.3rd)
          } else if group2(input) {
            (acc.1st, acc.2nd |> list.push(input), acc.3rd)
          } else {
            (acc.1st, acc.2nd, acc.3rd |> list.push(input))
          }
        },
      )
}

test test_group_inputs_at() {
  let tx =
    mocktail_tx()
      |> tx_in(True, mock_tx_hash(0), 0, zero, mock_pub_key_address(0, None))
      |> tx_in(True, mock_tx_hash(0), 1, zero, mock_pub_key_address(0, None))
      |> tx_in(True, mock_tx_hash(0), 2, zero, mock_pub_key_address(0, None))
      |> tx_in(True, mock_tx_hash(0), 3, zero, mock_pub_key_address(1, None))
      |> complete()

  let mock_inputs = tx.inputs

  let (inputs, inputs_2) =
    mock_inputs |> group_inputs(i_at(mock_pub_key_address(0, None)))
  list.length(inputs_2) == 1 && list.length(inputs) == 3
}

test test_inputs_at() {
  let tx =
    mocktail_tx()
      |> tx_in(True, mock_tx_hash(0), 0, zero, mock_pub_key_address(0, None))
      |> tx_in(True, mock_tx_hash(0), 1, zero, mock_pub_key_address(0, None))
      |> tx_in(True, mock_tx_hash(0), 2, zero, mock_pub_key_address(0, None))
      |> tx_in(True, mock_tx_hash(0), 3, zero, mock_pub_key_address(1, None))
      |> complete()

  let mock_inputs = tx.inputs

  let inputs = mock_inputs |> inputs_at(mock_pub_key_address(0, None))
  let inputs_2 = mock_inputs |> inputs_at(mock_pub_key_address(1, None))
  list.length(inputs_2) == 1 && list.length(inputs) == 3
}
