
@dynamicMemberLookup
public struct LawsOf<Structure: AlgebraicStructure> {
    public let structure: Structure
    public let equating: (Structure.A, Structure.A) -> Bool

    public init(_ structure: Structure, equating: @escaping (Structure.A, Structure.A) -> Bool) {
        self.structure = structure
        self.equating = equating
    }

    subscript<T>(dynamicMember kp: KeyPath<Structure, T>) -> T {
        structure[keyPath: kp]
    }

    public func properties(_ f: (Self) -> [Property]) -> [Property] {
        f(self)
    }

    public struct Property {
        public let name: String
        public let verification: Verification<Structure.A>

        public func verify(_ a: Structure.A, _ b: Structure.A, _ c: Structure.A) -> Bool {
            switch verification {
            case let .fromOne(f):
                return f(a)

            case let .fromTwo(f):
                return f(a, b)

            case let .fromThree(f):
                return f(a, b, c)
            }
        }
    }
}

public enum Verification<A> {
    case fromOne((A) -> Bool)
    case fromTwo((A, A) -> Bool)
    case fromThree((A, A, A) -> Bool)
}

// MARK: - Associativity

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
