protocol AlgebraicInstance {
  associatedtype ReferenceStructure: AlgebraicStructure where ReferenceStructure.A == Self
  static var referenceInstance: ReferenceStructure { get }
}

struct Abstract<Structure> where Structure: AlgebraicStructure {
  private var instance: Structure
  init(_ instance: Structure) {
    self.instance = instance
  }
}

extension AlgebraicInstance {
  static var abstract: Abstract<ReferenceStructure> {
    .init(referenceInstance)
  }
}

// MARK: - Wrapper

protocol Wrapper {
  associatedtype Wrapped
  init(_ wrapped: Wrapped)
  var wrapped: Wrapped { get }
}

// MARK: - Magma

extension Abstract where
  Structure: Associative & Commutative & Identity & Invertible
{
  var abelianGroup: AbelianGroup<Structure.A> {
    .init(from: instance)
  }
}

extension Abstract where
  Structure: Associative & Idempotent
{
  var band: Band<Structure.A> {
    .init(from: instance)
  }
}

extension Abstract where
  Structure: Associative & Commutative & Idempotent & Identity
{
  var boundedSemilattice: BoundedSemilattice<Structure.A> {
    .init(from: instance)
  }
}

extension Abstract where
  Structure: Associative & Commutative & Identity
{
  var commutativeMonoid: CommutativeMonoid<Structure.A> {
    .init(from: instance)
  }
}

extension Abstract where
  Structure: Associative & Commutative
{
  var commutativeSemigroup: CommutativeSemigroup<Structure.A> {
    .init(from: instance)
  }
}

extension Abstract where
  Structure: Associative & Identity & Invertible
{
  var group: Group<Structure.A> {
    .init(from: instance)
  }
}

extension Abstract where
  Structure: Associative & Idempotent & Identity
{
  var idempotentMonoid: IdempotentMonoid<Structure.A> {
    .init(from: instance)
  }
}

extension Abstract where
  Structure: Associative & Identity
{
  var monoid: Monoid<Structure.A> {
    .init(from: instance)
  }
}

extension Abstract where
  Structure: Associative
{
  var semigroup: Semigroup<Structure.A> {
    .init(from: instance)
  }
}

extension Abstract where
  Structure: Associative & Commutative & Idempotent
{
  var semilattice: Semilattice<Structure.A> {
    .init(from: instance)
  }
}

// MARK: - Ring-like

extension Abstract where
  Structure: RingLike & WithOne & WithNegate,
  Structure.Second: Commutative
{
  var commutativeRing: CommutativeRing<Structure.A> {
    .init(from: instance)
  }
}

extension Abstract where
  Structure: RingLike & WithOne,
  Structure.Second: Commutative
{
  var commutativeSemiring: CommutativeSemiring<Structure.A> {
    .init(from: instance)
  }
}

extension Abstract where
  Structure: RingLike & WithOne & WithNegate & WithReciprocal,
  Structure.Second: Commutative
{
  var field: Field<Structure.A> {
    .init(from: instance)
  }
}

extension Abstract where
  Structure: RingLike & WithOne & WithNegate
{
  var ring: Ring<Structure.A> {
    .init(from: instance)
  }
}

extension Abstract where
  Structure: RingLike & WithNegate
{
  var rng: Rng<Structure.A> {
    .init(from: instance)
  }
}

extension Abstract where
  Structure: RingLike & WithOne
{
  var semiring: Semiring<Structure.A> {
    .init(from: instance)
  }
}

// MARK: - Lattice-like

extension Abstract where
  Structure: LatticeLike & Distributive & WithZero & WithOne & WithImplies & ExcludedMiddle
{
  var boolean: Boolean<Structure.A> {
    .init(from: instance)
  }
}

extension Abstract where
  Structure: LatticeLike & Distributive & WithZero & WithOne
{
  var boundedDistributiveLattice: BoundedDistributiveLattice<Structure.A> {
    .init(from: instance)
  }
}

extension Abstract where
  Structure: LatticeLike & WithZero & WithOne
{
  var boundedLattice: BoundedLattice<Structure.A> {
    .init(from: instance)
  }
}

extension Abstract where
  Structure: LatticeLike & Distributive
{
  var distributiveLattice: DistributiveLattice<Structure.A> {
    .init(from: instance)
  }
}

extension Abstract where
  Structure: LatticeLike & Distributive & WithZero & WithOne & WithImplies
{
  var heyting: Heyting<Structure.A> {
    .init(from: instance)
  }
}

extension Abstract where
  Structure: LatticeLike
{
  var lattice: Lattice<Structure.A> {
    .init(from: instance)
  }
}

// MARK: - Instances

extension Sequence where
  Element: AlgebraicInstance,
  Element.ReferenceStructure: Associative & Identity
{
  func concat() -> Element {
    let instance = Element.abstract.monoid
    return reduce(instance.empty, instance.apply)
  }
}

struct Sum<Wrapped>: Wrapper where Wrapped: SignedNumeric {
  var wrapped: Wrapped

  init(_ wrapped: Wrapped) {
    self.wrapped = wrapped
  }
}

extension Sum: AlgebraicInstance {
  static var referenceInstance: AbelianGroup<Self> { .init(wrapping: .addition) }
}

struct Max<Wrapped>: Wrapper where Wrapped: Comparable {
  var wrapped: Wrapped

  init(_ wrapped: Wrapped) {
    self.wrapped = wrapped
  }
}

extension Max: AlgebraicInstance {
  static var referenceInstance: Semigroup<Self> { .init(from: Semilattice(wrapping: .max)) }
}

extension String: AlgebraicInstance {
  static let referenceInstance = Monoid.string
}
