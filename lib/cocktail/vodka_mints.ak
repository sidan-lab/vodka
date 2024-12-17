use aiken/collection/list
use cardano/assets.{AssetName, PolicyId, Value, flatten}

/// Check if a certain PolicyId is burning only if exists in the minted value.
/// ```aiken
/// let is_policy_only_burn = check_policy_only_burn(minted_value, policy);
/// ```
pub fn check_policy_only_burn(mint: Value, policy: PolicyId) -> Bool {
  let mint_value = flatten(mint)
  list.all(
    mint_value,
    fn(x) {
      if x.1st == policy {
        x.3rd < 0
      } else {
        True
      }
    },
  )
}

/// Check if the minted value contains only one distinct asset with particular PolicyId.
/// ```aiken
/// let is_only_minted_token = only_minted_token(minted_value, policy, name, quantity);
/// ```
pub fn only_minted_token(
  mint: Value,
  policy: PolicyId,
  name: AssetName,
  quantity: Int,
) {
  when flatten(mint) is {
    [(minted_policy, minted_asset_name, minted_quantity)] ->
      minted_policy == policy && minted_asset_name == name && minted_quantity == quantity
    _ -> False
  }
}

/// Check if the minted value contains a token with particular PolicyId, AssetName, and quantity.
/// ```aiken
/// let is_token_minted = token_minted(minted_value, policy, name, quantity);
/// ```
pub fn token_minted(
  mint: Value,
  policy: PolicyId,
  name: AssetName,
  quantity: Int,
) {
  flatten(mint)
    |> list.any(fn(x) { x.1st == policy && x.2nd == name && x.3rd == quantity })
}
