use aiken/collection/list

/// Check if a key is signed by any of the extra_signatories
/// ```aiken
/// let extra_signatories = ["key1", "key2", "key3"];
/// 
/// let key_to_test_1 = "key2";
/// let this_is_true = key_signed(extra_signatories, key_to_test_1);
///
/// let key_to_test_2 = "key4";
/// let this_is_false = key_signed(extra_signatories, key_to_test_2);
/// ```
pub fn key_signed(extra_signatories: List<ByteArray>, key: ByteArray) {
  list.has(extra_signatories, key)
}

/// Check if any of the keys are signed by the extra_signatories
/// ```aiken
/// let extra_signatories = ["key1", "key2", "key3"];
/// 
/// let keys_to_test_1 = ["key4", "key2", "key5"];
/// let this_is_true = one_of_keys_signed(extra_signatories, keys_to_test_1);
/// 
/// let keys_to_test_2 = ["key4", "key5"];
/// let this_is_false = one_of_keys_signed(extra_signatories, keys_to_test_2);
/// ```
pub fn one_of_keys_signed(
  extra_signatories: List<ByteArray>,
  keys: List<ByteArray>,
) {
  list.any(keys, fn(key) { key_signed(extra_signatories, key) })
}

/// Check if all of the keys are signed by the extra_signatories
/// ```aiken
/// let extra_signatories = ["key1", "key2", "key3"];
///
/// let keys_to_test_1 = ["key2", "key3"];
/// let this_is_true = all_keys_signed(extra_signatories, keys_to_test_1);
///
/// let keys_to_test_2 = ["key2", "key4"];
/// let this_is_false = all_keys_signed(extra_signatories, keys_to_test_2);
/// ```
pub fn all_key_signed(extra_signatories: List<ByteArray>, keys: List<ByteArray>) {
  list.all(keys, fn(key) { key_signed(extra_signatories, key) })
}
