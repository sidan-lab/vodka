//// Mocktail contains a set of functions to build transactions for testing purposes.
//// 
//// To use Mocktail Tx, there are 4 steps:
//// 1. Starts with [`mocktail_tx()`](./mocktail.html#mocktail_tx) to create a new transaction builder.
//// 2. Use tx building methods similar to MeshJS lower level APIs to build the transaction.
//// 3. Call [`complete`](./mocktail.html#complete) to complete building transaction.
//// 4. Finally, if there is any whole items to be added to the transaction, use the `add` functions.
//// 
//// Mocktail is built with devex and multiple test cases compatibility in mind.
//// 1. It is pipable.
//// 2. Each tx building and adding method takes as its first param a condition. That function will only run when this condition is `True`.
////
//// ## Example
//// ```aiken
//// let tx: Transaction =
////   mocktail_tx()
////     |> required_signer_hash(is_signature_provided, mock_pub_key_hash(0))
////     |> script_withdrawal(True, mock_script_hash(0), 0)
////     |> script_withdrawal(True, mock_script_hash(1), 0)
////     |> required_signer_hash(True, mock_pub_key_hash(1))
////     |> complete()
////     |> add_reference_input(True, mock_oracle_ref_input_1())
////     |> add_reference_input(True, mock_oracle_ref_input_2())
////     |> add_output(True, mock_pub_key_output(mock_fee_collection_address, mock_fee))
//// ```

use aiken/cbor
use aiken/collection/dict
use aiken/collection/list
use aiken/crypto.{VerificationKeyHash, blake2b_256}
use aiken/interval.{Finite, Interval}
use cardano/address.{Address, Credential, Script}
use cardano/assets.{Value, from_asset, merge, zero}
use cardano/certificate.{Certificate}
use cardano/transaction.{
  InlineDatum, Input, Output, OutputReference, Redeemer, ScriptPurpose,
  Transaction, TransactionId, Withdraw, placeholder,
}
use mocktail/virgin_address
use mocktail/virgin_key_hash
use mocktail/virgin_output_reference
use mocktail/virgin_outputs
use mocktail/virgin_validity_range

/// A mock transaction builder. It can be initialized with `mocktail_tx()`.
pub type MocktailTx {
  tx: Transaction,
  queue_input: Option<Input>,
  queue_output: Option<Output>,
  queue_ref_input: Option<Input>,
  queue_withdrawal: Option<Pair<Pair<Credential, Int>, Redeemer>>,
}

/// Initialize a new mock transaction builder, and output a built transaction with [`.complete().`](./mocktail.html#complete)
/// ```aiken
/// let tx = mocktail_tx()
///   |> ...other tx building methods
///   |> complete()
/// ```
pub fn mocktail_tx() -> MocktailTx {
  MocktailTx {
    tx: placeholder,
    queue_input: None,
    queue_output: None,
    queue_ref_input: None,
    queue_withdrawal: None,
  }
}

/// Tx building method - Add an input to the transaction.
/// This function will only run when the condition is `True`.
/// ```aiken
/// let tx = mocktail_tx()
///   |> tx_in(condition, tx_hash, tx_index, amount, address)
///   |> ...other tx building methods
///   |> complete()
/// ```
pub fn tx_in(
  mocktail_tx: MocktailTx,
  condition: Bool,
  tx_hash: ByteArray,
  tx_index: Int,
  amount: Value,
  address: Address,
) -> MocktailTx {
  if !condition {
    mocktail_tx
  } else {
    let queue_input =
      Some(
        Input {
          output_reference: OutputReference {
            transaction_id: tx_hash,
            output_index: tx_index,
          },
          output: mock_pub_key_output(address, amount),
        },
      )
    when mocktail_tx.queue_input is {
      Some(input) ->
        MocktailTx {
          ..mocktail_tx,
          queue_input: queue_input,
          tx: mocktail_tx.tx |> add_input(True, input),
        }
      None -> MocktailTx { ..mocktail_tx, queue_input: queue_input }
    }
  }
}

