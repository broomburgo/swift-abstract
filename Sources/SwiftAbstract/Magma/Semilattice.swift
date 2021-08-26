// MARK: - Definition

struct Semilattice<A>: Associative, Commutative, Idempotent {
  let apply: (A, A) -> A

  init(apply: @escaping (A, A) -> A) {
    self.apply = apply
  }

  init<MoreSpecific: Associative & Commutative & Idempotent>(from s: MoreSpecific) where MoreSpecific.A == A {
    self.init(apply: s.apply)
  }

//  func getProperties(equating: @escaping (A, A) -> Bool) -> [LawsOf<Semilattice<A>>.Property] {
//    LawsOf(self, equating: equating).properties {
//      [
//        $0.associativity,
//        $0.commutativity,
//        $0.idempotency
//      ]
//    }
//  }

    static var properties: [Property<Self>] {
        [
            .associativity,
            .commutativity,
            .idempotency,
        ]
    }
}

// MARK: - Instances

extension Semilattice where A: Comparable {
  static var max: Self {
    Semilattice(
      apply: { Swift.max($0, $1) }
    )
  }

  static var min: Self {
    Semilattice(
      apply: { Swift.min($0, $1) }
    )
  }
}

extension Semilattice where A == Bool {
  static var and: Self {
    Semilattice(
      apply: { $0 && $1 }
    )
  }

  static var or: Self {
    Semilattice(
      apply: { $0 || $1 }
    )
  }
}

extension Semilattice /* where A == Set */ {
  /// While this can be useful as the free bounded semilattice, to truly express the algebraic properties of sets, and define a boolean algebra based on them, we actually need `PredicateSet`.
  static func setUnion<Element>() -> Self where A == Set<Element> {
    Semilattice(
      apply: { $0.union($1) }
    )
  }
}

extension Semilattice /* where A == (Input) -> Output */ {
  static func function<Input, Output>(over output: Semilattice<Output>) -> Self where A == (Input) -> Output {
    Semilattice(
      apply: { f1, f2 in
        { output.apply(f1($0), f2($0)) }
      }
    )
  }
}
