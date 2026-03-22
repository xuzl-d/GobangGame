//
//  GobangGame.swift
//  GobangGame
//
//  Created by xuzhilin on 2026/3/22.
//
import SwiftUI
import Combine
import Foundation

// 棋子类型
enum Player: Equatable {
    case black   // 黑方
    case white   // 白方
    case empty   // 空位
}

// 游戏逻辑类（遵守 ObservableObject，让 SwiftUI 能自动更新界面）
class GobangGame: ObservableObject {
    // 棋盘大小：15x15（标准五子棋棋盘）
    let boardSize = 15
    
    // @Published 修饰的属性变化时会自动刷新视图
    @Published var board: [[Player]] = []
    @Published var currentPlayer: Player = .black
    @Published var gameOver = false
    @Published var winner: Player? = nil
    
    // 历史记录，用于悔棋
    private var history: [(row: Int, col: Int)] = []
    
    // 初始化
    init() {
        resetGame()
    }
    
    // 重置游戏
    func resetGame() {
        print("resetGame called")   // 添加这行
        // 创建一个 boardSize x boardSize 的二维数组，全部填 .empty
        board = Array(repeating: Array(repeating: .empty, count: boardSize), count: boardSize)
        currentPlayer = .black
        gameOver = false
        winner = nil
        history.removeAll()
    }
    
    // 悔棋
    func undoMove() -> Bool {
        guard !gameOver, let last = history.popLast() else { return false }
        // 清除棋子
        board[last.row][last.col] = .empty
        // 切换当前玩家（回到刚才下棋的人）
        currentPlayer = (currentPlayer == .black ? .white : .black)
        gameOver = false
        winner = nil
        return true
    }
    
    // 落子
    @discardableResult
    func placePiece(at row: Int, _ col: Int) -> Bool {
        print("placePiece called at (\(row), \(col))")
        // 检查位置是否有效、游戏是否已结束、格子是否为空
        guard row >= 0 && row < boardSize,
              col >= 0 && col < boardSize,
              !gameOver,
              board[row][col] == .empty else {
            return false
        }
        
        // 落子
        board[row][col] = currentPlayer
        history.append((row, col))
        
        // 判断胜负
        if checkWin(at: row, col: col, player: currentPlayer) {
            gameOver = true
            winner = currentPlayer
        } else if isBoardFull() {
            gameOver = true
            winner = nil  // 平局
        } else {
            // 切换玩家
            currentPlayer = (currentPlayer == .black ? .white : .black)
        }
        
        return true
    }
    
    // 检查棋盘是否已满
    private func isBoardFull() -> Bool {
        for row in 0..<boardSize {
            for col in 0..<boardSize {
                if board[row][col] == .empty {
                    return false
                }
            }
        }
        return true
    }
    
    // 检查指定位置是否连成五子
    private func checkWin(at row: Int, col: Int, player: Player) -> Bool {
        // 四个方向：(行变化, 列变化)
        let directions = [(1, 0), (0, 1), (1, 1), (1, -1)]
        
        for (dx, dy) in directions {
            var count = 1
            
            // 正方向延伸
            var r = row + dx
            var c = col + dy
            while r >= 0 && r < boardSize && c >= 0 && c < boardSize && board[r][c] == player {
                count += 1
                r += dx
                c += dy
            }
            
            // 反方向延伸
            r = row - dx
            c = col - dy
            while r >= 0 && r < boardSize && c >= 0 && c < boardSize && board[r][c] == player {
                count += 1
                r -= dx
                c -= dy
            }
            
            if count >= 5 {
                return true
            }
        }
        return false
    }
}
