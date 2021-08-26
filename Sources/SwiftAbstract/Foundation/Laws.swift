public struct Law<Structure: AlgebraicStructure> {
    public let name: String
    public let getCheck: (Structure, @escaping (Structure.A, Structure.A) -> Bool) -> Check<Structure.A>
}

public enum Check<A> {
    case fromOne((A) -> Bool)
    case fromTwo((A, A) -> Bool)
    case fromThree((A, A, A) -> Bool)
}

// MARK: - Absorption

extension Law where Structure: Absorption {
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

extension Law where Structure: WithAnnihilation {
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

extension Law where Structure: Associative {
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

extension Law where Structure: WithTwoBinaryOperations, Structure.FirstBinaryOperation: Associative {
    static var associativityOfFirst: Self {
        .init(name: "has first operation associative") { structure, equating in
            Law<Structure.FirstBinaryOperation>.associativity.getCheck(structure.first, equating)
        }
    }
}

extension Law where Structure: WithTwoBinaryOperations, Structure.SecondBinaryOperation: Associative {
    static var associativityOfSecond: Self {
        .init(name: "has second operation associative") { structure, equating in
            Law<Structure.SecondBinaryOperation>.associativity.getCheck(structure.second, equating)
        }
    }
}

// MARK: - Commutativity

extension Law where Structure: Commutative {
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

extension Law where Structure: WithTwoBinaryOperations, Structure.FirstBinaryOperation: Commutative {
    static var commutativityOfFirst: Self {
        .init(name: "has first operation commutative") { structure, equating in
            Law<Structure.FirstBinaryOperation>.commutativity.getCheck(structure.first, equating)
        }
    }
}

extension Law where Structure: WithTwoBinaryOperations, Structure.SecondBinaryOperation: Commutative {
    static var commutativityOfSecond: Self {
        .init(name: "has second operation commutative") { structure, equating in
            Law<Structure.SecondBinaryOperation>.commutativity.getCheck(structure.second, equating)
        }
    }
}

// MARK: - Distributivity

extension Law where Structure: DistributiveFirstOverSecond {
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

extension Law where Structure: DistributiveSecondOverFirst {
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

extension Law where Structure: ExcludedMiddle {
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

extension Law where Structure: Idempotent {
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

extension Law where Structure: WithTwoBinaryOperations, Structure.FirstBinaryOperation: Idempotent {
    static var idempotencyOfFirst: Self {
        .init(name: "has first operation idempotent") { structure, equating in
            Law<Structure.FirstBinaryOperation>.idempotency.getCheck(structure.first, equating)
        }
    }
}

extension Law where Structure: WithTwoBinaryOperations, Structure.SecondBinaryOperation: Idempotent {
    static var idempotencyOfSecond: Self {
        .init(name: "has second operation idempotent") { structure, equating in
            Law<Structure.SecondBinaryOperation>.idempotency.getCheck(structure.second, equating)
        }
    }
}

// MARK: - Identity

extension Law where Structure: WithIdentity {
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

extension Law where Structure: WithImplies {
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

extension Law where Structure: WithInverse {
    static var invertibility: Self {
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

//extension Law where Structure: WithInverse, Structure.A: FloatingPoint {
//    static var invertibility: Self {
//        .init(name: "is invertible") { structure, equating in
//            .fromOne {
//                guard $0 != .zero else {
//                    return true
//                }
//
//                return equating(
//                    structure.apply($0, structure.inverse($0)),
//                    structure.empty
//                )
//            }
//        }
//    }
//}

// MARK: - Negation

extension Law where Structure: WithNegate {
    static var negation: Self {
        .init(name: "has negation") { structure, equating in
            Law<Structure.FirstBinaryOperation>.invertibility.getCheck(structure.first, equating)
        }
    }
}

// MARK: - One identity

extension Law where Structure: WithOne {
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

extension Law where Structure: WithReciprocal {
    static var reciprocity: Self {
        .init(name: "has reciprocal") { structure, equating in
            Law<Structure.SecondBinaryOperation>.invertibility.getCheck(structure.second, equating)
        }
    }
}

// MARK: - Zero identity

extension Law where Structure: WithZero {
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
