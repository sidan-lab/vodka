use cardano/address.{
  Address, Credential, Script, StakeCredential, VerificationKey,
}
use mocktail/virgin_key_hash.{mock_pub_key_hash, mock_script_hash}

/// Mock a pub key credential
/// `variation` same the same index as `mock_pub_key_hash`
pub fn mock_verfication_key_credential(variation: Int) -> Credential {
  VerificationKey(mock_pub_key_hash(variation))
}

/// Mock a pub key address
/// `variation` same the same index as `mock_pub_key_hash`
/// `stake_credential` is optional
pub fn mock_pub_key_address(
  variation: Int,
  stake_credential: Option<StakeCredential>,
) -> Address {
  Address {
    payment_credential: mock_verfication_key_credential(variation),
    stake_credential,
  }
}

/// Mock a script credential
/// `variation` same the same index as `mock_script_hash`
pub fn mock_script_credential(variation: Int) -> Credential {
  Script(mock_script_hash(variation))
}

/// Mock a script address
/// `variation` same the same index as `mock_script_hash`
/// `stake_credential` is optional
pub fn mock_script_address(
  variation: Int,
  stake_credential: Option<StakeCredential>,
) -> Address {
  Address {
    payment_credential: mock_script_credential(variation),
    stake_credential,
  }
}
