use aiken/transaction/value.{PolicyId}

pub fn mock_policy_id(variation: Int) -> PolicyId {
  when variation is {
    1 -> #"1c1b7afe8affbee1505cf3ec5a58bd2734d4ffdfcc9b9f059625bd76"
    2 -> #"52e322a5dd87fe977c5ee5b91e3f42eedeccd6795a7ef4f158bd8892"
    3 -> #"a15cd6051ea2fc92c034b0bb1d33f2b7ba7ac92277e6ee5c30ab19a4"
    4 -> #"c0f778be07f8b129d2546ad37b0e13b3486747dfe1767ff8e7e8a4f3"
    _ -> #"ab4e38cc1e95e42c6f6e56d8d4243731c483bb57e49da5047c38e9d8"
  }
}
