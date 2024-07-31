public struct Ring<Value>: RingLike, WithOne, WithNegate {
  public var first: AbelianGroup<Value>
  public var second: Monoid<Value>

  public init(first: AbelianGroup<Value>, second: Monoid<Value>) {
    self.first = first
    self.second = second
  }

  public static var laws: [Law<Self>] { [
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

// MARK: - Initializers

extension Ring {
  public init(from root: some AlgebraicStructure<Value> & RingLike & WithOne & WithNegate) {
    self.init(
      first: .init(from: root.first),
      second: .init(from: root.second)
    )
  }
}

extension Ring where Value: Wrapper {
  public init(wrapping original: Ring<Value.Wrapped>) {
    self.init(
      first: .init(wrapping: original.first),
      second: .init(wrapping: original.second)
    )
  }
}
