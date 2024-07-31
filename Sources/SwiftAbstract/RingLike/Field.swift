public struct Field<Value>: RingLike, WithOne, WithNegate, WithReciprocal {
  public var first: AbelianGroup<Value>
  public var second: AbelianGroup<Value>

  public init(first: AbelianGroup<Value>, second: AbelianGroup<Value>) {
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
    .reciprocity,
    .zeroIdentity,
  ] }
}

// MARK: - Initializers

extension Field {
  public init<MoreSpecific: AlgebraicStructure<Value> & RingLike & WithOne & WithNegate & WithReciprocal>(from s: MoreSpecific)
    where MoreSpecific.Second: Commutative
  {
    self.init(
      first: .init(from: s.first),
      second: .init(from: s.second)
    )
  }
}

extension Field where Value: Wrapper {
  public init(wrapping original: Field<Value.Wrapped>) {
    self.init(
      first: .init(wrapping: original.first),
      second: .init(wrapping: original.second)
    )
  }
}

// MARK: - Instances

extension Field where Value: FloatingPoint {
  public static var real: Self {
    .init(
      first: .addition,
      second: .multiplication
    )
  }
}