/// Tx building method - Add an input with inline datum to the transaction.
/// This can only be used right after [`tx_in`](./mocktail.html#tx_in).
/// This function will only run when the condition is `True`.
/// If not followed by `tx_in`, this function will do nothing.
/// ```aiken
/// let tx = mocktail_tx()
///   |> tx_in(condition, tx_hash, tx_index, amount, address)
///   |> tx_in_inline_datum(condition, datum)
///   |> ...other tx building methods
///   |> complete()
/// ```
pub fn tx_in_inline_datum(
  mocktail_tx: MocktailTx,
  condition: Bool,
  datum: Data,
) -> MocktailTx {
  if !condition {
    mocktail_tx
  } else {
    let queue_input =
      when mocktail_tx.queue_input is {
        Some(input) -> {
          let Input { output_reference, output } = input
          Some(
            Input {
              output_reference,
              output: Output { ..output, datum: InlineDatum(datum) },
            },
          )
        }
        None -> None
      }
    MocktailTx { ..mocktail_tx, queue_input: queue_input }
  }
}

/// Tx building method - Add an output to the transaction.
/// This function will only run when the condition is `True`.
/// ```aiken
/// let tx = mocktail_tx()
///   |> tx_out(condition, address, amount)
///   |> ...other tx building methods
///   |> complete()
/// ```
pub fn tx_out(
  mocktail_tx: MocktailTx,
  condition: Bool,
  address: Address,
  amount: Value,
) -> MocktailTx {
  if !condition {
    mocktail_tx
  } else {
    let queue_output = Some(mock_pub_key_output(address, amount))
    when mocktail_tx.queue_output is {
      Some(output) ->
        MocktailTx {
          ..mocktail_tx,
          queue_output: queue_output,
          tx: mocktail_tx.tx |> add_output(True, output),
        }
      None -> MocktailTx { ..mocktail_tx, queue_output: queue_output }
    }
  }
}

/// Tx building method - Add an output with inline datum to the transaction.
/// This can only be used right after [`tx_out`](./mocktail.html#tx_out).
/// This function will only run when the condition is `True`.
/// If not followed by `tx_out`, this function will do nothing.
/// ```aiken
/// let tx = mocktail_tx()
///   |> tx_out(condition, address, amount)
///   |> tx_out_inline_datum(condition, datum)
///   |> ...other tx building methods
///   |> complete()
/// ```
pub fn tx_out_inline_datum(
  mocktail_tx: MocktailTx,
  condition: Bool,
  datum: Data,
) -> MocktailTx {
  if !condition {
    mocktail_tx
  } else {
    let queue_output =
      when mocktail_tx.queue_output is {
        Some(output) -> Some(Output { ..output, datum: InlineDatum(datum) })
        None -> None
      }
    MocktailTx { ..mocktail_tx, queue_output: queue_output }
  }
}

/// Tx building method - Add a mint to the transaction.
/// This function will only run when the condition is `True`.
/// ```aiken
/// let tx = mocktail_tx()
///   |> mint(condition, quantity, policy_id, token_name)
///   |> ...other tx building methods
///   |> complete()
/// ```
pub fn mint(
  mocktail_tx: MocktailTx,
  condition: Bool,
  quantity: Int,
  policy_id: ByteArray,
  token_name: ByteArray,
) -> MocktailTx {
  if !condition {
    mocktail_tx
  } else {
    MocktailTx {
      ..mocktail_tx,
      tx: mocktail_tx.tx
        |> add_mint(True, from_asset(policy_id, token_name, quantity)),
    }
  }
}

/// Tx building method - Add a reference input to the transaction.
/// This function will only run when the condition is `True`.
/// ```aiken
/// let tx = mocktail_tx()
///   |> ref_tx_in(condition, tx_hash, tx_index, amount, address)
///   |> ...other tx building methods
///   |> complete()
/// ```
pub fn ref_tx_in(
  mocktail_tx: MocktailTx,
  condition: Bool,
  tx_hash: ByteArray,
  tx_index: Int,
  amount: Value,
  address: Address,
) -> MocktailTx {
  if !condition {
    mocktail_tx
  } else {
    let queue_ref_input =
      Some(
        Input {
          output_reference: OutputReference {
            transaction_id: tx_hash,
            output_index: tx_index,
          },
          output: mock_pub_key_output(address, amount),
        },
      )
    when mocktail_tx.queue_ref_input is {
      Some(input) ->
        MocktailTx {
          ..mocktail_tx,
          queue_ref_input: queue_ref_input,
          tx: mocktail_tx.tx |> add_reference_input(True, input),
        }
      None -> MocktailTx { ..mocktail_tx, queue_ref_input: queue_ref_input }
    }
  }
}

