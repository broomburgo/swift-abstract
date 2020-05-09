// MARK: - Definition

struct CommutativeSemigroup<A>: Associative, Commutative {
  let apply: (A, A) -> A

  init(apply: @escaping (A, A) -> A) {
    self.apply = apply
  }

  init<MoreSpecific: Associative & Commutative>(from s: MoreSpecific) where MoreSpecific.A == A {
    self.init(apply: s.apply)
  }
}

// MARK: - Instances

extension CommutativeSemigroup where A: Comparable {
  static var max: Self {
    CommutativeSemigroup(
      apply: { Swift.max($0, $1) }
    )
  }

  static var min: Self {
    CommutativeSemigroup(
      apply: { Swift.min($0, $1) }
    )
  }
}

extension CommutativeSemigroup where A: AdditiveArithmetic {
  static var sum: Self {
    CommutativeSemigroup(
      apply: { $0 + $1 }
    )
  }
}

extension CommutativeSemigroup where A: Numeric {
  static var product: Self {
    CommutativeSemigroup(
      apply: { $0 * $1 }
    )
  }
}

extension CommutativeSemigroup where A == Bool {
  static var and: Self {
    CommutativeSemigroup(
      apply: { $0 && $1 }
    )
  }

  static var or: Self {
    CommutativeSemigroup(
      apply: { $0 || $1 }
    )
  }
}

extension CommutativeSemigroup where A == String {
  static var string: Self {
    CommutativeSemigroup(
      apply: { $0 + $1 }
    )
  }
}

extension CommutativeSemigroup /* where A == Set */ {
  /// While this can be useful as the free bounded semilattice, to truly express the algebraic properties of sets, and define a boolean algebra based on them, we actually need `PredicateSet`.
  static func setUnion<Element>() -> Self where A == Set<Element> {
    CommutativeSemigroup(
      apply: { $0.union($1) }
    )
  }

  /// This cannot be suitable for `WithEmpty` types, because there not such thing as the "universe" set, but it could be done with `PredicateSet`.
  static func setIntersection<Element>() -> Self where A == Set<Element> {
    CommutativeSemigroup(
      apply: { $0.intersection($1) }
    )
  }
}

extension CommutativeSemigroup /* where A == (Input) -> Output */ {
  static func function<Input, Output>(over output: CommutativeSemigroup<Output>) -> Self where A == (Input) -> Output {
    CommutativeSemigroup(
      apply: { f1, f2 in
        { input in
          output.apply(f1(input), f2(input))
        }
      }
    )
  }
}
