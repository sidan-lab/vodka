//// Mocktail contains a set of functions to build transactions for testing purposes.
//// 
//// To use Mocktail Tx, there are 4 steps
//// 1. Starts with [`mocktail_tx()`](./mocktail.html#mocktail_tx) to create a new transaction builder.
//// 2. Use tx building methods similar to MeshJS lower level APIs to build the transaction.
//// 3. Call [`complete`](./mocktail.html#complete) to complete building transaction.
//// 4. Finally, if there is any whole items to be added to the transaction, use the `add` functions.
//// 
//// Mocktail is built with devex and multiple test cases compatibility in mind.
//// 1. It is pipable.
//// 2. For every tx building and adding methods, it takes first param as condition. that function will only run when this condition is `True`.
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
  Transaction, TransactionId, placeholder,
}
use mocktail/virgin_address.{mock_script_address}
use mocktail/virgin_output_reference.{mock_utxo_ref}
use mocktail/virgin_outputs.{mock_pub_key_output, mock_script_output}
use mocktail/virgin_validity_range.{mock_interval}

/// A mock transaction builder. It can be initialized with `mocktail_tx()`.
pub type MocktailTx {
  tx: Transaction,
  queue_input: Option<Input>,
  queue_output: Option<Output>,
  queue_ref_input: Option<Input>,
}

/// Initialize a new mock transaction builder, and output a built transaction wiht [`.complete().`](./mocktail.html#complete)
/// ```aiken
/// let tx = mocktail_tx()
///   |> ...other tx building methods
///   |> complete();
/// ```
pub fn mocktail_tx() -> MocktailTx {
  MocktailTx {
    tx: placeholder,
    queue_input: None,
    queue_output: None,
    queue_ref_input: None,
  }
}

/// Tx building method - Add an input to the transaction.
/// This function will only run when the condition is `True`.
/// ```aiken
/// let tx = mocktail_tx()
///   |> tx_in(condition, tx_hash, tx_index, amount, address)
///   |> ...other tx building methods
///   |> complete();
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
/// ```aiken
/// let tx = mocktail_tx()
///   |> tx_in(condition, tx_hash, tx_index, amount, address)
///   |> tx_in_inline_datum(condition, datum)
///   |> ...other tx building methods
///   |> complete();
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
        None ->
          Some(
            Input {
              output_reference: mock_utxo_ref(0, 0),
              output: mock_script_output(
                mock_script_address(0, None),
                zero,
                InlineDatum(datum),
              ),
            },
          )
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
///   |> complete();
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
/// ```aiken
/// let tx = mocktail_tx()
///   |> tx_out(condition, address, amount)
///   |> tx_out_inline_datum(condition, datum)
///   |> ...other tx building methods
///   |> complete();
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
        None ->
          Some(
            mock_script_output(
              mock_script_address(0, None),
              zero,
              InlineDatum(datum),
            ),
          )
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
///   |> complete();
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
///   |> complete();
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
/// ```aiken
/// let tx = mocktail_tx()
///   |> ref_tx_in(condition, tx_hash, tx_index, amount, address)
///   |> ref_tx_in_inline_datum(condition, datum)
///   |> ...other tx building methods
///   |> complete();
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
        None ->
          Some(
            Input {
              output_reference: mock_utxo_ref(0, 0),
              output: mock_script_output(
                mock_script_address(0, None),
                zero,
                InlineDatum(datum),
              ),
            },
          )
      }
    MocktailTx { ..mocktail_tx, queue_ref_input: queue_ref_input }
  }
}

/// Tx building method - Add a a lower bound validity range to the transaction.
/// This function will only run when the condition is `True`.
/// ```aiken
/// let tx = mocktail_tx()
///   |> valid_hereafter(condition, time)
///   |> ...other tx building methods
///   |> complete();
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
///   |> valid_hereafter(condition, time)
///   |> ...other tx building methods
///   |> complete();
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
///   |> complete();
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
///  |> complete();
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
    MocktailTx {
      ..mocktail_tx,
      tx: mocktail_tx.tx
        |> add_withdrawal(True, Pair(Script(script_hash), withdrawal_amount)),
    }
  }
}

/// Tx building method - Conclude the transaction building process, and return the built transaction.
/// ```aiken
/// let tx = mocktail_tx()
///   |> ...tx building methods
///   |> complete();
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
  tx
}

/// Tx maniputlator - Add an input to the transaction.
/// This function will only run when the condition is `True`.
/// ```aiken
/// let tx = mocktail_tx()
///   |> ...tx building methods
///   |> complete()
///   |> add_input(condition, input)
///   |> ...other tx maniputlator methods
/// ```
pub fn add_input(tx: Transaction, condition: Bool, input: Input) -> Transaction {
  if !condition {
    tx
  } else {
    Transaction { ..tx, inputs: tx.inputs |> list.push(input) }
  }
}

