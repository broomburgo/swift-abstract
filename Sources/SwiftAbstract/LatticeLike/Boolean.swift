// MARK: - Definition

struct Boolean<A>: LatticeLike, Distributive, WithZero, WithOne, WithImplies, ExcludedMiddle {
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
        .excludedMiddle,
        .idempotencyOfFirst,
        .idempotencyOfSecond,
        .implication,
        .oneIdentity,
        .zeroIdentity,
    ] }
}

// MARK: - Instances

extension Boolean where A == Bool {
    static var bool: Self {
        Boolean(
            first: .or,
            second: .and,
            implies: { !$0 || $1 }
        )
    }
}
