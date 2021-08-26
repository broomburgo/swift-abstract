// MARK: - Definition

struct Ring<A>: RingLike, WithOne, WithNegate {
    let first: AbelianGroup<A>
    let second: Monoid<A>

    static var laws: [Law<Self>] { [
        .annihilability,
        .associativityOfFirst,
        .associativityOfSecond,
        .commutativityOfFirst,
        .distributivityOfSecondOverFirst,
        .negation,
        .oneIdentity,
        .zeroIdentity,
    ] }
}
