struct Monoid<A>: Associative, Identity {
  let apply: (A, A) -> A
  let empty: A

  init(apply: @escaping (A, A) -> A, empty: A) {
    self.apply = apply
    self.empty = empty
  }

  static var laws: [Law<Self>] { [
    .associativity,
    .identity,
  ] }
}

// MARK: - Initializers

extension Monoid {
  init<MoreSpecific: Associative & Identity>(from s: MoreSpecific) where MoreSpecific.A == A {
    self.init(apply: s.apply, empty: s.empty)
  }
}

extension Monoid where A: Wrapper {
  init(wrapping original: Monoid<A.Wrapped>) {
    self.init(
      apply: {
        .init(original.apply($0.wrapped, $1.wrapped))
      },
      empty: .init(original.empty)
    )
  }
}

// MARK: - Instances

extension Monoid where A == String {
  static var string: Self {
    Monoid(
      apply: { $0 + $1 },
      empty: ""
    )
  }
}

extension Monoid /* where A == Array */ {
  static func array<Element>() -> Self where A == [Element] {
    Monoid(
      apply: { $1 + $0 },
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
