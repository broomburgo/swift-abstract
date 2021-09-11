struct CommutativeMonoid<A>: Associative, Commutative, Identity {
  let apply: (A, A) -> A
  let empty: A

  init(apply: @escaping (A, A) -> A, empty: A) {
    self.apply = apply
    self.empty = empty
  }

  static var laws: [Law<Self>] { [
    .associativity,
    .commutativity,
    .identity,
  ] }
}

// MARK: - Initializers

extension CommutativeMonoid {
  init<MoreSpecific>(from s: MoreSpecific) where
    MoreSpecific: Associative & Commutative & Identity,
    MoreSpecific.A == A
  {
    self.init(apply: s.apply, empty: s.empty)
  }
}

extension CommutativeMonoid where A: Wrapper {
  init(wrapping original: CommutativeMonoid<A.Wrapped>) {
    self.init(
      apply: {
        .init(original.apply($0.wrapped, $1.wrapped))
      },
      empty: .init(original.empty)
    )
  }
}

// MARK: - Instances

extension CommutativeMonoid where A: AdditiveArithmetic {
  static var addition: Self {
    CommutativeMonoid(
      apply: { $0 + $1 },
      empty: .zero
    )
  }
}

extension CommutativeMonoid where A: Numeric {
  static var multiplication: Self {
    CommutativeMonoid(
      apply: { $0 * $1 },
      empty: 1
    )
  }
}

extension CommutativeMonoid /* where A == (Input) -> Output */ {
  static func function<Input, Output>(over output: CommutativeMonoid<Output>) -> Self where A == (Input) -> Output {
    CommutativeMonoid(
      apply: { f1, f2 in
        { output.apply(f1($0), f2($0)) }
      },
      empty: { _ in output.empty }
    )
  }
}
