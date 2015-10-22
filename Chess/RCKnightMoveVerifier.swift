//
//  RCKnightMoveVerifier.swift
//  Chess
//
//  Created by Alexander Robau on 9/20/15.
//  Copyright (c) 2015 Alexander Robau. All rights reserved.
//

import Foundation

class RCKnightMoveVerifier: RCMoveVerifier {
  override func verifyMove(move: RCChessMove, moveDelegate: RCMoveDelegate) -> RCChessMove? {
    // Getting the absolute value of the proposed move's x and y
    let columnMovementMagnitude = abs(move.columnMovement)
    let rowMovementMagnitude = abs(move.rowMovement)
    
    // Two xor statements make sure one of the movements coordinate movements has a magnitude of two
    // and one of the coordinate movements has a magnitude of 1
    if (columnMovementMagnitude == 2) != (rowMovementMagnitude == 2) &&
      (columnMovementMagnitude == 1) != (rowMovementMagnitude == 1) {
        // Get the destination square according to the destination coordinates
        let destinationSquare = moveDelegate[move.destination.column][move.destination.row]
        
        // If there is a piece at the destination, make sure it is not the same color as the moving
        // piece
        if let destinationPiece = destinationSquare.piece {
          // The move is valid only if the piece in the destination square is not the same color as
          // the moving piece
          return destinationPiece.color != move.piece.color ? move : nil
        } else {
          // The move is valid, there is no piece in the destination square
          return move
        }
    } else {
      // The move is not valid because it does not have the proper coordinates
      return nil
    }
  }
}