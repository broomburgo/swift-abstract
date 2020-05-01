struct SwiftAbstract {
  var text = "Hello, World!"
}

protocol BinaryOperation {
  associatedtype A
  var apply: (A, A) -> A { get }
}

protocol Associative: BinaryOperation {}

protocol Commutative: BinaryOperation {}

protocol WithIdentity: BinaryOperation {
  var empty: A { get }
}

protocol WithInverse: WithIdentity {
  var inverse: (A) -> A { get }
}

protocol Idempotent: BinaryOperation {}

struct Semigroup<A>: Associative {
  let apply: (A, A) -> A

  init(apply: @escaping (A, A) -> A) {
    self.apply = apply
  }

  init<MoreSpecific: Associative>(_ s: MoreSpecific) where MoreSpecific.A == A {
    self.init(apply: s.apply)
  }
}

struct CommutativeSemigroup<A>: Associative, Commutative {
  let apply: (A, A) -> A

  init(apply: @escaping (A, A) -> A) {
    self.apply = apply
  }

  init<MoreSpecific: Associative & Commutative>(_ s: MoreSpecific) where MoreSpecific.A == A {
    self.init(apply: s.apply)
  }
}

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

struct Band<A>: Associative, Idempotent {
  let apply: (A, A) -> A

  init(apply: @escaping (A, A) -> A) {
    self.apply = apply
  }

  init<MoreSpecific: Associative & Idempotent>(_ s: MoreSpecific) where MoreSpecific.A == A {
    self.init(apply: s.apply)
  }
}

struct Semilattice<A>: Associative, Commutative, Idempotent {
  let apply: (A, A) -> A

  init(apply: @escaping (A, A) -> A) {
    self.apply = apply
  }

  init<MoreSpecific: Associative & Commutative & Idempotent>(_ s: MoreSpecific) where MoreSpecific.A == A {
    self.init(apply: s.apply)
  }
}

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

protocol TwoBinaryOperations {
  associatedtype A
  associatedtype FirstBinaryOperation: BinaryOperation where FirstBinaryOperation.A == A
  associatedtype SecondBinaryOperation: BinaryOperation where SecondBinaryOperation.A == A

  var firstApply: (A, A) -> A { get }
  var secondApply: (A, A) -> A { get }
  init(forFirst: FirstBinaryOperation, forSecond: SecondBinaryOperation)
}

protocol AssociativeFirst: TwoBinaryOperations where FirstBinaryOperation: Associative {}

protocol AssociativeSecond: TwoBinaryOperations where SecondBinaryOperation: Associative {}

protocol DistributiveSecondOverFirst: TwoBinaryOperations {}

protocol CommutativeFirst: TwoBinaryOperations where FirstBinaryOperation: Commutative {}

protocol WithZero: TwoBinaryOperations where FirstBinaryOperation: WithIdentity {
  var zero: A { get }
}

protocol WithAnnihilation: WithZero {}

typealias RingLike = TwoBinaryOperations
  & AssociativeFirst
  & CommutativeFirst
  & WithAnnihilation
  & AssociativeSecond
  & DistributiveSecondOverFirst

extension TwoBinaryOperations where Self: RingLike {
  typealias PlusBinaryOperation = FirstBinaryOperation
  typealias TimesBinaryOperation = SecondBinaryOperation

  var plus: (A, A) -> A { firstApply }
  var times: (A, A) -> A { secondApply }

  init(forPlus: FirstBinaryOperation, forTimes: SecondBinaryOperation) {
    self.init(forFirst: forPlus, forSecond: forTimes)
  }
}

protocol WithOne: TwoBinaryOperations where SecondBinaryOperation: WithIdentity {
  var one: A { get }
}

protocol WithNegate: TwoBinaryOperations where FirstBinaryOperation: WithInverse {
  var negate: (A) -> A { get }
}

protocol WithReciprocal: TwoBinaryOperations where SecondBinaryOperation: WithInverse {
  var reciprocal: (A) -> A { get }
}

protocol CommutativeSecond: TwoBinaryOperations where SecondBinaryOperation: Commutative {}

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

protocol IdempotentFirst: TwoBinaryOperations where FirstBinaryOperation: Idempotent {}

protocol IdempotentSecond: TwoBinaryOperations where SecondBinaryOperation: Idempotent {}

protocol Absorption: TwoBinaryOperations {}

typealias LatticeLike = TwoBinaryOperations
  & AssociativeFirst
  & CommutativeFirst
  & IdempotentFirst
  & AssociativeSecond
  & CommutativeSecond
  & IdempotentSecond
  & Absorption

extension TwoBinaryOperations where Self: LatticeLike {
  typealias MeetBinaryOperation = FirstBinaryOperation
  typealias JoinBinaryOperation = SecondBinaryOperation

  var meet: (A, A) -> A { firstApply }
  var join: (A, A) -> A { secondApply }

  init(forMeet: FirstBinaryOperation, forJoin: SecondBinaryOperation) {
    self.init(forFirst: forMeet, forSecond: forJoin)
  }
}


