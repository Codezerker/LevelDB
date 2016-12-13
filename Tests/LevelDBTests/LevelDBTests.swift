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

    func testBasicOperations() {
        let fileURL = URL(fileURLWithPath: "/tmp/leveldb.test", isDirectory: true)
        guard let database = try? LevelDB(fileURL: fileURL) else {
            XCTAssert(false, "unexpected initialization failure")
            return
        }

        let key1 = "key1"
        let value1 = "value1".data(using: .utf8)

        database[key1] = value1
        guard let value = database[key1] else {
            XCTAssert(false, "value is missing")
            return
        }
        XCTAssertEqual(value, value1)

        database[key1] = nil
        XCTAssertNil(database[key1], "value should have been removed")
    }
}
