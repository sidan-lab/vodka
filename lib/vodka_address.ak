use aiken/bytearray
use aiken/hash.{Blake2b_224, Hash}
use aiken/transaction/credential.{
  Address, Script, ScriptCredential, VerificationKey, VerificationKeyCredential,
}

/// Compare two script addresses 
pub fn compare_script_address(x: Address, y: Address) -> Ordering {
  expect ScriptCredential(x_hash) = x.payment_credential
  expect ScriptCredential(y_hash) = y.payment_credential
  bytearray.compare(x_hash, y_hash)
}

/// Compare two addresses
pub fn compare_address(x: Address, y: Address) -> Ordering {
  let x_hash = x.payment_credential
  let y_hash = y.payment_credential
  when (x_hash, y_hash) is {
    (ScriptCredential(x_script_hash), ScriptCredential(y_script_hash)) ->
      bytearray.compare(x_script_hash, y_script_hash)
    (
      VerificationKeyCredential(x_key_hash),
      VerificationKeyCredential(y_key_hash),
    ) -> bytearray.compare(x_key_hash, y_key_hash)
    _ -> Equal
  }
}

/// Obtain the payment key of an address, it can be either a script hash or a verification key
pub fn address_payment_key(address: Address) -> Hash<Blake2b_224, ByteArray> {
  when address.payment_credential is {
    ScriptCredential(hash) -> hash
    VerificationKeyCredential(key_hash) -> key_hash
  }
}

/// Obtain the verification key of an address, None if it is a script address
pub fn address_pub_key(
  address: Address,
) -> Option<Hash<Blake2b_224, VerificationKey>> {
  when address.payment_credential is {
    VerificationKeyCredential(key_hash) -> Some(key_hash)
    _ -> None
  }
}

/// Obtain the script hash of an address, None if it is a verification key address
pub fn address_script_hash(
  address: Address,
) -> Option<Hash<Blake2b_224, Script>> {
  when address.payment_credential is {
    ScriptCredential(script_hash) -> Some(script_hash)
    _ -> None
  }
}
