// MARK: - Definition

struct CommutativeRing<A>: RingLike, WithOne, WithNegate {
    let first: AbelianGroup<A>
    let second: CommutativeMonoid<A>

    static var laws: [Law<Self>] { [
        .annihilability,
        .associativityOfFirst,
        .associativityOfSecond,
        .commutativityOfFirst,
        .commutativityOfSecond,
        .distributivityOfSecondOverFirst,
        .negation,
        .oneIdentity,
        .zeroIdentity,
    ] }
}
