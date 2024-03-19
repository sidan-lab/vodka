use aiken/transaction/credential.{
  Address, Credential, ScriptCredential, StakeCredential,
  VerificationKeyCredential,
}

// Pub Key Addresses

pub fn mock_pub_key_hex(variation: Int) -> ByteArray {
  when variation is {
    1 -> #"a2c20c77887ace1cd986193e4e75babd8993cfd56995cd5cfce609c2"
    2 -> #"e2cfca46ecdf7feb8a3a7f957ead86b88c156f3fdd9607bcb44eb8f5"
    _ -> #"310b3e52ee714c92f723d4e3e4060fc8029f13f672872eefa742a716"
  }
}

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

pub fn mock_script_hash_hex(variation: Int) -> ByteArray {
  when variation is {
    1 -> #"70ce90786897b6f7b6430a57ae005ecaf7c8cab817dd7510598403a9"
    2 -> #"efa5288b2b13cff1db555eed5debc54f3b25a62b7321db37f8af9213"
    3 -> #"a8ba4d8ab8d7f1f864a27a63dab1185cc47929dc3c3a34956d946286"
    4 -> #"ee557be73b5084e8907e2118a2b1cddf3a1e14dcb2e1ee5d586a3f90"
    5 -> #"84944ba25d1708d71058ee2ef715375873784adc588f6a0706fa2589"
    6 -> #"8be60057c65fbae6d5c0673f899fea68868b16aeba6ff06f2d7f3161"
    _ -> #"e9fbf88caff6bf3742fd30047abf3883d50ed7059ae832fddfda4b71"
  }
}

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
