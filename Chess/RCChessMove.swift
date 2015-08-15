//
//  ChessMove.swift
//  Chess
//
//  Created by Alexander Robau on 6/19/14.
//  Copyright (c) 2015 Robau Industries. All rights reserved.
//

import Foundation

// Enumeration to represent the flag that a move may carry if it is one of the special moves that
// needs specific processing
enum RCSpecialMoveFlag {
  case enPassant
  case castle
  case kingMove
  case none
}

// Class ChessMove 

// Used to keep track of how a chessmove is to be executed, its starts with
// the creationn of the move with a starting location and ending location.  As the move is
// processed, flags may be added to it to indicate if it is a special move.
class RCChessMove {
  var start: RCChessCoordinate
  var destination: RCChessCoordinate
  
  // Calculated column movement change from the start to the destination
  var columnMovement: Int {
    return destination.column - start.column
  }
  
  // Calculated row movement change from the start to the destination
  var rowMovement: Int {
    return destination.row - start.row
  }
  
  // The piece that is being moved
  var piece: RCChessPiece
  
  // A flag to represent whether a move needs special processing.  Set to .none by default and may
  // be changed later
  var flag: RCSpecialMoveFlag = .none
  
  // Initializer that will initialize the move with a start and destination, the flag will be
  // changed later if necessary
  init(start: RCChessCoordinate, destination: RCChessCoordinate, piece: RCChessPiece) {
    self.start = start
    self.destination = destination
    self.piece = piece
  }
  
  // Default initializer, puts the start and destination at -1,-1 outside of the range of the board
  // Also makes the piece undefined
  init() {
    self.start = RCChessCoordinate(column: -1, row: -1)
    self.destination = RCChessCoordinate(column: -1, row: -1)
    self.piece = RCChessPiece()
  }
}
