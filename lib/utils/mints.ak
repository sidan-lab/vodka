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
    [(mPolicy, mAssetName, mQuantity)] ->
      mPolicy == policy && mAssetName == name && mQuantity == quantity
    _ -> False
  }
}
