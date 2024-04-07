use aiken/hash.{Blake2b_224, Hash}
use aiken/transaction/credential.{Script, VerificationKey}
use aiken/transaction/value.{PolicyId}

pub fn mock_key_hex(variation: Int) -> ByteArray {
  when variation is {
    1 -> #"a2c20c77887ace1cd986193e4e75babd8993cfd56995cd5cfce609c2"
    2 -> #"e2cfca46ecdf7feb8a3a7f957ead86b88c156f3fdd9607bcb44eb8f5"
    3 -> #"70ce90786897b6f7b6430a57ae005ecaf7c8cab817dd7510598403a9"
    4 -> #"efa5288b2b13cff1db555eed5debc54f3b25a62b7321db37f8af9213"
    5 -> #"daa3d211db0e53d6088261552daeaa75f268b906f769d4eb04ead45d"
    11 -> #"e1491bc9d47bfe2117f792fa8c3389004d693b6b47e4c3facca1d146"
    12 -> #"2b77d1effa4dfb7f5913d176c88ae0e168b9e9c528bfc9b07784be1b"
    13 -> #"81f0f06d69c2422003d69113f497d78d3e0b42d7c1fb3fb5d6905ee2"
    14 -> #"81f0f06d69c2422003d69113f497d78d3e0b42d7c1fb3fb5d6905ee2"
    15 -> #"ecd2aeb53027de8b37ef622ba6a9b3a006c591301c7f6507ebb4e9b5"
    21 -> #"789cdcce60d344b947f28fa4c06ab6107c1a59d56bb35d7156951803"
    22 -> #"4d8a10609828b2b4403ba80e8559788f8c8433a8b007ebd70157c635"
    23 -> #"257c00a00c73e2ec2c113f877c742e79b0b6c6000b75e8f3ec92b0ab"
    24 -> #"672d5128420c19282d26e247aebc78669f896cff10173c1e23d2172e"
    25 -> #"bff30ac664233c97947b4e2f115320ac2c928bcc14cb85057679541e"
    26 -> #"80abf14bcde1d2237619057f40866b8de241b7264b5d6b4aa9f97ff9"
    27 -> #"8c4a9da730001048fb518a63696604c9b59e5433bb4f6332f8f2dd89"
    28 -> #"8ee022b68cfeb287c79966369301d3d01b1c4816e229509e7e1a6f61"
    29 -> #"6d628bcef102b61887dc389d962c401e724968fa2cdea5c4b4aeaa84"
    31 -> #"919cd6bf4bc94aa1fc008fe5776520a77dd9b0909872c0582792700a"
    32 -> #"ae3bdcce80699ab8a30f1583aed85c8bdf4c373f0d7441c2dcfd956b"
    33 -> #"c5dd55f31863ac8a72949de55810a55683c7ca3e1580740fd55dca0e"
    34 -> #"7d76f861a4d4f5fbf9e8760e95338d234b1e901e7c24586c67f6523a"
    35 -> #"586184843b60fd3941d01fd7b839c7712ebbaa045becefaeb9736e64"
    41 -> #"228fe3861b884a1148488811d56a35bfa834eb6c06c3797d7070aba7"
    42 -> #"df452e58fa35810e1a002f1e0e5beb07d7b7ef002feb3a124b32b00d"
    43 -> #"c031a6379982c1d48f4339993ceabc35a165ddaa00b6dc2e4b19b742"
    44 -> #"4bc61c9433f2c8b78022e57be0af60beb8242b53514edda19ddcd2a4"
    45 -> #"7736651b84aeba0f2f152b496767c4c6a7377702aa0998227883b1d2"
    _ -> #"49ab521ec4868f03d881452afe90e83a6c4e59681e7b97173ed9847e"
  }
}

pub fn mock_policy_id(variation: Int) -> PolicyId {
  when variation is {
    1 -> mock_key_hex(1)
    2 -> mock_key_hex(2)
    3 -> mock_key_hex(3)
    4 -> mock_key_hex(4)
    _ -> mock_key_hex(5)
  }
}

pub fn mock_pub_key_hex(variation: Int) -> Hash<Blake2b_224, VerificationKey> {
  when variation is {
    1 -> mock_key_hex(11)
    2 -> mock_key_hex(12)
    3 -> mock_key_hex(13)
    4 -> mock_key_hex(14)
    _ -> mock_key_hex(15)
  }
}

pub fn mock_script_hash_hex(variation: Int) -> Hash<Blake2b_224, Script> {
  when variation is {
    1 -> mock_key_hex(21)
    2 -> mock_key_hex(22)
    3 -> mock_key_hex(23)
    4 -> mock_key_hex(24)
    5 -> mock_key_hex(25)
    6 -> mock_key_hex(26)
    7 -> mock_key_hex(27)
    8 -> mock_key_hex(28)
    _ -> mock_key_hex(29)
  }
}

pub fn mock_stake_key_hex(variation: Int) -> Hash<Blake2b_224, VerificationKey> {
  when variation is {
    1 -> mock_key_hex(31)
    2 -> mock_key_hex(32)
    3 -> mock_key_hex(33)
    4 -> mock_key_hex(34)
    _ -> mock_key_hex(35)
  }
}

pub fn mock_script_stake_key_hex(variation: Int) -> Hash<Blake2b_224, Script> {
  when variation is {
    1 -> mock_key_hex(41)
    2 -> mock_key_hex(42)
    3 -> mock_key_hex(43)
    4 -> mock_key_hex(44)
    _ -> mock_key_hex(45)
  }
}
