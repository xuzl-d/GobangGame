//
//  PieceView.swift
//  GobangGame
//
//  Created by xuzhilin on 2026/3/22.
//

import SwiftUI

struct PieceView: View {
    let player: Player  // 传入棋子类型
    
    var body: some View {
        Circle()
            .fill(player == .black ? Color.black : Color.white)
            .shadow(color: .gray, radius: 2, x: 0, y: 2)
            .overlay(
                Circle()
                    .stroke(Color.gray, lineWidth: 1)
            )
    }
}
