// MARK: - Definition

struct IdempotentMonoid<A>: Associative, Idempotent, Identity {
    let apply: (A, A) -> A
    let empty: A

    init(apply: @escaping (A, A) -> A, empty: A) {
        self.apply = apply
        self.empty = empty
    }

    init<MoreSpecific: Associative & Idempotent & Identity>(from s: MoreSpecific) where MoreSpecific.A == A {
        self.init(apply: s.apply, empty: s.empty)
    }

    static var laws: [Law<Self>] { [
        .associativity,
        .idempotency,
        .idempotency,
    ] }
}

// MARK: - Instances

extension IdempotentMonoid where A: Comparable & WithMinimum {
    static var max: Self {
        IdempotentMonoid(
            apply: { Swift.max($0, $1) },
            empty: .minimum
        )
    }
}

extension IdempotentMonoid where A: Comparable & WithMaximum {
    static var min: Self {
        IdempotentMonoid(
            apply: { Swift.min($0, $1) },
            empty: .maximum
        )
    }
}

extension IdempotentMonoid where A == Bool {
    static var and: Self {
        IdempotentMonoid(
            apply: { $0 && $1 },
            empty: true
        )
    }

    static var or: Self {
        IdempotentMonoid(
            apply: { $0 || $1 },
            empty: false
        )
    }
}

extension IdempotentMonoid where A == Ordering {
    static var ordering: Self {
        IdempotentMonoid(
            apply: { A.merge($0, $1) },
            empty: .equalTo
        )
    }
}

extension IdempotentMonoid /* where A == Optional */ {
    static func firstIfPossible<Wrapped>() -> Self where A == Wrapped? {
        IdempotentMonoid(
            apply: { $0 ?? $1 },
            empty: nil
        )
    }
}

extension IdempotentMonoid /* where A == Optional */ {
    static func lastIfPossible<Wrapped>() -> Self where A == Wrapped? {
        IdempotentMonoid(
            apply: { $1 ?? $0 },
            empty: nil
        )
    }
}

extension IdempotentMonoid /* where A == Set */ {
    /// While this can be useful as the free bounded semilattice, to truly express the algebraic properties of sets, and define a boolean algebra based on them, we actually need `PredicateSet`.
    static func setUnion<Element>() -> Self where A == Set<Element> {
        IdempotentMonoid(
            apply: { $0.union($1) },
            empty: []
        )
    }
}

extension IdempotentMonoid /* where A == (Input) -> Output */ {
    static func function<Input, Output>(over output: IdempotentMonoid<Output>) -> Self where A == (Input) -> Output {
        IdempotentMonoid(
            apply: { f1, f2 in
                { output.apply(f1($0), f2($0)) }
            },
            empty: { _ in output.empty }
        )
    }
}
