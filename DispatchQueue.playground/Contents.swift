import UIKit

let customQueue = DispatchQueue.init(label: "com.myqueue",
                                     qos: .userInitiated,
                                     attributes: .concurrent,
                                     autoreleaseFrequency: .workItem,
                                     target: nil)

let globalQueue = DispatchQueue.global(qos: .background)


// Execute task in queue

// Anonymous closure

globalQueue.async {
    // Some code logic
    
    // Send data to main queue once task is completed

    DispatchQueue.main.async {
        // Assign to UI components
    }
}

// Work Item

let workItem = DispatchWorkItem(block: { print("Thread code to execute") })
globalQueue.async(execute: workItem)

// We can cancel workItems
workItem.cancel()

// And check if the item was cancelled
workItem.isCancelled

// Work Items also support notifications when finished

let workItemsQueue = DispatchQueue(label: "com.workItems.notifications")
let firstWorkItem = DispatchWorkItem(block: { print("First execution")})
let secondWorkItem = DispatchWorkItem(block: { print("Second execution")})

firstWorkItem.notify(queue: workItemsQueue, execute: secondWorkItem)
workItemsQueue.async(execute: firstWorkItem)
