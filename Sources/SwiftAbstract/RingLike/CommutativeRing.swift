public struct CommutativeRing<Value>: RingLike, WithOne, WithNegate {
  public var first: AbelianGroup<Value>
  public var second: CommutativeMonoid<Value>

  public init(
    first: AbelianGroup<Value>,
    second: CommutativeMonoid<Value>
  ) {
    self.first = first
    self.second = second
  }

  public static var laws: [Law<Self>] { [
    .annihilability,
    .associativityOfFirst,
    .associativityOfSecond,
    .commutativityOfFirst,
    .commutativityOfSecond,
    .distributivityOfSecondOverFirst,
    .negation,
    .oneIdentity,
    .zeroIdentity,
  ] }
}

// MARK: - Initializers

extension CommutativeRing {
  public init<MoreSpecific: AlgebraicStructure<Value> & RingLike & WithOne & WithNegate>(from root: MoreSpecific) where MoreSpecific.Second: Commutative {
    self.init(
      first: .init(from: root.first),
      second: .init(from: root.second)
    )
  }
}

extension CommutativeRing where Value: Wrapper {
  public init(wrapping original: CommutativeRing<Value.Wrapped>) {
    self.init(
      first: .init(wrapping: original.first),
      second: .init(wrapping: original.second)
    )
  }
}
