struct Semigroup<A>: ConstructibleWithOneBinaryOperation, Associative {
  let apply: (A, A) -> A

  init(apply: @escaping (A, A) -> A) {
    self.apply = apply
  }

  static var laws: [Law<Self>] { [
    .associativity,
  ] }
}

extension Semigroup {
  init<MoreSpecific: Associative>(from s: MoreSpecific) where MoreSpecific.A == A {
    self.init(apply: s.apply)
  }
}

extension Semigroup where A: Wrapper {
  init(wrapping original: Semigroup<A.Wrapped>) {
    self.init(
      apply: {
        .init(original.apply($0.wrapped, $1.wrapped))
      }
    )
  }
}

// MARK: - Instances

extension Semigroup {
  static var first: Self {
    Semigroup(
      apply: { a, _ in a }
    )
  }

  static var last: Self {
    Semigroup(
      apply: { _, b in b }
    )
  }
}

extension Semigroup where A: Comparable {
  static var max: Self {
    Semigroup(
      apply: { Swift.max($0, $1) }
    )
  }

  static var min: Self {
    Semigroup(
      apply: { Swift.min($0, $1) }
    )
  }
}

extension Semigroup where A: AdditiveArithmetic {
  static var addition: Self {
    Semigroup(
      apply: { $0 + $1 }
    )
  }
}

extension Semigroup where A: Numeric {
  static var multiplication: Self {
    Semigroup(
      apply: { $0 * $1 }
    )
  }
}

extension Semigroup where A == Bool {
  static var and: Self {
    Semigroup(
      apply: { $0 && $1 }
    )
  }

  static var or: Self {
    Semigroup(
      apply: { $0 || $1 }
    )
  }
}

extension Semigroup where A == String {
  static var string: Self {
    Semigroup(
      apply: { $0 + $1 }
    )
  }
}

extension Semigroup where A == Ordering {
  static var ordering: Self {
    Semigroup(
      apply: { A.merge($0, $1) }
    )
  }
}

extension Semigroup /* where A == Optional */ {
  static func firstIfPossible<Wrapped>() -> Self where A == Wrapped? {
    Semigroup(
      apply: { $0 ?? $1 }
    )
  }
}

extension Semigroup /* where A == Optional */ {
  static func lastIfPossible<Wrapped>() -> Self where A == Wrapped? {
    Semigroup(
      apply: { $1 ?? $0 }
    )
  }
}

extension Semigroup /* where A == Array */ {
  static func array<Element>() -> Self where A == [Element] {
    Semigroup(
      apply: { $1 + $0 }
    )
  }
}

extension Semigroup /* where A == Set */ {
  /// While this can be useful as the free bounded semilattice, to truly express the algebraic properties of sets, and define a boolean algebra based on them, we actually need `PredicateSet`.
  static func setUnion<Element>() -> Self where A == Set<Element> {
    Semigroup(
      apply: { $0.union($1) }
    )
  }

  /// This cannot be suitable for `WithEmpty` types, because there not such thing as the "universe" set, but it could be done with `PredicateSet`.
  static func setIntersection<Element>() -> Self where A == Set<Element> {
    Semigroup(
      apply: { $0.intersection($1) }
    )
  }
}

extension Semigroup /* where A == (T) -> T */ {
  static func endo<T>() -> Self where A == (T) -> T {
    Semigroup(
      apply: { f1, f2 in
        { f2(f1($0)) }
      }
    )
  }
}

extension Semigroup /* where A == (Input) -> Output */ {
  static func function<Input, Output>(over output: Semigroup<Output>) -> Self where A == (Input) -> Output {
    Semigroup(
      apply: { f1, f2 in
        { output.apply(f1($0), f2($0)) }
      }
    )
  }
}
