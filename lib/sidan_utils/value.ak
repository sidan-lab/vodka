use aiken/list
use aiken/transaction.{Input, Output}
use aiken/transaction/credential.{Address}
use aiken/transaction/value.{Value, flatten, merge, quantity_of, zero}

pub fn value_length(value: Value) -> Int {
  list.length(flatten(value))
}

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

pub fn value_geq(greater: Value, smaller: Value) -> Bool {
  list.all(
    flatten(smaller),
    fn(token) { quantity_of(greater, token.1st, token.2nd) >= token.3rd },
  )
}
