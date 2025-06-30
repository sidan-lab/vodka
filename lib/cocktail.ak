//// Vodka cocktail provides utility functions to build Aiken onchain code
////
//// All onchain utility functions are grouped with a naming convention of `vodka_<type>`, 
//// and all can be imported directly with `use cocktail`
//// 
//// ### Cardano data types
//// - `Address` - [`use vodka_address`](./cocktail/vodka_address.html) 
//// - `Value` - [`use vodka_value`](./cocktail/vodka_value.html)
////
//// ### Transaction types 
//// - `extra_signatories` - [Documentation](./cocktail/vodka_extra_signatories.html)
//// - `inputs` - [Documentation](./cocktail/vodka_inputs.html)
//// - `outputs` - [Documentation](./cocktail/vodka_outputs.html)
//// - `mints` - [Documentation](./cocktail/vodka_mints.html)
//// - `validity_range` - [Documentation](./cocktail/vodka_validity_range.html)
//// - `Redeemers` - [Documentation](./cocktail/vodka_redeemers.html)

use cocktail/vodka_address
use cocktail/vodka_certificate
use cocktail/vodka_converter
use cocktail/vodka_extra_signatories
use cocktail/vodka_inputs
use cocktail/vodka_mints
use cocktail/vodka_outputs
use cocktail/vodka_redeemers
use cocktail/vodka_validity_range
use cocktail/vodka_value

// Address

/// Documentation please refer to [`vodka_address`](./cocktail/vodka_address.html)
pub const compare_script_address = vodka_address.compare_script_address

/// Documentation please refer to [`vodka_address`](./cocktail/vodka_address.html)
pub const compare_address = vodka_address.compare_address

/// Documentation please refer to [`vodka_address`](./cocktail/vodka_address.html)
pub const address_payment_key = vodka_address.address_payment_key

/// Documentation please refer to [`vodka_address`](./cocktail/vodka_address.html)
pub const address_pub_key = vodka_address.address_pub_key

/// Documentation please refer to [`vodka_address`](./cocktail/vodka_address.html)
pub const address_script_hash = vodka_address.address_script_hash

// Converter

/// Documentation please refer to [`vodka_converter`](./cocktail/vodka_converter.html)
pub const convert_int_to_bytes = vodka_converter.convert_int_to_bytes

/// Documentation please refer to [`vodka_converter`](./cocktail/vodka_converter.html)
pub const get_number_digit = vodka_converter.get_number_digit

// Extra Signatories

/// Documentation please refer to [`vodka_extra_signatories`](./cocktail/vodka_extra_signatories.html)
pub const key_signed = vodka_extra_signatories.key_signed

/// Documentation please refer to [`vodka_extra_signatories`](./cocktail/vodka_extra_signatories.html)
pub const one_of_keys_signed = vodka_extra_signatories.one_of_keys_signed

/// Documentation please refer to [`vodka_extra_signatories`](./cocktail/vodka_extra_signatories.html)
pub const all_key_signed = vodka_extra_signatories.all_key_signed

// Inputs

/// Documentation please refer to [`vodka_inputs`](./cocktail/vodka_inputs.html)
pub const input_inline_datum = vodka_inputs.input_inline_datum

/// Documentation please refer to [`vodka_inputs`](./cocktail/vodka_inputs.html)
pub const only_input_datum_with = vodka_inputs.only_input_datum_with

/// Documentation please refer to [`vodka_inputs`](./cocktail/vodka_inputs.html)
pub const inputs_at = vodka_inputs.inputs_at

/// Documentation please refer to [`vodka_inputs`](./cocktail/vodka_inputs.html)
pub const inputs_with = vodka_inputs.inputs_with

/// Documentation please refer to [`vodka_inputs`](./cocktail/vodka_inputs.html)
pub const inputs_with_policy = vodka_inputs.inputs_with_policy

/// Documentation please refer to [`vodka_inputs`](./cocktail/vodka_inputs.html)
pub const inputs_at_with = vodka_inputs.inputs_at_with

/// Documentation please refer to [`vodka_inputs`](./cocktail/vodka_inputs.html)
pub const inputs_at_with_policy = vodka_inputs.inputs_at_with_policy

/// Documentation please refer to [`vodka_inputs`](./cocktail/vodka_inputs.html)
pub const inputs_token_quantity = vodka_inputs.inputs_token_quantity

// Mints

/// Documentation please refer to [`vodka_mints`](./cocktail/vodka_mints.html)
pub const check_policy_only_burn = vodka_mints.check_policy_only_burn

