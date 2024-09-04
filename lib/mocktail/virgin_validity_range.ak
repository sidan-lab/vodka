use aiken/interval.{
  Finite, Interval, IntervalBound, NegativeInfinity, PositiveInfinity,
}
use cardano/transaction.{ValidityRange}

/// Mock a validity range with the given lower and upper bounds.
pub fn mock_interval(lower: Option<Int>, upper: Option<Int>) -> ValidityRange {
  let lower_bound =
    when lower is {
      Some(lower_bound_number) ->
        IntervalBound {
          bound_type: Finite(lower_bound_number),
          is_inclusive: True,
        }
      None -> IntervalBound { bound_type: NegativeInfinity, is_inclusive: True }
    }
  let upper_bound =
    when upper is {
      Some(upper_bound_number) ->
        IntervalBound {
          bound_type: Finite(upper_bound_number),
          is_inclusive: True,
        }
      None -> IntervalBound { bound_type: PositiveInfinity, is_inclusive: True }
    }

  Interval { lower_bound, upper_bound }
}
