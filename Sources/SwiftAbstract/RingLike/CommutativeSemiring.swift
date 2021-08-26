// MARK: - Definition

struct CommutativeSemiring<A>: RingLike, WithOne {
    let first: CommutativeMonoid<A>
    let second: CommutativeMonoid<A>

    static var laws: [Law<Self>] { [
        .annihilability,
        .associativityOfFirst,
        .associativityOfSecond,
        .commutativityOfFirst,
        .commutativityOfSecond,
        .distributivityOfSecondOverFirst,
        .oneIdentity,
        .zeroIdentity,
    ] }
}
