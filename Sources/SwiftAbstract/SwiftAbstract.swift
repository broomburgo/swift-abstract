

// MARK: Monoid

// MARK: Group


// MARK: Commutative Monoid


// MARK: Abelian Group


// MARK: Band


// MARK: Idempotent Monoid


// MARK: Semilattice

struct Semilattice<A>: Associative, Commutative, Idempotent {
  let apply: (A, A) -> A

  init(apply: @escaping (A, A) -> A) {
    self.apply = apply
  }

  init<MoreSpecific: Associative & Commutative & Idempotent>(from s: MoreSpecific) where MoreSpecific.A == A {
    self.init(apply: s.apply)
  }
}

extension Semilattice where A: Comparable {
  static var min: Self {
    Semilattice(apply: { Swift.min($0, $1) })
  }

  static var max: Self {
    Semilattice(apply: { Swift.max($0, $1) })
  }
}

extension Semilattice where A == Bool {
  static var and: Self {
    Semilattice(from: BoundedSemilattice.and)
  }

  static var or: Self {
    Semilattice(from: BoundedSemilattice.or)
  }
}

extension Semilattice /* where A == Set */ {
  /// While this can be useful as the free bounded semilattice, to truly express the algebraic properties of sets, and define a boolean algebra based on them, we actually need `PredicateSet`.
  static func setUnion<Element>() -> Self where A == Set<Element> {
    Semilattice(from: BoundedSemilattice.setUnion())
  }
}

extension Semilattice /* where A == (Input) -> Output */ {
  static func function<Input, Output>(over output: Semilattice<Output>) -> Self where A == (Input) -> Output {
    Semilattice(
      apply: { f1, f2 in
        { input in
          output.apply(f1(input), f2(input))
        }
      }
    )
  }
}

// MARK: Bounded Semilattice

struct BoundedSemilattice<A>: Associative, Commutative, Idempotent, WithIdentity {
  let apply: (A, A) -> A
  let empty: A

  init(apply: @escaping (A, A) -> A, empty: A) {
    self.apply = apply
    self.empty = empty
  }

  init<MoreSpecific: Associative & Commutative & Idempotent & WithIdentity>(from s: MoreSpecific) where MoreSpecific.A == A {
    self.init(apply: s.apply, empty: s.empty)
  }
}

extension BoundedSemilattice where A == Bool {
  static var and: Self {
    BoundedSemilattice(apply: { $0 && $1 }, empty: true)
  }

  static var or: Self {
    BoundedSemilattice(apply: { $0 || $1 }, empty: false)
  }
}

extension BoundedSemilattice where A: Comparable & WithMinimum {
  static var min: Self {
    BoundedSemilattice(apply: { Swift.min($0, $1) }, empty: A.minimum)
  }
}

extension BoundedSemilattice where A: Comparable & WithMaximum {
  static var max: Self {
    BoundedSemilattice(apply: { Swift.max($0, $1) }, empty: A.maximum)
  }
}

extension BoundedSemilattice /* where A == Set */ {
  /// While this can be useful as the free bounded semilattice, to truly express the algebraic properties of sets, and define a boolean algebra based on them, we actually need `PredicateSet`.
  static func setUnion<Element>() -> Self where A == Set<Element> {
    BoundedSemilattice(apply: { $0.union($1) }, empty: [])
  }
}

extension BoundedSemilattice /* where A == (Input) -> Output */ {
  static func function<Input, Output>(over output: BoundedSemilattice<Output>) -> Self where A == (Input) -> Output {
    BoundedSemilattice(
      apply: { f1, f2 in
        { input in
          output.apply(f1(input), f2(input))
        }
      },
      empty: { _ in output.empty }
    )
  }
}

// MARK: - Ring-like

typealias RingLike = WithTwoBinaryOperations
  & AssociativeBoth
  & CommutativeFirst
  & DistributiveSecondOverFirst
  & WithZero
  & WithAnnihilation

extension WithTwoBinaryOperations where Self: RingLike {
  typealias PlusBinaryOperation = FirstBinaryOperation
  typealias TimesBinaryOperation = SecondBinaryOperation

  var plus: (A, A) -> A { first.apply }
  var times: (A, A) -> A { second.apply }
}

// MARK: Semiring

struct Semiring<A>: RingLike, WithOne {
  let first: CommutativeMonoid<A>
  let second: Monoid<A>
}

extension Semiring where A: AdditiveArithmetic & Comparable & WithMinimum {
  static var minTropical: Self {
    Semiring(
      first: .init(from: BoundedSemilattice.min),
      second: .init(from: CommutativeMonoid.sum)
    )
  }
}

