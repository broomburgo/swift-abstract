public struct Lattice<Value>: LatticeLike {
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
    .idempotencyOfFirst,
    .idempotencyOfSecond,
  ] }
}

// MARK: - Initializers

extension Lattice {
  public init(from root: some LatticeLike<Value>) {
    self.init(
      first: .init(from: root.first),
      second: .init(from: root.second)
    )
  }
}

extension Lattice where Value: Wrapper {
  public init(wrapping original: Lattice<Value.Wrapped>) {
    self.init(
      first: .init(wrapping: original.first),
      second: .init(wrapping: original.second)
    )
  }
}
