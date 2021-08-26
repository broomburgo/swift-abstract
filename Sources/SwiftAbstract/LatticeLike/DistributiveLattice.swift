// MARK: - Definition

struct DistributiveLattice<A>: LatticeLike, Distributive {
    let first: Semilattice<A>
    let second: Semilattice<A>

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
    ] }
}
