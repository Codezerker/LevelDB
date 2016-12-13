import Clibleveldb
import Foundation

public final class LevelDB {

    // MARK: - Type definitions

    public enum DatabaseError: Error {
        case lowLevel(message: String?)
    }

    public typealias KeyEnumeration = (String, Data) -> Void

    // MARK: - Properties

    public static var version: String {
        let majorVersion = leveldb_major_version()
        let minorVersion = leveldb_minor_version()
        return "\(majorVersion).\(minorVersion)"
    }

    private let database: OpaquePointer

    // MARK: - Life cycle

    public init(fileURL: URL) throws {
        let options = leveldb_options_create()
        leveldb_options_set_create_if_missing(options, 1)

        let databaseName = fileURL.path.cString(using: .utf8)
        var errorPtr: UnsafeMutablePointer<Int8>? = nil

        guard let database = leveldb_open(options, databaseName, &errorPtr) else {
            if let validErrorPtr = errorPtr {
                let error = String(cString: validErrorPtr, encoding: .utf8)
                throw DatabaseError.lowLevel(message: error)
            } else {
                throw DatabaseError.lowLevel(message: nil)
            }
        }
        self.database = database
    }

    deinit {
        leveldb_close(database)
    }

    // MARK: - Data operations

    public func data(for key: String) -> Data? {
        Unimplemented()
    }

    public func setData(_ data: Data?, for key: String) {
        Unimplemented()
    }

    // MARK: - Subscripts

    public subscript(key: String) -> Data? {
        get {
            return data(for: key)
        }
        set(newValue) {
            setData(newValue, for: key)
        }
    }

    // MARK: - Enumerates

    public func enumerateKeys(using closure: KeyEnumeration) {
        Unimplemented()
    }

    public func enumerateKeys(with keyPrefix: String, using closure: KeyEnumeration) {
        Unimplemented()
    }
}
