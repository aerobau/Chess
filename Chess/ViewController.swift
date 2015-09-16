//
//  ViewController.swift
//  Chess
//
//  Created by Alexander Robau on 8/12/15.
//  Copyright (c) 2015 Alexander Robau. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
  
  var buttons = [[NSButton]]()
  var chessBoard = RCFactory.prepareChessBoard()
  var activeButtonCoordinate: RCChessCoordinate?
  var turnColor = RCPieceColor.White
  var gameOver: Bool = false

  override func viewDidLoad() {
    super.viewDidLoad()

    // appending all of the buttins to a array so that their positions will match the possitions on
    // the chessboard
    buttons.append([button00, button01, button02, button03, button04, button05, button06, button07])
    buttons.append([button10, button11, button12, button13, button14, button15, button16, button17])
    buttons.append([button20, button21, button22, button23, button24, button25, button26, button27])
    buttons.append([button30, button31, button32, button33, button34, button35, button36, button37])
    buttons.append([button40, button41, button42, button43, button44, button45, button46, button47])
    buttons.append([button50, button51, button52, button53, button54, button55, button56, button57])
    buttons.append([button60, button61, button62, button63, button64, button65, button66, button67])
    buttons.append([button70, button71, button72, button73, button74, button75, button76, button77])
    
    // Update the UI so that the view ill load properly matching all of the images
    updateUI()
  }

  override var representedObject: AnyObject? {
    didSet {
    // Update the view, if already loaded.
    }
  }
  
  // Declaring all of the buttons with the coordinates
  @IBOutlet var button07: NSButton!
  @IBOutlet var button17: NSButton!
  @IBOutlet var button27: NSButton!
  @IBOutlet var button37: NSButton!
  @IBOutlet var button47: NSButton!
  @IBOutlet var button57: NSButton!
  @IBOutlet var button67: NSButton!
  @IBOutlet var button77: NSButton!
  
  @IBOutlet var button06: NSButton!
  @IBOutlet var button16: NSButton!
  @IBOutlet var button26: NSButton!
  @IBOutlet var button36: NSButton!
  @IBOutlet var button46: NSButton!
  @IBOutlet var button56: NSButton!
  @IBOutlet var button66: NSButton!
  @IBOutlet var button76: NSButton!
  
  @IBOutlet var button05: NSButton!
  @IBOutlet var button15: NSButton!
  @IBOutlet var button25: NSButton!
  @IBOutlet var button35: NSButton!
  @IBOutlet var button45: NSButton!
  @IBOutlet var button55: NSButton!
  @IBOutlet var button65: NSButton!
  @IBOutlet var button75: NSButton!
  
  @IBOutlet var button04: NSButton!
  @IBOutlet var button14: NSButton!
  @IBOutlet var button24: NSButton!
  @IBOutlet var button34: NSButton!
  @IBOutlet var button44: NSButton!
  @IBOutlet var button54: NSButton!
  @IBOutlet var button64: NSButton!
  @IBOutlet var button74: NSButton!
  
  @IBOutlet var button03: NSButton!
  @IBOutlet var button13: NSButton!
  @IBOutlet var button23: NSButton!
  @IBOutlet var button33: NSButton!
  @IBOutlet var button43: NSButton!
  @IBOutlet var button53: NSButton!
  @IBOutlet var button63: NSButton!
  @IBOutlet var button73: NSButton!
  
  @IBOutlet var button02: NSButton!
  @IBOutlet var button12: NSButton!
  @IBOutlet var button22: NSButton!
  @IBOutlet var button32: NSButton!
  @IBOutlet var button42: NSButton!
  @IBOutlet var button52: NSButton!
  @IBOutlet var button62: NSButton!
  @IBOutlet var button72: NSButton!
  
  @IBOutlet var button01: NSButton!
  @IBOutlet var button11: NSButton!
  @IBOutlet var button21: NSButton!
  @IBOutlet var button31: NSButton!
  @IBOutlet var button41: NSButton!
  @IBOutlet var button51: NSButton!
  @IBOutlet var button61: NSButton!
  @IBOutlet var button71: NSButton!
  
  @IBOutlet var button00: NSButton!
  @IBOutlet var button10: NSButton!
  @IBOutlet var button20: NSButton!
  @IBOutlet var button30: NSButton!
  @IBOutlet var button40: NSButton!
  @IBOutlet var button50: NSButton!
  @IBOutlet var button60: NSButton!
  @IBOutlet var button70: NSButton!
  
  // An outlet for the notification label
  @IBOutlet weak var notificationLabel: NSTextField!
  
  // An outlet for the label telling which turn it is
  @IBOutlet weak var turnLabel: NSTextField!
  
  private struct PlayerNotification {
    static let kingInCheck = "Your king is in check"
    static let kingInCheckmate = "Your king is in checkmate, you lose"
    static let resultsInCheck = "Move would result in your king being in check"
    static let invalidMove = "Invalid move"
  }
  
  private struct ImageNames {
    static let whitePawn = "white_pawn.png"
    static let blackPawn = "black_pawn.png"
    static let whiteRook = "white_rook.png"
    static let blackRook = "black_rook.png"
    static let whiteKnight = "white_knight.png"
    static let blackKnight = "black_knight.png"
    static let whiteBishop = "white_bishop.png"
    static let blackBishop = "black_bishop.png"
    static let whiteQueen = "white_queen.png"
    static let blackQueen = "black_queen.png"
    static let whiteKing = "white_king.png"
    static let blackKing = "black_king.png"
  }
  
  func updateUI() {
    for var i = 0; i < 8; ++i {
      for var j = 0; j < 8; ++j {
        let button = buttons[i][j]
        if let piece = chessBoard.board[i][j].piece {
          if piece.color == .White {
            switch piece.type {
            case .Pawn: button.image = NSImage(named: ImageNames.whitePawn)!
            case .Rook: button.image = NSImage(named: ImageNames.whiteRook)!
            case .Knight: button.image = NSImage(named: ImageNames.whiteKnight)!
            case .Bishop: button.image = NSImage(named: ImageNames.whiteBishop)!
            case .Queen: button.image = NSImage(named: ImageNames.whiteQueen)!
            case .King: button.image = NSImage(named: ImageNames.whiteKing)!
            default: button.image = nil
            }
          } else if piece.color == .Black {
            switch piece.type {
            case .Pawn: button.image = NSImage(named: ImageNames.blackPawn)!
            case .Rook: button.image = NSImage(named: ImageNames.blackRook)!
            case .Knight: button.image = NSImage(named: ImageNames.blackKnight)!
            case .Bishop: button.image = NSImage(named: ImageNames.blackBishop)!
            case .Queen: button.image = NSImage(named: ImageNames.blackQueen)!
            case .King: button.image = NSImage(named: ImageNames.blackKing)!
            default: button.image = nil
            }
          } else {
            button.image = nil
          }
        } else {
          button.image = nil
        }
      }
    }
    
    turnLabel.stringValue = "It is \(turnColor.rawValue)'s turn."
  }
  
  @IBAction func buttonPressed(sender: NSButton) {
    // get the button's identifier, which is set to be the number in "column""row" format of the
    // button's corresponding square
    let id = sender.identifier!
    
    // Getting the column and row from the number identifier
    let column = id.toInt()! / 10
    let row = id.toInt()! % 10
    
    // Creating a chess coordinate using retrieved column and row
    let coordinate = RCChessCoordinate(column: column, row: row)
    if let activeCoordinate = activeButtonCoordinate {
      // The active coordinate exists
      var piece = chessBoard.board[activeCoordinate.column][activeCoordinate.row].piece
      if  piece?.color == turnColor {
        var move = RCChessMove(start: activeCoordinate, destination: coordinate, piece: piece!)
        if let validMove = chessBoard.verifyMove(move) {
          if !chessBoard.performKingCheckTest(move) {
            chessBoard.performMove(move)
            notificationLabel.stringValue = ""
            switchTurn()
          } else {
            notificationLabel.stringValue = PlayerNotification.resultsInCheck
          }
        } else {
          notificationLabel.stringValue = PlayerNotification.invalidMove
        }
      } else {
        notificationLabel.stringValue = PlayerNotification.invalidMove
      }
      activeButtonCoordinate = nil
      updateUI()
    } else {
      activeButtonCoordinate = coordinate
    }
  }
  
  enum RCPlayerNotification {
    case resultsInCheck
    case kingInCheck
    case invalidMove
    case none
  }
  
  func switchTurn() {
    chessBoard.flipBoard()
    switch(turnColor) {
      case .White: turnColor = .Black
      case .Black: turnColor = .White
      default: break
    }
    
    if chessBoard.isKingInCheck(turnColor) {
      if chessBoard.testForCheckMate(turnColor) {
        notificationLabel.stringValue = PlayerNotification.kingInCheckmate
        gameOver = true
      } else {
        notificationLabel.stringValue = PlayerNotification.kingInCheck
      }
    }
  }
}

