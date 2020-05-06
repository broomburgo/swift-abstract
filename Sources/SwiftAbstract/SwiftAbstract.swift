// MARK: Commutative Semigroup

struct CommutativeSemigroup<A>: Associative, Commutative {
  let apply: (A, A) -> A

  init(apply: @escaping (A, A) -> A) {
    self.apply = apply
  }

  init<MoreSpecific: Associative & Commutative>(from s: MoreSpecific) where MoreSpecific.A == A {
    self.init(apply: s.apply)
  }
}

extension CommutativeSemigroup where A: Comparable {
  static var max: Self {
    CommutativeSemigroup(apply: { Swift.max($0, $1) })
  }

  static var min: Self {
    CommutativeSemigroup(apply: { Swift.min($0, $1) })
  }
}

extension CommutativeSemigroup /* where A == (Input) -> Output */ {
  static func function<Input, Output>(over output: CommutativeSemigroup<Output>) -> Self where A == (Input) -> Output {
    CommutativeSemigroup(
      apply: { f1, f2 in
        { input in
          output.apply(f1(input), f2(input))
        }
      }
    )
  }
}

// MARK: Monoid

struct Monoid<A>: Associative, WithIdentity {
  let apply: (A, A) -> A
  let empty: A

  init(apply: @escaping (A, A) -> A, empty: A) {
    self.apply = apply
    self.empty = empty
  }

  init<MoreSpecific: Associative & WithIdentity>(from s: MoreSpecific) where MoreSpecific.A == A {
    self.init(apply: s.apply, empty: s.empty)
  }
}

extension Monoid where A == String {
  static var string: Self {
    Monoid(apply: { $0 + $1 }, empty: "")
  }
}

extension Monoid where A: AdditiveArithmetic {
  static var sum: Self {
    Monoid(from: CommutativeMonoid.sum)
  }
}

extension Monoid where A: Numeric & ExpressibleByIntegerLiteral {
  static var product: Self {
    Monoid(from: CommutativeMonoid.product)
  }
}

extension Monoid /* where A == Array */ {
  static func array<Element>() -> Self where A == Array<Element> {
    Monoid(apply: { $0 + $1 }, empty: [])
  }
}

extension Monoid /* where A == (T) -> T */ {
  static func endo<T>() -> Self where A == (T) -> T {
    Monoid(apply: { f1, f2 in { f2(f1($0)) } }, empty: { $0 })
  }
}

extension Monoid /* where A == (Input) -> Output */ {
  static func function<Input, Output>(over output: Monoid<Output>) -> Self where A == (Input) -> Output {
    Monoid(
      apply: { f1, f2 in
        { input in
          output.apply(f1(input), f2(input))
        }
      },
      empty: { _ in output.empty }
    )
  }
}

// MARK: Group

struct Group<A>: Associative, WithIdentity, WithInverse {
  let apply: (A, A) -> A
  let empty: A
  let inverse: (A) -> A

  init(apply: @escaping (A, A) -> A, empty: A, inverse: @escaping (A) -> A) {
    self.apply = apply
    self.empty = empty
    self.inverse = inverse
  }

  init<MoreSpecific: Associative & WithIdentity & WithInverse>(from s: MoreSpecific) where MoreSpecific.A == A {
    self.init(apply: s.apply, empty: s.empty, inverse: s.inverse)
  }
}

extension Group where A: SignedNumeric {
  static var sum: Self {
    Group(from: AbelianGroup.sum)
  }
}

extension Group where A: FloatingPoint & ExpressibleByIntegerLiteral {
  static var product: Self {
    Group(from: AbelianGroup.product)
  }
}

extension Group /* where A == (Input) -> Output */ {
  static func function<Input, Output>(over output: Group<Output>) -> Self where A == (Input) -> Output {
    Group(
      apply: { f1, f2 in
        { input in
          output.apply(f1(input), f2(input))
        }
      },
      empty: { _ in output.empty },
      inverse: { f in
        { input in
          output.inverse(f(input))
        }
      }
    )
  }
}

// MARK: Commutative Monoid

struct CommutativeMonoid<A>: Associative, Commutative, WithIdentity {
  let apply: (A, A) -> A
  let empty: A

  init(apply: @escaping (A, A) -> A, empty: A) {
    self.apply = apply
    self.empty = empty
  }

  init<MoreSpecific: Associative & Commutative & WithIdentity>(from s: MoreSpecific) where MoreSpecific.A == A {
    self.init(apply: s.apply, empty: s.empty)
  }
}

extension CommutativeMonoid where A: AdditiveArithmetic {
  static var sum: Self {
    CommutativeMonoid(apply: { $0 + $1 }, empty: A.zero)
  }
}

extension CommutativeMonoid where A: Numeric & ExpressibleByIntegerLiteral {
  static var product: Self {
    CommutativeMonoid(apply: { $0 * $1 }, empty: 1)
  }
}

