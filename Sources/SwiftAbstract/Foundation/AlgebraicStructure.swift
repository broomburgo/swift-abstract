// MARK: - Algebraic structure

public protocol AlgebraicStructure {
    associatedtype A

    func getProperties(equating: @escaping (A, A) -> Bool) -> [LawsOf<Self>.Property]
}

extension AlgebraicStructure where A: Equatable {
    var properties: [LawsOf<Self>.Property] {
        getProperties(equating: ==)
    }
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

// MARK: - Laws

