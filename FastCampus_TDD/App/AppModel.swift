//
//  AppModel.swift
//  FastCampus_TDD
//
//  Created by 송종훈 on 2021/07/07.
//

import Foundation



enum PlayerMode: Int {
    case modeSelection
    case single
    case multiple
}

enum Input {
    case mode(_ mode: PlayerMode)
    case players(_ players: [String])
    case guess(_ guess: Int)
}

struct Constant {
    let selectModeMessage = "1: Single Player Game" + "\n" + "2: Multyplayer Game" + "\n" + "3: Exit" + "\n" + "Enter selcetion: "
    let singlePlayerModeIntroMessage = "Single player game" + "\n" + "I'm thinking of a number between 1 and 100." + "\n" + "Enter your guess: "
    let multiPlayerModeMessage = "Multiplayer game" + "\n" + "Enter player names separated with commas: "
}

public class AppModel {
    private let constant = Constant()
    private var completed = false
    private var output: String
    private var answer: Int
    private var playerMode = PlayerMode.modeSelection
    private var tries = 0
    private let generator: PositiveIntegerGenerator
    private var players: [String] = []
    
    init(generator: PositiveIntegerGenerator) {
        output = constant.selectModeMessage
        self.generator = generator
        answer = -1
    }
    
    func isCompleted() -> Bool {
        completed
    }
    
    @discardableResult
    func flushOutput() -> String {
        output
    }
    
    private func selectMode(_ mode: PlayerMode) {
        switch mode {
            case .single:
                answer = generator.generateLessThanOrEqualToHundread()
                output = constant.singlePlayerModeIntroMessage
            case .multiple:
                answer = generator.generateLessThanOrEqualToHundread()
                output = constant.multiPlayerModeMessage
            case .modeSelection:
                completed = true
        }
        
        playerMode = mode
    }
    
    private func playSinglePlayerGame(_ guess: Int) {
        tries += 1
        
        if guess < answer {
            output = "Your guess is too low." + "\n" + "Enter yout guess: "
        } else if guess > answer {
            output = "Your guess is too high." + "\n" + "Enter yout guess: "
        } else {
            output = "Correct! " + "\(tries)" + (tries == 1 ? " guess." : " guesses.") + "\n" + constant.selectModeMessage
            playerMode = .modeSelection
        }
    }
    
    private func playMultiPlayerGame(_ guess: Int) {
        if guess < answer {
            output = "\(players[tries % players.count])'s guess is too low." + "\n"
        } else if guess > answer {
            output = "\(players[tries % players.count])'s guess is too high" + "\n"
        } else {
            output = "Collect! \(players[tries % players.count]) wins" + "\n" + constant.selectModeMessage
            playerMode = .modeSelection
            return
        }
        
        tries += 1
        output += "Enter " + players[tries % players.count] + "'s guess: "
    }
    
    func setInput(_ input: Input) {
        switch input {
            case .mode(let mode):
                selectMode(mode)
            case .guess(let guess):
                switch playerMode {
                    case .single:
                        playSinglePlayerGame(guess)
                    case .multiple:
                        playMultiPlayerGame(guess)
                    case .modeSelection:
                        fatalError("invalid input!")
                }
            case .players(let players):
                self.players = players
                output = "I'm thinking of a number between 1 and 100." + "\n" + "Enter " + players[tries % players.count] + "'s guess: "
        }
    }
}
