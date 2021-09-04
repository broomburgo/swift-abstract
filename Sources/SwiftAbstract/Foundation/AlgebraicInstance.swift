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
  associatedtype ReferenceStructure: AlgebraicStructure where ReferenceStructure.A == Wrapped
  static var referenceInstance: ReferenceStructure { get }
}

extension String: AlgebraicInstance {
  typealias Wrapped = Self
  static let referenceInstance = Monoid.string
}

extension Array: AlgebraicInstance {
  typealias Wrapped = Self
  static var referenceInstance: Monoid<Self> {
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
  static var referenceInstance: Monoid<Wrapped> {
    .addition
  }
}

protocol MonoidInstance: AlgebraicInstance where ReferenceStructure == Monoid<Wrapped> {}

extension Sequence where Element: MonoidInstance {
  func concat() -> Element {
    let instance = Element.referenceInstance
    return reduce(.init(instance.empty)) {
      .init(instance.apply($0.wrapped, $1.wrapped))
    }
  }
}
