// MARK: - BinaryOperation

protocol BinaryOperation {
  associatedtype A
  var apply: (A, A) -> A { get }
}

struct Verify<BO: BinaryOperation> where BO.A: Equatable {
  let operation: BO

  init(operation: BO) {
    self.operation = operation
  }

  var run: (BO.A, BO.A) -> BO.A {
    operation.apply
  }
}

// MARK: Associativity

protocol Associative: BinaryOperation {}

extension Verify where BO: Associative {
  func associativity(_ a: BO.A, _ b: BO.A, _ c: BO.A) -> Bool {
    run(run(a, b), c) == run(a, run(b, c))
  }
}

// MARK: Commutativity

protocol Commutative: BinaryOperation {}

extension Verify where BO: Commutative {
  func commutativity(_ a: BO.A, _ b: BO.A) -> Bool {
    run(a, b) == run(b, a)
  }
}

// MARK: Idempotency

protocol Idempotent: BinaryOperation {}

extension Verify where BO: Idempotent {
  func idempotency(_ a: BO.A, _ b: BO.A) -> Bool {
    run(run(a, b), b) == run(a, b)
  }
}

// MARK: Identity

protocol WithIdentity: BinaryOperation {
  var empty: A { get }
}

extension Verify where BO: WithIdentity {
  var id: BO.A {
    operation.empty
  }

  func identity(_ a: BO.A) -> Bool {
    run(a, id) == a && run(id, a) == a
  }
}

// MARK: Invertibility

protocol WithInverse: WithIdentity {
  var inverse: (A) -> A { get }
}

extension Verify where BO: WithInverse {
  var inv: (BO.A) -> BO.A {
    operation.inverse
  }

  func inverse(_ a: BO.A) -> Bool {
    run(a, inv(a)) == id
  }
}

// MARK: - TwoBinaryOperations

protocol TwoBinaryOperations {
  associatedtype A
  associatedtype FirstBinaryOperation: BinaryOperation where FirstBinaryOperation.A == A
  associatedtype SecondBinaryOperation: BinaryOperation where SecondBinaryOperation.A == A

  var first: FirstBinaryOperation { get }
  var second: SecondBinaryOperation { get }
}

struct VerifyTwo<TBO: TwoBinaryOperations> where TBO.A: Equatable {
  private let operations: TBO

  init(operations: TBO) {
    self.operations = operations
  }

  private var runFst: (TBO.A, TBO.A) -> TBO.A {
    operations.first.apply
  }

  private var runSnd: (TBO.A, TBO.A) -> TBO.A {
    operations.second.apply
  }
}

// MARK: Associativity

protocol AssociativeFirst: TwoBinaryOperations where FirstBinaryOperation: Associative {}
protocol AssociativeSecond: TwoBinaryOperations where SecondBinaryOperation: Associative {}
typealias AssociativeBoth = AssociativeFirst & AssociativeSecond

extension VerifyTwo where TBO: AssociativeFirst {
  func associativityOfFirst(_ a: TBO.A, _ b: TBO.A, _ c: TBO.A) -> Bool {
    runFst(runFst(a, b), c) == runFst(a, runFst(b, c))
  }
}

extension VerifyTwo where TBO: AssociativeSecond {
  func associativityOfSecond(_ a: TBO.A, _ b: TBO.A, _ c: TBO.A) -> Bool {
    runSnd(runSnd(a, b), c) == runSnd(a, runSnd(b, c))
  }
}

extension VerifyTwo where TBO: AssociativeBoth {
  func associativity(_ a: TBO.A, _ b: TBO.A, _ c: TBO.A) -> Bool {
    associativityOfFirst(a, b, c) && associativityOfSecond(a, b, c)
  }
}

// MARK: Commutativity

protocol CommutativeFirst: TwoBinaryOperations where FirstBinaryOperation: Commutative {}
protocol CommutativeSecond: TwoBinaryOperations where SecondBinaryOperation: Commutative {}
typealias CommutativeBoth = CommutativeFirst & CommutativeSecond

extension VerifyTwo where TBO: CommutativeFirst {
  func commutativityOfFirst(_ a: TBO.A, _ b: TBO.A) -> Bool {
    runFst(a, b) == runFst(b, a)
  }
}

