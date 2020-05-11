import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(SemigroupTests.allTests),
        testCase(BooleanTests.allTests),
    ]
}
#endif
