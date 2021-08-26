public enum Check<A> {
    case fromOne((A) -> Bool)
    case fromTwo((A, A) -> Bool)
    case fromThree((A, A, A) -> Bool)
}

public struct Property<Structure: AlgebraicStructure> {
    public let name: String
    public let getCheck: (Structure, @escaping (Structure.A, Structure.A) -> Bool) -> Check<Structure.A>
}

public struct Verify<Structure: AlgebraicStructure> {
    public let structure: Structure
    public let equating: (Structure.A, Structure.A) -> Bool
    public let property: Property<Structure>

    public func callAsFunction(_ a: Structure.A, _ b: Structure.A, _ c: Structure.A) -> Bool {
        switch property.getCheck(structure, equating) {
        case let .fromOne(f):
            return f(a)

        case let .fromTwo(f):
            return f(a, b)

        case let .fromThree(f):
            return f(a, b, c)
        }
    }
}

// MARK: - Absorption

extension Property where Structure: Absorption {
    static var absorbability: Self {
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

extension Property where Structure: WithAnnihilation {
    static var annihilability: Self {
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

extension Property where Structure: Associative {
    static var associativity: Self {
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

extension Property where Structure: WithTwoBinaryOperations, Structure.FirstBinaryOperation: Associative {
    static var associativityOfFirst: Self {
        .init(name: "has first operation associative") { structure, equating in
            Property<Structure.FirstBinaryOperation>.associativity.getCheck(structure.first, equating)
        }
    }
}

extension Property where Structure: WithTwoBinaryOperations, Structure.SecondBinaryOperation: Associative {
    static var associativityOfSecond: Self {
        .init(name: "has second operation associative") { structure, equating in
            Property<Structure.SecondBinaryOperation>.associativity.getCheck(structure.second, equating)
        }
    }
}

// MARK: - Commutativity

extension Property where Structure: Commutative {
    static var commutativity: Self {
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

extension Property where Structure: WithTwoBinaryOperations, Structure.FirstBinaryOperation: Commutative {
    static var commutativityOfFirst: Self {
        .init(name: "has first operation commutative") { structure, equating in
            Property<Structure.FirstBinaryOperation>.commutativity.getCheck(structure.first, equating)
        }
    }
}

extension Property where Structure: WithTwoBinaryOperations, Structure.SecondBinaryOperation: Commutative {
    static var commutativityOfSecond: Self {
        .init(name: "has second operation commutative") { structure, equating in
            Property<Structure.SecondBinaryOperation>.commutativity.getCheck(structure.second, equating)
        }
    }
}

// MARK: - Distributivity

extension Property where Structure: DistributiveFirstOverSecond {
    static var distributivityOfFirstOverSecond: Self {
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

extension Property where Structure: DistributiveSecondOverFirst {
    static var distributivityOfSecondOverFirst: Self {
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

extension Property where Structure: ExcludedMiddle {
    static var excludedMiddle: Self {
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

extension Property where Structure: Idempotent {
    static var idempotency: Self {
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

extension Property where Structure: WithTwoBinaryOperations, Structure.FirstBinaryOperation: Idempotent {
    static var idempotencyOfFirst: Self {
        .init(name: "has first operation idempotent") { structure, equating in
            Property<Structure.FirstBinaryOperation>.idempotency.getCheck(structure.first, equating)
        }
    }
}

extension Property where Structure: WithTwoBinaryOperations, Structure.SecondBinaryOperation: Idempotent {
    static var idempotencyOfSecond: Self {
        .init(name: "has second operation idempotent") { structure, equating in
            Property<Structure.SecondBinaryOperation>.idempotency.getCheck(structure.second, equating)
        }
    }
}

// MARK: - Identity

extension Property where Structure: WithIdentity {
    static var identity: Self {
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

extension Property where Structure: WithImplies {
    static var implication: Self {
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

extension Property where Structure: WithInverse {
    static var invertibility: Self {
        .init(name: "has identity element") { structure, equating in
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

extension Property where Structure: WithNegate {
    static var negation: Self {
        .init(name: "has negation") { structure, equating in
            .fromOne {
                equating(
                    structure.first.apply($0, structure.negate($0)),
                    structure.zero
                ) && equating(
                    structure.first.apply(structure.negate($0), $0),
                    structure.zero
                )
            }
        }
    }
}

// MARK: - One identity

extension Property where Structure: WithOne {
    static var oneIdentity: Self {
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

extension Property where Structure: WithReciprocal {
    static var reciprocity: Self {
        .init(name: "has reciprocal") { structure, equating in
            .fromOne {
                equating(
                    structure.second.apply($0, structure.reciprocal($0)),
                    structure.one
                ) && equating(
                    structure.second.apply(structure.reciprocal($0), $0),
                    structure.one
                )
            }
        }
    }
}

// MARK: - Zero identity

extension Property where Structure: WithZero {
    static var zeroIdentity: Self {
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
