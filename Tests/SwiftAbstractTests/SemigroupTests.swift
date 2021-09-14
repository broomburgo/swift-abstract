//@testable import SwiftAbstract
//import SwiftCheck
//import XCTest
//
//final class SemigroupTests: XCTestCase {
//    func testLawsForSemigroupInstancesOfInt() {
//        verifyAllLaws(
//          ofStructure: Semigroup<Int>.self,
//          onInstances: [
//            ("first", .init(from: Semilattice.first)),
//            ("last", .last),
//            ("max", .max),
//            ("min", .min),
//            ("multiplication", .multiplication),
//            ("addition", .addition)
//          ],
//          equating: ==
//        )
//    }
//
//    func testLawsForSemigroupInstancesOfBool() {
//        verifyAllLaws(
//          ofStructure: Semigroup<Bool>.self,
//          onInstances: [
//            ("and", .and),
//            ("or", .or)
//          ],
//          equating: ==
//        )
//    }
//
//    func testLawsForSemigroupInstancesOfString() {
//        verifyAllLaws(
//          ofStructure: Semigroup<String>.self,
//          onInstances: [
//            ("string", .string)
//          ],
//          equating: ==
//        )
//    }
//
//    func testLawsForSemigroupInstancesOfOrdering() {
//        verifyAllLaws(
//          ofStructure: Semigroup<Ordering>.self,
//          onInstances: [
//            ("ordering", .ordering)
//          ],
//          equating: ==
//        )
//    }
//
//    func testLawsForSemigroupInstancesOfOptional() {
//        verifyAllLaws(
//          ofStructure: Semigroup<Int?>.self,
//          onInstances: [
//            ("firstIfPossible", .firstIfPossible()),
//            ("lastIfPossible", .lastIfPossible())
//          ],
//          equating: ==
//        )
//    }
//
//    func testLawsForSemigroupInstancesOfArray() {
//        verifyAllLaws(
//          ofStructure: Semigroup<[Int]>.self,
//          onInstances: [
//            ("array", .array())
//          ],
//          equating: ==
//        )
//    }
//
//    func testLawsForSemigroupInstancesOfSet() {
//        verifyAllLaws(
//          ofStructure: Semigroup<Set<Int>>.self,
//          onInstances: [
//            ("setIntersection", .setIntersection()),
//            ("setUnion", .setUnion())
//          ],
//          equating: ==
//        )
//    }
//
////  func testFunctionInstancesLaws() {
////    let endo = Semigroup<(Int) -> Int>.endo()
////
////    property("Semigroup.endo respects some laws") <- forAll { (a: ArrowOf<Int, Int>, b: ArrowOf<Int, Int>, c: ArrowOf<Int, Int>, value: Int) in
////      endo.getLaws(equating: { $0(value) == $1(value) })
////        .map { property in
////          TestResult(
////            require: "Semigroup.endo \(property.name)",
////            check: property.verify(a.getArrow, b.getArrow, c.getArrow)
////          )
////        }
////        .reduce(TestResult.succeeded.property) { conjoin($0, $1) }
////    }
////
////    struct GeneratedStructure: Arbitrary {
////      let get: Semigroup<Int>
////
////      static var arbitrary: Gen<GeneratedStructure> {
////        Gen<Semigroup<Int>>.fromElements(of: [
////          .first,
////          .last,
////          .max,
////          .min,
////          .product,
////          .addition
////        ]).map {
////          GeneratedStructure(get: $0)
////        }
////      }
////    }
////
////    property("Semigroup.function respects some laws") <- forAll {
////      (
////        a: ArrowOf<String, Int>,
////        b: ArrowOf<String, Int>,
////        c: ArrowOf<String, Int>,
////        structure: GeneratedStructure,
////        value: String
////      ) in
////      Semigroup<(String) -> Int>.function(over: structure.get)
////        .getLaws(equating: { $0(value) == $1(value) })
////        .map { property in
////          TestResult(
////            require: "Semigroup.function \(property.name)",
////            check: property.verify(a.getArrow, b.getArrow, c.getArrow)
////          )
////        }
////        .reduce(TestResult.succeeded.property) { conjoin($0, $1) }
////    }
////  }
//
//  static var allTests = [
//    ("testLawsForSemigroupInstancesOfInt", testLawsForSemigroupInstancesOfInt),
//    ("testLawsForSemigroupInstancesOfBool", testLawsForSemigroupInstancesOfBool),
//    ("testLawsForSemigroupInstancesOfString", testLawsForSemigroupInstancesOfString),
//    ("testLawsForSemigroupInstancesOfOrdering", testLawsForSemigroupInstancesOfOrdering),
//    ("testLawsForSemigroupInstancesOfOptional", testLawsForSemigroupInstancesOfOptional),
//    ("testLawsForSemigroupInstancesOfArray", testLawsForSemigroupInstancesOfArray),
//    ("testLawsForSemigroupInstancesOfSet", testLawsForSemigroupInstancesOfSet),
////    ("testFunctionInstancesLaws", testFunctionInstancesLaws),
//  ]
//}
