public struct Law<Structure: AlgebraicStructure> {
  public var name: String
  public var getCheck: (Structure, @escaping (Structure.Value, Structure.Value) -> Bool) -> Check<Structure.Value>

  public init(
    name: String,
    getCheck: @escaping (Structure, @escaping (Structure.Value, Structure.Value) -> Bool) -> Check<Structure.Value>
  ) {
    self.name = name
    self.getCheck = getCheck
  }
}

public enum Check<Value> {
  case fromOne((Value) -> Bool)
  case fromTwo((Value, Value) -> Bool)
  case fromThree((Value, Value, Value) -> Bool)
}

// MARK: - Absorption

extension Law where Structure: Absorption {
  public static var absorbability: Self {
    .init(name: "has operations linked by absorption law") { structure, equating in
      .fromTwo {
        equating(
          structure.second.apply($0, structure.first.apply($0, $1)),
          $0
        ) && equating(
          structure.first.apply($0, structure.second.apply($0, $1)),
          $0
        )
      }
    }
  }
}

// MARK: - Annihilability

extension Law where Structure: WithAnnihilation {
  public static var annihilability: Self {
    .init(name: "has zero annihilating the second operation") { structure, equating in
      .fromOne {
        equating(
          structure.second.apply($0, structure.zero),
          structure.zero
        ) && equating(
          structure.second.apply(structure.zero, $0),
          structure.zero
        )
      }
    }
  }
}

// MARK: - Associativity

extension Law where Structure: Associative {
  public static var associativity: Self {
    .init(name: "is associative") { structure, equating in
      .fromThree {
        equating(
          structure.apply(structure.apply($0, $1), $2),
          structure.apply($0, structure.apply($1, $2))
        )
      }
    }
  }
}

extension Law where Structure: Bimagma, Structure.First: Associative {
  public static var associativityOfFirst: Self {
    .init(name: "has first operation associative") { structure, equating in
      Law<Structure.First>.associativity.getCheck(structure.first, equating)
    }
  }
}

extension Law where Structure: Bimagma, Structure.Second: Associative {
  public static var associativityOfSecond: Self {
    .init(name: "has second operation associative") { structure, equating in
      Law<Structure.Second>.associativity.getCheck(structure.second, equating)
    }
  }
}

// MARK: - Commutativity

extension Law where Structure: Commutative {
  public static var commutativity: Self {
    .init(name: "is commutative") { structure, equating in
      .fromTwo {
        equating(
          structure.apply($0, $1),
          structure.apply($1, $0)
        )
      }
    }
  }
}

extension Law where Structure: Bimagma, Structure.First: Commutative {
  public static var commutativityOfFirst: Self {
    .init(name: "has first operation commutative") { structure, equating in
      Law<Structure.First>.commutativity.getCheck(structure.first, equating)
    }
  }
}

extension Law where Structure: Bimagma, Structure.Second: Commutative {
  public static var commutativityOfSecond: Self {
    .init(name: "has second operation commutative") { structure, equating in
      Law<Structure.Second>.commutativity.getCheck(structure.second, equating)
    }
  }
}

// MARK: - Distributivity

extension Law where Structure: DistributiveFirstOverSecond {
  public static var distributivityOfFirstOverSecond: Self {
    .init(name: "has first operation distributive over second") { structure, equating in
      .fromThree {
        equating(
          structure.first.apply($0, structure.second.apply($1, $2)),
          structure.second.apply(structure.first.apply($0, $1), structure.first.apply($0, $2))
        )
      }
    }
  }
}

extension Law where Structure: DistributiveSecondOverFirst {
  public static var distributivityOfSecondOverFirst: Self {
    .init(name: "has second operation distributive over first") { structure, equating in
      .fromThree {
        equating(
          structure.second.apply($0, structure.first.apply($1, $2)),
          structure.first.apply(structure.second.apply($0, $1), structure.second.apply($0, $2))
        )
      }
    }
  }
}

// MARK: - Excluded middle

extension Law where Structure: ExcludedMiddle {
  public static var excludedMiddle: Self {
    .init(name: "has operations respecting the law of excluded middle") { structure, equating in
      .fromOne {
        equating(
          structure.first.apply($0, structure.implies($0, structure.zero)),
          structure.one
        )
      }
    }
  }
}

// MARK: - Idempotency

extension Law where Structure: Idempotent {
  public static var idempotency: Self {
    .init(name: "is idempotent") { structure, equating in
      .fromTwo {
        equating(
          structure.apply(structure.apply($0, $1), $1),
          structure.apply($0, $1)
        )
      }
    }
  }
}

extension Law where Structure: Bimagma, Structure.First: Idempotent {
  public static var idempotencyOfFirst: Self {
    .init(name: "has first operation idempotent") { structure, equating in
      Law<Structure.First>.idempotency.getCheck(structure.first, equating)
    }
  }
}

extension Law where Structure: Bimagma, Structure.Second: Idempotent {
  public static var idempotencyOfSecond: Self {
    .init(name: "has second operation idempotent") { structure, equating in
      Law<Structure.Second>.idempotency.getCheck(structure.second, equating)
    }
  }
}

// MARK: - Identity

extension Law where Structure: Identity {
  public static var identity: Self {
    .init(name: "has identity element") { structure, equating in
      .fromOne {
        equating(
          structure.apply($0, structure.empty),
          $0
        ) && equating(
          structure.apply(structure.empty, $0),
          $0
        )
      }
    }
  }
}

// MARK: - Implication

extension Law where Structure: WithImplies {
  public static var implication: Self {
    .init(name: "has implication") { structure, equating in
      .fromThree {
        equating(
          structure.implies($0, $0),
          structure.one
        ) && equating(
          structure.second.apply($0, structure.implies($0, $1)),
          structure.second.apply($0, $1)
        ) && equating(
          structure.second.apply($1, structure.implies($0, $1)),
          $1
        ) && equating(
          structure.implies($0, structure.second.apply($1, $2)),
          structure.second.apply(structure.implies($0, $1), structure.implies($0, $2))
        )
      }
    }
  }
}

// MARK: - Invertibility

extension Law where Structure: Invertible {
  public static var invertibility: Self {
    .init(name: "is invertible") { structure, equating in
      .fromOne {
        equating(
          structure.apply($0, structure.inverse($0)),
          structure.empty
        )
      }
    }
  }
}

// MARK: - Negation

extension Law where Structure: WithNegate {
  public static var negation: Self {
    .init(name: "has negation") { structure, equating in
      Law<Structure.First>.invertibility.getCheck(structure.first, equating)
    }
  }
}

// MARK: - One identity

extension Law where Structure: WithOne {
  public static var oneIdentity: Self {
    .init(name: "has identity of one") { structure, equating in
      .fromOne {
        equating(
          structure.second.apply($0, structure.one),
          $0
        ) && equating(
          structure.second.apply(structure.one, $0),
          $0
        )
      }
    }
  }
}

// MARK: - Reciprocity

extension Law where Structure: WithReciprocal {
  public static var reciprocity: Self {
    .init(name: "has reciprocal") { structure, equating in
      Law<Structure.Second>.invertibility.getCheck(structure.second, equating)
    }
  }
}

// MARK: - Zero identity

extension Law where Structure: WithZero {
  public static var zeroIdentity: Self {
    .init(name: "has identity of zero") { structure, equating in
      .fromOne {
        equating(
          structure.first.apply($0, structure.zero),
          $0
        ) && equating(
          structure.first.apply(structure.zero, $0),
          $0
        )
      }
    }
  }
}
