import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var store: TodoStore
    @State private var newItemTitle = ""

    var body: some View {
        NavigationStack {
            List {
                Section {
                    HStack(spacing: 12) {
                        TextField("Nueva tarea", text: $newItemTitle)
                            .onSubmit(addItem)

                        Button("Agregar", action: addItem)
                            .buttonStyle(.borderedProminent)
                    }
                }

                if store.items.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("No hay tareas")
                            .font(.headline)
                        Text("Agregá la primera tarea para probar la app.")
                            .foregroundStyle(.secondary)
                    }
                } else {
                    Section("Tareas") {
                        ForEach(store.items) { item in
                            TodoRow(item: item) {
                                store.toggleDone(for: item)
                            }
                        }
                        .onDelete(perform: store.delete)
                    }
                }
            }
            .navigationTitle("MiniTodo")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Limpiar") {
                        store.clear()
                    }
                    .disabled(store.items.isEmpty)
                }
            }
        }
    }

    private func addItem() {
        store.add(title: newItemTitle)
        newItemTitle = ""
    }
}

private struct TodoRow: View {
    let item: TodoItem
    let onToggle: () -> Void

    var body: some View {
        Button(action: onToggle) {
            HStack(spacing: 12) {
                Image(systemName: item.isDone ? "checkmark.circle.fill" : "circle")
                    .foregroundStyle(item.isDone ? .green : .secondary)

                Text(item.title)
                    .strikethrough(item.isDone)
                    .foregroundStyle(item.isDone ? .secondary : .primary)

                Spacer()
            }
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    ContentView()
        .environmentObject(TodoStore())
}
