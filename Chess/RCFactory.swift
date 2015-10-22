//
//  Factory.swift
//  Chess
//
//  Created by Alexander Robau on 6/19/14.
//  Copyright (c) 2014 Robau Castillo Industries. All rights reserved.
//

import Foundation
import Cocoa

class RCFactory {
  class func prepareChessBoard() -> RCChessBoard {
    // Pawn creation
    let whitePawn = RCChessPiece(type: .Pawn, color: .White, moveVerifier: RCPawnMoveVerifier())
    let blackPawn = RCChessPiece(type: .Pawn, color: .Black, moveVerifier: RCPawnMoveVerifier())
    
    // Knight creation
    let whiteKnight = RCChessPiece(type: .Knight, color: .White, moveVerifier: RCKnightMoveVerifier())
    let blackKnight = RCChessPiece(type: .Knight, color: .Black, moveVerifier: RCKnightMoveVerifier())
    
    // Rook creation
    let whiteRook = RCChessPiece(type: .Rook, color: .White, moveVerifier: RCRookMoveVerifier())
    let blackRook = RCChessPiece(type: .Rook, color: .Black, moveVerifier: RCRookMoveVerifier())
    
    // Bishop creation
    let whiteBishop = RCChessPiece(type: .Bishop, color: .White, moveVerifier: RCBishopMoveVerifier())
    let blackBishop = RCChessPiece(type: .Bishop, color: .Black, moveVerifier: RCBishopMoveVerifier())
    
    // Queen creation
    let whiteQueen = RCChessPiece(type: .Queen, color: .White, moveVerifier: RCQueenMoveVerifier())
    let blackQueen = RCChessPiece(type: .Queen, color: .Black, moveVerifier: RCQueenMoveVerifier())
    
    // King creation
    let whiteKing = RCChessPiece(type: .King, color: .White, moveVerifier: RCKingMoveVerifier())
    let blackKing = RCChessPiece(type: .King, color: .Black, moveVerifier: RCKingMoveVerifier())
    
    var preparedBoard: [[RCChessSquare]] = []
    for var i = 0; i < 8; i++ {
      preparedBoard.append(Array(count: 8, repeatedValue: RCChessSquare()))
    }
    
    for var i = 0; i < 8; i++ {
      for var j = 0; j < 8; j++ {
        if j == 0 {
          if i == 0 || i == 7 {
            preparedBoard[i][j] =
              RCChessSquare(piece: RCChessPiece(copyPiece: whiteRook),
                coordinate: RCChessCoordinate(column: i, row: j))
          } else if i == 1 || i == 6 {
            preparedBoard[i][j] =
              RCChessSquare(piece: RCChessPiece(copyPiece: whiteKnight),
                coordinate: RCChessCoordinate(column: i, row: j))
          } else if i == 2 || i == 5 {
            preparedBoard[i][j] =
              RCChessSquare(piece: RCChessPiece(copyPiece: whiteBishop),
                coordinate: RCChessCoordinate(column: i, row: j))
          } else if i == 3 {
            preparedBoard[i][j] =
              RCChessSquare(piece: RCChessPiece(copyPiece: whiteQueen),
                coordinate: RCChessCoordinate(column: i, row: j))
          } else if i == 4 {
            preparedBoard[i][j] =
              RCChessSquare(piece: RCChessPiece(copyPiece: whiteKing),
                coordinate: RCChessCoordinate(column: i, row: j))
          }
        } else if j == 1 {
          preparedBoard[i][j] =
            RCChessSquare(piece: RCChessPiece(copyPiece: whitePawn),
              coordinate: RCChessCoordinate(column: i, row: j))
        }
        
        else if j == 7 {
          if i == 0 || i == 7 {
            preparedBoard[i][j] =
              RCChessSquare(piece: RCChessPiece(copyPiece: blackRook),
                coordinate: RCChessCoordinate(column: i, row: j))
          } else if i == 1 || i == 6 {
            preparedBoard[i][j] =
              RCChessSquare(piece: RCChessPiece(copyPiece: blackKnight),
                coordinate: RCChessCoordinate(column: i, row: j))
          } else if i == 2 || i == 5 {
            preparedBoard[i][j] =
              RCChessSquare(piece: RCChessPiece(copyPiece: blackBishop),
                coordinate: RCChessCoordinate(column: i, row: j))
          } else if i == 3 {
            preparedBoard[i][j] =
              RCChessSquare(piece: RCChessPiece(copyPiece: blackQueen),
                coordinate: RCChessCoordinate(column: i, row: j))
          } else if i == 4 {
            preparedBoard[i][j] =
              RCChessSquare(piece: RCChessPiece(copyPiece: blackKing),
                coordinate: RCChessCoordinate(column: i, row: j))
          }
        } else if j == 6 {
          preparedBoard[i][j] =
            RCChessSquare(piece: RCChessPiece(copyPiece: blackPawn),
              coordinate: RCChessCoordinate(column: i, row: j))
        } else {
          preparedBoard[i][j] = RCChessSquare(coordinate: RCChessCoordinate(column: i, row: j))
        }
      }
    }
    return RCChessBoard(board: preparedBoard)
  }
}