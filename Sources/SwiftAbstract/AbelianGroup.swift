// MARK: - Definition

struct AbelianGroup<A>: Associative, Commutative, WithIdentity, WithInverse {
  let apply: (A, A) -> A
  let empty: A
  let inverse: (A) -> A

  init(apply: @escaping (A, A) -> A, empty: A, inverse: @escaping (A) -> A) {
    self.apply = apply
    self.empty = empty
    self.inverse = inverse
  }

  init<MoreSpecific: Associative & Commutative & WithIdentity & WithInverse>(from s: MoreSpecific) where MoreSpecific.A == A {
    self.init(apply: s.apply, empty: s.empty, inverse: s.inverse)
  }

  func properties(equating: @escaping (A, A) -> Bool) -> [LawsOf<AbelianGroup<A>>.Property] {
    LawsOf(self, equating: equating).properties {
      [
        $0.associativity,
        $0.commutativity,
        $0.identity,
        $0.inverse
      ]
    }
  }
}

// MARK: - Instances

extension AbelianGroup where A: SignedNumeric {
  static var sum: Self {
    AbelianGroup(
      apply: { $0 + $1 },
      empty: .zero,
      inverse: { -$0 }
    )
  }
}

extension AbelianGroup /* where A == (Input) -> Output */ {
  static func function<Input, Output>(over output: AbelianGroup<Output>) -> Self where A == (Input) -> Output {
    AbelianGroup(
      apply: { f1, f2 in
        { output.apply(f1($0), f2($0)) }
      },
      empty: { _ in output.empty },
      inverse: { f in
        { output.inverse(f($0)) }
      }
    )
  }
}
