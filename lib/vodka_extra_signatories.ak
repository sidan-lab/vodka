use aiken/list

pub fn key_signed(witnesses: List<ByteArray>, key: ByteArray) {
  list.has(witnesses, key)
}

pub fn one_of_keys_signed(witnesses: List<ByteArray>, keys: List<ByteArray>) {
  list.any(keys, fn(key) { key_signed(witnesses, key) })
}

pub fn all_key_signed(witnesses: List<ByteArray>, keys: List<ByteArray>) {
  list.all(keys, fn(key) { key_signed(witnesses, key) })
}
