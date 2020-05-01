// MARK: - BinaryOperation

protocol BinaryOperation {
  associatedtype A
  var apply: (A, A) -> A { get }
}

// MARK: Properties

protocol Associative: BinaryOperation {}

protocol Commutative: BinaryOperation {}

protocol Idempotent: BinaryOperation {}

protocol WithIdentity: BinaryOperation {
  var empty: A { get }
}

protocol WithInverse: WithIdentity {
  var inverse: (A) -> A { get }
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

// MARK: Properties

protocol AssociativeFirst: TwoBinaryOperations where FirstBinaryOperation: Associative {}
protocol AssociativeSecond: TwoBinaryOperations where SecondBinaryOperation: Associative {}
typealias AssociativeBoth = AssociativeFirst & AssociativeSecond

protocol CommutativeFirst: TwoBinaryOperations where FirstBinaryOperation: Commutative {}
protocol CommutativeSecond: TwoBinaryOperations where SecondBinaryOperation: Commutative {}
typealias CommutativeBoth = CommutativeFirst & CommutativeSecond

protocol IdempotentFirst: TwoBinaryOperations where FirstBinaryOperation: Idempotent {}
protocol IdempotentSecond: TwoBinaryOperations where SecondBinaryOperation: Idempotent {}
typealias IdempotentBoth = IdempotentFirst & IdempotentSecond

protocol DistributiveFirstOverSecond: TwoBinaryOperations {}
protocol DistributiveSecondOverFirst: TwoBinaryOperations {}
typealias Distributive = DistributiveFirstOverSecond & DistributiveSecondOverFirst

protocol WithZero: TwoBinaryOperations where FirstBinaryOperation: WithIdentity {
  var zero: A { get }
}

protocol WithAnnihilation: WithZero {}

protocol WithOne: TwoBinaryOperations where SecondBinaryOperation: WithIdentity {
  var one: A { get }
}

protocol WithNegate: TwoBinaryOperations where FirstBinaryOperation: WithInverse {
  var negate: (A) -> A { get }
}

protocol WithReciprocal: TwoBinaryOperations where SecondBinaryOperation: WithInverse {
  var reciprocal: (A) -> A { get }
}

protocol Absorption: TwoBinaryOperations {}

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
