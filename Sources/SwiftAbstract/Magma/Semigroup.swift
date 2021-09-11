struct Semigroup<A>: Associative {
  let apply: (A, A) -> A

  init(apply: @escaping (A, A) -> A) {
    self.apply = apply
  }

  static var laws: [Law<Self>] { [
    .associativity,
  ] }
}

// MARK: - Initializers

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

extension Semigroup /* where A == (Input) -> Output */ {
  static func function<Input, Output>(over output: Semigroup<Output>) -> Self where A == (Input) -> Output {
    Semigroup(
      apply: { f1, f2 in
        { output.apply(f1($0), f2($0)) }
      }
    )
  }
}
