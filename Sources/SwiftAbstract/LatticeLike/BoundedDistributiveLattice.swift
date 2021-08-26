// MARK: - Definition

struct BoundedDistributiveLattice<A>: LatticeLike, Distributive, WithZero, WithOne {
    let first: BoundedSemilattice<A>
    let second: BoundedSemilattice<A>

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
        .oneIdentity,
        .zeroIdentity,
    ] }
}
