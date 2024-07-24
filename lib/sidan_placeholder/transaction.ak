use aiken/cbor
use aiken/dict
use aiken/hash.{Blake2b_224, Hash, blake2b_256}
use aiken/list
use aiken/transaction.{
  Input, Output, Redeemer, ScriptPurpose, Transaction, TransactionId,
}
use aiken/transaction/certificate.{Certificate}
use aiken/transaction/credential.{StakeCredential, VerificationKey}
use aiken/transaction/value.{
  Value, from_lovelace, from_minted_value, merge, to_minted_value,
}

pub fn add_input(tx: Transaction, condition: Bool, input: Input) -> Transaction {
  if !condition {
    tx
  } else {
    Transaction { ..tx, inputs: tx.inputs |> list.push(input) }
  }
}

pub fn add_refernece_input(
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
