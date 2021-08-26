// MARK: - Definition

struct Rng<A>: RingLike, WithNegate {
    let first: AbelianGroup<A>
    let second: Semigroup<A>

    static var laws: [Law<Self>] { [
        .annihilability,
        .associativityOfFirst,
        .associativityOfSecond,
        .commutativityOfFirst,
        .distributivityOfSecondOverFirst,
        .negation,
        .zeroIdentity,
    ] }
}
