import XCTest
@testable import LevelDB

class LevelDBTests: XCTestCase {

    static var allTests : [(String, (LevelDBTests) -> () throws -> Void)] {
        return [
            ("testInitWithDataFileURL", testInitWithDataFileURL),
        ]
    }

    func testInitWithDataFileURL() {
        let fileURL = URL(fileURLWithPath: "/tmp/leveldb.test", isDirectory: true)
        do {
            _ = try LevelDB(fileURL: fileURL)
        } catch {
            XCTAssert(false, "initialization failed")
        }

        let failureURL = URL(fileURLWithPath: "/tmp/leveldb.invalid/leveldb.test", isDirectory: true)
        do {
            _ = try LevelDB(fileURL: failureURL)
            XCTAssert(false, "initialization should fail")
        } catch LevelDB.DatabaseError.lowLevel(let message) {
            print("Caught expected error with message: \(message)")
        } catch {
            XCTAssert(false, "expecting only DatabaseError")
        }
    }
}
