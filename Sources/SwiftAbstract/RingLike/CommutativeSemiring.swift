public struct CommutativeSemiring<Value>: RingLike, WithOne {
  public var first: CommutativeMonoid<Value>
  public var second: CommutativeMonoid<Value>

  public init(first: CommutativeMonoid<Value>, second: CommutativeMonoid<Value>) {
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
    .oneIdentity,
    .zeroIdentity,
  ] }
}

// MARK: - Initializers

extension CommutativeSemiring {
  public init<MoreSpecific: AlgebraicStructure<Value> & RingLike & WithOne>(from root: MoreSpecific) where MoreSpecific.Second: Commutative {
    self.init(
      first: .init(from: root.first),
      second: .init(from: root.second)
    )
  }
}

extension CommutativeSemiring where Value: Wrapper {
  public init(wrapping original: CommutativeSemiring<Value.Wrapped>) {
    self.init(
      first: .init(wrapping: original.first),
      second: .init(wrapping: original.second)
    )
  }
}