/// Tx maniputlator - Add a reference input to the transaction.
/// This function will only run when the condition is `True`.
/// ```aiken
/// let tx = mocktail_tx()
///   |> ...tx building methods
///   |> complete()
///   |> add_reference_input(condition, input)
///   |> ...other tx maniputlator methods
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
      reference_inputs: tx.reference_inputs |> list.push(input),
    }
  }
}

/// Tx maniputlator - Add an output to the transaction.
/// This function will only run when the condition is `True`.
/// ```aiken
/// let t = mocktail_tx()
///   |> ...tx building methods
///   |> complete()
///   |> add_output(condition, output)
///   |> ...other tx maniputlator methods
/// ```
pub fn add_output(
  tx: Transaction,
  condition: Bool,
  output: Output,
) -> Transaction {
  if !condition {
    tx
  } else {
    Transaction { ..tx, outputs: tx.outputs |> list.push(output) }
  }
}

/// Tx maniputlator - Set a fee to the transaction.
/// This function will only run when the condition is `True`.
/// ```aiken
/// let tx = mocktail_tx()
///   |> ...tx building methods
///   |> complete()
///   |> set_fee(condition, lovelace_fee)
///   |> ...other tx maniputlator methods
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

/// Tx maniputlator - Add a mint to the transaction.
/// This function will only run when the condition is `True`.
/// ```aiken
/// let tx = mocktail_tx()
///   |> ...tx building methods
///   |> complete()
///   |> add_mint(condition, mint)
///   |> ...other tx maniputlator methods
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

/// Tx maniputlator - Add a certificate to the transaction.
/// This function will only run when the condition is `True`.
/// ```aiken
/// let tx = mocktail_tx()
///   |> ...tx building methods
///   |> complete()
///   |> add_certificate(condition, certificate)
///   |> ...other tx maniputlator methods
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
      certificates: tx.certificates |> list.push(certificate),
    }
  }
}

/// Tx maniputlator - Add a withdrawal to the transaction.
/// This function will only run when the condition is `True`.
/// ```aiken
/// let tx = mocktail_tx()
///   |> ...tx building methods
///   |> complete()
///   |> add_withdrawal(condition, stake_credential, amount)
///   |> ...other tx maniputlator methods
/// ```
pub fn add_withdrawal(
  tx: Transaction,
  condition: Bool,
  withdrawal: Pair<Credential, Int>,
) -> Transaction {
  if !condition {
    tx
  } else {
    Transaction { ..tx, withdrawals: tx.withdrawals |> list.push(withdrawal) }
  }
}

/// Tx maniputlator - Add an extra signatory to the transaction.
/// This function will only run when the condition is `True`.
/// ```aiken
/// let tx = mocktail_tx()
///   |> ...tx building methods
///   |> complete()
///   |> add_extra_signatory(condition, signatory)
///   |> ...other tx maniputlator methods
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
      extra_signatories: tx.extra_signatories |> list.push(signatory),
    }
  }
}

/// Tx maniputlator - Add a redeemer to the transaction.
/// This function will only run when the condition is `True`.
/// ```aiken
/// let tx = mocktail_tx()
///   |> ...tx building methods
///   |> complete()
///   |> add_redeemer(condition, redeemer)
///   |> ...other tx maniputlator methods
/// ```
pub fn add_redeemer(
  tx: Transaction,
  condition: Bool,
  redeemer: Pair<ScriptPurpose, Redeemer>,
) -> Transaction {
  if !condition {
    tx
  } else {
    Transaction { ..tx, redeemers: tx.redeemers |> list.push(redeemer) }
  }
}

/// Tx maniputlator - Add a datum to the transaction.
/// This function will only run when the condition is `True`.
/// ```aiken
/// let tx = mocktail_tx()
///   |> ...tx building methods
///   |> complete()
///   |> add_datum(condition, datum)
///   |> ...other tx maniputlator methods
/// ```
pub fn add_datum(tx: Transaction, condition: Bool, datum: Data) -> Transaction {
  if !condition {
    tx
  } else {
    let datum_hash = blake2b_256(cbor.serialise(datum))
    Transaction { ..tx, datums: tx.datums |> dict.insert(datum_hash, datum) }
  }
}

/// Tx maniputlator - Set the transaction id.
/// This function will only run when the condition is `True`.
/// ```aiken
/// let tx = mocktail_tx()
///   |> ...tx building methods
///   |> complete()
///   |> set_transaction_id(condition, transaction_id)
///   |> ...other tx maniputlator methods
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