extension VerifyTwo where TBO: CommutativeSecond {
  func commutativityOfSecond(_ a: TBO.A, _ b: TBO.A) -> Bool {
    runSnd(a, b) == runSnd(b, a)
  }
}

extension VerifyTwo where TBO: CommutativeBoth {
  func commutativity(_ a: TBO.A, _ b: TBO.A) -> Bool {
    commutativityOfFirst(a, b) && commutativityOfSecond(a, b)
  }
}

// MARK: Idempotency

protocol IdempotentFirst: TwoBinaryOperations where FirstBinaryOperation: Idempotent {}
protocol IdempotentSecond: TwoBinaryOperations where SecondBinaryOperation: Idempotent {}
typealias IdempotentBoth = IdempotentFirst & IdempotentSecond

extension VerifyTwo where TBO: IdempotentFirst {
  func idempotencyOfFirst(_ a: TBO.A, _ b: TBO.A) -> Bool {
    runFst(runFst(a, b), b) == runFst(a, b)
  }
}

extension VerifyTwo where TBO: IdempotentSecond {
  func idempotencyOfSecond(_ a: TBO.A, _ b: TBO.A) -> Bool {
    runSnd(runSnd(a, b), b) == runSnd(a, b)
  }
}

extension VerifyTwo where TBO: IdempotentBoth {
  func idempotency(_ a: TBO.A, _ b: TBO.A) -> Bool {
    idempotencyOfFirst(a, b) && idempotencyOfSecond(a, b)
  }
}

// MARK: Distributivity

protocol DistributiveFirstOverSecond: TwoBinaryOperations {}
protocol DistributiveSecondOverFirst: TwoBinaryOperations {}
typealias Distributive = DistributiveFirstOverSecond & DistributiveSecondOverFirst

extension VerifyTwo where TBO: DistributiveFirstOverSecond {
  func distributivityOfFirstOverSecond(_ a: TBO.A, _ b: TBO.A, _ c: TBO.A) -> Bool {
    runFst(a, runSnd(b, c)) == runSnd(runFst(a, b), runFst(a, c))
  }
}

extension VerifyTwo where TBO: DistributiveSecondOverFirst {
  func distributivityOfSecondOverFirst(_ a: TBO.A, _ b: TBO.A, _ c: TBO.A) -> Bool {
    runSnd(a, runFst(b, c)) == runFst(runSnd(a, b), runSnd(a, c))
  }
}

extension VerifyTwo where TBO: Distributive {
  func distributivity(_ a: TBO.A, _ b: TBO.A, _ c: TBO.A) -> Bool {
    distributivityOfFirstOverSecond(a, b, c) && distributivityOfSecondOverFirst(a, b, c)
  }
}

// MARK: Zero identity

protocol WithZero: TwoBinaryOperations where FirstBinaryOperation: WithIdentity {}

extension WithZero {
  var zero: A {
    first.empty
  }
}

extension VerifyTwo where TBO: WithZero {
  private var zero: TBO.A {
    operations.zero
  }

  func zeroIdentity(_ a: TBO.A) -> Bool {
    runFst(a, zero) == a && runFst(zero, a) == a
  }
}

// MARK: Negation

protocol WithNegate: WithZero where FirstBinaryOperation: WithInverse {}

extension WithNegate {
  var negate: (A) -> A {
    first.inverse
  }
}

extension VerifyTwo where TBO: WithNegate {
  private var neg: (TBO.A) -> TBO.A {
    operations.negate
  }

  func negation(_ a: TBO.A) -> Bool {
    runFst(a, neg(a)) == zero && runFst(neg(a), a) == zero
  }
}

// MARK: One identity

protocol WithOne: TwoBinaryOperations where SecondBinaryOperation: WithIdentity {}

extension WithOne {
  var one: A {
    second.empty
  }
}

extension VerifyTwo where TBO: WithOne {
  private var one: TBO.A {
    operations.one
  }

  func oneIdentity(_ a: TBO.A) -> Bool {
    runSnd(a, one) == a && runSnd(one, a) == a
  }
}

// MARK: Reciprocity

protocol WithReciprocal: WithOne where SecondBinaryOperation: WithInverse {}

extension WithReciprocal {
  var reciprocal: (A) -> A {
    second.inverse
  }
}

extension VerifyTwo where TBO: WithReciprocal {
  private var rec: (TBO.A) -> TBO.A {
    operations.reciprocal
  }

