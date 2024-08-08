use aiken/cbor
use aiken/dict
use aiken/hash.{Blake2b_224, Hash, blake2b_256}
use aiken/interval.{Finite, Interval}
use aiken/list
use aiken/time.{PosixTime}
use aiken/transaction.{
  InlineDatum, Input, Output, OutputReference, Redeemer, ScriptPurpose,
  Transaction, TransactionId, placeholder,
}
use aiken/transaction/certificate.{Certificate}
use aiken/transaction/credential.{
  Address, Inline, ScriptCredential, StakeCredential, VerificationKey,
}
use aiken/transaction/value.{
  Value, from_asset, from_lovelace, from_minted_value, merge, to_minted_value,
  zero,
}
use mocktail/virgin_address.{mock_script_address}
use mocktail/virgin_output_reference.{mock_utxo_ref}
use mocktail/virgin_outputs.{mock_pub_key_output, mock_script_output}
use mocktail/virgin_validity_range.{mock_interval}

pub type MocktailTx {
  tx: Transaction,
  queue_input: Option<Input>,
  queue_output: Option<Output>,
  queue_ref_input: Option<Input>,
}

pub fn mocktail_tx() -> MocktailTx {
  MocktailTx {
    tx: placeholder(),
    queue_input: None,
    queue_output: None,
    queue_ref_input: None,
  }
}

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
            transaction_id: TransactionId(tx_hash),
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
                zero(),
                InlineDatum(datum),
              ),
            },
          )
      }
    MocktailTx { ..mocktail_tx, queue_input: queue_input }
  }
}

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
              zero(),
              InlineDatum(datum),
            ),
          )
      }
    MocktailTx { ..mocktail_tx, queue_output: queue_output }
  }
}

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
            transaction_id: TransactionId(tx_hash),
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
                zero(),
                InlineDatum(datum),
              ),
            },
          )
      }
    MocktailTx { ..mocktail_tx, queue_ref_input: queue_ref_input }
  }
}

pub fn invalid_before(
  mocktail_tx: MocktailTx,
  condition: Bool,
  time: PosixTime,
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

pub fn invalid_hereafter(
  mocktail_tx: MocktailTx,
  condition: Bool,
  time: PosixTime,
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
        |> add_withdrawal(
            True,
            Pair(Inline(ScriptCredential(script_hash)), withdrawal_amount),
          ),
    }
  }
}

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

pub fn add_input(tx: Transaction, condition: Bool, input: Input) -> Transaction {
  if !condition {
    tx
  } else {
    Transaction { ..tx, inputs: tx.inputs |> list.push(input) }
  }
}

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

pub fn set_fee(
  tx: Transaction,
  condition: Bool,
  lovelace_fee: Int,
) -> Transaction {
  if !condition {
    tx
  } else {
    Transaction { ..tx, fee: from_lovelace(lovelace_fee) }
  }
}

pub fn add_mint(tx: Transaction, condition: Bool, mint: Value) -> Transaction {
  if !condition {
    tx
  } else {
    Transaction {
      ..tx,
      mint: from_minted_value(tx.mint)
        |> merge(mint)
        |> to_minted_value(),
    }
  }
}

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

pub fn add_withdrawal(
  tx: Transaction,
  condition: Bool,
  withdrawal: Pair<StakeCredential, Int>,
) -> Transaction {
  if !condition {
    tx
  } else {
    Transaction { ..tx, withdrawals: tx.withdrawals |> list.push(withdrawal) }
  }
}

pub fn add_extra_signatory(
  tx: Transaction,
  condition: Bool,
  signatory: Hash<Blake2b_224, VerificationKey>,
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

pub fn add_datum(tx: Transaction, condition: Bool, datum: Data) -> Transaction {
  if !condition {
    tx
  } else {
    let datum_hash = blake2b_256(cbor.serialise(datum))
    Transaction { ..tx, datums: tx.datums |> dict.insert(datum_hash, datum) }
  }
}

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
