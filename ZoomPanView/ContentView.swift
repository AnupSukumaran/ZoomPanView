//
//  ContentView.swift
//  ZoomPanView
//
//  Created by Sukumar.Sukumaran on 29/10/2024.
//

import SwiftUI

struct ContentView: View {
    
    @State private var currentZoom = 0.0
    @State private var totalZoom = 1.0
    
    @State private var scale: CGFloat = 1.0
    @GestureState private var pinchScale: CGFloat = 1.0

    @State private var offset: CGSize = .zero
    @GestureState private var dragOffset: CGSize = .zero

    @State private var prevCurrentState: MagnificationGesture.Value = .zero
   
    var body: some View {
    
        let pinchGesture = MagnificationGesture()
            .updating($pinchScale) { currentState, gestureState, transaction in
                 gestureState = currentState
//                print("<0><6>currentState: \(currentState)")
//                let offsetVal = max((offset.width - (offset.width  * currentState)), 0)
//                print("<0><12> offsetVal = \(offsetVal)")
//                offset.width = offsetVal
                let scale = max(scale * currentState, 1)
                print("<0><5>scale: \(scale)")
                let maxOffsetX = (UIScreen.main.bounds.width * (scale - 1)) / 2
                print("<0><5><1>maxOffsetX: \(maxOffsetX)")
                
                print("<0><5>scale: \(scale)")
                let newOffset = max(min(maxOffsetX, offset.width), -maxOffsetX)
                print("<0><5><1>newOffset = \(newOffset)")
                
//                let newOffsetVal = min(max(newOffset, -maxOffsetX), maxOffsetX)
//                
//                offset.width = max(newOffsetVal, 0)
                
                offset.width = newOffset
//                let newOffsetX = offset.width + finalDrag.translation.width
               
//                print("<0><5>newOffsetX = \(newOffsetX)")
               // offset.width = offset.width - (maxOffsetX * currentState)//min(max(newOffsetX, -maxOffsetX), maxOffsetX)
                //print("<0><5>offset.width_2 = \(offset.width)")
            }
            .onEnded { finalScale in
                scale = max(scale * finalScale, 1)
            }
        
        
        let dragGesture = DragGesture()
            .updating($dragOffset) { currentDrag, gestureState, _ in
                let trans = currentDrag.translation
                print("<0><2>trans.width: \(trans.width)")
                
                print("<0><8>dragOffset.width_1: \(dragOffset.width)")
                gestureState = trans
                print("<0><8>dragOffset.width_2: \(dragOffset.width)")
            }
            .onEnded { finalDrag in
                
                print("<0><6>UIScreen.main.bounds.width: \(UIScreen.main.bounds.width)")
               
                //let newScale = max(scale * pinchScale, 1)
                let maxOffsetX = (UIScreen.main.bounds.width * (scale - 1)) / 2
                print("<0><6>scale: \(scale)")
                print("<0><6>maxOffsetX: \(maxOffsetX)")
            //    let maxOffsetY = (250 * (scale - 1)) / 2

                let newOffsetX = offset.width + finalDrag.translation.width
               // let newOffsetY = offset.height + finalDrag.translation.height
                print("<0><6>newOffsetX = \(newOffsetX)")
                offset.width = min(max(newOffsetX, -maxOffsetX), maxOffsetX)
                print("<0><6>offset.width_2 = \(offset.width)")
             //   offset.height = min(max(newOffsetY, -maxOffsetY), maxOffsetY)
            }

           
        
//        let dragGesture = DragGesture()
//            .updating($dragOffset) { currentDrag, gestureState, _ in
//                // Calculate the potential new offset based on the current drag translation
//                let proposedOffsetX = offset.width + currentDrag.translation.width
//                let maxOffsetX = (UIScreen.main.bounds.width * (scale - 1)) / 2
//
//                // Clamp the proposed offset to prevent dragging outside the bounds
//                let clampedOffsetX = min(max(proposedOffsetX, -maxOffsetX), maxOffsetX)
//
//                // Update the gesture state to the clamped value
//                gestureState = CGSize(width: clampedOffsetX - offset.width, height: 0)
//            }
//            .onEnded { finalDrag in
//                // When the gesture ends, just update the final offset
//                offset.width += dragOffset.width
//                // Keep vertical offset unchanged
//            }


        
        VStack {
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
            
            
                .scaleEffect(max(scale * pinchScale, 1))
                .offset(x: offset.width + dragOffset.width, y: offset.height)
                .gesture(
                    pinchGesture
                        .simultaneously(with: dragGesture)
                )
                .onChange(of: dragOffset) { newValue in
                    print("<0><1> dragOffset.width = \(newValue.width)")
                    print("<0><1> offset.width = \(offset.width)")
                }
            
            
//            ZoomableScrollView {
//                Color.cyan
//                    .frame(height: 250)
//                    .overlay(
//                        RoundedRectangle(cornerRadius: 0)
//                            .stroke(.blue, lineWidth: 15)
//                            .overlay(
//                                
//                                Circle()
//                                    .frame(width: 50, height: 50)
//                                    .foregroundStyle(Color.blue)
//                            )
//                    )
//            }
            
        }
        
    }
}

#Preview {
    ContentView()
}
