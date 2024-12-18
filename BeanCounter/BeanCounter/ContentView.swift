import SwiftUI
import UIKit

struct ContentView: View {
    @ObservedObject var app: ViewModel
    @State var currentTab = 0
    
    func createChildAlertController() {
        let alertController = UIAlertController(title: "New Child", message: "Enter a name for this Child.", preferredStyle: .alert)

        alertController.addTextField { textField in
            textField.placeholder = "Name"
            textField.autocapitalizationType = .sentences
            NotificationCenter.default.addObserver(forName: UITextField.textDidChangeNotification, object: textField, queue: .main) { [weak alertController] _ in
                let text = textField.text ?? ""
                alertController?.actions[1].isEnabled = !text.isEmpty
            }
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let saveAction = UIAlertAction(title: "Save", style: .default) { _ in
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
        let alertController = UIAlertController(title: "Delete All Children", message: "Are you sure you want to deleta all children?", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { _ in
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
                    if (currentTab == 0) {
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
                }
            HStack {
                Text("Bean Counter")
                    .font(.largeTitle)
                    .fontWeight(.semibold)
                    .padding(.bottom, 10)
                    .padding(.leading, 20)
                Spacer()
            }
        }
        .padding(.top, 20)
        
        TabView(selection: $currentTab) {
            
            //Children
            VStack {
                    Divider()
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
                                    .swipeActions(edge: .leading) {
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
                    HStack(spacing: 10) {
                        Spacer()
                        Button(action: { app.startAllTimers() }) {
                            Image(systemName: "play")
                                .font(.headline)
                                .frame(width: 40, height: 40)
                                .foregroundColor(.white)
                                .background(Color.green)
                                .cornerRadius(10)
                        }
                        Spacer()
                        Button(action: { app.stopAllTimers() }) {
                            Image(systemName: "stop")
                                .font(.headline)
                                .frame(width: 40, height: 40)
                                .foregroundColor(.white)
                                .background(Color.red)
                                .cornerRadius(10)
                        }
                        Spacer()
                        Button(action: { app.resetAllTimers() }) {
                            Image(systemName: "arrow.circlepath")
                                .font(.headline)
                                .frame(width: 40, height: 40)
                                .foregroundColor(.white)
                                .background(Color.orange)
                                .cornerRadius(10)
                        }
                        Spacer()
                    }
                    .padding(.horizontal, 10)
                    .padding(.top, 10)
                    Spacer()
                    Spacer()
                    Spacer()
                }
                .tabItem {
                    Label("Children", systemImage: "person.2")
                }
                .tag(0)
                
                
                //Settings
                VStack {
                    List {
                        Text("Settings")
                        .font(.title)
                        .fontWeight(.semibold)
                        .padding(.bottom, 10)
                        HStack {
                            Image(systemName: "")
                            Text("Beans/Tick: \(app.settings.beansPerTick)")
                            Spacer()
                            Stepper(value: $app.settings.beansPerTick, in: 1...10) {}
                        }
                        .frame(width: .infinity)
                        .padding(.horizontal, 10)
                        HStack {
                            Image(systemName: "")
                            Text("Set ticks (min): \(app.settings.secondsPerTick)")
                            Spacer()
                            Stepper(value: $app.settings.secondsPerTick, in: 1...10) {}
                        }
                        .frame(width: .infinity)
                        .padding(.horizontal, 10)
                    }
                    .frame(height: .infinity)

                    Spacer()
                    Divider()
                        .padding(.bottom, 10)
                }
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
                .tag(1)
            }
        .animation(.none, value: currentTab)
        }
    }


#Preview {
    var viewModel = ViewModel()
    var contentView = ContentView(app: viewModel)
    return contentView
}
