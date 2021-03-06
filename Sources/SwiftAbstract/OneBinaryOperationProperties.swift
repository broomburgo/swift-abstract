// MARK: - Associativity

public protocol Associative: WithOneBinaryOperation {}

extension LawsOf where Structure: Associative {
  public var associativity: Property {
    Property(
      name: "is associative",
      verification: .fromThree {
        self.equating(
          self.apply(self.apply($0, $1), $2),
          self.apply($0, self.apply($1, $2))
        )
      }
    )
  }
}

// MARK: - Commutativity

public protocol Commutative: WithOneBinaryOperation {}

extension LawsOf where Structure: Commutative {
  public var commutativity: Property {
    Property(
      name: "is commutative",
      verification: .fromTwo {
        self.equating(
          self.apply($0, $1),
          self.apply($1, $0)
        )
      }
    )
  }
}

// MARK: - Idempotency

public protocol Idempotent: WithOneBinaryOperation {}

extension LawsOf where Structure: Idempotent {
  public var idempotency: Property {
    Property(
      name: "is idempotent",
      verification: .fromTwo {
        self.equating(
          self.apply(self.apply($0, $1), $1),
          self.apply($0, $1)
        )
      }
    )
  }
}

// MARK: - Identity

public protocol WithIdentity: WithOneBinaryOperation {
  var empty: A { get }
}

extension LawsOf where Structure: WithIdentity {
  public var identity: Property {
    Property(
      name: "has identity element",
      verification: .fromOne {
        self.equating(
          self.apply($0, self.empty),
          $0
        ) && self.equating(
          self.apply(self.empty, $0),
          $0
        )
      }
    )
  }
}

// MARK: - Invertibility

public protocol WithInverse: WithIdentity {
  var inverse: (A) -> A { get }
}

extension LawsOf where Structure: WithInverse {
  public var inverse: Property {
    Property(
      name: "has inverse",
      verification: .fromOne {
        self.equating(
          self.apply($0, self.inverse($0)),
          self.empty
        )
      }
    )
  }
}
