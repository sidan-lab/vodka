use aiken/cbor.{serialise}
use aiken/crypto.{ScriptHash, VerificationKeyHash, blake2b_224}
use aiken/primitive/bytearray.{concat}
use cardano/assets.{PolicyId}

pub const root_hash =
  #"a2c20c77887ace1cd986193e4e75babd8993cfd56995cd5cfce609c2"

/// Mock a key in hexadecimal format
pub fn mock_key_hash(variation: Int) -> ByteArray {
  serialise(variation) |> concat(root_hash) |> blake2b_224()
}

/// Mock a PolicyID
/// The variation is used to distinguish between different PolicyIDs
/// Use this but not other `mock_key_hash` functions to avoid hash collision
pub fn mock_policy_id(variation: Int) -> PolicyId {
  mock_key_hash(variation)
}

/// Mock a public key hash
/// The variation is used to distinguish between different public keys
/// Use this but not other `mock_key_hash` functions to avoid hash collision
pub fn mock_pub_key_hash(variation: Int) -> VerificationKeyHash {
  mock_key_hash(variation + 1000)
}

/// Mock a script hash
/// The variation is used to distinguish between different scripts
/// Use this but not other `mock_key_hash` functions to avoid hash collision
pub fn mock_script_hash(variation: Int) -> ScriptHash {
  mock_key_hash(variation + 2000)
}

/// Mock a stake key hash
/// The variation is used to distinguish between different stake keys
/// Use this but not other `mock_key_hash` functions to avoid hash collision
pub fn mock_stake_key_hash(variation: Int) -> VerificationKeyHash {
  mock_key_hash(variation + 3000)
}

/// Mock a script stake key hash
/// The variation is used to distinguish between different scripts
/// Use this but not other `mock_key_hash` functions to avoid hash collision
pub fn mock_script_stake_key_hash(variation: Int) -> ScriptHash {
  mock_key_hash(variation + 4000)
}
