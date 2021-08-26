// MARK: - Definition

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

    static var laws: [Law<Self>] { [
        .associativity,
        .commutativity,
        .identity,
    ] }
}

// MARK: - Instances

extension CommutativeMonoid where A: Comparable & WithMinimum {
    static var max: Self {
        CommutativeMonoid(
            apply: { Swift.max($0, $1) },
            empty: .minimum
        )
    }
}

extension CommutativeMonoid where A: Comparable & WithMaximum {
    static var min: Self {
        CommutativeMonoid(
            apply: { Swift.min($0, $1) },
            empty: .maximum
        )
    }
}

extension CommutativeMonoid where A: AdditiveArithmetic {
    static var sum: Self {
        CommutativeMonoid(
            apply: { $0 + $1 },
            empty: .zero
        )
    }
}

extension CommutativeMonoid where A: Numeric & ExpressibleByIntegerLiteral {
    static var product: Self {
        CommutativeMonoid(
            apply: { $0 * $1 },
            empty: 1
        )
    }
}

extension CommutativeMonoid where A == Bool {
    static var and: Self {
        CommutativeMonoid(
            apply: { $0 && $1 },
            empty: true
        )
    }

    static var or: Self {
        CommutativeMonoid(
            apply: { $0 || $1 },
            empty: false
        )
    }
}

extension CommutativeMonoid /* where A == Set */ {
    /// While this can be useful as the free bounded semilattice, to truly express the algebraic properties of sets, and define a boolean algebra based on them, we actually need `PredicateSet`.
    static func setUnion<Element>() -> Self where A == Set<Element> {
        CommutativeMonoid(
            apply: { $0.union($1) },
            empty: []
        )
    }
}

extension CommutativeMonoid /* where A == (Input) -> Output */ {
    static func function<Input, Output>(over output: CommutativeMonoid<Output>) -> Self where A == (Input) -> Output {
        CommutativeMonoid(
            apply: { f1, f2 in
                { output.apply(f1($0), f2($0)) }
            },
            empty: { _ in output.empty }
        )
    }
}