extension Semiring where A: AdditiveArithmetic & Comparable & WithMaximum {
  static var maxTropical: Self {
    Semiring(
      first: .init(from: BoundedSemilattice.max),
      second: .init(from: CommutativeMonoid.sum)
    )
  }
}

// MARK: Rng

struct Rng<A>: RingLike, WithNegate {
  let first: AbelianGroup<A>
  let second: Semigroup<A>
}

// MARK: Commutative Semiring

struct CommutativeSemiring<A>: RingLike, WithOne, CommutativeSecond {
  let first: CommutativeMonoid<A>
  let second: CommutativeMonoid<A>
}

// MARK: Ring

struct Ring<A>: RingLike, WithOne, WithNegate {
  let first: AbelianGroup<A>
  let second: Monoid<A>
}

// MARK: Commutative Ring

struct CommutativeRing<A>: RingLike, WithOne, WithNegate, CommutativeSecond {
  let first: AbelianGroup<A>
  let second: CommutativeMonoid<A>
}

// MARK: Field

struct Field<A>: RingLike, WithOne, WithNegate, CommutativeSecond, WithReciprocal {
  let first: AbelianGroup<A>
  let second: AbelianGroup<A>
}

// MARK: - Lattice-like

public typealias LatticeLike = WithTwoBinaryOperations
  & AssociativeBoth
  & CommutativeBoth
  & IdempotentBoth
  & Absorption

extension WithTwoBinaryOperations where Self: LatticeLike {
  typealias MeetBinaryOperation = FirstBinaryOperation
  typealias JoinBinaryOperation = SecondBinaryOperation

  var join: (A, A) -> A { first.apply } /// ~ OR
  var meet: (A, A) -> A { second.apply } /// ~ AND
}

// MARK: Lattice

struct Lattice<A>: LatticeLike {
  let first: Semilattice<A>
  let second: Semilattice<A>
}

// MARK: Distributive Lattice

struct DistributiveLattice<A>: LatticeLike, Distributive {
  let first: Semilattice<A>
  let second: Semilattice<A>
}

// MARK: Bounded Lattice

struct BoundedLattice<A>: LatticeLike, WithZero, WithOne {
  let first: BoundedSemilattice<A>
  let second: BoundedSemilattice<A>
}

// MARK: Bounded Distributive Lattice

struct BoundedDistributiveLattice<A>: LatticeLike, Distributive, WithZero, WithOne {
  let first: BoundedSemilattice<A>
  let second: BoundedSemilattice<A>
}

// MARK: Heyting

struct Heyting<A>: LatticeLike, Distributive, WithZero, WithOne, WithImplies {
  let first: BoundedSemilattice<A>
  let second: BoundedSemilattice<A>
  let implies: (A, A) -> A
}

// MARK: Boolean

struct Boolean<A>: LatticeLike, Distributive, WithZero, WithOne, WithImplies, ExcludedMiddle {
  let first: BoundedSemilattice<A>
  let second: BoundedSemilattice<A>
  let implies: (A, A) -> A
}

extension Boolean where A == Bool {
  static var bool: Self {
    Boolean(
      first: .or,
      second: .and,
      implies: { !$0 || $1 }
    )
  }
}

// MARK: - Extra types

enum Ordering {
  case lowerThan
  case equalTo
  case greaterThan

  static func merge(_ lhs: Self, _ rhs: Self) -> Self {
    switch lhs {
    case .lowerThan, .greaterThan:
      return lhs
    case .equalTo:
      return rhs
    }
  }
}

// MARK: - Utility protocols

protocol WithMinimum {
  static var minimum: Self { get }
}

protocol WithMaximum {
  static var maximum: Self { get }
}

extension Int8: WithMinimum {
  static let minimum = min
}

extension Int8: WithMaximum {
  static let maximum = max
}

extension Int16: WithMinimum {
  static let minimum = min
}

extension Int16: WithMaximum {
  static let maximum = max
}

extension Int32: WithMinimum {
  static let minimum = min
}

extension Int32: WithMaximum {
  static let maximum = max
}

extension Int64: WithMinimum {
  static let minimum = min
}

extension Int64: WithMaximum {
  static let maximum = max
}

extension UInt: WithMinimum {
  static let minimum = min
}

extension UInt: WithMaximum {
  static let maximum = max
}

extension Float: WithMinimum {
  static let minimum = -infinity
}

extension Float: WithMaximum {
  static let maximum = infinity
}

extension Double: WithMinimum {
  static let minimum = -infinity
}

extension Double: WithMaximum {
  static let maximum = infinity
}
