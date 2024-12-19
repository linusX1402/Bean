import SwiftUI

struct ChildRow: View {
    var child: Child
    var app: ViewModel
    
    var body: some View {
        Grid {
            GridRow {
                Text(child.name)
                    .padding(.trailing, 5)
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Spacer()
                Button(action: {app.toggleTimer(child)}){
                    
                    if (child.isRunning) {
                        Image(systemName: "stop")
                            .frame(width: 18, height: 18)
                            .padding(7)
                            .background(Color.red)
                            .cornerRadius(10)
                    } else {
                        Image(systemName: "play")
                            .frame(width: 18, height: 18)
                            .padding(7)
                            .background(Color.green)
                            .cornerRadius(10)
                        
                    }
                }
                .foregroundStyle(Color.white)
                Text("\(child.totalBeansToPay) 🫘")
                    .padding(.leading, 5)
                    .multilineTextAlignment(.trailing)
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }
            .frame(maxWidth: .infinity)
        }
        if (!child.isRunning) {
            
        }
    }
}

#Preview {
    var viewModel = ViewModel()
    var contentView = ContentView(app: viewModel)
    return contentView
}
