public protocol AlgebraicInstance {
  associatedtype ReferenceStructure: AlgebraicStructure<Self>
  static var referenceInstance: ReferenceStructure { get }
}

public struct Abstract<Structure: AlgebraicStructure> {
  public var instance: Structure

  public init(_ instance: Structure) {
    self.instance = instance
  }
}

extension AlgebraicInstance {
  public static var abstract: Abstract<ReferenceStructure> {
    .init(referenceInstance)
  }
}

// MARK: - Wrapper

public protocol Wrapper<Wrapped> {
  associatedtype Wrapped
  init(_ wrapped: Wrapped)
  var wrapped: Wrapped { get }
}

// MARK: - Magma

extension Abstract where Structure: Associative & Commutative & Identity & Invertible {
  public var abelianGroup: AbelianGroup<Structure.Value> {
    .init(from: instance)
  }
}

extension Abstract where Structure: Associative & Idempotent {
  public var band: Band<Structure.Value> {
    .init(from: instance)
  }
}

extension Abstract where Structure: Associative & Commutative & Idempotent & Identity {
  public var boundedSemilattice: BoundedSemilattice<Structure.Value> {
    .init(from: instance)
  }
}

extension Abstract where Structure: Associative & Commutative & Identity {
  public var commutativeMonoid: CommutativeMonoid<Structure.Value> {
    .init(from: instance)
  }
}

extension Abstract where Structure: Associative & Commutative {
  public var commutativeSemigroup: CommutativeSemigroup<Structure.Value> {
    .init(from: instance)
  }
}

extension Abstract where Structure: Associative & Identity & Invertible {
  public var group: Group<Structure.Value> {
    .init(from: instance)
  }
}

extension Abstract where Structure: Associative & Idempotent & Identity {
  public var idempotentMonoid: IdempotentMonoid<Structure.Value> {
    .init(from: instance)
  }
}

extension Abstract where Structure: Associative & Identity {
  public var monoid: Monoid<Structure.Value> {
    .init(from: instance)
  }
}

extension Abstract where Structure: Associative {
  public var semigroup: Semigroup<Structure.Value> {
    .init(from: instance)
  }
}

extension Abstract where Structure: Associative & Commutative & Idempotent {
  public var semilattice: Semilattice<Structure.Value> {
    .init(from: instance)
  }
}

// MARK: - Ring-like

extension Abstract where Structure: RingLike & WithOne & WithNegate, Structure.Second: Commutative {
  public var commutativeRing: CommutativeRing<Structure.Value> {
    .init(from: instance)
  }
}

extension Abstract where Structure: RingLike & WithOne, Structure.Second: Commutative {
  public var commutativeSemiring: CommutativeSemiring<Structure.Value> {
    .init(from: instance)
  }
}

extension Abstract where Structure: RingLike & WithOne & WithNegate & WithReciprocal, Structure.Second: Commutative {
  public var field: Field<Structure.Value> {
    .init(from: instance)
  }
}

extension Abstract where Structure: RingLike & WithOne & WithNegate {
  public var ring: Ring<Structure.Value> {
    .init(from: instance)
  }
}

extension Abstract where Structure: RingLike & WithNegate {
  public var rng: Rng<Structure.Value> {
    .init(from: instance)
  }
}

extension Abstract where Structure: RingLike & WithOne {
  public var semiring: Semiring<Structure.Value> {
    .init(from: instance)
  }
}

// MARK: - Lattice-like

extension Abstract where Structure: LatticeLike & Distributive & WithZero & WithOne & WithImplies & ExcludedMiddle {
  public var boolean: Boolean<Structure.Value> {
    .init(from: instance)
  }
}

extension Abstract where Structure: LatticeLike & Distributive & WithZero & WithOne {
  public var boundedDistributiveLattice: BoundedDistributiveLattice<Structure.Value> {
    .init(from: instance)
  }
}

extension Abstract where Structure: LatticeLike & WithZero & WithOne {
  public var boundedLattice: BoundedLattice<Structure.Value> {
    .init(from: instance)
  }
}

extension Abstract where Structure: LatticeLike & Distributive {
  public var distributiveLattice: DistributiveLattice<Structure.Value> {
    .init(from: instance)
  }
}

extension Abstract where Structure: LatticeLike & Distributive & WithZero & WithOne & WithImplies {
  public var heyting: Heyting<Structure.Value> {
    .init(from: instance)
  }
}

extension Abstract where Structure: LatticeLike {
  public var lattice: Lattice<Structure.Value> {
    .init(from: instance)
  }
}

// MARK: - Instances

extension Sequence where Element: AlgebraicInstance, Element.ReferenceStructure: Associative & Identity {
  public func concat() -> Element {
    let instance = Element.abstract.monoid
    return reduce(instance.empty, instance.apply)
  }
}

public struct Sum<Wrapped: SignedNumeric>: Wrapper {
  public var wrapped: Wrapped

  public init(_ wrapped: Wrapped) {
    self.wrapped = wrapped
  }
}

extension Sum: AlgebraicInstance {
  public static var referenceInstance: AbelianGroup<Self> { .init(wrapping: .addition) }
}

public struct Max<Wrapped: Comparable>: Wrapper {
  public var wrapped: Wrapped

  public init(_ wrapped: Wrapped) {
    self.wrapped = wrapped
  }
}

extension Max: AlgebraicInstance {
  public static var referenceInstance: Semigroup<Self> { .init(from: Semilattice(wrapping: .max)) }
}

extension String: AlgebraicInstance {
  public static let referenceInstance = Monoid.string
}
