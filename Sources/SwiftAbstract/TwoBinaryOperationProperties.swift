// MARK: - Absorption

public protocol Absorption: WithTwoBinaryOperations {}

extension LawsOf where Structure: Absorption {
  public var absorbability: Property {
    Property(
      name: "has operations linked by absorption law",
      verification: .fromTwo {
        self.equating(
          self.second.apply($0, self.first.apply($0, $1)),
          $0
        ) && self.equating(
          self.first.apply($0, self.second.apply($0, $1)),
          $0
        )
      }
    )
  }
}

// MARK: - Annihilation

public protocol WithAnnihilation: WithZero {}

extension LawsOf where Structure: WithAnnihilation {
  var annihilability: Property {
    Property(
      name: "has zero annihilating the second operation",
      verification: .fromOne {
        self.equating(
          self.second.apply($0, self.zero),
          self.zero
          ) && self.equating(
          self.second.apply(self.zero, $0),
          self.zero
        )
      }
    )
  }
}

// MARK: - Associativity

public protocol AssociativeFirst: WithTwoBinaryOperations where FirstBinaryOperation: Associative {}
public protocol AssociativeSecond: WithTwoBinaryOperations where SecondBinaryOperation: Associative {}
public typealias AssociativeBoth = AssociativeFirst & AssociativeSecond

extension LawsOf where Structure: AssociativeFirst {
  public var associativityOfFirst: Property {
    Property(
      name: "has first operation associative",
      verification: .fromThree {
        self.equating(
          self.first.apply(self.first.apply($0, $1), $2),
          self.first.apply($0, self.first.apply($1, $2))
        )
      }
    )
  }
}

extension LawsOf where Structure: AssociativeSecond {
  public var associativityOfSecond: Property {
    Property(
      name: "has second operation associative",
      verification: .fromThree {
        self.equating(
          self.second.apply(self.second.apply($0, $1), $2),
          self.second.apply($0, self.second.apply($1, $2))
        )
      }
    )
  }
}

// MARK: - Commutativity

public protocol CommutativeFirst: WithTwoBinaryOperations where FirstBinaryOperation: Commutative {}
public protocol CommutativeSecond: WithTwoBinaryOperations where SecondBinaryOperation: Commutative {}
public typealias CommutativeBoth = CommutativeFirst & CommutativeSecond

extension LawsOf where Structure: CommutativeFirst {
  public var commutativityOfFirst: Property {
    Property(
      name: "has first operation commutative",
      verification: .fromTwo {
        self.equating(
          self.first.apply($0, $1),
          self.first.apply($1, $0)
        )
      }
    )
  }
}

extension LawsOf where Structure: CommutativeSecond {
  public var commutativityOfSecond: Property {
    Property(
      name: "has second operation commutative",
      verification: .fromTwo {
        self.equating(
          self.second.apply($0, $1),
          self.second.apply($1, $0)
        )
      }
    )
  }
}

// MARK: - Distributivity

public protocol DistributiveFirstOverSecond: WithTwoBinaryOperations {}
public protocol DistributiveSecondOverFirst: WithTwoBinaryOperations {}
public typealias Distributive = DistributiveFirstOverSecond & DistributiveSecondOverFirst

extension LawsOf where Structure: DistributiveFirstOverSecond {
  public var distributivityOfFirstOverSecond: Property {
    Property(
      name: "has first operation distributive over second",
      verification: .fromThree {
        self.equating(
          self.first.apply($0, self.second.apply($1, $2)),
          self.second.apply(self.first.apply($0, $1), self.first.apply($0, $2))
        )
      }
    )
  }
}

extension LawsOf where Structure: DistributiveSecondOverFirst {
  public var distributivityOfSecondOverFirst: Property {
    Property(
      name: "has second operation distributive over first",
      verification: .fromThree {
        self.equating(
          self.second.apply($0, self.first.apply($1, $2)),
          self.first.apply(self.second.apply($0, $1), self.second.apply($0, $2))
        )
      }
    )
  }
}

// MARK: - Excluded middle

public protocol ExcludedMiddle: WithImplies, WithZero {}

