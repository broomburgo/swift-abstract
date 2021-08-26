// MARK: - Definition

struct BoundedLattice<A>: LatticeLike, WithZero, WithOne {
    let first: BoundedSemilattice<A>
    let second: BoundedSemilattice<A>

    static var laws: [Law<Self>] { [
        .absorbability,
        .associativityOfFirst,
        .associativityOfSecond,
        .commutativityOfFirst,
        .commutativityOfSecond,
        .idempotencyOfFirst,
        .idempotencyOfSecond,
        .oneIdentity,
        .zeroIdentity,
    ] }
}
