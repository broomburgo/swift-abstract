// MARK: - Algebraic structure

public protocol AlgebraicStructure {
    associatedtype A

    static var laws: [Law<Self>] { get }
}

// MARK: - Magma

public protocol Magma: AlgebraicStructure {
    var apply: (A, A) -> A { get }
}

public protocol Associative: Magma {}

public protocol Commutative: Magma {}

public protocol Idempotent: Magma {}

public protocol Identity: Magma {
    var empty: A { get }
}

public protocol Invertible: Identity {
    var inverse: (A) -> A { get }
}

// MARK: - Bimagma

public protocol Bimagma: AlgebraicStructure {
    associatedtype First: Magma where First.A == A
    associatedtype Second: Magma where Second.A == A

    var first: First { get }
    var second: Second { get }
}

public protocol Absorption: Bimagma {}

public protocol WithAnnihilation: WithZero {}

public protocol DistributiveFirstOverSecond: Bimagma {}
public protocol DistributiveSecondOverFirst: Bimagma {}
public typealias Distributive = DistributiveFirstOverSecond & DistributiveSecondOverFirst

public protocol ExcludedMiddle: WithImplies, WithZero {}

public protocol WithImplies: LatticeLike, WithOne {
    var implies: (A, A) -> A { get }
}

public protocol WithNegate: WithZero where First: Invertible {}

public extension WithNegate {
    var negate: (A) -> A {
        first.inverse
    }
}

public protocol WithOne: Bimagma where Second: Identity {}

public extension WithOne {
    var one: A {
        second.empty
    }
}

public protocol WithReciprocal: WithOne where Second: Invertible {}

public extension WithReciprocal {
    var reciprocal: (A) -> A {
        second.inverse
    }
}

public protocol WithZero: Bimagma where First: Identity {}

public extension WithZero {
    var zero: A {
        first.empty
    }
}

// MARK: - Ring-Like

public protocol RingLike: DistributiveSecondOverFirst, WithAnnihilation where
    First: Associative & Commutative,
    Second: Associative {}

extension Bimagma where Self: RingLike {
    typealias Plus = First
    typealias Times = Second

    var plus: (A, A) -> A { first.apply }
    var times: (A, A) -> A { second.apply }
}

// MARK: - Lattice-Like

public protocol LatticeLike: Absorption where
    First: Associative & Commutative & Idempotent,
    Second: Associative & Commutative & Idempotent {}

extension Bimagma where Self: LatticeLike {
    typealias Join = First
    typealias Meet = Second

    var join: (A, A) -> A { first.apply } /// ~ OR ; ~ MAX
    var meet: (A, A) -> A { second.apply } /// ~ AND; ~ MIN
}
