//
//  ContentView.swift
//  ZoomPanView
//
//  Created by Sukumar.Sukumaran on 29/10/2024.
//

import SwiftUI

struct ContentView: View {
    
    var body: some View {
    
        VStack {
            Color.red
                .frame(height: 60)
                
            Spacer()
            Color.cyan
                .frame(height: 250)
                .overlay(
                    RoundedRectangle(cornerRadius: 0)
                        .stroke(.blue, lineWidth: 15)
                        .overlay(
                            
                            Circle()
                                .frame(width: 50, height: 50)
                                .foregroundStyle(Color.blue)
                        )
                )
                .viewZoomable()
                .zIndex(-1)
            
            Spacer()
            
            
        }
        
    }
}

struct Zoomable: ViewModifier {
    
    @State private var currentZoom = 0.0
    @State private var totalZoom = 1.0
    
    @State private var scale: CGFloat = 1.0
    @GestureState private var pinchScale: CGFloat = 1.0

    @State private var offset: CGSize = .zero
    @GestureState private var dragOffset: CGSize = .zero

    @State private var prevCurrentState: MagnificationGesture.Value = .zero
    
  
   
    func body(content: Content) -> some View {
        
        let pinchGesture = MagnificationGesture()
            .updating($pinchScale) { currentState, gestureState, transaction in
                gestureState = currentState
                let scale = max(scale * currentState, 1)
                let maxOffsetX = (UIScreen.main.bounds.width * (scale - 1)) / 2
                let maxOffsetY = (250 * (scale - 1)) / 2
                let newOffsetX = max(min(maxOffsetX, offset.width), -maxOffsetX)
                let newOffsetY = max(min(maxOffsetY, offset.height), -maxOffsetY)
                                
                offset.width = newOffsetX
                offset.height = newOffsetY

            }
            .onEnded { finalScale in
                scale = max(scale * finalScale, 1)
            }
        
        
        let dragGesture = DragGesture()
            .updating($dragOffset) { currentDrag, gestureState, _ in
                let trans = currentDrag.translation
                gestureState = trans
            }
            .onEnded { finalDrag in
                let maxOffsetX = (UIScreen.main.bounds.width * (scale - 1)) / 2
                let maxOffsetY = (250 * (scale - 1)) / 2
                let newOffsetX = offset.width + finalDrag.translation.width
                let newOffsetY = offset.height + finalDrag.translation.height
                offset.width = min(max(newOffsetX, -maxOffsetX), maxOffsetX)
                offset.height = min(max(newOffsetY, -maxOffsetY), maxOffsetY)
            }

    
        VStack {
            content
                .scaleEffect(max(scale * pinchScale, 1))
               // .offset(x: offset.width + dragOffset.width, y: offset.height + dragOffset.height)
                .gesture(
                    pinchGesture
                       // .simultaneously(with: dragGesture)
                )
                .onChange(of: dragOffset) { newValue in
                    print("<0><1> dragOffset.width = \(newValue.width)")
                    print("<0><1> offset.width = \(offset.width)")
                }
        
            
        }
        
    }
    
    
}

extension View {
    
    func viewZoomable() -> some View {
        modifier(Zoomable())
    }
}


#Preview {
    ContentView()
}
