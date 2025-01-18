import SwiftUI

struct ChildrenView: View {
    @ObservedObject var app: ViewModel
    @State private var lastClicked = 0
    
    private func setAllTimers(clickedBy: Int, action: () -> Void) {
        if lastClicked == clickedBy {
            action()
        }
        lastClicked = clickedBy
    }
    
    func createChildAlertController() {
        let alertController = UIAlertController(
            title: NSLocalizedString("new_child_title", comment: "Title for new child alert"),
            message: NSLocalizedString("new_child_message", comment: "Message for new child alert"),
            preferredStyle: .alert
        )

        alertController.addTextField { textField in
            textField.placeholder = NSLocalizedString("name_placeholder", comment: "Placeholder for name field")
            textField.autocapitalizationType = .sentences
            NotificationCenter.default.addObserver(forName: UITextField.textDidChangeNotification, object: textField, queue: .main) { [weak alertController] _ in
                let text = textField.text ?? ""
                alertController?.actions[1].isEnabled = !text.isEmpty
            }
        }

        let cancelAction = UIAlertAction(
            title: NSLocalizedString("cancel_button", comment: "Cancel button title"),
            style: .cancel,
            handler: nil
        )
        let saveAction = UIAlertAction(
            title: NSLocalizedString("save_button", comment: "Save button title"),
            style: .default
        ) { _ in
            if let textField = alertController.textFields?.first, let name = textField.text {
                app.addChild(name)
            }
        }
        saveAction.isEnabled = false

        alertController.addAction(cancelAction)
        alertController.addAction(saveAction)

        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = scene.windows.first(where: { $0.isKeyWindow }),
           let topController = window.rootViewController {
            topController.present(alertController, animated: true, completion: nil)
        }
    }

    func deleteChildrenAlertController() {
        let alertController = UIAlertController(
            title: NSLocalizedString("delete_children_title", comment: "Title for delete children alert"),
            message: NSLocalizedString("delete_children_message", comment: "Message for delete children alert"),
            preferredStyle: .alert
        )

        let cancelAction = UIAlertAction(
            title: NSLocalizedString("cancel_button", comment: "Cancel button title"),
            style: .cancel,
            handler: nil
        )
        let deleteAction = UIAlertAction(
            title: NSLocalizedString("delete_button", comment: "Delete button title"),
            style: .destructive
        ) { _ in
            app.deleteAllChildren()
        }

        alertController.addAction(cancelAction)
        alertController.addAction(deleteAction)

        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = scene.windows.first,
           let topController = window.rootViewController {
            topController.present(alertController, animated: true, completion: nil)
        }
    }

    
    var body: some View {
        VStack {
            HStack {
                Button(action: deleteChildrenAlertController ) {
                    Image(systemName: "trash")
                        .font(.title2)
                        .padding(.leading, 10)
                }
                .padding(.bottom, 5)
                Spacer()
                Button(action: createChildAlertController ) {
                    Image(systemName: "plus")
                        .font(.title2)
                        .padding(.trailing, 10)
                }
            }
            HStack {
                Text("Bean")
                    .font(.largeTitle)
                    .fontWeight(.semibold)
                    .padding(.bottom, 10)
                    .padding(.leading, 20)
                Spacer()
            }
        }
        .padding(.top, 10)
        
        HStack(spacing: 15) {
            Spacer()
            Button(action: {withAnimation {
                setAllTimers(clickedBy: 0, action: {app.startAllTimers()})}}) {
                Image(systemName: "play")
                    .font(.headline)
                if lastClicked == 0 {
                    Text ("Start")
                        .font(.headline)
                        .lineLimit(1)
                }
            }
            .padding()
            .background(Color.green)
            .foregroundColor(.white)
            .cornerRadius(15)
            .tag(0)
            Button(action: {withAnimation {
                setAllTimers(clickedBy: 1, action: {app.stopAllTimers()})}})  {
                Image(systemName: "stop")
                    .font(.headline)
                if lastClicked == 1 {
                    Text ("Stop")
                        .font(.headline)
                        .lineLimit(1)
                }
            }
            .padding()
            .foregroundColor(.white)
            .background(Color.red)
            .cornerRadius(15)
            .tag(1)
            Button(action: {withAnimation {
                setAllTimers(clickedBy: 2, action: { app.resetAllTimers() })
            }}) {
                
                Image(systemName: "arrow.circlepath")
                    .font(.headline)
                if lastClicked == 2 {
                    Text ("Reset")
                        .font(.headline)
                        .lineLimit(1)
                }
            }
            .padding()
            .foregroundColor(.white)
            .background(Color.orange)
            .cornerRadius(15)
            .tag(2)
            Spacer()
        }
        
        .padding(.horizontal, 10)
        .padding(.top, 10)
            List {
                Label("Children", systemImage: "person.2")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundStyle(Color.secondary)
                ForEach( app.children, id: \.id) { child in
                    ChildRow(child: child, app: app)
                        .swipeActions {
                            Button(role: .destructive) {
                                app.removeChild(child)
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                        .swipeActions {
                            Button {
                                app.resetTimer(for: child)
                            } label: {
                                Image(systemName: "arrow.circlepath")
                                    .tint(Color.orange)
                            }
                        }
                }
            }
            .listStyle(.plain)
            Divider()
            .padding(.bottom, 15)
    }
}

#Preview {
    let viewModel = ViewModel()
    let childrenView =  ChildrenView(app: viewModel)
        .environment(\.locale, .init(identifier: "de"))
    return childrenView
}
