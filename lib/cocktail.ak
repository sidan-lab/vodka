//// Vodka cocktail provides utility functions to build Aiken onchain code
////
//// All onchain utility functions are grouped with a naming convention of `vodka_<type>`:
//// 
//// ### Cardano data types
//// - `Address` - [`use vodka_address`](./vodka_address.html) 
//// - `Value` - [`use vodka_value`](./vodka_value.html)
////
//// ### Transaction types 
//// - `extra_signatories` - [`use vodka_extra_signatories`](./vodka_extra_signatories.html)
//// - `inputs` - [`use vodka_inputs`](./vodka_inputs.html)
//// - `outputs` - [`use vodka_outputs`](./vodka_outputs.html)
//// - `mints` - [`use vodka_mints`](./vodka_mints.html)
//// - `validity_range` - [`use vodka_validity_range`](./vodka_validity_range.html)
//// - `Redeemers` - [`use vodka_redeemers`](./vodka_redeemers.html)

use vodka_address
use vodka_converter
use vodka_extra_signatories
use vodka_inputs
use vodka_mints
use vodka_outputs
use vodka_redeemers
use vodka_validity_range
use vodka_value

// Address

pub const compare_script_address = vodka_address.compare_script_address

pub const compare_address = vodka_address.compare_address

pub const address_pub_key = vodka_address.address_pub_key

pub const address_script_hash = vodka_address.address_script_hash

// Converter

pub const convert_int_to_bytes = vodka_converter.convert_int_to_bytes

pub const get_number_digit = vodka_converter.get_number_digit

// Extra Signatories

pub const key_signed = vodka_extra_signatories.key_signed

pub const one_of_keys_signed = vodka_extra_signatories.one_of_keys_signed

pub const all_key_signed = vodka_extra_signatories.all_key_signed

// Inputs

pub const input_inline_datum = vodka_inputs.input_inline_datum

pub const only_input_datum_with = vodka_inputs.only_input_datum_with

pub const inputs_at = vodka_inputs.inputs_at

pub const inputs_with = vodka_inputs.inputs_with

pub const inputs_with_policy = vodka_inputs.inputs_with_policy

pub const inputs_at_with = vodka_inputs.inputs_at_with

pub const inputs_at_with_policy = vodka_inputs.inputs_at_with_policy

pub const inputs_token_quantity = vodka_inputs.inputs_token_quantity

// Mints

pub const check_policy_only_burn = vodka_mints.check_policy_only_burn

pub const only_minted_token = vodka_mints.only_minted_token

pub const token_minted = vodka_mints.token_minted

// Outputs

pub const output_inline_datum = vodka_outputs.output_inline_datum

pub const outputs_at = vodka_outputs.outputs_at

pub const outputs_with = vodka_outputs.outputs_with

pub const outputs_with_policy = vodka_outputs.outputs_with_policy

pub const outputs_at_with = vodka_outputs.outputs_at_with

pub const outputs_at_with_policy = vodka_outputs.outputs_at_with_policy

// Redeemers

pub const redeemer_from = vodka_redeemers.redeemer_from

pub const withdrawal_redeemer = vodka_redeemers.withdrawal_redeemer

pub const compare_output_reference = vodka_redeemers.compare_output_reference

// Validity Range

pub const valid_after = vodka_validity_range.valid_after

pub const valid_before = vodka_validity_range.valid_before

// Value

pub const value_length = vodka_value.value_length

pub const get_all_value_to = vodka_value.get_all_value_to

pub const get_all_value_from = vodka_value.get_all_value_from

pub const value_geq = vodka_value.value_geq

pub const value_policy_info = vodka_value.value_policy_info

pub const value_tokens = vodka_value.value_tokens
