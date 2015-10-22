//
//  RCPawnMoveVerifier.swift
//  Chess
//
//  Created by Alexander Robau on 9/17/15.
//  Copyright (c) 2015 Alexander Robau. All rights reserved.
//

import Foundation

class RCPawnMoveVerifier: RCMoveVerifier {
  // Method to check if the move is valid and update it if necessary
  override func verifyMove(move: RCChessMove, moveDelegate: RCMoveDelegate) -> RCChessMove? {
    // Getting the positive column movement
    let columnMovementMagnitude = abs(move.columnMovement)
    let rowMovementMagnitude = abs(move.rowMovement)
    
    // Diagonal movement, must be a capture of some sort
    if columnMovementMagnitude == 1 && columnMovementMagnitude == 1 {
      // Determining if this is an en passant capture
      let opponentPieceEnPassant: Bool
      if let piece = moveDelegate[move.destination.column][move.start.row].piece {
        // There is a piece en passant, determine if it is a different color pawn
        opponentPieceEnPassant = validCaptureForEnPassant(piece)
      } else {
        opponentPieceEnPassant = false
      }
      
      // Determining if this is a normal capture
      let opponentPieceDiagonal: Bool
      if let piece = moveDelegate[move.destination.column][move.destination.row]
        .piece {
          // There is a piece diagonally, determine if it is of a different color
          opponentPieceDiagonal = piece.color != move.piece.color
      } else {
        opponentPieceDiagonal = false
      }
      
      // The following if statements make sure that the piece is moving only in the correct
      // direction due to pawns having a one way system
      if move.rowMovement == 1 {
        // Pawn is moving upwards with the home color
        if opponentPieceDiagonal {
          // The move is a regular capture
          return move
        } else if opponentPieceEnPassant {
          // The move is an enpassant capture, set the flag to enpassant and return the move
          move.flag = .enPassant
          return move
        } else {
          // The move is not legal, return a nil chess move
          return nil
        }
      } else if move.rowMovement == -1 {
        // Pawn is moving downwards without the home color
        if opponentPieceDiagonal {
          // The move is a regular capture
          return move
        } else if opponentPieceEnPassant {
          // The move is an enpassant capture, set the flag to enpassant and return the move
          move.flag = .enPassant
          return move
        } else {
          // The move is not legal, return a nil chess move
          return nil
        }
      } else {
        // The move is not legal, return a nil chess move
        return nil
      }
    }
    
      // If the row movement is 2 it can only be an opening move, and the column movement must = 0
    else if rowMovementMagnitude == 2 && columnMovementMagnitude == 0 {
      // Getting the row of the square in the middle of the destination and start
      let midSpaceRow = move.start.row + (move.rowMovement / 2)
      
      // Setting a boolean validMove to whether or not the move is valid
      let validMove = !move.piece.moved &&
        moveDelegate[move.destination.column][move.destination.row].piece == nil &&
        moveDelegate[move.start.column][midSpaceRow].piece == nil
      
      // If the move is valid, taking into consideration the direction of travel, return it,
      // otherwise return nil
      if move.rowMovement == 2 && move.piece.color == moveDelegate.getHomeColor() {
        return validMove ? move : nil
      } else if move.rowMovement == -2 && move.piece.color != moveDelegate.getHomeColor() {
        return validMove ? move : nil
      } else {
        return nil
      }
    }
      
      // If the row movement magnitude is 1, this is a normal 1 step forward movement
    else if rowMovementMagnitude == 1 && columnMovementMagnitude == 0 {
      // Setting a boolean validMove to whether or not the move is valid
      let validMove =
      moveDelegate[move.destination.column][move.destination.row].piece == nil
      
      // If the move is valid, taking into account direction of travel, return it
      // otherwise return nil
      if move.rowMovement > 0 && move.piece.color == moveDelegate.getHomeColor() {
        return validMove ? move : nil
      } else if move.rowMovement < 0 && move.piece.color != moveDelegate.getHomeColor() {
        return validMove ? move : nil
      } else {
        return nil
      }
    }
      
      // None of the possible moves were used, return a nil ChessMove
    else { return nil }
  }
  
  private func validCaptureForEnPassant(piece: RCChessPiece) -> Bool {
    // The piece needs to be a pawn that has only moved once
    if piece.type == .Pawn && piece.moveHistory.count == 1 {
      // Getting the last move of the piece
      let lastMove = piece.moveHistory[0]
      
      // The last piece was a two forward pawn move
      if abs(lastMove.rowMovement) == 2 && lastMove.columnMovement == 0 {
        return true
      } else {
        return false
      }
    } else {
      return false
    }
  }
}