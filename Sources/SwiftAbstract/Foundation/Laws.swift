
//@dynamicMemberLookup
//public struct LawsOf<Structure: AlgebraicStructure> {
//    public let structure: Structure
//    public let equating: (Structure.A, Structure.A) -> Bool
//
//    public init(_ structure: Structure, equating: @escaping (Structure.A, Structure.A) -> Bool) {
//        self.structure = structure
//        self.equating = equating
//    }
//
//    subscript<T>(dynamicMember kp: KeyPath<Structure, T>) -> T {
//        structure[keyPath: kp]
//    }
//
//    public func properties(_ f: (Self) -> [Property]) -> [Property] {
//        f(self)
//    }
//
//    public struct Property {
//        public let name: String
//        public let verification: Verification<Structure.A>
//
//        public func verify(_ a: Structure.A, _ b: Structure.A, _ c: Structure.A) -> Bool {
//            switch verification {
//            case let .fromOne(f):
//                return f(a)
//
//            case let .fromTwo(f):
//                return f(a, b)
//
//            case let .fromThree(f):
//                return f(a, b, c)
//            }
//        }
//    }
//}
//
//public enum Verification<A> {
//    case fromOne((A) -> Bool)
//    case fromTwo((A, A) -> Bool)
//    case fromThree((A, A, A) -> Bool)
//}

public enum _Check<A> {
    case fromOne((A) -> Bool)
    case fromTwo((A, A) -> Bool)
    case fromThree((A, A, A) -> Bool)
}

public struct _Property<Structure: AlgebraicStructure> {
    public let name: String
    public let getCheck: (Structure, @escaping (Structure.A, Structure.A) -> Bool) -> _Check<Structure.A>
}

public struct _Verify<Structure: AlgebraicStructure> {
    public let structure: Structure
    public let equating: (Structure.A, Structure.A) -> Bool
    public let property: _Property<Structure>

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

// MARK: - Associativity

extension _Property where Structure: Associative {
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

// MARK: - Commutativity

extension _Property where Structure: Commutative {
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

// MARK: - Idempotency

extension _Property where Structure: Idempotent {
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

// MARK: - Identity

extension _Property where Structure: WithIdentity {
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

// MARK: - Invertibility

extension _Property where Structure: WithInverse {
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
