//
//  PlaygroundFile.swift
//  TripManager
//
//  Created by thomas lacan on 26/07/2024.
//

import Foundation

class PlaygroundThread {

  var name: String = ""

  @MainActor func updateName(newName: String) {
    print(Thread.isMainThread ? "New name On Main Thread" : "New name Not MainThread")
    self.name = newName
  }

  static func taskFunc(instance: PlaygroundThread) {
    print("Begin Task Func")
    Task {
      print("Begin Task")
      /*Task { @MainActor in
        await instance.updateName(newName: "test")
      }*/
      await instance.updateName(newName: "test")

      print("End Task")
      print(Thread.isMainThread ? "On Main Thread" : "Not MainThread")
    }
    print("End Task Func")
    print(Thread.isMainThread ? "On Main Thread 2" : "Not MainThread 2")

  }

  func fetchUserData() async -> String {
    print("User Begin")
    try? await Task.sleep(nanoseconds: 1_000_000_000)
    print("User End")
    return "user data"
  }

  func fetchMessages() async -> Int {
    print("Message Begin")
    try? await Task.sleep(nanoseconds: 2_000_000_000)
    print("Message End")
    return 2
  }

  func fetchAll() {
    Task { [weak self] in
      guard let self else { return }
      print("task begin")
      /*async let userData = self.fetchUserData()
      async let messages = self.fetchMessages()
      let (fetchedUserData, fetchedMessagesData) = await (userData, messages)*/
      await withTaskGroup(of: String.self) { taskGroup in
        for _ in 0...4 {
          taskGroup.addTask {
            await self.fetchUserData()
          }
        }
        for await result in taskGroup {
          print("Result: \(result)")
        }
      }
      print("task end")
    }
  }
}
