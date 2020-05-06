// MARK: - Algebraic structure

protocol AlgebraicStructure {
  associatedtype A
}

// MARK: - One binary operation

protocol WithOneBinaryOperation: AlgebraicStructure {
  var apply: (A, A) -> A { get }
}

struct VerifyOne<OneBO: WithOneBinaryOperation> where OneBO.A: Equatable {
  let operation: OneBO

  init(operation: OneBO) {
    self.operation = operation
  }

  var run: (OneBO.A, OneBO.A) -> OneBO.A {
    operation.apply
  }
}

// MARK: Associativity

protocol Associative: WithOneBinaryOperation {}

extension VerifyOne where OneBO: Associative {
  func associativity(_ a: OneBO.A, _ b: OneBO.A, _ c: OneBO.A) -> Bool {
    run(run(a, b), c) == run(a, run(b, c))
  }
}

// MARK: Commutativity

protocol Commutative: WithOneBinaryOperation {}

extension VerifyOne where OneBO: Commutative {
  func commutativity(_ a: OneBO.A, _ b: OneBO.A) -> Bool {
    run(a, b) == run(b, a)
  }
}

// MARK: Idempotency

protocol Idempotent: WithOneBinaryOperation {}

extension VerifyOne where OneBO: Idempotent {
  func idempotency(_ a: OneBO.A, _ b: OneBO.A) -> Bool {
    run(run(a, b), b) == run(a, b)
  }
}

// MARK: Identity

protocol WithIdentity: WithOneBinaryOperation {
  var empty: A { get }
}

extension VerifyOne where OneBO: WithIdentity {
  var id: OneBO.A {
    operation.empty
  }

  func identity(_ a: OneBO.A) -> Bool {
    run(a, id) == a && run(id, a) == a
  }
}

// MARK: Invertibility

protocol WithInverse: WithIdentity {
  var inverse: (A) -> A { get }
}

extension VerifyOne where OneBO: WithInverse {
  var inv: (OneBO.A) -> OneBO.A {
    operation.inverse
  }

  func inverse(_ a: OneBO.A) -> Bool {
    run(a, inv(a)) == id
  }
}

// MARK: - Two binary operations

protocol WithTwoBinaryOperations: AlgebraicStructure {
  associatedtype FirstBinaryOperation: WithOneBinaryOperation where FirstBinaryOperation.A == A
  associatedtype SecondBinaryOperation: WithOneBinaryOperation where SecondBinaryOperation.A == A

  var first: FirstBinaryOperation { get }
  var second: SecondBinaryOperation { get }
}

struct VerifyTwo<TwoBO: WithTwoBinaryOperations> where TwoBO.A: Equatable {
  private let operations: TwoBO

  init(operations: TwoBO) {
    self.operations = operations
  }

  private var runFst: (TwoBO.A, TwoBO.A) -> TwoBO.A {
    operations.first.apply
  }

  private var runSnd: (TwoBO.A, TwoBO.A) -> TwoBO.A {
    operations.second.apply
  }
}

// MARK: Associativity

protocol AssociativeFirst: WithTwoBinaryOperations where FirstBinaryOperation: Associative {}
protocol AssociativeSecond: WithTwoBinaryOperations where SecondBinaryOperation: Associative {}
typealias AssociativeBoth = AssociativeFirst & AssociativeSecond

extension VerifyTwo where TwoBO: AssociativeFirst {
  func associativityOfFirst(_ a: TwoBO.A, _ b: TwoBO.A, _ c: TwoBO.A) -> Bool {
    runFst(runFst(a, b), c) == runFst(a, runFst(b, c))
  }
}

extension VerifyTwo where TwoBO: AssociativeSecond {
  func associativityOfSecond(_ a: TwoBO.A, _ b: TwoBO.A, _ c: TwoBO.A) -> Bool {
    runSnd(runSnd(a, b), c) == runSnd(a, runSnd(b, c))
  }
}

extension VerifyTwo where TwoBO: AssociativeBoth {
  func associativity(_ a: TwoBO.A, _ b: TwoBO.A, _ c: TwoBO.A) -> Bool {
    associativityOfFirst(a, b, c) && associativityOfSecond(a, b, c)
  }
}

