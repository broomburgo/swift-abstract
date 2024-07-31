public struct Semiring<Value>: RingLike, WithOne {
  public var first: CommutativeMonoid<Value>
  public var second: Monoid<Value>

  public init(first: CommutativeMonoid<Value>, second: Monoid<Value>) {
    self.first = first
    self.second = second
  }

  public static var laws: [Law<Self>] { [
    .annihilability,
    .associativityOfFirst,
    .associativityOfSecond,
    .commutativityOfFirst,
    .distributivityOfSecondOverFirst,
    .oneIdentity,
    .zeroIdentity,
  ] }
}

// MARK: - Initializers

extension Semiring {
  public init(from root: some AlgebraicStructure<Value> & RingLike & WithOne) {
    self.init(
      first: .init(from: root.first),
      second: .init(from: root.second)
    )
  }
}

extension Semiring where Value: Wrapper {
  public init(wrapping original: Semiring<Value.Wrapped>) {
    self.init(
      first: .init(wrapping: original.first),
      second: .init(wrapping: original.second)
    )
  }
}

// MARK: - Instances

extension Semiring where Value: AdditiveArithmetic & Comparable & WithMaximum {
  public static var minTropical: Self {
    Semiring(
      first: .init(from: BoundedSemilattice.min),
      second: .init(from: CommutativeMonoid.addition)
    )
  }
}

extension Semiring where Value: AdditiveArithmetic & Comparable & WithMinimum {
  public static var maxTropical: Self {
    Semiring(
      first: .init(from: BoundedSemilattice.max),
      second: .init(from: CommutativeMonoid.addition)
    )
  }
}
