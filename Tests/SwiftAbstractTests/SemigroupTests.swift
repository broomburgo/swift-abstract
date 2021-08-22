@testable import SwiftAbstract
import SwiftCheck
import XCTest

final class SemigroupTests: XCTestCase {
    
    func testPropertiesForSemigroupInstancesOfInt() {
        _verifyAllProperties(
          ofStructure: Semigroup<Int>.self,
          onInstances: [
            ("first", .first),
            ("last", .last),
            ("max", .max),
            ("min", .min),
            ("product", .product),
            ("sum", .sum)
          ],
          equating: ==
        )
    }

    func testPropertiesForSemigroupInstancesOfBool() {
        _verifyAllProperties(
          ofStructure: Semigroup<Bool>.self,
          onInstances: [
            ("and", .and),
            ("or", .or)
          ],
          equating: ==
        )
    }

    func testPropertiesForSemigroupInstancesOfString() {
        _verifyAllProperties(
          ofStructure: Semigroup<String>.self,
          onInstances: [
            ("string", .string)
          ],
          equating: ==
        )
    }

    func testPropertiesForSemigroupInstancesOfOrdering() {
        _verifyAllProperties(
          ofStructure: Semigroup<Ordering>.self,
          onInstances: [
            ("ordering", .ordering)
          ],
          equating: ==
        )
    }

    func testPropertiesForSemigroupInstancesOfOptional() {
        _verifyAllProperties(
          ofStructure: Semigroup<Int?>.self,
          onInstances: [
            ("firstIfPossible", .firstIfPossible()),
            ("lastIfPossible", .lastIfPossible())
          ],
          equating: ==
        )
    }

    func testPropertiesForSemigroupInstancesOfArray() {
        _verifyAllProperties(
          ofStructure: Semigroup<[Int]>.self,
          onInstances: [
            ("array", .array())
          ],
          equating: ==
        )
    }

    func testPropertiesForSemigroupInstancesOfSet() {
        _verifyAllProperties(
          ofStructure: Semigroup<Set<Int>>.self,
          onInstances: [
            ("setIntersection", .setIntersection()),
            ("setUnion", .setUnion())
          ],
          equating: ==
        )
    }

//  func testFunctionInstancesProperties() {
//    let endo = Semigroup<(Int) -> Int>.endo()
//
//    property("Semigroup.endo respects some laws") <- forAll { (a: ArrowOf<Int, Int>, b: ArrowOf<Int, Int>, c: ArrowOf<Int, Int>, value: Int) in
//      endo.getProperties(equating: { $0(value) == $1(value) })
//        .map { property in
//          TestResult(
//            require: "Semigroup.endo \(property.name)",
//            check: property.verify(a.getArrow, b.getArrow, c.getArrow)
//          )
//        }
//        .reduce(TestResult.succeeded.property) { conjoin($0, $1) }
//    }
//
//    struct GeneratedStructure: Arbitrary {
//      let get: Semigroup<Int>
//
//      static var arbitrary: Gen<GeneratedStructure> {
//        Gen<Semigroup<Int>>.fromElements(of: [
//          .first,
//          .last,
//          .max,
//          .min,
//          .product,
//          .sum
//        ]).map {
//          GeneratedStructure(get: $0)
//        }
//      }
//    }
//
//    property("Semigroup.function respects some laws") <- forAll {
//      (
//        a: ArrowOf<String, Int>,
//        b: ArrowOf<String, Int>,
//        c: ArrowOf<String, Int>,
//        structure: GeneratedStructure,
//        value: String
//      ) in
//      Semigroup<(String) -> Int>.function(over: structure.get)
//        .getProperties(equating: { $0(value) == $1(value) })
//        .map { property in
//          TestResult(
//            require: "Semigroup.function \(property.name)",
//            check: property.verify(a.getArrow, b.getArrow, c.getArrow)
//          )
//        }
//        .reduce(TestResult.succeeded.property) { conjoin($0, $1) }
//    }
//  }

  static var allTests = [
    ("testPropertiesForSemigroupInstancesOfInt", testPropertiesForSemigroupInstancesOfInt),
    ("testPropertiesForSemigroupInstancesOfBool", testPropertiesForSemigroupInstancesOfBool),
    ("testPropertiesForSemigroupInstancesOfString", testPropertiesForSemigroupInstancesOfString),
    ("testPropertiesForSemigroupInstancesOfOrdering", testPropertiesForSemigroupInstancesOfOrdering),
    ("testPropertiesForSemigroupInstancesOfOptional", testPropertiesForSemigroupInstancesOfOptional),
    ("testPropertiesForSemigroupInstancesOfArray", testPropertiesForSemigroupInstancesOfArray),
    ("testPropertiesForSemigroupInstancesOfSet", testPropertiesForSemigroupInstancesOfSet),
//    ("testFunctionInstancesProperties", testFunctionInstancesProperties),
  ]
}
