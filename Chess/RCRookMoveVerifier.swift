//
//  RCRookMoveVerifier.swift
//  Chess
//
//  Created by Alexander Robau on 9/20/15.
//  Copyright (c) 2015 Alexander Robau. All rights reserved.
//

import Foundation

class RCRookMoveVerifier: RCMoveVerifier {
  override func verifyMove(move: RCChessMove, moveDelegate: RCMoveDelegate) -> RCChessMove? {
    // One and only one coordinate of the move must be zero for a legal rook move
    if (move.columnMovement == 0) != (move.rowMovement == 0) {
      // Verifying the movement, returning nil if it is not valid
      return verifyMovementPath(move.start, destination: move.destination,
        moveDelegate: moveDelegate) ? move : nil
    } else {
      // The move is not valid, return a nil ChessMove
      return nil
    }
  }
}