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

            
        }
        
    }
}

#Preview {
    ContentView()
}