// MARK: Commutativity

protocol CommutativeFirst: WithTwoBinaryOperations where FirstBinaryOperation: Commutative {}
protocol CommutativeSecond: WithTwoBinaryOperations where SecondBinaryOperation: Commutative {}
typealias CommutativeBoth = CommutativeFirst & CommutativeSecond

extension VerifyTwo where TwoBO: CommutativeFirst {
  func commutativityOfFirst(_ a: TwoBO.A, _ b: TwoBO.A) -> Bool {
    runFst(a, b) == runFst(b, a)
  }
}

extension VerifyTwo where TwoBO: CommutativeSecond {
  func commutativityOfSecond(_ a: TwoBO.A, _ b: TwoBO.A) -> Bool {
    runSnd(a, b) == runSnd(b, a)
  }
}

extension VerifyTwo where TwoBO: CommutativeBoth {
  func commutativity(_ a: TwoBO.A, _ b: TwoBO.A) -> Bool {
    commutativityOfFirst(a, b) && commutativityOfSecond(a, b)
  }
}

// MARK: Idempotency

protocol IdempotentFirst: WithTwoBinaryOperations where FirstBinaryOperation: Idempotent {}
protocol IdempotentSecond: WithTwoBinaryOperations where SecondBinaryOperation: Idempotent {}
typealias IdempotentBoth = IdempotentFirst & IdempotentSecond

extension VerifyTwo where TwoBO: IdempotentFirst {
  func idempotencyOfFirst(_ a: TwoBO.A, _ b: TwoBO.A) -> Bool {
    runFst(runFst(a, b), b) == runFst(a, b)
  }
}

extension VerifyTwo where TwoBO: IdempotentSecond {
  func idempotencyOfSecond(_ a: TwoBO.A, _ b: TwoBO.A) -> Bool {
    runSnd(runSnd(a, b), b) == runSnd(a, b)
  }
}

extension VerifyTwo where TwoBO: IdempotentBoth {
  func idempotency(_ a: TwoBO.A, _ b: TwoBO.A) -> Bool {
    idempotencyOfFirst(a, b) && idempotencyOfSecond(a, b)
  }
}

// MARK: Distributivity

protocol DistributiveFirstOverSecond: WithTwoBinaryOperations {}
protocol DistributiveSecondOverFirst: WithTwoBinaryOperations {}
typealias Distributive = DistributiveFirstOverSecond & DistributiveSecondOverFirst

extension VerifyTwo where TwoBO: DistributiveFirstOverSecond {
  func distributivityOfFirstOverSecond(_ a: TwoBO.A, _ b: TwoBO.A, _ c: TwoBO.A) -> Bool {
    runFst(a, runSnd(b, c)) == runSnd(runFst(a, b), runFst(a, c))
  }
}

extension VerifyTwo where TwoBO: DistributiveSecondOverFirst {
  func distributivityOfSecondOverFirst(_ a: TwoBO.A, _ b: TwoBO.A, _ c: TwoBO.A) -> Bool {
    runSnd(a, runFst(b, c)) == runFst(runSnd(a, b), runSnd(a, c))
  }
}

extension VerifyTwo where TwoBO: Distributive {
  func distributivity(_ a: TwoBO.A, _ b: TwoBO.A, _ c: TwoBO.A) -> Bool {
    distributivityOfFirstOverSecond(a, b, c) && distributivityOfSecondOverFirst(a, b, c)
  }
}

// MARK: Zero identity

protocol WithZero: WithTwoBinaryOperations where FirstBinaryOperation: WithIdentity {}

extension WithZero {
  var zero: A {
    first.empty
  }
}

extension VerifyTwo where TwoBO: WithZero {
  private var zero: TwoBO.A {
    operations.zero
  }

