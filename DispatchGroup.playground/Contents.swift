import UIKit

let group = DispatchGroup()

let queue1 = DispatchQueue(label: "first queue")
let queue2 = DispatchQueue(label: "second queue")
let queue3 = DispatchQueue.global(qos: .userInitiated)

// Syncronous tasks
let task1 = {
    print("Task 1 started")
    Thread.sleep(until: Date().addingTimeInterval(5))
    print("Task 1 completed")
}

let task2 = {
    print("Task 2 started")
    Thread.sleep(until: Date().addingTimeInterval(10))
    print("Task 2 completed")
}

queue1.async(group: group, execute: task1)
queue2.async(group: group, execute: task2)

// Asyncronous task
queue3.async(group: group, execute: {
    group.enter()
    print("Task 3 completed")
    DispatchQueue.main.asyncAfter(deadline: .now() + 15, execute: {
        defer { group.leave() }
        print("Task 3 completed")
    })
})

group.notify(queue: DispatchQueue.main, execute: {
    print("All tasks were executed")
})

