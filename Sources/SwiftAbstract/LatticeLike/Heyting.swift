// MARK: - Definition

struct Heyting<A>: LatticeLike, Distributive, WithZero, WithOne, WithImplies {
    let first: BoundedSemilattice<A>
    let second: BoundedSemilattice<A>
    let implies: (A, A) -> A

    static var laws: [Law<Self>] { [
        .absorbability,
        .associativityOfFirst,
        .associativityOfSecond,
        .commutativityOfFirst,
        .commutativityOfSecond,
        .distributivityOfFirstOverSecond,
        .distributivityOfSecondOverFirst,
        .idempotencyOfFirst,
        .idempotencyOfSecond,
        .implication,
        .oneIdentity,
        .zeroIdentity,
    ] }
}
