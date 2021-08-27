// MARK: - Definition

struct Group<A>: Associative, Identity, Invertible {
    let apply: (A, A) -> A
    let empty: A
    let inverse: (A) -> A

    init(apply: @escaping (A, A) -> A, empty: A, inverse: @escaping (A) -> A) {
        self.apply = apply
        self.empty = empty
        self.inverse = inverse
    }

    init<MoreSpecific: Associative & Identity & Invertible>(from s: MoreSpecific) where MoreSpecific.A == A {
        self.init(apply: s.apply, empty: s.empty, inverse: s.inverse)
    }

    static var laws: [Law<Self>] { [
        .associativity,
        .identity,
        .invertibility,
    ] }
}

// MARK: - Instances

extension Group where A: SignedNumeric {
    static var addition: Self {
        Group(
            apply: { $0 + $1 },
            empty: .zero,
            inverse: { -$0 }
        )
    }
}

extension Group /* where A == (Input) -> Output */ {
    static func function<Input, Output>(over output: Group<Output>) -> Self where A == (Input) -> Output {
        Group(
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
