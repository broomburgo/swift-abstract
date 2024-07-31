public struct DistributiveLattice<Value>: LatticeLike, Distributive {
  public var first: Semilattice<Value>
  public var second: Semilattice<Value>

  public init(first: Semilattice<Value>, second: Semilattice<Value>) {
    self.first = first
    self.second = second
  }

  public static var laws: [Law<Self>] { [
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

// MARK: - Initializers

extension DistributiveLattice {
  public init(from root: some AlgebraicStructure<Value> & LatticeLike & Distributive) {
    self.init(
      first: .init(from: root.first),
      second: .init(from: root.second)
    )
  }
}

extension DistributiveLattice where Value: Wrapper {
  public init(wrapping original: DistributiveLattice<Value.Wrapped>) {
    self.init(
      first: .init(wrapping: original.first),
      second: .init(wrapping: original.second)
    )
  }
}
