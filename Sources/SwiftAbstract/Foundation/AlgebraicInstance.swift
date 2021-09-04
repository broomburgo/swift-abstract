struct Algebraic<Structure> where Structure: AlgebraicStructure {
  var instance: Structure
  init(_ instance: Structure) {
    self.instance = instance
  }
}

protocol AlgebraicInstance {
  associatedtype ReferenceStructure: AlgebraicStructure where ReferenceStructure.A == Self
  static var algebraic: Algebraic<ReferenceStructure> { get }
}

extension Algebraic where Structure: Associative {
  var semigroup: Semigroup<Structure.A> {
    .init(from: instance)
  }
}

extension Algebraic where Structure: Associative & Identity {
  var monoid: Monoid<Structure.A> {
    .init(from: instance)
  }
}

protocol Wrapper {
  associatedtype Wrapped
  init(_ wrapped: Wrapped)
  var wrapped: Wrapped { get }
}

extension Sequence where
  Element: AlgebraicInstance,
  Element.ReferenceStructure: Associative,
  Element.ReferenceStructure: Identity
{
  func concat() -> Element {
    let instance = Element.algebraic.monoid
    return reduce(instance.empty, instance.apply)
  }
}

struct Sum<Wrapped>: Wrapper where Wrapped: AdditiveArithmetic {
  var wrapped: Wrapped

  init(_ wrapped: Wrapped) {
    self.wrapped = wrapped
  }
}

extension Sum: AlgebraicInstance {
  static var algebraic: Algebraic<Monoid<Self>> { .init(.init(wrapping: .addition)) }
}

struct Max<Wrapped>: Wrapper where Wrapped: Comparable {
  var wrapped: Wrapped

  init(_ wrapped: Wrapped) {
    self.wrapped = wrapped
  }
}

extension Max: AlgebraicInstance {
  static var algebraic: Algebraic<Semigroup<Self>> { .init(.init(wrapping: .max)) }
}
