//// Vodka provides utility functions to build CIP onchain code
//// 
//// ### Example usage
//// ```aiken
//// use cip
//// use cardano/assets.{AssetName}
////
//// let cip68_100_asset_name = cip.cip68_100(asset_name)
//// let cip68_222_asset_name = cip.cip68_222(asset_name)
//// let cip68_333_asset_name = cip.cip68_333(asset_name)
//// let cip68_444_asset_name = cip.cip68_444(asset_name)

use aiken/primitive/bytearray.{concat}
use cardano/assets.{AssetName}

/// The byte prefix for CIP-68 asset - Reference Token
pub const cip68_100_prefix: ByteArray = #"000643b0"

/// The byte prefix for CIP-68 asset - Non-Fungible Token
pub const cip68_222_prefix: ByteArray = #"000de140"

/// The byte prefix for CIP-68 asset - Fungible Token
pub const cip68_333_prefix: ByteArray = #"0014df10"

/// The byte prefix for CIP-68 asset - Rich-Fungible Token
pub const cip68_444_prefix: ByteArray = #"001bc280"

pub fn drop_cip68_prefix(cip_68_asset_name: AssetName) -> AssetName {
  cip_68_asset_name |> bytearray.drop(4)
}

test test_drop_cip68_prefix() {
  let cip68_100_asset_name = #"000643b012345678"
  drop_cip68_prefix(cip68_100_asset_name) == #"12345678"
}

/// Obtain the asset name for CIP-68 asset - Reference Token
/// ```aiken
/// let cip68_100_asset_name = cip68_100(asset_name)
/// ```
pub fn cip68_100(asset_name: AssetName) -> AssetName {
  concat(cip68_100_prefix, asset_name)
}

/// Obtain the asset name for CIP-68 asset - Non-Fungible Token
/// ```aiken
/// let cip68_222_asset_name = cip68_222(asset_name)
/// ```
pub fn cip68_222(asset_name: AssetName) -> AssetName {
  concat(cip68_222_prefix, asset_name)
}

/// Obtain the asset name for CIP-68 asset - Fungible Token
/// ```aiken
/// let cip68_333_asset_name = cip68_333(asset_name)
/// ```
pub fn cip68_333(asset_name: AssetName) -> AssetName {
  concat(cip68_333_prefix, asset_name)
}

/// Obtain the asset name for CIP-68 asset - Rich-Fungible Token
/// ```aiken
/// let cip68_444_asset_name = cip68_444(asset_name)
/// ```
pub fn cip68_444(asset_name: AssetName) -> AssetName {
  concat(cip68_444_prefix, asset_name)
}

/// The metadata attached with CIP-68 reference token (100)
pub type CIP68Metadata {
  metadata: Pairs<Data, Data>,
  version: Int,
}
