use aiken/interval.{Finite, IntervalBound}
use aiken/transaction.{ValidityRange}

pub fn valid_after(
  validity_range: ValidityRange,
  required_timestamp: Int,
) -> Bool {
  let IntervalBound { bound_type, is_inclusive } = validity_range.lower_bound
  when (bound_type, is_inclusive) is {
    (Finite(lower_bound), True) -> lower_bound > required_timestamp
    (Finite(lower_bound), False) -> lower_bound >= required_timestamp
    _ -> False
  }
}

pub fn valid_before(
  validity_range: ValidityRange,
  required_timestamp: Int,
) -> Bool {
  let IntervalBound { bound_type, is_inclusive } = validity_range.upper_bound
  when (bound_type, is_inclusive) is {
    (Finite(upper_bound), True) -> upper_bound < required_timestamp
    (Finite(upper_bound), False) -> upper_bound <= required_timestamp
    _ -> False
  }
}
