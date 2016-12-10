import Clibleveldb

public struct LevelDB {

    public static var version: String {
        let majorVersion = leveldb_major_version()
        let minorVersion = leveldb_minor_version()
        return "\(majorVersion).\(minorVersion)"
    }

    // TODO: wrap libleveldb with swift
}
