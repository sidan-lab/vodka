use aiken/collection/list
use aiken/crypto.{
  VerificationKey, VerificationKeyHash, blake2b_224, verify_ed25519_signature,
}

pub fn verify_signatures(
  keys: List<VerificationKey>,
  msg: ByteArray,
  sigs: List<ByteArray>,
) -> Bool {
  when keys is {
    [key, ..rest_keys] -> {
      expect [sig, ..rest_sigs] = sigs
      when verify_ed25519_signature(key, msg, sig) is {
        True -> verify_signatures(rest_keys, msg, rest_sigs)?
        False -> False
      }
    }
    [] -> True
  }
}

test verify_signatures_with_valid_keys() {
  let msg =
    #"a240a1401a68428886581cc69b981db7a65e339a6d783755f85a2e03afa1cece9714c55fe4c913a1445553444d1a088e268a"

  let keys =
    [
      #"8a2447b9e7f1705aa5b2dcb16a7254db089fbac7e462cf6008e9a6dc8a7a6c21",
      #"312803d57366263f9e5310262fb9984f58dbc5602ad5ebdd5725719f4f913ced",
      #"fa357c31b2e47f49d4e0da6eac605a4dc068f4e72fbc56bfef2850e2da1ba3a3",
      #"63c5d69570349e4233a0575811464f0e8a3fd329abe76e9bdc3d3f1b95982179",
    ]

  let sigs =
    [
      #"9156b338a765232c2f1a23da9e20eea167f14ea88cdd4f6c36d6a64a2a0e54b7317a98331b14df3dd0199538d97d117cbf83ac6fb6f7e820eaa9759b81c2960e",
      #"748a2ed197a9dfafa3c5affc9b876e966843fbba6817971e013a59e5de9af6e223d19ae44e20ee70a100af357a85142df90d3772ac2220c14b3c8642d7b76503",
      #"ffe97112a1647462c1e110999f9d9fef71bb970d5c42d963374bcbbc5d9e5baba06de66f6faa4bb628889e4942d27fe5f6852d9f7c6c26938824882f174c5c00",
      #"ee1a65db1a07b7fd821698c82d3720b653f21a9bf1b91d3bc64b5c4d8b216a307978550f07ee68b9a7fc69c67409292a1fd4357ae8762537f6d4746d68a64d02",
    ]
  verify_signatures(keys, msg, sigs) == True
}

test verify_signatures_with_one_invalid_key() {
  let msg =
    #"a240a1401a68428886581cc69b981db7a65e339a6d783755f85a2e03afa1cece9714c55fe4c913a1445553444d1a088e268a"

  let keys =
    [
      #"8a2447b9e7f1705aa5b2dcb16a7254db089fbac7e462cf6008e9a6dc8a7a6c20",
      #"312803d57366263f9e5310262fb9984f58dbc5602ad5ebdd5725719f4f913ced",
      #"fa357c31b2e47f49d4e0da6eac605a4dc068f4e72fbc56bfef2850e2da1ba3a3",
      #"63c5d69570349e4233a0575811464f0e8a3fd329abe76e9bdc3d3f1b95982179",
    ]

  let sigs =
    [
      #"9156b338a765232c2f1a23da9e20eea167f14ea88cdd4f6c36d6a64a2a0e54b7317a98331b14df3dd0199538d97d117cbf83ac6fb6f7e820eaa9759b81c2960e",
      #"748a2ed197a9dfafa3c5affc9b876e966843fbba6817971e013a59e5de9af6e223d19ae44e20ee70a100af357a85142df90d3772ac2220c14b3c8642d7b76503",
      #"ffe97112a1647462c1e110999f9d9fef71bb970d5c42d963374bcbbc5d9e5baba06de66f6faa4bb628889e4942d27fe5f6852d9f7c6c26938824882f174c5c00",
      #"ee1a65db1a07b7fd821698c82d3720b653f21a9bf1b91d3bc64b5c4d8b216a307978550f07ee68b9a7fc69c67409292a1fd4357ae8762537f6d4746d68a64d02",
    ]
  verify_signatures(keys, msg, sigs) == False
}

test verify_signatures_with_empty_key() {
  let msg =
    #"a240a1401a68428886581cc69b981db7a65e339a6d783755f85a2e03afa1cece9714c55fe4c913a1445553444d1a088e268a"

  let keys = []

  let sigs =
    [
      #"9156b338a765232c2f1a23da9e20eea167f14ea88cdd4f6c36d6a64a2a0e54b7317a98331b14df3dd0199538d97d117cbf83ac6fb6f7e820eaa9759b81c2960e",
      #"748a2ed197a9dfafa3c5affc9b876e966843fbba6817971e013a59e5de9af6e223d19ae44e20ee70a100af357a85142df90d3772ac2220c14b3c8642d7b76503",
      #"ffe97112a1647462c1e110999f9d9fef71bb970d5c42d963374bcbbc5d9e5baba06de66f6faa4bb628889e4942d27fe5f6852d9f7c6c26938824882f174c5c00",
      #"ee1a65db1a07b7fd821698c82d3720b653f21a9bf1b91d3bc64b5c4d8b216a307978550f07ee68b9a7fc69c67409292a1fd4357ae8762537f6d4746d68a64d02",
    ]
  verify_signatures(keys, msg, sigs) == True
}