extension CommutativeMonoid /* where A == (Input) -> Output */ {
  static func function<Input, Output>(over output: CommutativeMonoid<Output>) -> Self where A == (Input) -> Output {
    CommutativeMonoid(
      apply: { f1, f2 in
        { input in
          output.apply(f1(input), f2(input))
        }
      },
      empty: { _ in output.empty }
    )
  }
}

// MARK: Abelian Group

struct AbelianGroup<A>: Associative, Commutative, WithIdentity, WithInverse {
  let apply: (A, A) -> A
  let empty: A
  let inverse: (A) -> A

  init(apply: @escaping (A, A) -> A, empty: A, inverse: @escaping (A) -> A) {
    self.apply = apply
    self.empty = empty
    self.inverse = inverse
  }

  init<MoreSpecific: Associative & Commutative & WithIdentity & WithInverse>(from s: MoreSpecific) where MoreSpecific.A == A {
    self.init(apply: s.apply, empty: s.empty, inverse: s.inverse)
  }
}

extension AbelianGroup where A: SignedNumeric {
  static var sum: Self {
    AbelianGroup(apply: { $0 + $1 }, empty: A.zero, inverse: { -$0 })
  }
}

extension AbelianGroup where A: FloatingPoint & ExpressibleByIntegerLiteral {
  static var product: Self {
    AbelianGroup(apply: { $0 * $1 }, empty: 1, inverse: { 1 / $0 })
  }
}

extension AbelianGroup /* where A == (Input) -> Output */ {
  static func function<Input, Output>(over output: AbelianGroup<Output>) -> Self where A == (Input) -> Output {
    AbelianGroup(
      apply: { f1, f2 in
        { input in
          output.apply(f1(input), f2(input))
        }
      },
      empty: { _ in output.empty },
      inverse: { f in
        { input in
          output.inverse(f(input))
        }
      }
    )
  }
}

// MARK: Band

struct Band<A>: Associative, Idempotent {
  let apply: (A, A) -> A

  init(apply: @escaping (A, A) -> A) {
    self.apply = apply
  }

  init<MoreSpecific: Associative & Idempotent>(from s: MoreSpecific) where MoreSpecific.A == A {
    self.init(apply: s.apply)
  }
}

extension Band where A == Ordering {
  static var ordering: Self {
    Band(from: IdempotentMonoid.ordering)
  }
}

extension Band where A: Comparable {
  static var min: Self {
    Band(from: Semilattice.min)
  }

  static var max: Self {
    Band(from: Semilattice.max)
  }
}

extension Band where A == Bool {
  static var and: Self {
    Band(from: IdempotentMonoid.and)
  }

  static var or: Self {
    Band(from: IdempotentMonoid.or)
  }
}

extension Band /* where A == Set */ {
  /// While this can be useful as the free bounded semilattice, to truly express the algebraic properties of sets, and define a boolean algebra based on them, we actually need `PredicateSet`.
  static func setUnion<Element>() -> Self where A == Set<Element> {
    Band(from: Semilattice.setUnion())
  }
}

extension Band /* where A == Optional */ {
  static func firstIfPossible<Wrapped>() -> Self where A == Optional<Wrapped> {
    Band(from: IdempotentMonoid.firstIfPossible())
  }
}

extension Band /* where A == Optional */ {
  static func lastIfPossible<Wrapped>() -> Self where A == Optional<Wrapped> {
    Band(from: IdempotentMonoid.lastIfPossible())
  }
}

extension Band /* where A == (Input) -> Output */ {
  static func function<Input, Output>(over output: Band<Output>) -> Self where A == (Input) -> Output {
    Band(
      apply: { f1, f2 in
        { input in
          output.apply(f1(input), f2(input))
        }
      }
    )
  }
}

// MARK: Idempotent Monoid

struct IdempotentMonoid<A>: Associative, Idempotent, WithIdentity {
  let apply: (A, A) -> A
  let empty: A

  init(apply: @escaping (A, A) -> A, empty: A) {
    self.apply = apply
    self.empty = empty
  }

  init<MoreSpecific: Associative & Idempotent & WithIdentity>(from s: MoreSpecific) where MoreSpecific.A == A {
    self.init(apply: s.apply, empty: s.empty)
  }
}

extension IdempotentMonoid where A == Bool {
  static var and: Self {
    IdempotentMonoid(from: BoundedSemilattice.and)
  }

  static var or: Self {
    IdempotentMonoid(from: BoundedSemilattice.or)
  }
}

extension IdempotentMonoid where A == Ordering {
  static var ordering: Self {
    IdempotentMonoid(apply: { A.merge($0, $1) }, empty: A.neutral)
  }
}

extension IdempotentMonoid /* where A == Optional */ {
  static func firstIfPossible<Wrapped>() -> Self where A == Optional<Wrapped> {
    IdempotentMonoid(apply: { $0 ?? $1 }, empty: nil)
  }
}

extension IdempotentMonoid /* where A == Optional */ {
  static func lastIfPossible<Wrapped>() -> Self where A == Optional<Wrapped> {
    IdempotentMonoid(apply: { $1 ?? $0 }, empty: nil)
  }
}

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

  static var neutral: Self {
    .equalTo
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
