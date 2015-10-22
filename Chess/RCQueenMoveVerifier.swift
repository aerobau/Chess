//
//  RCQueenMoveVerifier.swift
//  Chess
//
//  Created by Alexander Robau on 9/20/15.
//  Copyright (c) 2015 Alexander Robau. All rights reserved.
//

import Foundation

class RCQueenMoveVerifier: RCMoveVerifier {
  override func verifyMove(move: RCChessMove, moveDelegate: RCMoveDelegate) -> RCChessMove? {
    // Verify movement path returns false if the move is not diagonal or straight, so thus the queen
    // can send moves directly for verification.  If the verification is successful, return the move
    // otherwise return nil
    return verifyMovementPath(move.start, destination: move.destination,
      moveDelegate: moveDelegate) ? move : nil
  }
}