use aiken/collection/list
use cardano/assets.{from_asset, zero}
use cocktail/vodka_outputs.{
  group_outputs, group_outputs_2, o_at, outputs_at, outputs_with,
  outputs_with_policy,
}
use mocktail.{
  complete, mock_policy_id, mock_pub_key_address, mocktail_tx, tx_out,
}

test test_outputs_at() {
  let tx =
    mocktail_tx()
      |> tx_out(True, mock_pub_key_address(0, None), zero)
      |> tx_out(True, mock_pub_key_address(0, None), zero)
      |> tx_out(True, mock_pub_key_address(1, None), zero)
      |> complete()

  let mock_outputs = tx.outputs

  let outs_a = mock_outputs |> outputs_at(mock_pub_key_address(0, None))
  let outs_b = mock_outputs |> outputs_at(mock_pub_key_address(1, None))

  list.length(outs_a) == 2 && list.length(outs_b) == 1
}

test test_group_outputs_at() {
  let tx =
    mocktail_tx()
      |> tx_out(True, mock_pub_key_address(0, None), zero)
      |> tx_out(True, mock_pub_key_address(0, None), zero)
      |> tx_out(True, mock_pub_key_address(1, None), zero)
      |> complete()

  let mock_outputs = tx.outputs

  let (g1, g2) =
    mock_outputs |> group_outputs(o_at(mock_pub_key_address(0, None)))

  list.length(g1) == 2 && list.length(g2) == 1
}

test test_outputs_with_policy() {
  let policy = mock_policy_id(0)
  let token_value = from_asset(policy, "Token", 5)

  let tx =
    mocktail_tx()
      |> tx_out(True, mock_pub_key_address(0, None), token_value)
      |> tx_out(True, mock_pub_key_address(0, None), zero)
      |> complete()

  let mock_outputs = tx.outputs

  let outs = mock_outputs |> outputs_with_policy(policy)

  list.length(outs) == 1
}

test test_outputs_with_singleton() {
  let policy = mock_policy_id(1)
  let name = "NFT"

  let v_single = from_asset(policy, name, 1)
  let v_multi = from_asset(policy, name, 2)

  let tx =
    mocktail_tx()
      |> tx_out(True, mock_pub_key_address(0, None), v_single)
      |> tx_out(True, mock_pub_key_address(0, None), v_multi)
      |> complete()

  let mock_outputs = tx.outputs

  let outs = mock_outputs |> outputs_with(policy, name)

  // only the quantity == 1 output should match
  list.length(outs) == 1
}

test test_group_outputs_2_at() {
  let tx =
    mocktail_tx()
      |> tx_out(True, mock_pub_key_address(0, None), zero)
      |> tx_out(True, mock_pub_key_address(1, None), zero)
      |> tx_out(True, mock_pub_key_address(2, None), zero)
      |> tx_out(True, mock_pub_key_address(0, None), zero)
      |> complete()

  let mock_outputs = tx.outputs

  let (g1, g2, g3) =
    mock_outputs
      |> group_outputs_2(
          o_at(mock_pub_key_address(0, None)),
          o_at(mock_pub_key_address(1, None)),
        )

  list.length(g1) == 2 && list.length(g2) == 1 && list.length(g3) == 1
}
