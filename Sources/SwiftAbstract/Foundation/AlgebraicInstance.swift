protocol Wrapper {
  associatedtype Wrapped
  init(_ wrapped: Wrapped)
  var wrapped: Wrapped { get }
}

extension Wrapper where Wrapped == Self {
  init(_ wrapped: Wrapped) {
    self = wrapped
  }

  var wrapped: Wrapped {
    self
  }
}

protocol AlgebraicInstance: Wrapper {
  associatedtype Structure: AlgebraicStructure where Structure.A == Wrapped
  static var algebraicPrimitive: Structure { get }
}

extension String: AlgebraicInstance {
  typealias Wrapped = Self
  static let algebraicPrimitive = Monoid.string
}

extension Array: AlgebraicInstance {
  typealias Wrapped = Self
  static var algebraicPrimitive: Monoid<Self> {
    .array()
  }
}

struct Sum<Wrapped>: Wrapper where Wrapped: AdditiveArithmetic {
  let wrapped: Wrapped
  init(_ wrapped: Wrapped) {
    self.wrapped = wrapped
  }
}

extension Sum: AlgebraicInstance {
  static var algebraicPrimitive: Monoid<Wrapped> {
    .addition
  }
}

protocol _Monoid: AlgebraicInstance where Structure == Monoid<Wrapped> {}

extension Sequence where Element: _Monoid {
  func concat() -> Element {
    let instance = Element.algebraicPrimitive
    return reduce(.init(instance.empty)) {
      .init(instance.apply($0.wrapped, $1.wrapped))
    }
  }
}
