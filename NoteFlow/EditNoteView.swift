
import SwiftUI
import SwiftData

struct EditNoteView: View {
    @Environment(\.dismiss) private var dismiss

    @Bindable var note: Note

    @State private var title = ""
    @State private var content = ""

    var body: some View {
        Form {
            Section("Başlık") {
                TextField("Not başlığı", text: $title)
            }

            Section("İçerik") {
                TextEditor(text: $content)
                    .frame(minHeight: 280)
            }
        }
        .navigationTitle("Notu Düzenle")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("Bitti") {
                    note.title = title.trimmingCharacters(
                        in: .whitespacesAndNewlines
                    )
                    note.content = content
                    note.updatedAt = .now
                    dismiss()
                }
            }
        }
        .onAppear {
            title = note.title
            content = note.content
        }
    }
}

#Preview {
    NavigationStack {
        EditNoteView(
            note: Note(
                title: "Örnek Not",
                content: "Bu bir örnek nottur."
            )
        )
        .modelContainer(for: Note.self, inMemory: true)
    }
}
