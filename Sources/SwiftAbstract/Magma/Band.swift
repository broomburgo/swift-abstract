struct Band<A>: Associative, Idempotent {
  let apply: (A, A) -> A

  init(apply: @escaping (A, A) -> A) {
    self.apply = apply
  }

  static var laws: [Law<Self>] { [
    .associativity,
    .idempotency,
  ] }
}

// MARK: - Initializers

extension Band {
  init<MoreSpecific>(from s: MoreSpecific) where
    MoreSpecific: Associative & Idempotent,
    MoreSpecific.A == A
  {
    self.init(apply: s.apply)
  }
}

extension Band where A: Wrapper {
  init(wrapping original: Band<A.Wrapped>) {
    self.init(
      apply: {
        .init(original.apply($0.wrapped, $1.wrapped))
      }
    )
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

extension Band /* where A == (Input) -> Output */ {
  static func function<Input, Output>(over output: Band<Output>) -> Self where A == (Input) -> Output {
    Band(
      apply: { f1, f2 in
        { output.apply(f1($0), f2($0)) }
      }
    )
  }
}