/// Documentation please refer to [`vodka_mints`](./cocktail/vodka_mints.html)
pub const only_minted_token = vodka_mints.only_minted_token

/// Documentation please refer to [`vodka_mints`](./cocktail/vodka_mints.html)
pub const policy_only_minted_token = vodka_mints.policy_only_minted_token

/// Documentation please refer to [`vodka_mints`](./cocktail/vodka_mints.html)
pub const token_minted = vodka_mints.token_minted

// Outputs

/// Documentation please refer to [`vodka_outputs`](./cocktail/vodka_outputs.html)
pub const output_inline_datum = vodka_outputs.output_inline_datum

/// Documentation please refer to [`vodka_outputs`](./cocktail/vodka_outputs.html)
pub const outputs_at = vodka_outputs.outputs_at

/// Documentation please refer to [`vodka_outputs`](./cocktail/vodka_outputs.html)
pub const outputs_with = vodka_outputs.outputs_with

/// Documentation please refer to [`vodka_outputs`](./cocktail/vodka_outputs.html)
pub const outputs_with_policy = vodka_outputs.outputs_with_policy

/// Documentation please refer to [`vodka_outputs`](./cocktail/vodka_outputs.html)
pub const outputs_at_with = vodka_outputs.outputs_at_with

/// Documentation please refer to [`vodka_outputs`](./cocktail/vodka_outputs.html)
pub const outputs_at_with_policy = vodka_outputs.outputs_at_with_policy

// Redeemers

/// Documentation please refer to [`vodka_redeemers`](./cocktail/vodka_redeemers.html)
pub const redeemer_from = vodka_redeemers.redeemer_from

/// Documentation please refer to [`vodka_redeemers`](./cocktail/vodka_redeemers.html)
pub const withdrawal_redeemer = vodka_redeemers.withdrawal_redeemer

/// Documentation please refer to [`vodka_redeemers`](./cocktail/vodka_redeemers.html)
pub const compare_output_reference = vodka_redeemers.compare_output_reference

// Validity Range

/// Documentation please refer to [`vodka_validity_range`](./cocktail/vodka_validity_range.html)
pub const valid_after = vodka_validity_range.valid_after

/// Documentation please refer to [`vodka_validity_range`](./cocktail/vodka_validity_range.html)
pub const valid_before = vodka_validity_range.valid_before

// Value

/// Documentation please refer to [`vodka_value`](./cocktail/vodka_value.html)
pub const value_length = vodka_value.value_length

/// Documentation please refer to [`vodka_value`](./cocktail/vodka_value.html)
pub const get_all_value_to = vodka_value.get_all_value_to

/// Documentation please refer to [`vodka_value`](./cocktail/vodka_value.html)
pub const get_all_value_from = vodka_value.get_all_value_from

/// Documentation please refer to [`vodka_value`](./cocktail/vodka_value.html)
pub const value_geq = vodka_value.value_geq

/// Documentation please refer to [`vodka_value`](./cocktail/vodka_value.html)
pub const value_policy_info = vodka_value.value_policy_info

/// Documentation please refer to [`vodka_value`](./cocktail/vodka_value.html)
pub const value_tokens = vodka_value.value_tokens

// Certificate

/// Documentation please refer to [`vodka_certificate`](./cocktail/vodka_certificate.html)
pub const register_stake_certificate =
  vodka_certificate.register_stake_certificate

/// Documentation please refer to [`vodka_certificate`](./cocktail/vodka_certificate.html)
pub const unregister_stake_certificate =
  vodka_certificate.unregister_stake_certificate

/// Documentation please refer to [`vodka_certificate`](./cocktail/vodka_certificate.html)
pub const register_drep_certificate =
  vodka_certificate.register_drep_certificate

/// Documentation please refer to [`vodka_certificate`](./cocktail/vodka_certificate.html)
pub const unregister_drep_certificate =
  vodka_certificate.unregister_drep_certificate

/// Documentation please refer to [`vodka_certificate`](./cocktail/vodka_certificate.html)
pub const delegate_stake_certificate =
  vodka_certificate.delegate_stake_certificate

/// Documentation please refer to [`vodka_certificate`](./cocktail/vodka_certificate.html)
pub const delegate_vote_certificate =
  vodka_certificate.delegate_vote_certificate

/// Documentation please refer to [`vodka_certificate`](./cocktail/vodka_certificate.html)
pub const delegate_stake_and_vote_certificate =
  vodka_certificate.delegate_stake_and_vote_certificate
