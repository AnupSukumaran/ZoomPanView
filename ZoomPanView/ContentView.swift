//
//  ContentView.swift
//  ZoomPanView
//
//  Created by Sukumar.Sukumaran on 29/10/2024.
//

import SwiftUI

struct ContentView: View {
    
    let baselineHeight: CGFloat = 896.0
    let baselineWidth: CGFloat = 414.0
    let baselineScale: CGFloat = 2.2
    
    // Current screen dimensions
    let currentHeight = UIScreen.main.bounds.height
    let currentWidth = UIScreen.main.bounds.width
    
    

    
    @State var isLetterBox: Bool = true
    @State var dynamicScale: CGFloat = 1
    
    var body: some View {
    
        VStack {
            Color.red
                .frame(height: 60)
            Button {
                isLetterBox.toggle()
                let height = UIScreen.main.bounds.height
                let width = UIScreen.main.bounds.width
                print("height = \(height)")
                print("width = \(width)")
            } label: {
                Text("Letter Box = \(isLetterBox)")
            }

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
                .viewZoomable(scale: $dynamicScale, isLetterBox: $isLetterBox)
                .zIndex(-1)
            
            Spacer()
            
            
        }
        .onChange(of: isLetterBox) { newValue in
            
            // Calculate scale based on average of height and width ratios
            let heightRatio = currentHeight / baselineHeight
            let widthRatio = currentWidth / baselineWidth
            
            let dynamicScaleVal = baselineScale * ((heightRatio + widthRatio) / 2)
            print("dynamicScaleVal = \(dynamicScaleVal)")
            dynamicScale = isLetterBox ? 1 : 2.5
        }
        .onAppear {
           
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

 //   @State private var prevCurrentState: MagnificationGesture.Value = .zero
    @Binding var dynamicScale: CGFloat // = 2.5
    @Binding var isLetterBox: Bool
   
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
                if isLetterBox {
                    offset.height = min(max(newOffsetY, -maxOffsetY), maxOffsetY)
                }
                
            }

    
        VStack {
            content
                .scaleEffect(max(scale * pinchScale, 1))
                .offset(x: offset.width + dragOffset.width, y: offset.height + dragOffset.height)
                .gesture(dragGesture, isEnabled: !isLetterBox)
                .gesture(pinchGesture
                    .simultaneously(with: dragGesture), isEnabled: isLetterBox)

                .onChange(of: dragOffset) { newValue in
                    print("<0><1> dragOffset.width = \(newValue.width)")
                    print("<0><1> offset.width = \(offset.width)")
                }
                .onChange(of: dynamicScale) { newValue in
                    scale = newValue
                }
                .onChange(of: isLetterBox) { newValue in
                    offset = .zero
                }
            
        }
        
    }
    
    
}

extension View {
    
    func viewZoomable(scale: Binding<CGFloat>, isLetterBox: Binding<Bool>) -> some View {
        modifier(Zoomable(dynamicScale: scale, isLetterBox: isLetterBox))
    }
}


#Preview {
    ContentView()
}