  func zeroIdentity(_ a: TwoBO.A) -> Bool {
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

extension VerifyTwo where TwoBO: WithNegate {
  private var neg: (TwoBO.A) -> TwoBO.A {
    operations.negate
  }

  func negation(_ a: TwoBO.A) -> Bool {
    runFst(a, neg(a)) == zero && runFst(neg(a), a) == zero
  }
}

// MARK: One identity

protocol WithOne: WithTwoBinaryOperations where SecondBinaryOperation: WithIdentity {}

extension WithOne {
  var one: A {
    second.empty
  }
}

extension VerifyTwo where TwoBO: WithOne {
  private var one: TwoBO.A {
    operations.one
  }

  func oneIdentity(_ a: TwoBO.A) -> Bool {
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

extension VerifyTwo where TwoBO: WithReciprocal {
  private var rec: (TwoBO.A) -> TwoBO.A {
    operations.reciprocal
  }

  func reciprocity(_ a: TwoBO.A) -> Bool {
    runSnd(a, rec(a)) == one && runSnd(rec(a), a) == one
  }
}

// MARK: Annihilability

protocol WithAnnihilation: WithZero {}

extension VerifyTwo where TwoBO: WithAnnihilation {
  func annihilability(_ a: TwoBO.A) -> Bool {
    runSnd(a, zero) == zero && runSnd(zero, a) == zero
  }
}

// MARK: Absorbability

protocol Absorption: WithTwoBinaryOperations {}

extension VerifyTwo where TwoBO: Absorption {
  func absorbability(_ a: TwoBO.A, _ b: TwoBO.A) -> Bool {
    runSnd(a, runFst(a, b)) == a
      && runFst(a, runSnd(a, b)) == a
  }
}

// MARK: Implication

protocol WithImplies: LatticeLike, WithOne {
  var implies: (A, A) -> A { get }
}

extension VerifyTwo where TwoBO: WithImplies {
  private var imp: (TwoBO.A, TwoBO.A) -> TwoBO.A {
    operations.implies
  }

  func implication(_ a: TwoBO.A, _ b: TwoBO.A, _ c: TwoBO.A) -> Bool {
    imp(a, a) == one
      && runSnd(a, imp(a, b)) == runSnd(a, b)
      && runSnd(b, imp(a, b)) == b
      && imp(a, runSnd(b, c)) == runSnd(imp(a, b), imp(a, c))
  }
}

// MARK: Excluded middle

protocol ExcludedMiddle: WithImplies, WithZero {}

extension VerifyTwo where TwoBO: ExcludedMiddle {
  func excludedMiddle(_ a: TwoBO.A) -> Bool {
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

extension Semigroup where A: Comparable {
  static var max: Self {
    Semigroup(from: CommutativeSemigroup.max)
  }

  static var min: Self {
    Semigroup(from: CommutativeSemigroup.min)
  }
}

extension Semigroup where A == String {
  static var string: Self {
    Semigroup(from: Monoid.string)
  }
}

extension Semigroup where A: SignedNumeric {
  static var sum: Self {
    Semigroup(from: Monoid.sum)
  }
}

extension Semigroup where A: FloatingPoint & ExpressibleByIntegerLiteral {
  static var product: Self {
    Semigroup(from: Monoid.product)
  }
}

extension Semigroup /* where A == Array */ {
  static func array<Element>() -> Self where A == Array<Element> {
    Semigroup(from: Monoid.array())
  }
}

extension Semigroup /* where A == (T) -> T */ {
  static func endo<T>() -> Self where A == (T) -> T {
    Semigroup(from: Monoid.endo())
  }
}

extension Semigroup /* where A == (Input) -> Output */ {
  static func function<Input, Output>(over output: Semigroup<Output>) -> Self where A == (Input) -> Output {
    Semigroup(
      apply: { f1, f2 in
        { input in
          output.apply(f1(input), f2(input))
        }
      }
    )
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

extension Monoid where A: SignedNumeric {
  static var sum: Self {
    Monoid(from: Group.sum)
  }
}

extension Monoid where A: FloatingPoint & ExpressibleByIntegerLiteral {
  static var product: Self {
    Monoid(from: Group.product)
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
    Band(from: Semilattice.and)
  }

  static var or: Self {
    Band(from: Semilattice.or)
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

typealias LatticeLike = WithTwoBinaryOperations
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