/// Tx building method - Add an inline datum to last reference input in the transaction.
/// This can only be used right after [`ref_tx_in`](./mocktail.html#ref_tx_in).
/// This function will only run when the condition is `True`.
/// If not followed by `ref_tx_in`, this function will do nothing.
/// ```aiken
/// let tx = mocktail_tx()
///   |> ref_tx_in(condition, tx_hash, tx_index, amount, address)
///   |> ref_tx_in_inline_datum(condition, datum)
///   |> ...other tx building methods
///   |> complete()
/// ```
pub fn ref_tx_in_inline_datum(
  mocktail_tx: MocktailTx,
  condition: Bool,
  datum: Data,
) -> MocktailTx {
  if !condition {
    mocktail_tx
  } else {
    let queue_ref_input =
      when mocktail_tx.queue_ref_input is {
        Some(input) -> {
          let Input { output_reference, output } = input
          Some(
            Input {
              output_reference,
              output: Output { ..output, datum: InlineDatum(datum) },
            },
          )
        }
        None -> None
      }
    MocktailTx { ..mocktail_tx, queue_ref_input: queue_ref_input }
  }
}

/// Tx building method - Add a a lower bound validity range to the transaction.
/// This function will only run when the condition is `True`.
/// ```aiken
/// let tx = mocktail_tx()
///   |> invalid_before(condition, time)
///   |> ...other tx building methods
///   |> complete()
/// ```
pub fn invalid_before(
  mocktail_tx: MocktailTx,
  condition: Bool,
  time: Int,
) -> MocktailTx {
  if !condition {
    mocktail_tx
  } else {
    let tx = mocktail_tx.tx
    let upper_bound =
      when tx.validity_range.upper_bound.bound_type is {
        Finite(x) -> Some(x)
        _ -> None
      }
    MocktailTx {
      ..mocktail_tx,
      tx: Transaction {
        ..tx,
        validity_range: mock_interval(Some(time), upper_bound),
      },
    }
  }
}

/// Tx building method - Add a a upper bound validity range to the transaction.
/// This function will only run when the condition is `True`.
/// ```aiken
/// let tx = mocktail_tx()
///   |> invalid_hereafter(condition, time)
///   |> ...other tx building methods
///   |> complete()
/// ```
pub fn invalid_hereafter(
  mocktail_tx: MocktailTx,
  condition: Bool,
  time: Int,
) -> MocktailTx {
  if !condition {
    mocktail_tx
  } else {
    let tx = mocktail_tx.tx
    let lower_bound =
      when tx.validity_range.lower_bound.bound_type is {
        Finite(x) -> Some(x)
        _ -> None
      }
    MocktailTx {
      ..mocktail_tx,
      tx: Transaction {
        ..tx,
        validity_range: mock_interval(lower_bound, Some(time)),
      },
    }
  }
}

/// Tx building method - Add a required signer hash to the transaction.
/// This function will only run when the condition is `True`.
/// ```aiken
/// let tx = mocktail_tx()
///   |> required_signer_hash(condition, key)
///   |> ...other tx building methods
///   |> complete()
/// ```
pub fn required_signer_hash(
  mocktail_tx: MocktailTx,
  condition: Bool,
  key: ByteArray,
) -> MocktailTx {
  if !condition {
    mocktail_tx
  } else {
    MocktailTx {
      ..mocktail_tx,
      tx: mocktail_tx.tx |> add_extra_signatory(True, key),
    }
  }
}

/// Tx building method - Add a script withdrawal to the transaction.
/// This function will only run when the condition is `True`.
/// ```aiken
/// let tx = mocktail_tx()
///  |> script_withdrawal(condition, script_hash, withdrawal_amount)
///  |> ...other tx building methods
///  |> complete()
/// ```
pub fn script_withdrawal(
  mocktail_tx: MocktailTx,
  condition: Bool,
  script_hash: ByteArray,
  withdrawal_amount: Int,
) -> MocktailTx {
  if !condition {
    mocktail_tx
  } else {
    let redeemer: Redeemer = Void
    let queue_withdrawal =
      Some(Pair(Pair(Script(script_hash), withdrawal_amount), redeemer))

    when mocktail_tx.queue_withdrawal is {
      Some(last_queue_withdrawal) -> {
        let Pair(last_withdrawal, last_redeemer) = last_queue_withdrawal
        let is_script_withdrawal =
          when last_withdrawal.1st is {
            Script(_) -> True
            _ -> False
          }
        MocktailTx {
          ..mocktail_tx,
          queue_withdrawal: queue_withdrawal,
          tx: mocktail_tx.tx
            |> add_withdrawal(True, last_withdrawal)
            |> add_redeemer(
                is_script_withdrawal,
                Pair(Withdraw(last_withdrawal.1st), last_redeemer),
              ),
        }
      }
      None -> MocktailTx { ..mocktail_tx, queue_withdrawal: queue_withdrawal }
    }
  }
}

