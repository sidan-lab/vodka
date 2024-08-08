use aiken/list
use aiken/transaction/value.{
  AssetName, MintedValue, PolicyId, flatten, from_minted_value,
}

pub fn check_policy_only_burn(mint: MintedValue, policy: PolicyId) -> Bool {
  let burn_value = flatten(from_minted_value(mint))
  list.all(
    burn_value,
    fn(x) {
      if x.1st == policy {
        x.3rd < 0
      } else {
        True
      }
    },
  )
}

pub fn only_minted_token(
  mint: MintedValue,
  policy: PolicyId,
  name: AssetName,
  quantity: Int,
) {
  when from_minted_value(mint) |> flatten() is {
    [(minted_policy, minted_asset_name, minted_quantity)] ->
      minted_policy == policy && minted_asset_name == name && minted_quantity == quantity
    _ -> False
  }
}

pub fn token_minted(
  mint: MintedValue,
  policy: PolicyId,
  name: AssetName,
  quantity: Int,
) {
  from_minted_value(mint)
    |> flatten()
    |> list.any(fn(x) { x.1st == policy && x.2nd == name && x.3rd == quantity })
}
