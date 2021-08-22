public protocol LatticeLike: Absorption where
    FirstBinaryOperation: Associative & Commutative & Idempotent,
    SecondBinaryOperation: Associative & Commutative & Idempotent {}

extension WithTwoBinaryOperations where Self: LatticeLike {
    typealias Join = FirstBinaryOperation
    typealias Meet = SecondBinaryOperation

    var join: (A, A) -> A { first.apply } /// ~ OR ; ~ MAX
    var meet: (A, A) -> A { second.apply } /// ~ AND; ~ MIN
}
