import XCTest
@testable import LevelDB

class LevelDBTests: XCTestCase {

    static var allTests : [(String, (LevelDBTests) -> () throws -> Void)] {
        return [
            ("testInitWithDataFileURL", testInitWithDataFileURL),
            ("testBasicOperations", testBasicOperations),
            ("testEnumerates", testEnumerates),
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

    func testEnumerates() {
        let fileURL = URL(fileURLWithPath: "/tmp/leveldb.test", isDirectory: true)
        guard let database = try? LevelDB(fileURL: fileURL) else {
            XCTAssert(false, "unexpected initialization failure")
            return
        }

        let testCase = [
            "a" : "1",
            "b" : "2",
            "c" : "3",
            "prefix_a" : "4",
            "prefix_b" : "5",
            "prefix_c" : "6",
            "x" : "7",
            "y" : "8",
            "z" : "9",
        ]
        for (key, value) in testCase {
            database[key] = value.data(using: .utf8)
        }

        var description = ""
        database.enumerateKeys { key, value in
            let valueString = String(data: value, encoding: .utf8) ?? "nil"
            description += "\(key):\(valueString)|"
        }
        XCTAssertEqual(description, "a:1|b:2|c:3|prefix_a:4|prefix_b:5|prefix_c:6|x:7|y:8|z:9|")

        description = ""
        database.enumerateKeys(with: "prefix_") { key, value in
            let valueString = String(data: value, encoding: .utf8) ?? "nil"
            description += "\(key):\(valueString)|"
        }
        XCTAssertEqual(description, "prefix_a:4|prefix_b:5|prefix_c:6|")

        // clean up
        for (key, _) in testCase {
            database[key] = nil
        }
        for (key, _) in testCase {
            XCTAssertNil(database[key], "all test value should have been removed")
        }
    }
}
