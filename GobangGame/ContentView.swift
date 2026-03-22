//
//  ContentView.swift
//  GobangGame
//
//  Created by xuzhilin on 2026/3/22.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        List {
            NavigationLink(destination: GobangView()) {
                HStack {
                    Image(systemName: "circle.grid.cross")
                        .foregroundColor(.black)
                    Text("五子棋")
                        .font(.title2)
                }
                .padding(.vertical, 8)
            }
            
            // 其他游戏（灰色占位）
            HStack {
                Image(systemName: "circle.grid.cross.fill")
                    .foregroundColor(.gray)
                Text("围棋")
                    .font(.title2)
                    .foregroundColor(.gray)
            }
            .padding(.vertical, 8)
            .disabled(true)
            
            HStack {
                Image(systemName: "rectangle.grid.1x2")
                    .foregroundColor(.gray)
                Text("象棋")
                    .font(.title2)
                    .foregroundColor(.gray)
            }
            .padding(.vertical, 8)
            .disabled(true)
            
            HStack {
                Image(systemName: "square.grid.3x3")
                    .foregroundColor(.gray)
                Text("西瓜棋")
                    .font(.title2)
                    .foregroundColor(.gray)
            }
            .padding(.vertical, 8)
            .disabled(true)
        }
        .navigationTitle("棋类游戏")
    }
}
