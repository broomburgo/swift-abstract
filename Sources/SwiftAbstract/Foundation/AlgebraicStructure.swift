// MARK: - Algebraic structure

public protocol AlgebraicStructure<Value> {
  associatedtype Value

  static var laws: [Law<Self>] { get }
}

// MARK: - Magma

public protocol Magma<Value>: AlgebraicStructure {
  var apply: (Value, Value) -> Value { get }
}

public protocol Associative<Value>: Magma {}

public protocol Commutative<Value>: Magma {}

public protocol Idempotent<Value>: Magma {}

public protocol Identity<Value>: Magma {
  var empty: Value { get }
}

public protocol Invertible<Value>: Identity {
  var inverse: (Value) -> Value { get }
}

// MARK: - Bimagma

public protocol Bimagma<Value>: AlgebraicStructure {
  associatedtype First: Magma<Value>
  associatedtype Second: Magma<Value>

  var first: First { get }
  var second: Second { get }
}

public protocol Absorption<Value>: Bimagma {}

public protocol WithAnnihilation<Value>: WithZero {}

public protocol DistributiveFirstOverSecond<Value>: Bimagma {}
public protocol DistributiveSecondOverFirst<Value>: Bimagma {}
public typealias Distributive = DistributiveFirstOverSecond & DistributiveSecondOverFirst

public protocol ExcludedMiddle<Value>: WithImplies, WithZero {}

public protocol WithImplies<Value>: LatticeLike, WithOne {
  var implies: (Value, Value) -> Value { get }
}

public protocol WithNegate<Value>: WithZero where First: Invertible {}

extension WithNegate {
  public var negate: (Value) -> Value {
    first.inverse
  }
}

public protocol WithOne<Value>: Bimagma where Second: Identity {}

extension WithOne {
  public var one: Value {
    second.empty
  }
}

public protocol WithReciprocal<Value>: WithOne where Second: Invertible {}

extension WithReciprocal {
  public var reciprocal: (Value) -> Value {
    second.inverse
  }
}

public protocol WithZero<Value>: Bimagma where First: Identity {}

extension WithZero {
  public var zero: Value {
    first.empty
  }
}

// MARK: - Ring-Like

public protocol RingLike<Value>: DistributiveSecondOverFirst, WithAnnihilation where
  First: Associative & Commutative,
  Second: Associative {}

extension Bimagma where Self: RingLike {
  public typealias Plus = First
  public typealias Times = Second

  public var plus: (Value, Value) -> Value { first.apply }
  public var times: (Value, Value) -> Value { second.apply }
}

// MARK: - Lattice-Like

public protocol LatticeLike<Value>: Absorption where
  First: Associative & Commutative & Idempotent,
  Second: Associative & Commutative & Idempotent {}

extension Bimagma where Self: LatticeLike {
  public typealias Join = First
  public typealias Meet = Second

  public var join: (Value, Value) -> Value { first.apply } /// ~ OR ; ~ MAX
  public var meet: (Value, Value) -> Value { second.apply } /// ~ AND; ~ MIN
}
