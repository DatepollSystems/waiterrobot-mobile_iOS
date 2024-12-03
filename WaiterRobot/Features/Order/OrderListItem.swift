import shared
import SwiftUI
import WRCore

struct OrderListItem: View {
    let name: String
    let amount: Int32
    let note: String?
    let addOne: () -> Void
    let removeOne: () -> Void
    let removeAll: () -> Void
    let onSaveNote: (String?) -> Void

    @State private var editNote: Bool = false
    @State private var editedNote: String = ""

    var body: some View {
        Button {
            addOne()
        } label: {
            HStack {
                VStack {
                    HStack {
                        Text("\(amount)x")
                            .font(.title3)
                            .frame(width: 40, alignment: .leading)
                            .multilineTextAlignment(.leading)

                        Text(name)
                            .font(.title3)
                            .multilineTextAlignment(.leading)

                        Spacer()
                    }

                    if let note {
                        Text(note)
                            .foregroundColor(.secondary)
                            .font(.caption)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }

                HStack {
                    Button {
                        editNote = true
                        editedNote = note ?? ""
                    } label: {
                        Image(systemName: "pencil")
                            .padding(10)
                    }
                    .buttonStyle(.primary)
                }
                .padding(.vertical, 2)
                .frame(maxHeight: .infinity, alignment: .center)
            }

            .foregroundColor(.blackWhite)
        }
        .sheet(isPresented: $editNote) {
            orderProductNote()
        }
        .swipeActions(edge: .trailing, allowsFullSwipe: true, content: {
            HStack {
                Button(action: {
                    removeOne()
                }, label: {
                    Image(systemName: "minus")
                })
                .tint(.gray)

                Button(action: {
                    withAnimation(.spring()) {
                        removeAll()
                    }
                }, label: {
                    Image(systemName: "trash")
                })
                .tint(.red)
            }
        })
        .swipeActions(edge: .leading, allowsFullSwipe: true, content: {
            Button(action: {
                addOne()
            }, label: {
                Image(systemName: "plus")
            })
            .tint(.green)
        })
    }

    private func orderProductNote() -> some View {
        OrderProductNoteView(name: name, noteText: $editedNote, onSaveNote: onSaveNote)
    }
}

#Preview {
    PreviewView {
        List {
            OrderListItem(
                name: "Beer",
                amount: 5,
                note: nil,
                addOne: {},
                removeOne: {},
                removeAll: {},
                onSaveNote: { _ in }
            )
            OrderListItem(
                name: "Wine",
                amount: 20,
                note: "1x without Tomato",
                addOne: {},
                removeOne: {},
                removeAll: {},
                onSaveNote: { _ in }
            )
        }
    }
}
