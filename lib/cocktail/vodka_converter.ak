use aiken/primitive/bytearray

/// Convert an integer to a "stringify" ByteArray value
/// ```aiken
/// let int_bytes = convert_int_to_bytes(123);
/// let this_is_true = int_bytes == "123";
/// ```
pub fn convert_int_to_bytes(i: Int) -> ByteArray {
  convert_int_to_bytes_go(i, get_number_digit(i))
}

fn convert_int_to_bytes_go(newInt: Int, digit: Int) -> ByteArray {
  if digit == 1 {
    bytearray.push("", newInt + 48)
  } else {
    bytearray.push(
      convert_int_to_bytes_go(newInt % digit, digit / 10),
      newInt / digit + 48,
    )
  }
}

/// Get the number of digits in an integer
pub fn get_number_digit(i: Int) -> Int {
  go_get_number_digit(i, 1)
}

fn go_get_number_digit(newInt: Int, digit: Int) -> Int {
  if newInt < 10 {
    digit
  } else {
    go_get_number_digit(newInt / 10, digit * 10)
  }
}

test byte_conversion() {
  convert_int_to_bytes(1) == "1" && convert_int_to_bytes(123) == "123" && convert_int_to_bytes(
    672912,
  ) == "672912"
}
