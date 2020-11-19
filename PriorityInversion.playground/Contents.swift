import UIKit

///////////////////////////
//// Priority Inversion ///
///////////////////////////

// Priority Inversion occurs when a queue with a lower quality of service is given a higher
// system priority than a queue with higher quality of service QoS

// A common situation wherein priority inversion occurs is when a higher quality of service queue shares a resource with a lower quality of service queue.
// When the lower queue gets a lock on the object, the higher queue will have to wait
// Therefore, until the lock is released, the high priority queue is effectively stuck doing nothing while low-priority tasks run


// Let's see this in action

let high = DispatchQueue.global(qos: .userInteractive)
let medium = DispatchQueue.global(qos: .userInitiated)
let low = DispatchQueue.global(qos: .background)

let semaphore = DispatchSemaphore(value: 1)

high.async {
    // Wait two second just to make sure all the other tasks have enqueued
    Thread.sleep(forTimeInterval: 2)
    semaphore.wait()
    defer { semaphore.signal() }

    print("High priority is now running")
}

for i in 1 ... 10 {
    medium.async {
        let waitTime = Double(exactly: arc4random_uniform(7))!
        print("Running medium task: \(i)")
        Thread.sleep(forTimeInterval: waitTime)
    }
}

low.async {
    semaphore.wait()
    defer { semaphore.signal() }
    print("Running long, lowest priority task")
    Thread.sleep(forTimeInterval: 5)
}
