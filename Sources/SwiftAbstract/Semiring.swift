// MARK: - Definition

struct Semiring<A>: RingLike, WithOne {
  let first: CommutativeMonoid<A>
  let second: Monoid<A>

  func verifyProperties(equating: @escaping (A, A) -> Bool) -> [(property: String, verify: (A, A, A) -> Bool)] {
    let verify = VerifyTwo(self, equating: equating)

    return [
      ("has first operation associative", { a, b, c in verify.associativityOfFirst(a, b, c) }),
      ("has second operation associative", { a, b, c in verify.associativityOfSecond(a, b, c) }),
      ("has first operation commutative", { a, b, _ in verify.commutativityOfFirst(a, b) }),
      ("has second operation distributive over first", { a, b, c in verify.distributivityOfSecondOverFirst(a, b, c) }),
      ("has identity of zero", { a, _, _ in verify.zeroIdentity(a) }),
      ("has annihilating zero", { a, _, _ in verify.annihilability(a) }),
      ("has identity of one", { a, _, _ in verify.oneIdentity(a) })
    ]
  }
}

// MARK: - Instances

extension Semiring where A: AdditiveArithmetic & Comparable & WithMaximum {
  static var minTropical: Self {
    Semiring(
      first: CommutativeMonoid.min,
      second: Monoid.sum
    )
  }
}

extension Semiring where A: AdditiveArithmetic & Comparable & WithMinimum {
  static var maxTropical: Self {
    Semiring(
      first: CommutativeMonoid.max,
      second: Monoid.sum
    )
  }
}