test verify_signatures_with_empty_signatures() fail {
  let msg =
    #"a240a1401a68428886581cc69b981db7a65e339a6d783755f85a2e03afa1cece9714c55fe4c913a1445553444d1a088e268a"

  let keys =
    [
      #"8a2447b9e7f1705aa5b2dcb16a7254db089fbac7e462cf6008e9a6dc8a7a6c21",
      #"312803d57366263f9e5310262fb9984f58dbc5602ad5ebdd5725719f4f913ced",
      #"fa357c31b2e47f49d4e0da6eac605a4dc068f4e72fbc56bfef2850e2da1ba3a3",
      #"63c5d69570349e4233a0575811464f0e8a3fd329abe76e9bdc3d3f1b95982179",
    ]

  let sigs = []
  verify_signatures(keys, msg, sigs) == False
}

pub fn verify_pub_keys(
  keys: List<VerificationKey>,
  pkhs: List<VerificationKeyHash>,
) -> Bool {
  list.map2(
    keys,
    pkhs,
    fn(key: VerificationKey, pkh: VerificationKeyHash) {
      blake2b_224(key) == pkh
    },
  )
    |> list.all(fn(x: Bool) { x })
}

test verify_pub_keys_with_valid_keys() {
  let keys =
    [
      #"8a2447b9e7f1705aa5b2dcb16a7254db089fbac7e462cf6008e9a6dc8a7a6c21",
      #"312803d57366263f9e5310262fb9984f58dbc5602ad5ebdd5725719f4f913ced",
      #"fa357c31b2e47f49d4e0da6eac605a4dc068f4e72fbc56bfef2850e2da1ba3a3",
      #"63c5d69570349e4233a0575811464f0e8a3fd329abe76e9bdc3d3f1b95982179",
    ]

  let pkhs =
    [
      #"a65106a37f0b23f0384d19b7102550ecb3591c21d4804a1d35191315",
      #"b5ea75ba2eac9a884ba7c47110ab7f94f9c0306636e4df01f338920f",
      #"1195997a35c4f3f0b0d1edb2c3123a25897d9810e0545f950c61ae1f",
      #"00b7847c89d5721592fc0cc8932f50a8f8258b39b93861140a1b99fb",
    ]

  verify_pub_keys(keys, pkhs) == True
}

test verify_pub_keys_with_one_invalid_key() {
  let keys =
    [
      #"8a2447b9e7f1705aa5b2dcb16a7254db089fbac7e462cf6008e9a6dc8a7a6c20",
      #"312803d57366263f9e5310262fb9984f58dbc5602ad5ebdd5725719f4f913ced",
      #"fa357c31b2e47f49d4e0da6eac605a4dc068f4e72fbc56bfef2850e2da1ba3a3",
      #"63c5d69570349e4233a0575811464f0e8a3fd329abe76e9bdc3d3f1b95982179",
    ]

  let pkhs =
    [
      #"a65106a37f0b23f0384d19b7102550ecb3591c21d4804a1d35191315",
      #"b5ea75ba2eac9a884ba7c47110ab7f94f9c0306636e4df01f338920f",
      #"1195997a35c4f3f0b0d1edb2c3123a25897d9810e0545f950c61ae1f",
      #"00b7847c89d5721592fc0cc8932f50a8f8258b39b93861140a1b99fb",
    ]

  verify_pub_keys(keys, pkhs) == False
}

test verify_pub_keys_with_diff_len() fail {
  let keys =
    [
      #"8a2447b9e7f1705aa5b2dcb16a7254db089fbac7e462cf6008e9a6dc8a7a6c21",
      #"312803d57366263f9e5310262fb9984f58dbc5602ad5ebdd5725719f4f913ced",
      #"fa357c31b2e47f49d4e0da6eac605a4dc068f4e72fbc56bfef2850e2da1ba3a3",
    ]

  let pkhs =
    [
      #"a65106a37f0b23f0384d19b7102550ecb3591c21d4804a1d35191315",
      #"b5ea75ba2eac9a884ba7c47110ab7f94f9c0306636e4df01f338920f",
      #"1195997a35c4f3f0b0d1edb2c3123a25897d9810e0545f950c61ae1f",
      #"00b7847c89d5721592fc0cc8932f50a8f8258b39b93861140a1b99fb",
    ]

  verify_pub_keys(keys, pkhs) == False
}

test verify_pub_keys_with_empty() {
  let keys = []
  let pkhs = []

  verify_pub_keys(keys, pkhs) == True
}
