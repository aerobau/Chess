//
//  RCBishopMoveVerifier.swift
//  Chess
//
//  Created by Alexander Robau on 9/20/15.
//  Copyright (c) 2015 Alexander Robau. All rights reserved.
//

import Foundation

class RCBishopMoveVerifier: RCMoveVerifier {
  override func verifyMove(move: RCChessMove, moveDelegate: RCMoveDelegate) -> RCChessMove? {
    // Getting the absolute value of the proposed move's x and y
    let columnMovementMagnitude = abs(move.columnMovement)
    let rowMovementMagnitude = abs(move.rowMovement)
    
    // If the positive versions are equal the move is indeed diagonal as required for bishops
    if columnMovementMagnitude == rowMovementMagnitude {
      // Verifying the movement, if it is valid, return the proposed move, otherwise return nil
      return verifyMovementPath(move.start, destination: move.destination,
        moveDelegate: moveDelegate) ? move : nil
    } else {
      // The magnitudes of the column and row movements are not the same so the movement is not
      // diagonal and thus the move is not valid
      return nil
    }

  }
}