import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack {
            Text("Hello, World!")
            SKCanvasView()
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
