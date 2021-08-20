public protocol LatticeLike: IdempotentBoth, Absorption where
    FirstBinaryOperation: Associative & Commutative,
    SecondBinaryOperation: Associative & Commutative {}

extension WithTwoBinaryOperations where Self: LatticeLike {
    typealias Join = FirstBinaryOperation
    typealias Meet = SecondBinaryOperation

    var join: (A, A) -> A { first.apply } /// ~ OR ; ~ MAX
    var meet: (A, A) -> A { second.apply } /// ~ AND; ~ MIN
}
