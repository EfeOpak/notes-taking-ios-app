
import SwiftUI
import SwiftData

struct AddNoteView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    @State private var title = ""
    @State private var content = ""

    var body: some View {
        NavigationStack {
            Form {
                Section("Başlık") {
                    TextField("Not başlığı", text: $title)
                }

                Section("İçerik") {
                    TextEditor(text: $content)
                        .frame(minHeight: 220)
                }
            }
            .navigationTitle("Yeni Not")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("İptal") {
                        dismiss()
                    }
                }

                ToolbarItem(placement: .confirmationAction) {
                    Button("Kaydet") {
                        saveNote()
                    }
                    .disabled(
                        title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
                        content.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                    )
                }
            }
        }
    }

    private func saveNote() {
        let note = Note(
            title: title.trimmingCharacters(in: .whitespacesAndNewlines),
            content: content,
            createdAt: .now,
            updatedAt: .now
        )

        modelContext.insert(note)
        dismiss()
    }
}

#Preview {
    AddNoteView()
        .modelContainer(for: Note.self, inMemory: true)
}
