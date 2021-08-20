public protocol RingLike: DistributiveSecondOverFirst, WithAnnihilation where
    FirstBinaryOperation: Associative & Commutative,
    SecondBinaryOperation: Associative {}

extension WithTwoBinaryOperations where Self: RingLike {
    typealias Plus = FirstBinaryOperation
    typealias Times = SecondBinaryOperation

    var plus: (A, A) -> A { first.apply }
    var times: (A, A) -> A { second.apply }
}
