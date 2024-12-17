use aiken/crypto.{Blake2b_224, Hash, ScriptHash, VerificationKeyHash}
use aiken/primitive/bytearray
use cardano/address.{Address, Script, VerificationKey}

/// Compare two script addresses 
pub fn compare_script_address(x: Address, y: Address) -> Ordering {
  expect Script(x_hash) = x.payment_credential
  expect Script(y_hash) = y.payment_credential
  bytearray.compare(x_hash, y_hash)
}

/// Compare two addresses
pub fn compare_address(x: Address, y: Address) -> Ordering {
  let x_hash = x.payment_credential
  let y_hash = y.payment_credential
  when (x_hash, y_hash) is {
    (Script(x_script_hash), Script(y_script_hash)) ->
      bytearray.compare(x_script_hash, y_script_hash)
    (VerificationKey(x_key_hash), VerificationKey(y_key_hash)) ->
      bytearray.compare(x_key_hash, y_key_hash)
    _ -> Equal
  }
}

/// Obtain the payment key of an address, it can be either a script hash or a verification key
/// ```aiken
/// let payment_key_hash = address_payment_key(address);
/// ```
pub fn address_payment_key(address: Address) -> Hash<Blake2b_224, ByteArray> {
  when address.payment_credential is {
    Script(hash) -> hash
    VerificationKey(key_hash) -> key_hash
  }
}

/// Obtain the verification key of an address, None if it is a script address
/// ```aiken
/// expect Some(pub_key_hash) = address_pub_key(address);
/// ```
pub fn address_pub_key(address: Address) -> Option<VerificationKeyHash> {
  when address.payment_credential is {
    VerificationKey(key_hash) -> Some(key_hash)
    _ -> None
  }
}

/// Obtain the script hash of an address, None if it is a verification key address
/// ```aiken
/// expect Some(script_hash) = address_pub_key(address);
/// ```
pub fn address_script_hash(address: Address) -> Option<ScriptHash> {
  when address.payment_credential is {
    Script(script_hash) -> Some(script_hash)
    _ -> None
  }
}
