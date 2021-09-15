struct IdempotentMonoid<A>: Associative, Idempotent, Identity {
  let apply: (A, A) -> A
  let empty: A

  init(apply: @escaping (A, A) -> A, empty: A) {
    self.apply = apply
    self.empty = empty
  }

  static var laws: [Law<Self>] { [
    .associativity,
    .idempotency,
    .idempotency,
  ] }
}

// MARK: - Initializers

extension IdempotentMonoid {
  init<MoreSpecific>(from s: MoreSpecific) where
    MoreSpecific: Associative & Idempotent & Identity,
    MoreSpecific.A == A
  {
    self.init(apply: s.apply, empty: s.empty)
  }
}

extension IdempotentMonoid where A: Wrapper {
  init(wrapping original: IdempotentMonoid<A.Wrapped>) {
    self.init(
      apply: {
        .init(original.apply($0.wrapped, $1.wrapped))
      },
      empty: .init(original.empty)
    )
  }
}

// MARK: - Instances

extension IdempotentMonoid where A == Ordering {
  static var ordering: Self {
    IdempotentMonoid(
      apply: { A.merge($0, $1) },
      empty: .equalTo
    )
  }
}

extension IdempotentMonoid /*where<Wrapped> A == Optional<Wrapped>*/ {
  static func firstIfPossible<Wrapped>() -> Self where A == Wrapped? {
    IdempotentMonoid(
      apply: { $0 ?? $1 },
      empty: nil
    )
  }

  static func lastIfPossible<Wrapped>() -> Self where A == Wrapped? {
    IdempotentMonoid(
      apply: { $1 ?? $0 },
      empty: nil
    )
  }
}

extension IdempotentMonoid /* where A == (Input) -> Output */ {
  static func function<Input, Output>(over output: IdempotentMonoid<Output>) -> Self where A == (Input) -> Output {
    IdempotentMonoid(
      apply: { f1, f2 in
        { output.apply(f1($0), f2($0)) }
      },
      empty: { _ in output.empty }
    )
  }
}