/// Tx building method - Add a redeemer to last script withdrawal in the transaction.
/// This can only be used right after [`script_withdrawal`](./mocktail.html#script_withdrawal).
/// This function will only run when the condition is `True`.
/// If not followed by `script_withdrawal`, this function will do nothing.
/// ```aiken
/// let tx = mocktail_tx()
///   |> script_withdrawal(condition, script_hash, withdrawal_amount)
///   |> withdrawal_redeemer_value(condition, redeemer)
///   |> ...other tx building methods
///   |> complete()
/// ```
pub fn withdrawal_redeemer_value(
  mocktail_tx: MocktailTx,
  condition: Bool,
  redeemer: Redeemer,
) -> MocktailTx {
  if !condition {
    mocktail_tx
  } else {
    let queue_withdrawal =
      when mocktail_tx.queue_withdrawal is {
        Some(withdrawal) -> {
          let Pair(Pair(credential, amount), _) = withdrawal
          Some(Pair(Pair(credential, amount), redeemer))
        }
        None -> None
      }
    MocktailTx { ..mocktail_tx, queue_withdrawal: queue_withdrawal }
  }
}

/// Tx building method - Conclude the transaction building process, and return the built transaction.
/// ```aiken
/// let tx = mocktail_tx()
///   |> ...tx building methods
///   |> complete()
pub fn complete(mocktail_tx: MocktailTx) -> Transaction {
  let tx = mocktail_tx.tx
  let tx =
    when mocktail_tx.queue_input is {
      Some(input) -> tx |> add_input(True, input)
      None -> tx
    }
  let tx =
    when mocktail_tx.queue_output is {
      Some(output) -> tx |> add_output(True, output)
      None -> tx
    }
  let tx =
    when mocktail_tx.queue_ref_input is {
      Some(input) -> tx |> add_reference_input(True, input)
      None -> tx
    }
  let tx =
    when mocktail_tx.queue_withdrawal is {
      Some(Pair(withdrawal, redeemer)) -> {
        let is_script_withdrawal =
          when withdrawal.1st is {
            Script(_) -> True
            _ -> False
          }
        tx
          |> add_withdrawal(True, withdrawal)
          |> add_redeemer(
              is_script_withdrawal,
              Pair(Withdraw(withdrawal.1st), redeemer),
            )
      }
      None -> tx
    }
  tx
}

/// Tx manipulator - Add an input to the transaction.
/// This function will only run when the condition is `True`.
/// ```aiken
/// let tx = mocktail_tx()
///   |> ...tx building methods
///   |> complete()
///   |> add_input(condition, input)
///   |> ...other tx manipulator methods
/// ```
pub fn add_input(tx: Transaction, condition: Bool, input: Input) -> Transaction {
  if !condition {
    tx
  } else {
    Transaction { ..tx, inputs: tx.inputs |> list.concat([input]) }
  }
}

/// Tx manipulator - Add a reference input to the transaction.
/// This function will only run when the condition is `True`.
/// ```aiken
/// let tx = mocktail_tx()
///   |> ...tx building methods
///   |> complete()
///   |> add_reference_input(condition, input)
///   |> ...other tx manipulator methods
/// ```
pub fn add_reference_input(
  tx: Transaction,
  condition: Bool,
  input: Input,
) -> Transaction {
  if !condition {
    tx
  } else {
    Transaction {
      ..tx,
      reference_inputs: tx.reference_inputs |> list.concat([input]),
    }
  }
}