  func reciprocity(_ a: TBO.A) -> Bool {
    runSnd(a, rec(a)) == one && runSnd(rec(a), a) == one
  }
}

// MARK: Annihilability

protocol WithAnnihilation: WithZero {}

extension VerifyTwo where TBO: WithAnnihilation {
  func annihilability(_ a: TBO.A) -> Bool {
    runSnd(a, zero) == zero && runSnd(zero, a) == zero
  }
}

// MARK: Absorbability

protocol Absorption: TwoBinaryOperations {}

extension VerifyTwo where TBO: Absorption {
  func absorbability(_ a: TBO.A, _ b: TBO.A) -> Bool {
    runSnd(a, runFst(a, b)) == a
      && runFst(a, runSnd(a, b)) == a
  }
}

// MARK: Implication

protocol WithImplies: LatticeLike, WithOne {
  var implies: (A, A) -> A { get }
}

extension VerifyTwo where TBO: WithImplies {
  private var imp: (TBO.A, TBO.A) -> TBO.A {
    operations.implies
  }

  func implication(_ a: TBO.A, _ b: TBO.A, _ c: TBO.A) -> Bool {
    imp(a, a) == one
      && runSnd(a, imp(a, b)) == runSnd(a, b)
      && runSnd(b, imp(a, b)) == b
      && imp(a, runSnd(b, c)) == runSnd(imp(a, b), imp(a, c))
  }
}

// MARK: Excluded middle

protocol ExcludedMiddle: WithImplies, WithZero {}

extension VerifyTwo where TBO: ExcludedMiddle {
  func excludedMiddle(_ a: TBO.A) -> Bool {
    runFst(a, imp(a, zero)) == one
  }
}

// MARK: - Magma-like

//

// MARK: Semigroup

struct Semigroup<A>: Associative {
  let apply: (A, A) -> A

  init(apply: @escaping (A, A) -> A) {
    self.apply = apply
  }

  init<MoreSpecific: Associative>(from s: MoreSpecific) where MoreSpecific.A == A {
    self.init(apply: s.apply)
  }
}

extension Semigroup {
  static var first: Self {
    Semigroup(apply: { a, _ in a })
  }

  static var last: Self {
    Semigroup(apply: { _, b in b })
  }
}

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

extension Monoid /* where A == Array */ {
  static func array<Element>() -> Self where A == [Element] {
    Monoid(apply: { $0 + $1 }, empty: [])
  }
}

extension Monoid /* where A == (T) -> T */ {
  static func endo<T>() -> Self where A == (T) -> T {
    Monoid(apply: { f1, f2 in { f2(f1($0)) } }, empty: { $0 })
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

extension IdempotentMonoid /* where A == Optional */ {
  static func firstIfPossible<Wrapped>() -> Self where A == Wrapped? {
    IdempotentMonoid(apply: { $0 ?? $1 }, empty: nil)
  }
}

extension IdempotentMonoid /* where A == Optional */ {
  static func lastIfPossible<Wrapped>() -> Self where A == Wrapped? {
    IdempotentMonoid(apply: { $1 ?? $0 }, empty: nil)
  }
}

extension IdempotentMonoid where A == Ordering {
  static var ordering: Self {
    IdempotentMonoid(apply: { A.merge($0, $1) }, empty: A.neutral)
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
  static var lessThan: Self {
    Semilattice(apply: { $0 < $1 ? $0 : $1 })
  }

  static var lessThanOrEqual: Self {
    Semilattice(apply: { $0 <= $1 ? $0 : $1 })
  }

  static var greaterThan: Self {
    Semilattice(apply: { $0 > $1 ? $0 : $1 })
  }

  static var greaterThanOrEqual: Self {
    Semilattice(apply: { $0 >= $1 ? $0 : $1 })
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

typealias RingLike = TwoBinaryOperations
  & AssociativeBoth
  & CommutativeFirst
  & DistributiveSecondOverFirst
  & WithZero
  & WithAnnihilation

extension TwoBinaryOperations where Self: RingLike {
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

typealias LatticeLike = TwoBinaryOperations
  & AssociativeBoth
  & CommutativeBoth
  & IdempotentBoth
  & Absorption

extension TwoBinaryOperations where Self: LatticeLike {
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
