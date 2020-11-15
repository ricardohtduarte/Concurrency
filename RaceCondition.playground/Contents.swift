// RACE CONDITIONS

// Threads that share the same process also share the same address space
// This means that each thread is trying to read and write to the same shared resource
// Race conditions may happen when multiple threads try to write at the same variable at the same time
// Which may result in non-expected results

// FIRST SOLUTION: serial queue wrapper

// Wrap reads and writes inside with a private queue so that the variable may be accessed concurrently

import Foundation

private let threadSafeCountQueue = DispatchQueue(label: "com.race.condition")

private var _count = 0
public var count: Int {
    get {
        return threadSafeCountQueue.sync {
            _count
        }
    }
    set {
        threadSafeCountQueue.sync {
            _count = newValue
        }
    }
}

// SECOND SOLUTION: Thread barrier

// When a variable needs to be written to, we can lock down the queue so
// that everything already submitted completes, but no new submissions are run until the update completes

private var _secondCount = 0
public var secondCount: Int {
    get {
        return threadSafeCountQueue.sync {
            _count
        }
    }
    set {
        threadSafeCountQueue.async(flags: .barrier) {
            _count = newValue
        }
    }
}

