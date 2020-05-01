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

  var firstApply: (A, A) -> A { get }
  var secondApply: (A, A) -> A { get }
  init(forFirst: FirstBinaryOperation, forSecond: SecondBinaryOperation)
}

struct VerifyTwo<TBO: TwoBinaryOperations> where TBO.A: Equatable {
  let operations: TBO

  init(operations: TBO) {
    self.operations = operations
  }

  var runFst: (TBO.A, TBO.A) -> TBO.A {
    operations.firstApply
  }

  var runSnd: (TBO.A, TBO.A) -> TBO.A {
    operations.secondApply
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

protocol WithZero: TwoBinaryOperations where FirstBinaryOperation: WithIdentity {
  var zero: A { get }
}

extension VerifyTwo where TBO: WithZero {
  var zero: TBO.A {
    operations.zero
  }
  
  func zeroIdentity(_ a: TBO.A) -> Bool {
    runFst(a, zero) == a && runFst(zero, a) == a
  }
}

// MARK: Negation

protocol WithNegate: WithZero where FirstBinaryOperation: WithInverse {
  var negate: (A) -> A { get }
}

extension VerifyTwo where TBO: WithNegate {
  var neg: (TBO.A) -> TBO.A {
    operations.negate
  }
  
  func negation(_ a: TBO.A) -> Bool {
    runFst(a, neg(a)) == zero && runFst(neg(a), a) == zero
  }
}

// MARK: One identity

protocol WithOne: TwoBinaryOperations where SecondBinaryOperation: WithIdentity {
  var one: A { get }
}

extension VerifyTwo where TBO: WithOne {
  var one: TBO.A {
    operations.one
  }
  
  func oneIdentity(_ a: TBO.A) -> Bool {
    runSnd(a, one) == a && runSnd(one, a) == a
  }
}

// MARK: Reciprocity

protocol WithReciprocal: WithOne where SecondBinaryOperation: WithInverse {
  var reciprocal: (A) -> A { get }
}

extension VerifyTwo where TBO: WithReciprocal {
  var rec: (TBO.A) -> TBO.A {
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

// MARK: - Magma-like

//

// MARK: Semigroup

struct Semigroup<A>: Associative {
  let apply: (A, A) -> A

  init(apply: @escaping (A, A) -> A) {
    self.apply = apply
  }

  init<MoreSpecific: Associative>(_ s: MoreSpecific) where MoreSpecific.A == A {
    self.init(apply: s.apply)
  }
}

// MARK: Commutative Semigroup

struct CommutativeSemigroup<A>: Associative, Commutative {
  let apply: (A, A) -> A

  init(apply: @escaping (A, A) -> A) {
    self.apply = apply
  }

  init<MoreSpecific: Associative & Commutative>(_ s: MoreSpecific) where MoreSpecific.A == A {
    self.init(apply: s.apply)
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

  init<MoreSpecific: Associative & WithIdentity>(_ s: MoreSpecific) where MoreSpecific.A == A {
    self.init(apply: s.apply, empty: s.empty)
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

  init<MoreSpecific: Associative & WithIdentity & WithInverse>(_ s: MoreSpecific) where MoreSpecific.A == A {
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

  init<MoreSpecific: Associative & Commutative & WithIdentity>(_ s: MoreSpecific) where MoreSpecific.A == A {
    self.init(apply: s.apply, empty: s.empty)
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

  init<MoreSpecific: Associative & Commutative & WithIdentity & WithInverse>(_ s: MoreSpecific) where MoreSpecific.A == A {
    self.init(apply: s.apply, empty: s.empty, inverse: s.inverse)
  }
}

// MARK: Band

struct Band<A>: Associative, Idempotent {
  let apply: (A, A) -> A

  init(apply: @escaping (A, A) -> A) {
    self.apply = apply
  }

  init<MoreSpecific: Associative & Idempotent>(_ s: MoreSpecific) where MoreSpecific.A == A {
    self.init(apply: s.apply)
  }
}

// MARK: Semilattice

struct Semilattice<A>: Associative, Commutative, Idempotent {
  let apply: (A, A) -> A

  init(apply: @escaping (A, A) -> A) {
    self.apply = apply
  }

  init<MoreSpecific: Associative & Commutative & Idempotent>(_ s: MoreSpecific) where MoreSpecific.A == A {
    self.init(apply: s.apply)
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

  init<MoreSpecific: Associative & Commutative & Idempotent & WithIdentity>(_ s: MoreSpecific) where MoreSpecific.A == A {
    self.init(apply: s.apply, empty: s.empty)
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

  var plus: (A, A) -> A { firstApply }
  var times: (A, A) -> A { secondApply }

  init(forPlus: FirstBinaryOperation, forTimes: SecondBinaryOperation) {
    self.init(forFirst: forPlus, forSecond: forTimes)
  }
}

// MARK: Semiring

struct Semiring<A>: RingLike, WithOne {
  typealias FirstBinaryOperation = CommutativeMonoid<A>
  typealias SecondBinaryOperation = Monoid<A>

  let firstApply: (A, A) -> A
  let secondApply: (A, A) -> A
  let zero: A
  let one: A

  init(
    firstApply: @escaping (A, A) -> A,
    secondApply: @escaping (A, A) -> A,
    zero: A,
    one: A
  ) {
    self.firstApply = firstApply
    self.secondApply = secondApply
    self.zero = zero
    self.one = one
  }

  init(forFirst: FirstBinaryOperation, forSecond: SecondBinaryOperation) {
    self.init(
      firstApply: forFirst.apply,
      secondApply: forSecond.apply,
      zero: forFirst.empty,
      one: forSecond.empty
    )
  }
}

// MARK: Rng

struct Rng<A>: RingLike, WithNegate {
  typealias FirstBinaryOperation = AbelianGroup<A>
  typealias SecondBinaryOperation = Semigroup<A>

  let firstApply: (A, A) -> A
  let secondApply: (A, A) -> A
  let zero: A
  let negate: (A) -> A

  init(
    firstApply: @escaping (A, A) -> A,
    secondApply: @escaping (A, A) -> A,
    zero: A,
    negate: @escaping (A) -> A
  ) {
    self.firstApply = firstApply
    self.secondApply = secondApply
    self.zero = zero
    self.negate = negate
  }

  init(forFirst: FirstBinaryOperation, forSecond: SecondBinaryOperation) {
    self.init(
      firstApply: forFirst.apply,
      secondApply: forSecond.apply,
      zero: forFirst.empty,
      negate: forFirst.inverse
    )
  }
}

// MARK: Commutative Semiring

struct CommutativeSemiring<A>: RingLike, WithOne, CommutativeSecond {
  typealias FirstBinaryOperation = CommutativeMonoid<A>
  typealias SecondBinaryOperation = CommutativeMonoid<A>

  let firstApply: (A, A) -> A
  let secondApply: (A, A) -> A
  let zero: A
  let one: A

  init(
    firstApply: @escaping (A, A) -> A,
    secondApply: @escaping (A, A) -> A,
    zero: A,
    one: A
  ) {
    self.firstApply = firstApply
    self.secondApply = secondApply
    self.zero = zero
    self.one = one
  }

  init(forFirst: FirstBinaryOperation, forSecond: SecondBinaryOperation) {
    self.init(
      firstApply: forFirst.apply,
      secondApply: forSecond.apply,
      zero: forFirst.empty,
      one: forSecond.empty
    )
  }
}

// MARK: Ring

struct Ring<A>: RingLike, WithOne, WithNegate {
  typealias FirstBinaryOperation = AbelianGroup<A>
  typealias SecondBinaryOperation = Monoid<A>

  let firstApply: (A, A) -> A
  let secondApply: (A, A) -> A
  let zero: A
  let one: A
  let negate: (A) -> A

  init(
    firstApply: @escaping (A, A) -> A,
    secondApply: @escaping (A, A) -> A,
    zero: A,
    one: A,
    negate: @escaping (A) -> A
  ) {
    self.firstApply = firstApply
    self.secondApply = secondApply
    self.zero = zero
    self.one = one
    self.negate = negate
  }

  init(forFirst: FirstBinaryOperation, forSecond: SecondBinaryOperation) {
    self.init(
      firstApply: forFirst.apply,
      secondApply: forSecond.apply,
      zero: forFirst.empty,
      one: forSecond.empty,
      negate: forFirst.inverse
    )
  }
}

// MARK: Commutative Ring

struct CommutativeRing<A>: RingLike, WithOne, WithNegate, CommutativeSecond {
  typealias FirstBinaryOperation = AbelianGroup<A>
  typealias SecondBinaryOperation = CommutativeMonoid<A>

  let firstApply: (A, A) -> A
  let secondApply: (A, A) -> A
  let zero: A
  let one: A
  let negate: (A) -> A

  init(
    firstApply: @escaping (A, A) -> A,
    secondApply: @escaping (A, A) -> A,
    zero: A,
    one: A,
    negate: @escaping (A) -> A
  ) {
    self.firstApply = firstApply
    self.secondApply = secondApply
    self.zero = zero
    self.one = one
    self.negate = negate
  }

  init(forFirst: FirstBinaryOperation, forSecond: SecondBinaryOperation) {
    self.init(
      firstApply: forFirst.apply,
      secondApply: forSecond.apply,
      zero: forFirst.empty,
      one: forSecond.empty,
      negate: forFirst.inverse
    )
  }
}

// MARK: Field

struct Field<A>: RingLike, WithOne, WithNegate, CommutativeSecond, WithReciprocal {
  typealias FirstBinaryOperation = AbelianGroup<A>
  typealias SecondBinaryOperation = AbelianGroup<A>

  let firstApply: (A, A) -> A
  let secondApply: (A, A) -> A
  let zero: A
  let one: A
  let negate: (A) -> A
  let reciprocal: (A) -> A

  init(
    firstApply: @escaping (A, A) -> A,
    secondApply: @escaping (A, A) -> A,
    zero: A,
    one: A,
    negate: @escaping (A) -> A,
    reciprocal: @escaping (A) -> A
  ) {
    self.firstApply = firstApply
    self.secondApply = secondApply
    self.zero = zero
    self.one = one
    self.negate = negate
    self.reciprocal = reciprocal
  }

  init(forFirst: FirstBinaryOperation, forSecond: SecondBinaryOperation) {
    self.init(
      firstApply: forFirst.apply,
      secondApply: forSecond.apply,
      zero: forFirst.empty,
      one: forSecond.empty,
      negate: forFirst.inverse,
      reciprocal: forSecond.inverse
    )
  }
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

  var meet: (A, A) -> A { firstApply } /// AND
  var join: (A, A) -> A { secondApply } /// OR

  init(forMeet: FirstBinaryOperation, forJoin: SecondBinaryOperation) {
    self.init(forFirst: forMeet, forSecond: forJoin)
  }
}

// MARK: Lattice

struct Lattice<A>: LatticeLike {
  typealias FirstBinaryOperation = Semilattice<A>
  typealias SecondBinaryOperation = Semilattice<A>

  let firstApply: (A, A) -> A
  let secondApply: (A, A) -> A

  init(forFirst: FirstBinaryOperation, forSecond: SecondBinaryOperation) {
    self.firstApply = forFirst.apply
    self.secondApply = forSecond.apply
  }
}

// MARK: Distributive Lattice

struct DistributiveLattice<A>: LatticeLike, Distributive {
  typealias FirstBinaryOperation = Semilattice<A>
  typealias SecondBinaryOperation = Semilattice<A>

  let firstApply: (A, A) -> A
  let secondApply: (A, A) -> A

  init(forFirst: FirstBinaryOperation, forSecond: SecondBinaryOperation) {
    self.firstApply = forFirst.apply
    self.secondApply = forSecond.apply
  }
}

// MARK: Bounded Lattice

struct BoundedLattice<A>: LatticeLike, WithZero, WithOne {
  typealias FirstBinaryOperation = BoundedSemilattice<A>
  typealias SecondBinaryOperation = BoundedSemilattice<A>

  let firstApply: (A, A) -> A
  let secondApply: (A, A) -> A
  let zero: A
  let one: A

  init(forFirst: FirstBinaryOperation, forSecond: SecondBinaryOperation) {
    self.firstApply = forFirst.apply
    self.secondApply = forSecond.apply
    self.zero = forFirst.empty
    self.one = forSecond.empty
  }
}

// MARK: Bounded Distributive Lattice

struct BoundedDistributiveLattice<A>: LatticeLike, Distributive, WithZero, WithOne {
  typealias FirstBinaryOperation = BoundedSemilattice<A>
  typealias SecondBinaryOperation = BoundedSemilattice<A>

  let firstApply: (A, A) -> A
  let secondApply: (A, A) -> A
  let zero: A
  let one: A

  init(forFirst: FirstBinaryOperation, forSecond: SecondBinaryOperation) {
    self.firstApply = forFirst.apply
    self.secondApply = forSecond.apply
    self.zero = forFirst.empty
    self.one = forSecond.empty
  }
}
