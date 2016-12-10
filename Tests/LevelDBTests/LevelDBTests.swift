import XCTest
@testable import LevelDB

class LevelDBTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        XCTAssertEqual(LevelDB().text, "Hello, World!")
    }


    static var allTests : [(String, (LevelDBTests) -> () throws -> Void)] {
        return [
            ("testExample", testExample),
        ]
    }
}
