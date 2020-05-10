import SwiftUI

enum TouchState {
    case start
    case end
    case move
}

struct ContentView: View {
    @State var touchState = TouchState.end

    var body: some View {
        ZStack {
            Text("Hello, World!")
            SKCanvasView()
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                .gesture(
                    DragGesture()
                        .onChanged({ value in
                            if (self.touchState == TouchState.end) {
                                self.touchState = TouchState.start
                            } else {
                                self.touchState = TouchState.move
                            }
                        
                            self.handleTouch(value.location)
                        })
                        .onEnded({ (value) in
                            self.touchState = TouchState.end
                            self.handleTouch(value.location)
                        })
            )
        }
    }
    
    private func handleTouch(_ value: CGPoint) {
        switch self.touchState {
        case .start:
            sendRequestCommand(.onTouchStart(x: Float(value.x), y: Float(value.y)))
            print(value)
        case .end:
            sendRequestCommand(.onTouchEnd(x: Float(value.x), y: Float(value.y)))
        case .move:
            sendRequestCommand(.onTouchMove(x: Float(value.x), y: Float(value.y)))
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
