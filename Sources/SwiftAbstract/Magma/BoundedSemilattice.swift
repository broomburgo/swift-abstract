struct BoundedSemilattice<A>: Associative, Commutative, Idempotent, Identity {
  let apply: (A, A) -> A
  let empty: A

  init(apply: @escaping (A, A) -> A, empty: A) {
    self.apply = apply
    self.empty = empty
  }

  static var laws: [Law<Self>] { [
    .associativity,
    .commutativity,
    .idempotency,
    .identity,
  ] }
}

// MARK: - Initializers

extension BoundedSemilattice {
  init<MoreSpecific>(from s: MoreSpecific) where
    MoreSpecific: Associative & Commutative & Idempotent & Identity,
    MoreSpecific.A == A
  {
    self.init(apply: s.apply, empty: s.empty)
  }
}

extension BoundedSemilattice where A: Wrapper {
  init(wrapping original: BoundedSemilattice<A.Wrapped>) {
    self.init(
      apply: {
        .init(original.apply($0.wrapped, $1.wrapped))
      },
      empty: .init(original.empty)
    )
  }
}

// MARK: - Instances

extension BoundedSemilattice where A: Comparable & WithMinimum {
  static var max: Self {
    BoundedSemilattice(
      apply: { Swift.max($0, $1) },
      empty: .minimum
    )
  }
}

extension BoundedSemilattice where A: Comparable & WithMaximum {
  static var min: Self {
    BoundedSemilattice(
      apply: { Swift.min($0, $1) },
      empty: .maximum
    )
  }
}

extension BoundedSemilattice where A == Bool {
  static var and: Self {
    BoundedSemilattice(
      apply: { $0 && $1 },
      empty: true
    )
  }

  static var or: Self {
    BoundedSemilattice(
      apply: { $0 || $1 },
      empty: false
    )
  }
}

extension BoundedSemilattice /* where A == Set */ {
  /// While this can be useful as the free bounded semilattice, to truly express the algebraic properties of sets, and define a boolean algebra based on them, we actually need `PredicateSet`.
  static func setUnion<Element>() -> Self where A == Set<Element> {
    BoundedSemilattice(
      apply: { $0.union($1) },
      empty: []
    )
  }
}

extension BoundedSemilattice /* where A == (Input) -> Output */ {
  static func function<Input, Output>(over output: BoundedSemilattice<Output>) -> Self where A == (Input) -> Output {
    BoundedSemilattice(
      apply: { f1, f2 in
        { output.apply(f1($0), f2($0)) }
      },
      empty: { _ in output.empty }
    )
  }
}
