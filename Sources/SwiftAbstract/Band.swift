struct Band<A>: Associative, Idempotent {
  let apply: (A, A) -> A

  init(apply: @escaping (A, A) -> A) {
    self.apply = apply
  }

  init<MoreSpecific: Associative & Idempotent>(from s: MoreSpecific) where MoreSpecific.A == A {
    self.init(apply: s.apply)
  }
}

// MARK: - Instances

extension Band {
  static var first: Self {
    Band(
      apply: { a, _ in a }
    )
  }

  static var last: Self {
    Band(
      apply: { _, b in b }
    )
  }
}

extension Band where A: Comparable {
  static var max: Self {
    Band(
      apply: { Swift.max($0, $1) }
    )
  }

  static var min: Self {
    Band(
      apply: { Swift.min($0, $1) }
    )
  }
}

extension Band where A == Bool {
  static var and: Self {
    Band(
      apply: { $0 && $1 }
    )
  }

  static var or: Self {
    Band(
      apply: { $0 || $1 }
    )
  }
}

extension Band where A == Ordering {
  static var ordering: Self {
    Band(
      apply: { A.merge($0, $1) }
    )
  }
}

extension Band /* where A == Optional */ {
  static func firstIfPossible<Wrapped>() -> Self where A == Optional<Wrapped> {
    Band(
      apply: { $0 ?? $1 }
    )
  }
}

extension Band /* where A == Optional */ {
  static func lastIfPossible<Wrapped>() -> Self where A == Optional<Wrapped> {
    Band(
      apply: { $1 ?? $0 }
    )
  }
}

extension Band /* where A == Set */ {
  /// While this can be useful as the free bounded semilattice, to truly express the algebraic properties of sets, and define a boolean algebra based on them, we actually need `PredicateSet`.
  static func setUnion<Element>() -> Self where A == Set<Element> {
    Band(
      apply: { $0.union($1) }
    )
  }

  /// This cannot be suitable for `WithEmpty` types, because there not such thing as the "universe" set, but it could be done with `PredicateSet`.
  static func setIntersection<Element>() -> Self where A == Set<Element> {
    Band(
      apply: { $0.intersection($1) }
    )
  }
}

extension Band /* where A == (Input) -> Output */ {
  static func function<Input, Output>(over output: Band<Output>) -> Self where A == (Input) -> Output {
    Band(
      apply: { f1, f2 in
        { output.apply(f1($0), f2($0)) }
      }
    )
  }
}
