use aiken/collection/list
use cardano/address.{Address}
use cardano/assets.{
  AssetName, PolicyId, Value, flatten, merge, quantity_of, zero,
}
use cardano/transaction.{Input, Output}

/// Calulate the length of a value
/// ```aiken
/// let value_length = value_length(value);
/// ```
pub fn value_length(value: Value) -> Int {
  list.length(flatten(value))
}

/// Get the value send to a particular address in a list of outputs
/// ```aiken
/// let value_to = get_all_value_to(outputs, address);
/// ```
pub fn get_all_value_to(outputs: List<Output>, address: Address) -> Value {
  list.foldr(
    outputs,
    zero,
    fn(output, acc_value) {
      if output.address == address {
        merge(acc_value, output.value)
      } else {
        acc_value
      }
    },
  )
}

/// Get the value coming from a particular address in a list of inputs
/// ```aiken
/// let value_from = get_all_value_from(inputs, address);
/// ```
pub fn get_all_value_from(inputs: List<Input>, address: Address) -> Value {
  list.foldr(
    inputs,
    zero,
    fn(input, acc_value) {
      if input.output.address == address {
        merge(acc_value, input.output.value)
      } else {
        acc_value
      }
    },
  )
}

/// Check if the first value provided is greater than or equal to the second value
/// ```aiken
/// let is_geq = value_geq(supposed_greater, supposed_smaller);
/// ```
pub fn value_geq(greater: Value, smaller: Value) -> Bool {
  list.all(
    flatten(smaller),
    fn(token) { quantity_of(greater, token.1st, token.2nd) >= token.3rd },
  )
}

/// Obtain the information (i.e. flattened value) of a policy in a value 
/// ```aiken
/// expect Some((policyId, assetName, quantity)) = value_policy_info(value, policy);
/// ```
pub fn value_policy_info(
  value: Value,
  policy: ByteArray,
) -> Option<(ByteArray, ByteArray, Int)> {
  list.find(flatten(value), fn(t) { t.1st == policy })
}

/// Obtain the non-lovelace information (i.e. flattened value) of a policy in a value
/// ```aiken
/// let tokens = value_tokens(value);
/// ```
pub fn value_tokens(value: Value) -> List<(PolicyId, AssetName, Int)> {
  list.filter(flatten(value), fn(t) { t.1st != "" })
}
