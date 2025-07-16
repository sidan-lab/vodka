use aiken/collection/pairs.{has_key}
use aiken/crypto.{ScriptHash}
use cardano/address.{Credential, Script}
use cardano/assets.{Lovelace}

/// Check if the withdrawal script hash is present in the withdrawals
/// ```aiken
/// let is_withdrawal_script_presented = withdrawal_script_validated(
///   withdrawals,
///   withdrawal_script_hash,
/// )
/// ```
pub fn withdrawal_script_validated(
  withdrawals: Pairs<Credential, Lovelace>,
  withdrawal_script_hash: ScriptHash,
) -> Bool {
  withdrawals
    |> has_key(Script(withdrawal_script_hash))
}
