use aiken/list

// Check if a key is signed by any of the extra_signatories
pub fn key_signed(extra_signatories: List<ByteArray>, key: ByteArray) {
  list.has(extra_signatories, key)
}

/// Check if any of the keys are signed by the extra_signatories
pub fn one_of_keys_signed(
  extra_signatories: List<ByteArray>,
  keys: List<ByteArray>,
) {
  list.any(keys, fn(key) { key_signed(extra_signatories, key) })
}

/// Check if all of the keys are signed by the extra_signatories
pub fn all_key_signed(extra_signatories: List<ByteArray>, keys: List<ByteArray>) {
  list.all(keys, fn(key) { key_signed(extra_signatories, key) })
}
