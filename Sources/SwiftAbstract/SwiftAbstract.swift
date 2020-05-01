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
  associatedtype PlusBinaryOperation: BinaryOperation where PlusBinaryOperation.A == A
  associatedtype TimesBinaryOperation: BinaryOperation where TimesBinaryOperation.A == A

  var plus: (A, A) -> A { get }
  var times: (A, A) -> A { get }
  init(forPlus: PlusBinaryOperation, forTimes: TimesBinaryOperation)
}

protocol Distributive: TwoBinaryOperations {}

protocol AssociativePlusTimes: TwoBinaryOperations where PlusBinaryOperation: Associative {}

protocol CommutativePlus: TwoBinaryOperations where PlusBinaryOperation: Commutative {}

protocol WithZero: TwoBinaryOperations where PlusBinaryOperation: WithIdentity  {
  var zero: A { get }
}

protocol WithAnnihilation: WithZero {}

typealias RingLike = Distributive & AssociativePlusTimes & CommutativePlus & WithAnnihilation

protocol WithOne: TwoBinaryOperations where TimesBinaryOperation: WithIdentity {
  var one: A { get }
}

protocol WithNegate: TwoBinaryOperations where PlusBinaryOperation: WithInverse {
  var negate: (A) -> A { get }
}

protocol WithReciprocal: TwoBinaryOperations where TimesBinaryOperation: WithInverse {
  var reciprocal: (A) -> A { get }
}

protocol CommutativeTimes: TwoBinaryOperations where TimesBinaryOperation: Commutative {}

struct Semiring<A>: RingLike, WithOne {
  typealias PlusBinaryOperation = CommutativeMonoid<A>
  typealias TimesBinaryOperation = Monoid<A>

  let plus: (A, A) -> A
  let times: (A, A) -> A
  let zero: A
  let one: A

  init(
    plus: @escaping (A, A) -> A,
    times: @escaping (A, A) -> A,
    zero: A,
    one: A
  ) {
    self.plus = plus
    self.times = times
    self.zero = zero
    self.one = one
  }

  init(forPlus: PlusBinaryOperation, forTimes: TimesBinaryOperation) {
    self.init(
      plus: forPlus.apply,
      times: forTimes.apply,
      zero: forPlus.empty,
      one: forTimes.empty
    )
  }
}

struct Rng<A>: RingLike, WithNegate {
  typealias PlusBinaryOperation = AbelianGroup<A>
  typealias TimesBinaryOperation = Semigroup<A>

  let plus: (A, A) -> A
  let times: (A, A) -> A
  let zero: A
  let negate: (A) -> A

  init(
    plus: @escaping (A, A) -> A,
    times: @escaping (A, A) -> A,
    zero: A,
    negate: @escaping (A) -> A
  ) {
    self.plus = plus
    self.times = times
    self.zero = zero
    self.negate = negate
  }

  init(forPlus: PlusBinaryOperation, forTimes: TimesBinaryOperation) {
    self.init(
      plus: forPlus.apply,
      times: forTimes.apply,
      zero: forPlus.empty,
      negate: forPlus.inverse
    )
  }
}

struct CommutativeSemiring<A>: RingLike, WithOne, CommutativeTimes {
  typealias PlusBinaryOperation = CommutativeMonoid<A>
  typealias TimesBinaryOperation = CommutativeMonoid<A>

  let plus: (A, A) -> A
  let times: (A, A) -> A
  let zero: A
  let one: A

  init(
    plus: @escaping (A, A) -> A,
    times: @escaping (A, A) -> A,
    zero: A,
    one: A
  ) {
    self.plus = plus
    self.times = times
    self.zero = zero
    self.one = one
  }

  init(forPlus: PlusBinaryOperation, forTimes: TimesBinaryOperation) {
    self.init(
      plus: forPlus.apply,
      times: forTimes.apply,
      zero: forPlus.empty,
      one: forTimes.empty
    )
  }
}

struct Ring<A>: RingLike, WithOne, WithNegate {
  typealias PlusBinaryOperation = AbelianGroup<A>
  typealias TimesBinaryOperation = Monoid<A>

  let plus: (A, A) -> A
  let times: (A, A) -> A
  let zero: A
  let one: A
  let negate: (A) -> A

  init(
    plus: @escaping (A, A) -> A,
    times: @escaping (A, A) -> A,
    zero: A,
    one: A,
    negate: @escaping (A) -> A
  ) {
    self.plus = plus
    self.times = times
    self.zero = zero
    self.one = one
    self.negate = negate
  }

  init(forPlus: PlusBinaryOperation, forTimes: TimesBinaryOperation) {
    self.init(
      plus: forPlus.apply,
      times: forTimes.apply,
      zero: forPlus.empty,
      one: forTimes.empty,
      negate: forPlus.inverse
    )
  }
}

struct CommutativeRing<A>: RingLike, WithOne, WithNegate, CommutativeTimes {
  typealias PlusBinaryOperation = AbelianGroup<A>
  typealias TimesBinaryOperation = CommutativeMonoid<A>

  let plus: (A, A) -> A
  let times: (A, A) -> A
  let zero: A
  let one: A
  let negate: (A) -> A

  init(
    plus: @escaping (A, A) -> A,
    times: @escaping (A, A) -> A,
    zero: A,
    one: A,
    negate: @escaping (A) -> A
  ) {
    self.plus = plus
    self.times = times
    self.zero = zero
    self.one = one
    self.negate = negate
  }

  init(forPlus: PlusBinaryOperation, forTimes: TimesBinaryOperation) {
    self.init(
      plus: forPlus.apply,
      times: forTimes.apply,
      zero: forPlus.empty,
      one: forTimes.empty,
      negate: forPlus.inverse
    )
  }
}

struct Field<A>: RingLike, WithOne, WithNegate, CommutativeTimes, WithReciprocal {
  typealias PlusBinaryOperation = AbelianGroup<A>
  typealias TimesBinaryOperation = AbelianGroup<A>

  let plus: (A, A) -> A
  let times: (A, A) -> A
  let zero: A
  let one: A
  let negate: (A) -> A
  let reciprocal: (A) -> A

  init(
    plus: @escaping (A, A) -> A,
    times: @escaping (A, A) -> A,
    zero: A,
    one: A,
    negate: @escaping (A) -> A,
    reciprocal: @escaping (A) -> A
  ) {
    self.plus = plus
    self.times = times
    self.zero = zero
    self.one = one
    self.negate = negate
    self.reciprocal = reciprocal
  }

  init(forPlus: PlusBinaryOperation, forTimes: TimesBinaryOperation) {
    self.init(
      plus: forPlus.apply,
      times: forTimes.apply,
      zero: forPlus.empty,
      one: forTimes.empty,
      negate: forPlus.inverse,
      reciprocal: forTimes.inverse
    )
  }
}