/// Tx manipulator - Add an output to the transaction.
/// This function will only run when the condition is `True`.
/// ```aiken
/// let t = mocktail_tx()
///   |> ...tx building methods
///   |> complete()
///   |> add_output(condition, output)
///   |> ...other tx manipulator methods
/// ```
pub fn add_output(
  tx: Transaction,
  condition: Bool,
  output: Output,
) -> Transaction {
  if !condition {
    tx
  } else {
    Transaction { ..tx, outputs: tx.outputs |> list.concat([output]) }
  }
}

/// Tx manipulator - Set a fee to the transaction.
/// This function will only run when the condition is `True`.
/// ```aiken
/// let tx = mocktail_tx()
///   |> ...tx building methods
///   |> complete()
///   |> set_fee(condition, lovelace_fee)
///   |> ...other tx manipulator methods
/// ```
pub fn set_fee(
  tx: Transaction,
  condition: Bool,
  lovelace_fee: Int,
) -> Transaction {
  if !condition {
    tx
  } else {
    Transaction { ..tx, fee: lovelace_fee }
  }
}

/// Tx manipulator - Add a mint to the transaction.
/// This function will only run when the condition is `True`.
/// ```aiken
/// let tx = mocktail_tx()
///   |> ...tx building methods
///   |> complete()
///   |> add_mint(condition, mint)
///   |> ...other tx manipulator methods
/// ```
pub fn add_mint(tx: Transaction, condition: Bool, mint: Value) -> Transaction {
  if !condition {
    tx
  } else {
    Transaction {
      ..tx,
      mint: tx.mint
        |> merge(mint),
    }
  }
}

/// Tx manipulator - Add a certificate to the transaction.
/// This function will only run when the condition is `True`.
/// ```aiken
/// let tx = mocktail_tx()
///   |> ...tx building methods
///   |> complete()
///   |> add_certificate(condition, certificate)
///   |> ...other tx manipulator methods
/// ```
pub fn add_certificate(
  tx: Transaction,
  condition: Bool,
  certificate: Certificate,
) -> Transaction {
  if !condition {
    tx
  } else {
    Transaction {
      ..tx,
      certificates: tx.certificates |> list.concat([certificate]),
    }
  }
}

/// Tx manipulator - Add a withdrawal to the transaction.
/// This function will only run when the condition is `True`.
/// ```aiken
/// let tx = mocktail_tx()
///   |> ...tx building methods
///   |> complete()
///   |> add_withdrawal(condition, stake_credential, amount)
///   |> ...other tx manipulator methods
/// ```
pub fn add_withdrawal(
  tx: Transaction,
  condition: Bool,
  withdrawal: Pair<Credential, Int>,
) -> Transaction {
  if !condition {
    tx
  } else {
    Transaction {
      ..tx,
      withdrawals: tx.withdrawals |> list.concat([withdrawal]),
    }
  }
}

/// Tx manipulator - Add an extra signatory to the transaction.
/// This function will only run when the condition is `True`.
/// ```aiken
/// let tx = mocktail_tx()
///   |> ...tx building methods
///   |> complete()
///   |> add_extra_signatory(condition, signatory)
///   |> ...other tx manipulator methods
/// ```
pub fn add_extra_signatory(
  tx: Transaction,
  condition: Bool,
  signatory: VerificationKeyHash,
) -> Transaction {
  if !condition {
    tx
  } else {
    Transaction {
      ..tx,
      extra_signatories: tx.extra_signatories |> list.concat([signatory]),
    }
  }
}

/// Tx manipulator - Add a redeemer to the transaction.
/// This function will only run when the condition is `True`.
/// ```aiken
/// let tx = mocktail_tx()
///   |> ...tx building methods
///   |> complete()
///   |> add_redeemer(condition, redeemer)
///   |> ...other tx manipulator methods
/// ```
pub fn add_redeemer(
  tx: Transaction,
  condition: Bool,
  redeemer: Pair<ScriptPurpose, Redeemer>,
) -> Transaction {
  if !condition {
    tx
  } else {
    Transaction { ..tx, redeemers: tx.redeemers |> list.concat([redeemer]) }
  }
}

