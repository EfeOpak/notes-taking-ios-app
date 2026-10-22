
import SwiftUI
import SwiftData

@main
struct NoteFlowApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: Note.self)
    }
}
