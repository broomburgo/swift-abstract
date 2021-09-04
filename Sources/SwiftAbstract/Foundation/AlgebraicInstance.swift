protocol AlgebraicInstance {
  associatedtype ReferenceStructure: AlgebraicStructure where ReferenceStructure.A == Self
  static var referenceInstance: ReferenceStructure { get }
}

protocol Wrapper {
  associatedtype Wrapped
  init(_ wrapped: Wrapped)
  var wrapped: Wrapped { get }
}

func wrapping<_Wrapper>(_ original: Monoid<_Wrapper.Wrapped>) -> Monoid<_Wrapper> where _Wrapper: Wrapper {
  .init(
    apply: {
      .init(original.apply($0.wrapped, $1.wrapped))
    },
    empty: .init(original.empty)
  )
}

struct Sum<Wrapped>: Wrapper where Wrapped: AdditiveArithmetic {
  var wrapped: Wrapped

  init(_ wrapped: Wrapped) {
    self.wrapped = wrapped
  }
}

extension Sum: AlgebraicInstance {
  static var referenceInstance: Monoid<Self> { wrapping(.addition) }
}
