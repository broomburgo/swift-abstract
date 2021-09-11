struct CommutativeSemigroup<A>: Associative, Commutative {
  let apply: (A, A) -> A

  init(apply: @escaping (A, A) -> A) {
    self.apply = apply
  }

  static var laws: [Law<Self>] { [
    .associativity,
    .commutativity,
  ] }
}

// MARK: - Initializers

extension CommutativeSemigroup {
  init<MoreSpecific>(from s: MoreSpecific) where
    MoreSpecific: Associative & Commutative,
    MoreSpecific.A == A
  {
    self.init(apply: s.apply)
  }
}

extension CommutativeSemigroup where A: Wrapper {
  init(wrapping original: CommutativeSemigroup<A.Wrapped>) {
    self.init(
      apply: {
        .init(original.apply($0.wrapped, $1.wrapped))
      }
    )
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