extension LawsOf where Structure: ExcludedMiddle {
  public var excludedMiddle: Property {
    Property(
      name: "has operations respecting the law of excluded middle",
      verification: .fromOne {
        self.equating(
          self.first.apply($0, self.implies($0, self.zero)),
          self.one
        )
      }
    )
  }
}

// MARK: - Implication

public protocol WithImplies: LatticeLike, WithOne {
  var implies: (A, A) -> A { get }
}

extension LawsOf where Structure: WithImplies {
  public var implication: Property {
    Property(
      name: "has implication",
      verification: .fromThree {
        self.equating(
          self.implies($0, $0),
          self.one
        ) && self.equating(
          self.second.apply($0, self.implies($0, $1)),
          self.second.apply($0, $1)
        ) && self.equating(
          self.second.apply($1, self.implies($0, $1)),
          $1
        ) && self.equating(
          self.implies($0, self.second.apply($1, $2)),
          self.second.apply(self.implies($0, $1), self.implies($0, $2))
        )
      }
    )
  }
}

// MARK: - Idempotency

public protocol IdempotentFirst: WithTwoBinaryOperations where FirstBinaryOperation: Idempotent {}
public protocol IdempotentSecond: WithTwoBinaryOperations where SecondBinaryOperation: Idempotent {}
public typealias IdempotentBoth = IdempotentFirst & IdempotentSecond

extension LawsOf where Structure: IdempotentFirst {
  public var idempotencyOfFirst: Property {
    Property(
      name: "has first operation idempotent",
      verification: .fromTwo {
        self.equating(
          self.first.apply(self.first.apply($0, $1), $1),
          self.first.apply($0, $1)
        )
      }
    )
  }
}

extension LawsOf where Structure: IdempotentSecond {
  public var idempotencyOfSecond: Property {
    Property(
      name: "has second operation idempotent",
      verification: .fromTwo {
        self.equating(
          self.second.apply(self.second.apply($0, $1), $1),
          self.second.apply($0, $1)
        )
      }
    )
  }
}

// MARK: - Negation

public protocol WithNegate: WithZero where FirstBinaryOperation: WithInverse {}

extension WithNegate {
  public var negate: (A) -> A {
    first.inverse
  }
}

extension LawsOf where Structure: WithNegate {
  public var negation: Property {
    Property(
      name: "has negation",
      verification: .fromOne {
        self.equating(
          self.first.apply($0, self.negate($0)),
          self.zero
        ) && self.equating(
          self.first.apply(self.negate($0), $0),
          self.zero
        )
      }
    )
  }
}

// MARK: - One identity

public protocol WithOne: WithTwoBinaryOperations where SecondBinaryOperation: WithIdentity {}

extension WithOne {
  public var one: A {
    second.empty
  }
}

extension LawsOf where Structure: WithOne {
  public var oneIdentity: Property {
    Property(
      name: "has identity of one",
      verification: .fromOne {
        self.equating(
          self.second.apply($0, self.one),
          $0
        ) && self.equating(
          self.second.apply(self.one, $0),
          $0
        )
      }
    )
  }
}

// MARK: - Reciprocity

public protocol WithReciprocal: WithOne where SecondBinaryOperation: WithInverse {}

extension WithReciprocal {
  public var reciprocal: (A) -> A {
    second.inverse
  }
}

extension LawsOf where Structure: WithReciprocal {
  public var reciprocity: Property {
    Property(
      name: "has reciprocal",
      verification: .fromOne {
        self.equating(
          self.second.apply($0, self.reciprocal($0)),
          self.one
        ) && self.equating(
          self.second.apply(self.reciprocal($0), $0),
          self.one
        )
      }
    )
  }
}

// MARK: - Zero identity

public protocol WithZero: WithTwoBinaryOperations where FirstBinaryOperation: WithIdentity {}

extension WithZero {
  public var zero: A {
    first.empty
  }
}

extension LawsOf where Structure: WithZero {
  public var zeroIdentity: Property {
    Property(
      name: "has identity of zero",
      verification: .fromOne {
        self.equating(
          self.first.apply($0, self.zero),
          $0
        ) && self.equating(
          self.first.apply(self.zero, $0),
          $0
        )
      }
    )
  }
}
