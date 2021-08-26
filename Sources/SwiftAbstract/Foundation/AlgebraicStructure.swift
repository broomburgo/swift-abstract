// MARK: - Algebraic structure

public protocol AlgebraicStructure {
    associatedtype A

    static var properties: [Property<Self>] { get }
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

