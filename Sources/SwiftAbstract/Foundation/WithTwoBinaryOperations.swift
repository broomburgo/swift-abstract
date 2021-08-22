public protocol WithTwoBinaryOperations: AlgebraicStructure {
    associatedtype FirstBinaryOperation: WithOneBinaryOperation where FirstBinaryOperation.A == A
    associatedtype SecondBinaryOperation: WithOneBinaryOperation where SecondBinaryOperation.A == A

    var first: FirstBinaryOperation { get }
    var second: SecondBinaryOperation { get }
}

// MARK: - Absorption

public protocol Absorption: WithTwoBinaryOperations {}

extension _Property where Structure: Absorption {
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

// MARK: - Annihilation

public protocol WithAnnihilation: WithZero {}

extension _Property where Structure: WithAnnihilation {
    static var annihilability: Self {
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

// MARK: - Associativity

//extension Verification {
//    init<Structure>(from laws: LawsOf<Structure>, property kp: KeyPath<LawsOf<Structure>, LawsOf<Structure>.Property>) where Structure.A == A {
//        self = laws[keyPath: kp].verification
//    }
//}
//
//extension LawsOf {
//    func derived<Substructure>(
//        from substructure: Substructure,
//        property kp: KeyPath<LawsOf<Substructure>, LawsOf<Substructure>.Property>
//    ) -> Verification<Structure.A> where Substructure.A == Structure.A {
//        LawsOf<Substructure>(substructure, equating: equating)[keyPath: kp].verification
//    }
//}
//
//extension LawsOf {
//    func der_ived<Substructure>(
//        from substructure: Substructure
//    ) -> LawsOf<Substructure> where Substructure.A == Structure.A {
//        LawsOf<Substructure>(substructure, equating: equating)
//    }
//}
//
//extension LawsOf {
//    func verifying<Substructure>(
//        that substructure: Substructure,
//        has property: KeyPath<LawsOf<Substructure>, LawsOf<Substructure>.Property>
//    ) -> Verification<Structure.A> where Substructure.A == Structure.A {
//        LawsOf<Substructure>(substructure, equating: equating)[keyPath: property].verification
//    }
//}

//extension _Property {
//    func verifying<Substructure>(
//        that substructure: Substructure,
//        has property: KeyPath<Substructure.Type, _Property<Substructure>>
//    ) -> _Property<Structure.A> where Substructure.A == Structure.A {
////        LawsOf<Substructure>(substructure, equating: equating)[keyPath: property].verification
//
//    }
//}

//extension _Property {
//    static func verifying<Substructure: AlgebraicStructure>(
//        that substructure: Substructure,
//        has property: KeyPath<Substructure.Type, _Property<Substructure>>
//    ) -> _Property<Structure> where Substructure.A == Structure.A {
//        _Verify
//    }
//}


//public extension LawsOf where Structure: WithTwoBinaryOperations, Structure.FirstBinaryOperation: Associative {
//    var associativityOfFirst: Property {
//        Property(
//            name: "has first operation associative",
//            verification: verifying(that: first, has: \.associativity)
//        )
//    }
//}
//
//public extension LawsOf where Structure: WithTwoBinaryOperations, Structure.SecondBinaryOperation: Associative {
//    var associativityOfSecond: Property {
//        Property(
//            name: "has second operation associative",
//            verification: verifying(that: second, has: \.associativity)
//        )
//    }
//}

extension _Property where Structure: WithTwoBinaryOperations, Structure.FirstBinaryOperation: Associative {
    static var associativityOfFirst: Self {
        .init(name: "has first operation associative") { structure, equating in
            _Property<Structure.FirstBinaryOperation>.associativity.getCheck(structure.first, equating)
        }
    }
}

extension _Property where Structure: WithTwoBinaryOperations, Structure.SecondBinaryOperation: Associative {
    static var associativityOfSecond: Self {
        .init(name: "has second operation associative") { structure, equating in
            _Property<Structure.SecondBinaryOperation>.associativity.getCheck(structure.second, equating)
        }
    }
}


// MARK: - Commutativity

extension _Property where Structure: WithTwoBinaryOperations, Structure.FirstBinaryOperation: Commutative {
    static var commutativityOfFirst: Self {
        .init(name: "has first operation commutative") { structure, equating in
            _Property<Structure.FirstBinaryOperation>.commutativity.getCheck(structure.first, equating)
        }
    }
}

extension _Property where Structure: WithTwoBinaryOperations, Structure.SecondBinaryOperation: Commutative {
    static var commutativityOfSecond: Self {
        .init(name: "has second operation commutative") { structure, equating in
            _Property<Structure.SecondBinaryOperation>.commutativity.getCheck(structure.second, equating)
        }
    }
}

//
//
//public extension LawsOf where Structure: WithTwoBinaryOperations, Structure.FirstBinaryOperation: Commutative {
//    var commutativityOfFirst: Property {
//        Property(
//            name: "has first operation commutative",
//            verification: .fromTwo {
//                self.equating(
//                    self.first.apply($0, $1),
//                    self.first.apply($1, $0)
//                )
//            }
//        )
//    }
//}
//
//public extension LawsOf where Structure: WithTwoBinaryOperations, Structure.SecondBinaryOperation: Commutative {
//    var commutativityOfSecond: Property {
//        Property(
//            name: "has second operation commutative",
//            verification: .fromTwo {
//                self.equating(
//                    self.second.apply($0, $1),
//                    self.second.apply($1, $0)
//                )
//            }
//        )
//    }
//}

// MARK: - Distributivity

public protocol DistributiveFirstOverSecond: WithTwoBinaryOperations {}
public protocol DistributiveSecondOverFirst: WithTwoBinaryOperations {}
public typealias Distributive = DistributiveFirstOverSecond & DistributiveSecondOverFirst

extension _Property where Structure: DistributiveFirstOverSecond {
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

extension _Property where Structure: DistributiveSecondOverFirst {
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


//public extension LawsOf where Structure: DistributiveFirstOverSecond {
//    var distributivityOfFirstOverSecond: Property {
//        Property(
//            name: "has first operation distributive over second",
//            verification: .fromThree {
//                self.equating(
//                    self.first.apply($0, self.second.apply($1, $2)),
//                    self.second.apply(self.first.apply($0, $1), self.first.apply($0, $2))
//                )
//            }
//        )
//    }
//}
//
//public extension LawsOf where Structure: DistributiveSecondOverFirst {
//    var distributivityOfSecondOverFirst: Property {
//        Property(
//            name: "has second operation distributive over first",
//            verification: .fromThree {
//                self.equating(
//                    self.second.apply($0, self.first.apply($1, $2)),
//                    self.first.apply(self.second.apply($0, $1), self.second.apply($0, $2))
//                )
//            }
//        )
//    }
//}

// MARK: - Excluded middle

public protocol ExcludedMiddle: WithImplies, WithZero {}

extension _Property where Structure: ExcludedMiddle {
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

//public extension LawsOf where Structure: ExcludedMiddle {
//    var excludedMiddle: Property {
//        Property(
//            name: "has operations respecting the law of excluded middle",
//            verification: .fromOne {
//                self.equating(
//                    self.first.apply($0, self.implies($0, self.zero)),
//                    self.one
//                )
//            }
//        )
//    }
//}

// MARK: - Implication

public protocol WithImplies: LatticeLike, WithOne {
    var implies: (A, A) -> A { get }
}

extension _Property where Structure: WithImplies {
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

//public extension LawsOf where Structure: WithImplies {
//    var implication: Property {
//        Property(
//            name: "has implication",
//            verification: .fromThree {
//                self.equating(
//                    self.implies($0, $0),
//                    self.one
//                ) && self.equating(
//                    self.second.apply($0, self.implies($0, $1)),
//                    self.second.apply($0, $1)
//                ) && self.equating(
//                    self.second.apply($1, self.implies($0, $1)),
//                    $1
//                ) && self.equating(
//                    self.implies($0, self.second.apply($1, $2)),
//                    self.second.apply(self.implies($0, $1), self.implies($0, $2))
//                )
//            }
//        )
//    }
//}

// MARK: - Idempotency

extension _Property where Structure: WithTwoBinaryOperations, Structure.FirstBinaryOperation: Idempotent {
    static var idempotencyOfFirst: Self {
        .init(name: "has first operation idempotent") { structure, equating in
            _Property<Structure.FirstBinaryOperation>.idempotency.getCheck(structure.first, equating)
        }
    }
}

extension _Property where Structure: WithTwoBinaryOperations, Structure.SecondBinaryOperation: Idempotent {
    static var idempotencyOfSecond: Self {
        .init(name: "has second operation idempotent") { structure, equating in
            _Property<Structure.SecondBinaryOperation>.idempotency.getCheck(structure.second, equating)
        }
    }
}



//public protocol IdempotentFirst: WithTwoBinaryOperations where FirstBinaryOperation: Idempotent {}
//public protocol IdempotentSecond: WithTwoBinaryOperations where SecondBinaryOperation: Idempotent {}
//public typealias IdempotentBoth = IdempotentFirst & IdempotentSecond
//
//public extension LawsOf where Structure: IdempotentFirst {
//    var idempotencyOfFirst: Property {
//        Property(
//            name: "has first operation idempotent",
//            verification: .fromTwo {
//                self.equating(
//                    self.first.apply(self.first.apply($0, $1), $1),
//                    self.first.apply($0, $1)
//                )
//            }
//        )
//    }
//}
//
//public extension LawsOf where Structure: IdempotentSecond {
//    var idempotencyOfSecond: Property {
//        Property(
//            name: "has second operation idempotent",
//            verification: .fromTwo {
//                self.equating(
//                    self.second.apply(self.second.apply($0, $1), $1),
//                    self.second.apply($0, $1)
//                )
//            }
//        )
//    }
//}

// MARK: - Negation

public protocol WithNegate: WithZero where FirstBinaryOperation: WithInverse {}

public extension WithNegate {
    var negate: (A) -> A {
        first.inverse
    }
}

extension _Property where Structure: WithNegate {
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
//
//public extension LawsOf where Structure: WithNegate {
//    var negation: Property {
//        Property(
//            name: "has negation",
//            verification: .fromOne {
//                self.equating(
//                    self.first.apply($0, self.negate($0)),
//                    self.zero
//                ) && self.equating(
//                    self.first.apply(self.negate($0), $0),
//                    self.zero
//                )
//            }
//        )
//    }
//}

// MARK: - One identity

public protocol WithOne: WithTwoBinaryOperations where SecondBinaryOperation: WithIdentity {}

public extension WithOne {
    var one: A {
        second.empty
    }
}

extension _Property where Structure: WithOne {
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

//public extension LawsOf where Structure: WithOne {
//    var oneIdentity: Property {
//        Property(
//            name: "has identity of one",
//            verification: .fromOne {
//                self.equating(
//                    self.second.apply($0, self.one),
//                    $0
//                ) && self.equating(
//                    self.second.apply(self.one, $0),
//                    $0
//                )
//            }
//        )
//    }
//}

// MARK: - Reciprocity

public protocol WithReciprocal: WithOne where SecondBinaryOperation: WithInverse {}

public extension WithReciprocal {
    var reciprocal: (A) -> A {
        second.inverse
    }
}

extension _Property where Structure: WithReciprocal {
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

//public extension LawsOf where Structure: WithReciprocal {
//    var reciprocity: Property {
//        Property(
//            name: "has reciprocal",
//            verification: .fromOne {
//                self.equating(
//                    self.second.apply($0, self.reciprocal($0)),
//                    self.one
//                ) && self.equating(
//                    self.second.apply(self.reciprocal($0), $0),
//                    self.one
//                )
//            }
//        )
//    }
//}

// MARK: - Zero identity

public protocol WithZero: WithTwoBinaryOperations where FirstBinaryOperation: WithIdentity {}

public extension WithZero {
    var zero: A {
        first.empty
    }
}

extension _Property where Structure: WithZero {
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

//public extension LawsOf where Structure: WithZero {
//    var zeroIdentity: Property {
//        Property(
//            name: "has identity of zero",
//            verification: .fromOne {
//                self.equating(
//                    self.first.apply($0, self.zero),
//                    $0
//                ) && self.equating(
//                    self.first.apply(self.zero, $0),
//                    $0
//                )
//            }
//        )
//    }
//}
