// MARK: - Definition

struct Monoid<A>: Associative, WithIdentity {
  let apply: (A, A) -> A
  let empty: A

  init(apply: @escaping (A, A) -> A, empty: A) {
    self.apply = apply
    self.empty = empty
  }

  init<MoreSpecific: Associative & WithIdentity>(from s: MoreSpecific) where MoreSpecific.A == A {
    self.init(apply: s.apply, empty: s.empty)
  }

  func properties(equating: @escaping (A, A) -> Bool) -> [LawsOf<Monoid<A>>.Property] {
    LawsOf(self, equating: equating).properties {
      [
        $0.associativity,
        $0.identity
      ]
    }
  }
}

// MARK: - Instances

extension Monoid where A: Comparable & WithMinimum {
  static var max: Self {
    Monoid(
      apply: { Swift.max($0, $1) },
      empty: .minimum
    )
  }
}

extension Monoid where A: Comparable & WithMaximum {
  static var min: Self {
    Monoid(
      apply: { Swift.min($0, $1) },
      empty: .maximum
    )
  }
}

extension Monoid where A: AdditiveArithmetic {
  static var sum: Self {
    Monoid(
      apply: { $0 + $1 },
      empty: .zero
    )
  }
}

extension Monoid where A: Numeric & ExpressibleByIntegerLiteral {
  static var product: Self {
    Monoid(
      apply: { $0 * $1 },
      empty: 1
    )
  }
}

extension Monoid where A == Bool {
  static var and: Self {
    Monoid(
      apply: { $0 && $1 },
      empty: true
    )
  }

  static var or: Self {
    Monoid(
      apply: { $0 || $1 },
      empty: false
    )
  }
}

extension Monoid where A == String {
  static var string: Self {
    Monoid(
      apply: { $0 + $1 },
      empty: ""
    )
  }
}

extension Monoid where A == Ordering {
  static var ordering: Self {
    Monoid(
      apply: { A.merge($0, $1) },
      empty: .equalTo
    )
  }
}

extension Monoid /* where A == Optional */ {
  static func firstIfPossible<Wrapped>() -> Self where A == Optional<Wrapped> {
    Monoid(
      apply: { $0 ?? $1 },
      empty: nil
    )
  }
}

extension Monoid /* where A == Optional */ {
  static func lastIfPossible<Wrapped>() -> Self where A == Optional<Wrapped> {
    Monoid(
      apply: { $1 ?? $0 },
      empty: nil
    )
  }
}

extension Monoid /* where A == Array */ {
  static func array<Element>() -> Self where A == Array<Element> {
    Monoid(
      apply: { $1 + $0 },
      empty: []
    )
  }
}

extension Monoid /* where A == Set */ {
  /// While this can be useful as the free bounded semilattice, to truly express the algebraic properties of sets, and define a boolean algebra based on them, we actually need `PredicateSet`.
  static func setUnion<Element>() -> Self where A == Set<Element> {
    Monoid(
      apply: { $0.union($1) },
      empty: []
    )
  }
}

extension Monoid /* where A == (T) -> T */ {
  static func endo<T>() -> Self where A == (T) -> T {
    Monoid(
      apply: { f1, f2 in
        { f2(f1($0)) }
      },
      empty: { $0 }
    )
  }
}

extension Monoid /* where A == (Input) -> Output */ {
  static func function<Input, Output>(over output: Monoid<Output>) -> Self where A == (Input) -> Output {
    Monoid(
      apply: { f1, f2 in
        { output.apply(f1($0), f2($0)) }
      },
      empty: { _ in output.empty }
    )
  }
}
