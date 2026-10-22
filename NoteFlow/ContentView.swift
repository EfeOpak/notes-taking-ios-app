
import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext

    @Query(sort: \Note.updatedAt, order: .reverse)
    private var notes: [Note]

    @State private var searchText = ""
    @State private var showingAddNote = false

    private var filteredNotes: [Note] {
        guard !searchText.isEmpty else { return notes }

        return notes.filter {
            $0.title.localizedCaseInsensitiveContains(searchText) ||
            $0.content.localizedCaseInsensitiveContains(searchText)
        }
    }

    var body: some View {
        NavigationStack {
            Group {
                if filteredNotes.isEmpty {
                    ContentUnavailableView(
                        searchText.isEmpty ? "Henüz Not Yok" : "Sonuç Bulunamadı",
                        systemImage: searchText.isEmpty
                            ? "note.text"
                            : "magnifyingglass",
                        description: Text(
                            searchText.isEmpty
                                ? "Yeni bir not oluşturarak başla."
                                : "Başka bir kelime aramayı dene."
                        )
                    )
                } else {
                    List {
                        ForEach(filteredNotes) { note in
                            NavigationLink {
                                EditNoteView(note: note)
                            } label: {
                                VStack(alignment: .leading, spacing: 6) {
                                    Text(note.title.isEmpty ? "Başlıksız Not" : note.title)
                                        .font(.headline)
                                        .lineLimit(1)

                                    Text(note.content)
                                        .font(.subheadline)
                                        .foregroundStyle(.secondary)
                                        .lineLimit(2)

                                    Text(note.updatedAt, style: .date)
                                        .font(.caption2)
                                        .foregroundStyle(.tertiary)
                                }
                                .padding(.vertical, 4)
                            }
                        }
                        .onDelete(perform: deleteNotes)
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle("NoteFlow")
            .searchable(text: $searchText, prompt: "Notlarda ara")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showingAddNote = true
                    } label: {
                        Image(systemName: "plus")
                    }
                    .accessibilityLabel("Yeni not")
                }
            }
            .sheet(isPresented: $showingAddNote) {
                AddNoteView()
            }
        }
    }

    private func deleteNotes(at offsets: IndexSet) {
        for index in offsets {
            let note = filteredNotes[index]
            modelContext.delete(note)
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Note.self, inMemory: true)
}
