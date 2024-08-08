use aiken/list
use aiken/transaction.{Input, Output}
use aiken/transaction/credential.{Address}
use aiken/transaction/value.{Value, flatten, merge, quantity_of, zero}

/// Calulate the length of a value
pub fn value_length(value: Value) -> Int {
  list.length(flatten(value))
}

/// Get the value send to a particular address in a list of outputs
pub fn get_all_value_to(outputs: List<Output>, address: Address) -> Value {
  list.foldr(
    outputs,
    zero(),
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
pub fn get_all_value_from(inputs: List<Input>, address: Address) -> Value {
  list.foldr(
    inputs,
    zero(),
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
pub fn value_geq(greater: Value, smaller: Value) -> Bool {
  list.all(
    flatten(smaller),
    fn(token) { quantity_of(greater, token.1st, token.2nd) >= token.3rd },
  )
}

/// Obtain the information (i.e. flattened value) of a policy in a value 
pub fn value_policy_info(
  value: Value,
  policy: ByteArray,
) -> Option<(ByteArray, ByteArray, Int)> {
  list.find(flatten(value), fn(t) { t.1st == policy })
}
