protocol AlgebraicInstance {
    associatedtype Structure: AlgebraicStructure where Structure.A == Self
    static var algebraicInstance: Structure { get }
}

extension AlgebraicInstance where Structure: WithOneBinaryOperation {
    func merge(_ other: Self) -> Self {
        Self.algebraicInstance.apply(self, other)
    }
}

extension Sequence where Element: AlgebraicInstance, Element.Structure: Identity {
    func reduce() -> Element {
        reduce(Element.algebraicInstance.empty, Element.algebraicInstance.apply)
    }
}

extension String: AlgebraicInstance {
    static var algebraicInstance: Monoid<Self> {
        .string
    }
}

protocol Wrapper: RawRepresentable {
    init(rawValue: RawValue)
}

struct Sum: Wrapper {
    let rawValue: Int

    init(rawValue: Int) {
        self.rawValue = rawValue
    }
}

extension Sum: AlgebraicInstance {
    static let algebraicInstance = Monoid<Self>(wrapping: Monoid.addition)
}

protocol RequiresApplyAndEmpty: AlgebraicStructure {
    init(apply: @escaping (A, A) -> A, empty: A)
}

extension Monoid: RequiresApplyAndEmpty {}

extension RequiresApplyAndEmpty {
    init<WrappedInstance>(
        wrapping wrappedInstance: WrappedInstance
    ) where
        WrappedInstance: Identity,
        A: Wrapper,
        A.RawValue == WrappedInstance.A
    {
        self.init(
            apply: { .init(rawValue: wrappedInstance.apply($0.rawValue, $1.rawValue)) },
            empty: .init(rawValue: wrappedInstance.empty)
        )
    }
}

extension ConstructibleWithOneBinaryOperation {
    init<WrappedInstance>(
        wrapping wrappedInstance: WrappedInstance
    ) where
        WrappedInstance: WithOneBinaryOperation,
        A: Wrapper,
        A.RawValue == WrappedInstance.A
    {
        self.init(
            apply: { .init(rawValue: wrappedInstance.apply($0.rawValue, $1.rawValue)) }
        )
    }
}
