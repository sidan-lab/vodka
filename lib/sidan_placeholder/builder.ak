use aiken/interval.{Finite, Interval}
use aiken/list
use aiken/time.{PosixTime}
use aiken/transaction.{Input, Output, Transaction}
use aiken/transaction/value.{add, from_minted_value, to_minted_value}
use sidan_placeholder/validity_range.{mock_interval}

pub fn tx_in(tx: Transaction, input: Input) -> Transaction {
  Transaction { ..tx, inputs: list.push(tx.inputs, input) }
}

pub fn tx_out(tx: Transaction, output: Output) -> Transaction {
  Transaction { ..tx, outputs: list.push(tx.outputs, output) }
}

pub fn mint(
  tx: Transaction,
  policy_id: ByteArray,
  token_name: ByteArray,
  quantity: Int,
) -> Transaction {
  Transaction {
    ..tx,
    mint: from_minted_value(tx.mint)
      |> add(policy_id, token_name, quantity)
      |> to_minted_value(),
  }
}

pub fn read_only_tx_in_reference(tx: Transaction, input: Input) -> Transaction {
  Transaction { ..tx, reference_inputs: list.push(tx.reference_inputs, input) }
}

pub fn invalid_before(tx: Transaction, time: PosixTime) -> Transaction {
  let upper_bound =
    when tx.validity_range.upper_bound.bound_type is {
      Finite(x) -> Some(x)
      _ -> None
    }
  Transaction { ..tx, validity_range: mock_interval(Some(time), upper_bound) }
}

pub fn invalid_hereafter(tx: Transaction, time: PosixTime) -> Transaction {
  let lower_bound =
    when tx.validity_range.lower_bound.bound_type is {
      Finite(x) -> Some(x)
      _ -> None
    }
  Transaction { ..tx, validity_range: mock_interval(lower_bound, Some(time)) }
}

pub fn signing_key(tx: Transaction, key: ByteArray) -> Transaction {
  Transaction { ..tx, extra_signatories: list.push(tx.extra_signatories, key) }
}
