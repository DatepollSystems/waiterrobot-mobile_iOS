import shared
import SwiftUI
import WRCore

struct OrderProductNoteView: View {
    let name: String
    @Binding var noteText: String
    let onSaveNote: (String?) -> Void

    private let maxLength = 150

    @Environment(\.dismiss)
    private var dismiss

    @FocusState
    private var focused: Bool

    var body: some View {
        NavigationView {
            content()
                .navigationTitle(localize.order.addNoteDialog.title(value0: name))
                .navigationBarTitleDisplayMode(.inline)
        }
    }

    @ViewBuilder
    private func content() -> some View {
        VStack {
            Text(localize.order.addNoteDialog.inputLabel())

            Group {
                if #available(iOS 16, *) {
                    TextField(localize.order.addNoteDialog.inputPlaceholder(), text: $noteText, axis: .vertical)
                        .lineLimit(5, reservesSpace: true)
                        .toolbarBackground(.visible, for: .bottomBar)
                } else {
                    // TODO: Maybe change to TextEditor
                    TextField(localize.order.addNoteDialog.inputPlaceholder(), text: $noteText)
                        .lineLimit(5)
                }
            }
            .textFieldStyle(.roundedBorder)
            .focused($focused)
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    toolbarButtons()
                }

                ToolbarItemGroup(placement: .bottomBar) {
                    toolbarButtons()
                }
            }

            Text("\(noteText.count)/\(maxLength)")
                .font(.caption)

            Spacer()
        }
        .padding()
        .onChange(of: noteText) { _ in
            if noteText.count > maxLength {
                noteText = String(noteText.prefix(maxLength))
            }
        }
        .task {
            focused = true
        }
    }

    @ViewBuilder
    private func toolbarButtons() -> some View {
        cancelButton()

        Spacer()

        clearButton()

        Spacer()

        saveButton()
    }

    @ViewBuilder
    private func cancelButton() -> some View {
        Button(localize.dialog.cancel(), role: .cancel) {
            dismiss()
        }
    }

    @ViewBuilder
    private func clearButton() -> some View {
        Button(localize.dialog.clear(), role: .destructive) {
            noteText = ""
            onSaveNote(nil)
            dismiss()
        }
        .foregroundStyle(.red)
    }

    @ViewBuilder
    private func saveButton() -> some View {
        Button(localize.dialog.save()) {
            onSaveNote(noteText)
            dismiss()
        }
    }
}

#Preview {
    EmptyView()
        .sheet(isPresented: .constant(true)) {
            PreviewView {
                OrderProductNoteView(name: "Beer", noteText: .constant("Test")) { _ in
                }
            }
        }
}
