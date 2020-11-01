import UIKit

// SEMAPHORES

// Control how many threads have access to the same resource

let semaphore = DispatchSemaphore(value: 2)
let group = DispatchGroup()
let queue = DispatchQueue(label: "com.test.semaphore")

for i in 1...10 {
    queue.async(group: group) {
        semaphore.wait()
        group.enter()
        DispatchQueue.main.asyncAfter(deadline: .now() + 5, execute: {
            defer {
                group.leave()
                semaphore.signal()
            }
            print("Task \(i) completed")
        })
    }
}


