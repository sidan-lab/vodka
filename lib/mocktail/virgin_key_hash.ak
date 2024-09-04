use aiken/crypto.{ScriptHash, VerificationKeyHash}
use cardano/assets.{PolicyId}

/// Mock a key in hexadecimal format
pub fn mock_key_hash(variation: Int) -> ByteArray {
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
    100 -> #"5ea38808617f1d5a15cd3a4a5c8ed73a9b39e2649d803bb2e126b649"
    101 -> #"a0a867fc08bea53ac1a499c650d7b2f08810a8bdebf13790ad060b43"
    102 -> #"5c86ba6ce3ce3c8b7919164d9e97868839a5927d8c59db8f1868aa6f"
    103 -> #"1599d5256c64ed7d5a6d277460aff5c22975ebea544f08add08d116a"
    104 -> #"1b5635b617817de4a66da0f6cd1130805744f651d2f2baf934b74090"
    105 -> #"4f151b79f239c61b1db3d4a220f856675c0ec3397c4caa3a2fa469b6"
    106 -> #"66b81fa9d4bb50c5d99432f483c68c0e9e641d2803eb53fb7bf55291"
    107 -> #"269aa0c869e188d5483cd804fa32181ba66fc2dd54fe0b2b23ec7e3c"
    108 -> #"d91e83eed8e97db6794c13430c18730fe7cd2525bbf56d17a8d5cb8d"
    109 -> #"7a55a79490f5c67067d63b89ca92f3829bda7f72cf9ee360a8d1e1fc"
    110 -> #"9e43100d2ad567b971ecc7ce384fa899200683462c662c781f8be5ac"
    111 -> #"b257e731eae5a50f078ed1ec976d14b66a01bdb4d0ce6c6bc0d1ccc2"
    112 -> #"a98eec8962b83e5564542f641a9183b332ce341866f3b4edb6abc5a5"
    113 -> #"7192b1d72ce9c0bdfff218f566a840be5e8d442b69b70a6d98008bed"
    114 -> #"2077abc628e957f03b6f0468665558735cbb66474aff20cb7f9f89fc"
    115 -> #"e98788d22cf93ebc9ee43108c614006c07ad6d3c4960f5f9f8c64ae1"
    116 -> #"c1ab28790f71cf90d91a5e7ed241a5fc6b09a4802964be0303e81860"
    117 -> #"f647de2f68b54508f1e751b5809130db2ef04d1a1956e9afbcc4aaed"
    118 -> #"c9e4262b3d65fd28f1fa719beb87ad55c9541078c6f6badf29b3e2dc"
    119 -> #"11f4cb688954a273e9d3d3ce459290fe555c8b7f569de1e1f9c20cb9"
    120 -> #"e2ff8411220469fc3f5596736e0575c113b06ce9883bda9347cf6723"
    121 -> #"5e20695e3c109dc38b0742bd7fd1e8efcf22b7b372b0bc24c6575916"
    122 -> #"7f46d6e02bd7d432bbe5630d6bf11e5238c556408818960eafd3dc9c"
    123 -> #"e103e15926605b608282cbfb588abbe6e3e85aef6fe2202179237551"
    124 -> #"6bd19f36563611a4947e63585b5e36afa7db04daaf1e240b69bd5c0c"
    125 -> #"e814cc4ec4e677681370c992a46934c4dd0a5eaefd3dea56b2678956"
    126 -> #"213c5ad0b80af3a61a47ab982dc5dc3d570f0ac592a0957cf1928bef"
    127 -> #"dab8076d475085650ac92934f8b1e3601654cce60ebf589b2d247ac9"
    128 -> #"ab1c06794b2edbd2083bdb21cc9e43a797144c4e549aef9ff4f37ab9"
    129 -> #"5ea38808617f1d5a15cd3a4a5c8ed73a9b39e2649d803bb2e126b649"
    _ -> #"49ab521ec4868f03d881452afe90e83a6c4e59681e7b97173ed9847e"
  }
}

/// Mock a PolicyID
/// The variation is used to distinguish between different PolicyIDs
/// Use this but not other `mock_key_hash` functions to avoid hash collision
pub fn mock_policy_id(variation: Int) -> PolicyId {
  when variation is {
    1 -> mock_key_hash(1)
    2 -> mock_key_hash(2)
    3 -> mock_key_hash(3)
    4 -> mock_key_hash(4)
    _ -> mock_key_hash(5)
  }
}

/// Mock a public key hash
/// The variation is used to distinguish between different public keys
/// Use this but not other `mock_key_hash` functions to avoid hash collision
pub fn mock_pub_key_hash(variation: Int) -> VerificationKeyHash {
  when variation is {
    1 -> mock_key_hash(11)
    2 -> mock_key_hash(12)
    3 -> mock_key_hash(13)
    4 -> mock_key_hash(14)
    _ -> mock_key_hash(15)
  }
}

/// Mock a script hash
/// The variation is used to distinguish between different scripts
/// Use this but not other `mock_key_hash` functions to avoid hash collision
pub fn mock_script_hash(variation: Int) -> ScriptHash {
  when variation is {
    1 -> mock_key_hash(101)
    2 -> mock_key_hash(102)
    3 -> mock_key_hash(103)
    4 -> mock_key_hash(104)
    5 -> mock_key_hash(105)
    6 -> mock_key_hash(106)
    7 -> mock_key_hash(107)
    8 -> mock_key_hash(108)
    9 -> mock_key_hash(109)
    10 -> mock_key_hash(109)
    11 -> mock_key_hash(111)
    12 -> mock_key_hash(112)
    13 -> mock_key_hash(113)
    14 -> mock_key_hash(114)
    15 -> mock_key_hash(115)
    16 -> mock_key_hash(116)
    17 -> mock_key_hash(117)
    18 -> mock_key_hash(118)
    19 -> mock_key_hash(119)
    20 -> mock_key_hash(120)
    21 -> mock_key_hash(121)
    22 -> mock_key_hash(122)
    23 -> mock_key_hash(123)
    24 -> mock_key_hash(124)
    25 -> mock_key_hash(125)
    26 -> mock_key_hash(126)
    27 -> mock_key_hash(127)
    28 -> mock_key_hash(128)
    29 -> mock_key_hash(129)
    30 -> mock_key_hash(130)
    _ -> mock_key_hash(100)
  }
}

/// Mock a stake key hash
/// The variation is used to distinguish between different stake keys
/// Use this but not other `mock_key_hash` functions to avoid hash collision
pub fn mock_stake_key_hash(variation: Int) -> VerificationKeyHash {
  when variation is {
    1 -> mock_key_hash(21)
    2 -> mock_key_hash(22)
    3 -> mock_key_hash(23)
    4 -> mock_key_hash(24)
    _ -> mock_key_hash(25)
  }
}

/// Mock a script stake key hash
/// The variation is used to distinguish between different scripts
/// Use this but not other `mock_key_hash` functions to avoid hash collision
pub fn mock_script_stake_key_hash(variation: Int) -> ScriptHash {
  when variation is {
    1 -> mock_key_hash(31)
    2 -> mock_key_hash(32)
    3 -> mock_key_hash(33)
    4 -> mock_key_hash(34)
    _ -> mock_key_hash(35)
  }
}
