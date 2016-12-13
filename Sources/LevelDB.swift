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
        defer {
            leveldb_options_destroy(options)
        }

        let databaseName = fileURL.path
        var errorPtr: UnsafeMutablePointer<Int8>? = nil

        guard let database = leveldb_open(options, databaseName, &errorPtr) else {
            if let validErrorPtr = errorPtr {
                let error = String(cString: validErrorPtr)
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
        let options = leveldb_readoptions_create()
        defer {
            leveldb_readoptions_destroy(options)
        }

        let keyLength = key.lengthOfBytes(using: .utf8)
        var resultLength: Int = 0
        var errorPtr: UnsafeMutablePointer<Int8>? = nil

        if let valueBytes = leveldb_get(database, options, key, keyLength, &resultLength, &errorPtr) {
            let valueString = String(cString: valueBytes)
            return valueString.data(using: .utf8)
        } else {
            return nil
        }
    }

    public func setData(_ data: Data?, for key: String) {
        if let data = data {
            updateData(data, for: key)
        } else {
            deleteData(for: key)
        }
    }

    private func updateData(_ data: Data, for key: String) {
        let options = leveldb_writeoptions_create()
        defer {
            leveldb_writeoptions_destroy(options)
        }

        let keyLength = key.lengthOfBytes(using: .utf8)
        let valueString = String(data: data, encoding: .utf8)!
        let valueLength = data.count
        var errorPtr: UnsafeMutablePointer<Int8>? = nil

        leveldb_put(database, options, key, keyLength, valueString, valueLength, &errorPtr)
    }

    private func deleteData(for key: String) {
        let options = leveldb_writeoptions_create()
        defer {
            leveldb_writeoptions_destroy(options)
        }

        let keyLength = key.lengthOfBytes(using: .utf8)
        var errorPtr: UnsafeMutablePointer<Int8>? = nil

        leveldb_delete(database, options, key, keyLength, &errorPtr)
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
