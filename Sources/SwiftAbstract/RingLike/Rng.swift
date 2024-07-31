public struct Rng<Value>: RingLike, WithNegate {
  public var first: AbelianGroup<Value>
  public var second: Semigroup<Value>

  public init(first: AbelianGroup<Value>, second: Semigroup<Value>) {
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
    .zeroIdentity,
  ] }
}

// MARK: - Initializers

extension Rng {
  public init(from root: some AlgebraicStructure<Value> & RingLike & WithNegate) {
    self.init(
      first: .init(from: root.first),
      second: .init(from: root.second)
    )
  }
}

extension Rng where Value: Wrapper {
  public init(wrapping original: Rng<Value.Wrapped>) {
    self.init(
      first: .init(wrapping: original.first),
      second: .init(wrapping: original.second)
    )
  }
}
