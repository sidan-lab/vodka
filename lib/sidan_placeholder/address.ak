use aiken/transaction/credential.{
  Address, Credential, ScriptCredential, StakeCredential,
  VerificationKeyCredential,
}
use sidan_placeholder/key_hex.{mock_pub_key_hex, mock_script_hash_hex}

// Pub Key Addresses
pub fn mock_verfication_key_credential(variation: Int) -> Credential {
  VerificationKeyCredential(mock_pub_key_hex(variation))
}

pub fn mock_pub_key_address(variation: Int, stake_credential) -> Address {
  Address {
    payment_credential: mock_verfication_key_credential(variation),
    stake_credential,
  }
}

// Script Addresses
pub fn mock_script_credential(variation: Int) -> Credential {
  ScriptCredential(mock_script_hash_hex(variation))
}

pub fn mock_script_address(
  variation: Int,
  stake_credential: Option<StakeCredential>,
) -> Address {
  Address {
    payment_credential: mock_script_credential(variation),
    stake_credential,
  }
}
