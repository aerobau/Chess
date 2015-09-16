//
//  ChessPiece.swift
//  Chess
//
//  Created by Alexander Robau on 6/19/14.
//  Copyright (c) 2015 Robau Industries. All rights reserved.
//

import Foundation
import Cocoa

// Enumeration to define different types of pieces the chess piece could be
enum RCPieceType: String {
  case Pawn = "Pawn"
  case Rook = "Rook"
  case Knight = "Knight"
  case Bishop = "Bishop"
  case Queen = "Queen"
  case King = "King"
  case Undefined = ""
}

// Enumeration to define the two different colors that a chesspiece could be
enum RCPieceColor: String {
  case White = "White"
  case Black = "Black"
  case Undefined = ""
}

// Class to define what a chesspiece is.  Has three attributes:
//   type: pawn, rook, knight, bishop, etc
//   moved: whether or not the piece has been moved ever (moves like castling and two step pawns)
//   image: an image which represents the piece.
struct RCChessPiece {
  var type: RCPieceType
  var color: RCPieceColor
  var moveHistory: [RCChessMove] = []
  
  var moved: Bool {
    return moveHistory.count != 0
  }
  
  init(type: RCPieceType = .Undefined, color: RCPieceColor = .Undefined) {
    self.type = type
    self.color = color
  }
  
  init(copyPiece: RCChessPiece) {
    self.type = copyPiece.type
    self.color = copyPiece.color
  }
}
