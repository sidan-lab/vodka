use aiken/interval.{Finite, Interval}
use aiken/list
use aiken/time.{PosixTime}
use aiken/transaction.{
  InlineDatum, Input, Output, OutputReference, Transaction, TransactionId,
  placeholder,
}
use aiken/transaction/credential.{Address}
use aiken/transaction/value.{
  Value, add, from_minted_value, to_minted_value, zero,
}
use sidan_placeholder/address.{mock_script_address}
use sidan_placeholder/output_reference.{mock_utxo_ref}
use sidan_placeholder/outputs.{mock_pub_key_output, mock_script_output}
use sidan_placeholder/validity_range.{mock_interval}

pub type TxTester {
  tx: Transaction,
  queue_input: Option<Input>,
  queue_output: Option<Output>,
  queue_ref_input: Option<Input>,
}

pub fn new_tx_tester() -> TxTester {
  TxTester {
    tx: placeholder(),
    queue_input: None,
    queue_output: None,
    queue_ref_input: None,
  }
}

pub fn tx_in(
  tx_tester: TxTester,
  condition: Bool,
  tx_hash: ByteArray,
  tx_index: Int,
  amount: Value,
  address: Address,
) -> TxTester {
  if !condition {
    tx_tester
  } else {
    let queue_input =
      Some(
        Input {
          output_reference: OutputReference {
            transaction_id: TransactionId(tx_hash),
            output_index: tx_index,
          },
          output: mock_pub_key_output(address, amount),
        },
      )
    when tx_tester.queue_input is {
      Some(input) ->
        TxTester {
          ..tx_tester,
          queue_input: queue_input,
          tx: Transaction {
            ..tx_tester.tx,
            inputs: tx_tester.tx.inputs |> list.push(input),
          },
        }
      None -> TxTester { ..tx_tester, queue_input: queue_input }
    }
  }
}

pub fn tx_in_inline_datum(
  tx_tester: TxTester,
  condition: Bool,
  datum: Data,
) -> TxTester {
  if !condition {
    tx_tester
  } else {
    let queue_input =
      when tx_tester.queue_input is {
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
                zero(),
                InlineDatum(datum),
              ),
            },
          )
      }
    TxTester { ..tx_tester, queue_input: queue_input }
  }
}

pub fn tx_out(
  tx_tester: TxTester,
  condition: Bool,
  address: Address,
  amount: Value,
) -> TxTester {
  if !condition {
    tx_tester
  } else {
    let queue_output = Some(mock_pub_key_output(address, amount))
    when tx_tester.queue_output is {
      Some(output) ->
        TxTester {
          ..tx_tester,
          queue_output: queue_output,
          tx: Transaction {
            ..tx_tester.tx,
            outputs: tx_tester.tx.outputs |> list.push(output),
          },
        }
      None -> TxTester { ..tx_tester, queue_output: queue_output }
    }
  }
}

pub fn tx_out_inline_datum(
  tx_tester: TxTester,
  condition: Bool,
  datum: Data,
) -> TxTester {
  if !condition {
    tx_tester
  } else {
    let queue_output =
      when tx_tester.queue_output is {
        Some(output) -> Some(Output { ..output, datum: InlineDatum(datum) })
        None ->
          Some(
            mock_script_output(
              mock_script_address(0, None),
              zero(),
              InlineDatum(datum),
            ),
          )
      }
    TxTester { ..tx_tester, queue_output: queue_output }
  }
}

pub fn mint(
  tx_tester: TxTester,
  condition: Bool,
  policy_id: ByteArray,
  token_name: ByteArray,
  quantity: Int,
) -> TxTester {
  if !condition {
    tx_tester
  } else {
    TxTester {
      ..tx_tester,
      tx: Transaction {
        ..tx_tester.tx,
        mint: from_minted_value(tx_tester.tx.mint)
          |> add(policy_id, token_name, quantity)
          |> to_minted_value(),
      },
    }
  }
}

pub fn ref_tx_in(
  tx_tester: TxTester,
  condition: Bool,
  tx_hash: ByteArray,
  tx_index: Int,
  amount: Value,
  address: Address,
) -> TxTester {
  if !condition {
    tx_tester
  } else {
    let queue_ref_input =
      Some(
        Input {
          output_reference: OutputReference {
            transaction_id: TransactionId(tx_hash),
            output_index: tx_index,
          },
          output: mock_pub_key_output(address, amount),
        },
      )
    when tx_tester.queue_ref_input is {
      Some(input) ->
        TxTester {
          ..tx_tester,
          queue_ref_input: queue_ref_input,
          tx: Transaction {
            ..tx_tester.tx,
            reference_inputs: tx_tester.tx.reference_inputs |> list.push(input),
          },
        }
      None -> TxTester { ..tx_tester, queue_ref_input: queue_ref_input }
    }
  }
}

pub fn ref_tx_in_inline_datum(
  tx_tester: TxTester,
  condition: Bool,
  datum: Data,
) -> TxTester {
  if !condition {
    tx_tester
  } else {
    let queue_ref_input =
      when tx_tester.queue_ref_input is {
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
                zero(),
                InlineDatum(datum),
              ),
            },
          )
      }
    TxTester { ..tx_tester, queue_ref_input: queue_ref_input }
  }
}

pub fn invalid_before(
  tx_tester: TxTester,
  condition: Bool,
  time: PosixTime,
) -> TxTester {
  if !condition {
    tx_tester
  } else {
    let tx = tx_tester.tx
    let upper_bound =
      when tx.validity_range.upper_bound.bound_type is {
        Finite(x) -> Some(x)
        _ -> None
      }
    TxTester {
      ..tx_tester,
      tx: Transaction {
        ..tx,
        validity_range: mock_interval(Some(time), upper_bound),
      },
    }
  }
}

pub fn invalid_hereafter(
  tx_tester: TxTester,
  condition: Bool,
  time: PosixTime,
) -> TxTester {
  if !condition {
    tx_tester
  } else {
    let tx = tx_tester.tx
    let lower_bound =
      when tx.validity_range.lower_bound.bound_type is {
        Finite(x) -> Some(x)
        _ -> None
      }
    TxTester {
      ..tx_tester,
      tx: Transaction {
        ..tx,
        validity_range: mock_interval(lower_bound, Some(time)),
      },
    }
  }
}

pub fn signing_key(
  tx_tester: TxTester,
  condition: Bool,
  key: ByteArray,
) -> TxTester {
  if !condition {
    tx_tester
  } else {
    let tx = tx_tester.tx
    TxTester {
      ..tx_tester,
      tx: Transaction {
        ..tx,
        extra_signatories: list.push(tx.extra_signatories, key),
      },
    }
  }
}

pub fn complete(tx_tester: TxTester) -> Transaction {
  let tx = tx_tester.tx
  let tx =
    when tx_tester.queue_input is {
      Some(input) -> Transaction { ..tx, inputs: list.push(tx.inputs, input) }
      None -> tx
    }
  let tx =
    when tx_tester.queue_output is {
      Some(output) ->
        Transaction { ..tx, outputs: list.push(tx.outputs, output) }
      None -> tx
    }
  let tx =
    when tx_tester.queue_ref_input is {
      Some(input) ->
        Transaction {
          ..tx,
          reference_inputs: list.push(tx.reference_inputs, input),
        }
      None -> tx
    }
  tx
}
