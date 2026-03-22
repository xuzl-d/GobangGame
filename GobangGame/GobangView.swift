//
//  GobangView.swift
//  GobangGame
//
//  Created by xuzhilin on 2026/3/22.
//

import SwiftUI

struct GobangView: View {
    @StateObject private var game = GobangGame()
    @State private var showAlert = false
    let lineSpacing: CGFloat = 30

    var body: some View {
        VStack(spacing: 10) {
            // 游戏状态显示（与之前相同）
            VStack {
                Text("五子棋")
                    .font(.largeTitle)
                    .bold()
                
                if game.gameOver {
                    if let winner = game.winner {
                        Text("\(winner == .black ? "黑方" : "白方") 获胜!")
                            .font(.title2)
                            .foregroundColor(.red)
                    } else {
                        Text("平局!")
                            .font(.title2)
                    }
                } else {
                    Text("当前回合: \(game.currentPlayer == .black ? "黑方" : "白方")")
                        .font(.title2)
                }
            }
            .padding()

            // 棋盘区域（保持原有代码）
            GeometryReader { geometry in
                ZStack {
                    drawBoardLines()
                    drawPieces()
                }
                .background(Color(red: 0.95, green: 0.8, blue: 0.6))
                .cornerRadius(10)
                .shadow(radius: 5)
            }
            .frame(width: CGFloat(game.boardSize) * lineSpacing,
                   height: CGFloat(game.boardSize) * lineSpacing)
            .padding()

            // 控制按钮（与之前相同）
            HStack(spacing: 30) {
                Button("重新开始") {
                    game.resetGame()
                }
                .font(.headline)
                .foregroundColor(.white)
                .padding()
                .frame(width: 140)
                .background(Color.blue)
                .cornerRadius(10)

                Button("悔棋") {
                    game.undoMove()
                }
                .font(.headline)
                .foregroundColor(.white)
                .padding()
                .frame(width: 140)
                .background(Color.gray)
                .cornerRadius(10)
            }

            Spacer()

            // 游戏规则说明（与之前相同）
            VStack(alignment: .leading, spacing: 8) {
                Text("游戏规则:")
                    .font(.headline)
                Text("• 黑方先手，轮流在交叉点落子")
                Text("• 先形成五子连线者获胜")
                Text("• 点击棋盘交叉点放置棋子")
            }
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(10)
            .padding(.horizontal)
        }
        .onChange(of: game.gameOver) { newValue in
            if newValue {
                showAlert = true
            }
        }
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text(game.winner == nil ? "平局！" : "游戏结束"),
                message: Text(game.winner == nil ? "棋盘已满" : "\(game.winner == .black ? "黑方" : "白方")获胜！"),
                dismissButton: .default(Text("确定"))
            )
        }
        .navigationTitle("五子棋")          // ⭐ 添加导航标题
        .navigationBarTitleDisplayMode(.inline) // 可选：紧凑模式
    }

    // 以下 drawBoardLines 和 drawPieces 方法保持不变（与之前相同）
    private func drawBoardLines() -> some View {
        ZStack {
            VStack(spacing: lineSpacing) {
                ForEach(0..<game.boardSize, id: \.self) { _ in
                    Rectangle()
                        .fill(Color.black)
                        .frame(height: 1)
                }
            }
            .padding(.horizontal, lineSpacing / 2)
            
            HStack(spacing: lineSpacing) {
                ForEach(0..<game.boardSize, id: \.self) { _ in
                    Rectangle()
                        .fill(Color.black)
                        .frame(width: 1)
                }
            }
            .padding(.vertical, lineSpacing / 2)
        }
        .allowsHitTesting(false)   // 让网格不拦截点击
    }

    private func drawPieces() -> some View {
        ForEach(0..<game.boardSize, id: \.self) { row in
            ForEach(0..<game.boardSize, id: \.self) { col in
                if game.board[row][col] != .empty {
                    PieceView(player: game.board[row][col])
                        .frame(width: lineSpacing, height: lineSpacing)
                        .position(
                            x: CGFloat(col) * lineSpacing + lineSpacing / 2,
                            y: CGFloat(row) * lineSpacing + lineSpacing / 2
                        )
                } else {
                    Rectangle()
                        .fill(Color.clear)
                        .frame(width: lineSpacing, height: lineSpacing)
                        .contentShape(Rectangle())   // 保证透明区域可点击
                        .position(
                            x: CGFloat(col) * lineSpacing + lineSpacing / 2,
                            y: CGFloat(row) * lineSpacing + lineSpacing / 2
                        )
                        .onTapGesture {
                            game.placePiece(at: row, col)
                        }
                }
            }
        }
    }
}

struct GobangView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            GobangView()
        }
    }
}
