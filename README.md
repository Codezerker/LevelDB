# LevelDB
Swift wrapper for [LevelDB](https://github.com/google/leveldb)

[![build status](https://travis-ci.org/Codezerker/LevelDB.svg?branch=master)](https://travis-ci.org/Codezerker/LevelDB)

## Usage

```swift

let fileURL = URL(fileURLWithPath: "/path/to/database")
let database = LevelDB(fileURL: fileURL)

// put `key` to `value`
database["key"] = value

// get value for `key` 
print(database["key"])

// delete `key`
database["key"] = nil

// enumerate through keys
database.enumerateKeys { key, value in
    // ...
}

// enumerate through keys with a specific prefix
let keyPrefix = "prefix_"
database.enumerateKeys(with: keyPrefix) { key, value in
    // ...
}

```

## TODO

- [ ] Wrap batch write
- [ ] Provide APIs to customize db/read/write/iterator options
