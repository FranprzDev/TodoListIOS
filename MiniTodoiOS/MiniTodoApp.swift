import SwiftUI

@main
struct MiniTodoApp: App {
    @StateObject private var store = TodoStore()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(store)
        }
    }
}
