struct Abstract<Structure> where Structure: AlgebraicStructure {
  private var instance: Structure
  init(_ instance: Structure) {
    self.instance = instance
  }
}

protocol AlgebraicInstance {
  associatedtype ReferenceStructure: AlgebraicStructure where ReferenceStructure.A == Self
  static var abstract: Abstract<ReferenceStructure> { get }
}

extension Abstract where Structure: Associative {
  var semigroup: Semigroup<Structure.A> {
    .init(from: instance)
  }
}

extension Abstract where Structure: Associative & Identity {
  var monoid: Monoid<Structure.A> {
    .init(from: instance)
  }
}

extension Abstract where Structure: Associative & Identity & Invertible {
  var group: Group<Structure.A> {
    .init(from: instance)
  }
}

extension Abstract where Structure: Associative & Commutative & Identity & Invertible {
  var abelianGroup: AbelianGroup<Structure.A> {
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
    let instance = Element.abstract.monoid
    return reduce(instance.empty, instance.apply)
  }
}

struct Sum<Wrapped>: Wrapper where Wrapped: SignedNumeric {
  var wrapped: Wrapped

  init(_ wrapped: Wrapped) {
    self.wrapped = wrapped
  }
}

extension Sum: AlgebraicInstance {
  static var abstract: Abstract<AbelianGroup<Self>> { .init(.init(wrapping: .addition)) }
}

struct Max<Wrapped>: Wrapper where Wrapped: Comparable {
  var wrapped: Wrapped

  init(_ wrapped: Wrapped) {
    self.wrapped = wrapped
  }
}

extension Max: AlgebraicInstance {
  static var abstract: Abstract<Semigroup<Self>> { .init(.init(wrapping: .max)) }
}

extension String: AlgebraicInstance {
  static let abstract = Abstract(Monoid.string)
}
