// MARK: - Definition

struct AbelianGroup<A>: Associative, Commutative, Identity, Invertible {
    let apply: (A, A) -> A
    let empty: A
    let inverse: (A) -> A

    init(apply: @escaping (A, A) -> A, empty: A, inverse: @escaping (A) -> A) {
        self.apply = apply
        self.empty = empty
        self.inverse = inverse
    }

    init<MoreSpecific: Associative & Commutative & Identity & Invertible>(from s: MoreSpecific) where MoreSpecific.A == A {
        self.init(apply: s.apply, empty: s.empty, inverse: s.inverse)
    }

    static var laws: [Law<Self>] { [
        .associativity,
        .commutativity,
        .identity,
        .invertibility,
    ] }
}

// MARK: - Instances

extension AbelianGroup where A: SignedNumeric {
    static var addition: Self {
        AbelianGroup(
            apply: { $0 + $1 },
            empty: .zero,
            inverse: { -$0 }
        )
    }
}

extension AbelianGroup where A: FloatingPoint {
    static var multiplication: Self {
        AbelianGroup(
            apply: {
                if ($0 == .infinity && $1 == .zero) || ($0 == .zero && $1 == .infinity) {
                    return 1
                }

                return $0 * $1
            },
            empty: 1,
            inverse: { 1 / $0 }
        )
    }
}

extension AbelianGroup /* where A == (Input) -> Output */ {
    static func function<Input, Output>(over output: AbelianGroup<Output>) -> Self where A == (Input) -> Output {
        AbelianGroup(
            apply: { f1, f2 in
                { output.apply(f1($0), f2($0)) }
            },
            empty: { _ in output.empty },
            inverse: { f in
                { output.inverse(f($0)) }
            }
        )
    }
}