/// Tx manipulator - Add a datum to the transaction.
/// This function will only run when the condition is `True`.
/// ```aiken
/// let tx = mocktail_tx()
///   |> ...tx building methods
///   |> complete()
///   |> add_datum(condition, datum)
///   |> ...other tx manipulator methods
/// ```
pub fn add_datum(tx: Transaction, condition: Bool, datum: Data) -> Transaction {
  if !condition {
    tx
  } else {
    let datum_hash = blake2b_256(cbor.serialise(datum))
    Transaction { ..tx, datums: tx.datums |> dict.insert(datum_hash, datum) }
  }
}

/// Tx manipulator - Set the transaction id.
/// This function will only run when the condition is `True`.
/// ```aiken
/// let tx = mocktail_tx()
///   |> ...tx building methods
///   |> complete()
///   |> set_transaction_id(condition, transaction_id)
///   |> ...other tx manipulator methods
/// ```
pub fn set_transaction_id(
  tx: Transaction,
  condition: Bool,
  transaction_id: TransactionId,
) -> Transaction {
  if !condition {
    tx
  } else {
    Transaction { ..tx, id: transaction_id }
  }
}

// Address

/// For documentation, please refer to [`virgin_address`](./mocktail/virgin_address.html)
pub const mock_verfication_key_credential =
  virgin_address.mock_verfication_key_credential

/// For documentation, please refer to [`virgin_address`](./mocktail/virgin_address.html)
pub const mock_pub_key_address = virgin_address.mock_pub_key_address

/// For documentation, please refer to [`virgin_address`](./mocktail/virgin_address.html)
pub const mock_script_credential = virgin_address.mock_script_credential

/// For documentation, please refer to [`virgin_address`](./mocktail/virgin_address.html)
pub const mock_script_address = virgin_address.mock_script_address

// Key hash

/// For documentation, please refer to [`virgin_key_hash`](./mocktail/virgin_key_hash.html)
pub const mock_key_hash = virgin_key_hash.mock_key_hash

/// For documentation, please refer to [`virgin_key_hash`](./mocktail/virgin_key_hash.html)
pub const mock_policy_id = virgin_key_hash.mock_policy_id

/// For documentation, please refer to [`virgin_key_hash`](./mocktail/virgin_key_hash.html)
pub const mock_pub_key_hash = virgin_key_hash.mock_pub_key_hash

/// For documentation, please refer to [`virgin_key_hash`](./mocktail/virgin_key_hash.html)
pub const mock_script_hash = virgin_key_hash.mock_script_hash

/// For documentation, please refer to [`virgin_key_hash`](./mocktail/virgin_key_hash.html)
pub const mock_stake_key_hash = virgin_key_hash.mock_stake_key_hash

/// For documentation, please refer to [`virgin_key_hash`](./mocktail/virgin_key_hash.html)
pub const mock_script_stake_key_hash =
  virgin_key_hash.mock_script_stake_key_hash

// Output reference

/// For documentation, please refer to [`virgin_output_reference`](./mocktail/virgin_output_reference.html)
pub const mock_tx_hash = virgin_output_reference.mock_tx_hash

/// For documentation, please refer to [`virgin_output_reference`](./mocktail/virgin_output_reference.html)
pub const mock_utxo_ref = virgin_output_reference.mock_utxo_ref

// Outputs

/// For documentation, please refer to [`virgin_outputs`](./mocktail/virgin_outputs.html)
pub const mock_output = virgin_outputs.mock_output

/// For documentation, please refer to [`virgin_outputs`](./mocktail/virgin_outputs.html)
pub const mock_pub_key_output = virgin_outputs.mock_pub_key_output

/// For documentation, please refer to [`virgin_outputs`](./mocktail/virgin_outputs.html)
pub const mock_script_output = virgin_outputs.mock_script_output

// Validity range

/// For documentation, please refer to [`virgin_validity_range`](./mocktail/virgin_validity_range.html)
pub const mock_interval = virgin_validity_range.mock_interval

test preserve_tx_in_order() {
  let tx: Transaction =
    mocktail_tx()
      |> tx_in(True, mock_tx_hash(0), 0, zero, mock_pub_key_address(0, None))
      |> tx_in(True, mock_tx_hash(1), 1, zero, mock_pub_key_address(1, None))
      |> complete()
  expect [input1, input2] = tx.inputs
  and {
    input1.output_reference.transaction_id == mock_tx_hash(0),
    input1.output_reference.output_index == 0,
    input2.output_reference.transaction_id == mock_tx_hash(1),
    input2.output_reference.output_index == 1,
  }
}
