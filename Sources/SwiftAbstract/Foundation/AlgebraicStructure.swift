// MARK: - Algebraic structure

public protocol AlgebraicStructure {
    associatedtype A

    static var laws: [Law<Self>] { get }
}

// MARK: - WithOneBinaryOperation

public protocol WithOneBinaryOperation: AlgebraicStructure {
    var apply: (A, A) -> A { get }
}

public protocol Associative: WithOneBinaryOperation {}

public protocol Commutative: WithOneBinaryOperation {}

public protocol Idempotent: WithOneBinaryOperation {}

public protocol WithIdentity: WithOneBinaryOperation {
    var empty: A { get }
}

public protocol WithInverse: WithIdentity {
    var inverse: (A) -> A { get }
}

public protocol ConstructibleWithOneBinaryOperation: AlgebraicStructure {
    init(apply: @escaping (A, A) -> A)
}

// MARK: - WithTwoBinaryOperations

public protocol WithTwoBinaryOperations: AlgebraicStructure {
    associatedtype FirstBinaryOperation: WithOneBinaryOperation where FirstBinaryOperation.A == A
    associatedtype SecondBinaryOperation: WithOneBinaryOperation where SecondBinaryOperation.A == A

    var first: FirstBinaryOperation { get }
    var second: SecondBinaryOperation { get }
}

public protocol Absorption: WithTwoBinaryOperations {}

public protocol WithAnnihilation: WithZero {}

public protocol DistributiveFirstOverSecond: WithTwoBinaryOperations {}
public protocol DistributiveSecondOverFirst: WithTwoBinaryOperations {}
public typealias Distributive = DistributiveFirstOverSecond & DistributiveSecondOverFirst

public protocol ExcludedMiddle: WithImplies, WithZero {}

public protocol WithImplies: LatticeLike, WithOne {
    var implies: (A, A) -> A { get }
}

public protocol WithNegate: WithZero where FirstBinaryOperation: WithInverse {}

public extension WithNegate {
    var negate: (A) -> A {
        first.inverse
    }
}

public protocol WithOne: WithTwoBinaryOperations where SecondBinaryOperation: WithIdentity {}

public extension WithOne {
    var one: A {
        second.empty
    }
}

public protocol WithReciprocal: WithOne where SecondBinaryOperation: WithInverse {}

public extension WithReciprocal {
    var reciprocal: (A) -> A {
        second.inverse
    }
}

public protocol WithZero: WithTwoBinaryOperations where FirstBinaryOperation: WithIdentity {}

public extension WithZero {
    var zero: A {
        first.empty
    }
}

// MARK: - Lattice-Like

public protocol LatticeLike: Absorption where
    FirstBinaryOperation: Associative & Commutative & Idempotent,
    SecondBinaryOperation: Associative & Commutative & Idempotent {}

extension WithTwoBinaryOperations where Self: LatticeLike {
    typealias Join = FirstBinaryOperation
    typealias Meet = SecondBinaryOperation

    var join: (A, A) -> A { first.apply } /// ~ OR ; ~ MAX
    var meet: (A, A) -> A { second.apply } /// ~ AND; ~ MIN
}

// MARK: - Ring-Like

public protocol RingLike: DistributiveSecondOverFirst, WithAnnihilation where
    FirstBinaryOperation: Associative & Commutative,
    SecondBinaryOperation: Associative {}

extension WithTwoBinaryOperations where Self: RingLike {
    typealias Plus = FirstBinaryOperation
    typealias Times = SecondBinaryOperation

    var plus: (A, A) -> A { first.apply }
    var times: (A, A) -> A { second.apply }
}
