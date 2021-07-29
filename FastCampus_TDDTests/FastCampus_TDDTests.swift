//
//  FastCampus_TDDTests.swift
//  FastCampus_TDDTests
//
//  Created by 송종훈 on 2021/07/07.
//

import XCTest
@testable import FastCampus_TDD

class GeneratorStub: PositiveIntegerGenerator {
    private let answers: [Int]
    private var index = 0
    
    init(answer: Int) {
        self.answers = [answer]
    }
    
    init(answers: [Int]) {
        self.answers = answers
    }
    
    func generateLessThanOrEqualToHundread() -> Int {
        let number = answers[index]
        index = (index + 1) % answers.count
        return number
    }
}

class FastCampus_TDDTests: XCTestCase {

    func test_IsCompleted_when_initialized() {
        let appModel = AppModel(generator: RandomGenerator())
        XCTAssertEqual(appModel.isCompleted(), false)
    }
    
    func test_CollectlyMessage_when_select_model() {
        let appModel = AppModel(generator: RandomGenerator())
        let message = appModel.flushOutput()
        
        XCTAssertEqual(message, "1: Single Player Game" + "\n" + "2: Multyplayer Game" + "\n" + "3: Exit" + "\n" + "Enter selcetion: ")
    }
    
    func test_CollectlyExits() {
        let appModel = AppModel(generator: RandomGenerator())
        appModel.setInput(.mode(.modeSelection))
        
        XCTAssertTrue(appModel.isCompleted())
    }
    
    func test_CollectlyPrint_single_player_game_start_message() {
        let appModel = AppModel(generator: RandomGenerator())
        appModel.setInput(.mode(.single))
        
        XCTAssertEqual(appModel.flushOutput(), "Single player game" + "\n" + "I'm thinking of a number between 1 and 100." + "\n" + "Enter your guess: ")
    }
    
    func test_CollectlyPrint_tooLowMessage_in_single_player_game() {
        typealias Param = (answer: Int, guess: Int)
        
        let testParam: [Param] = [(50, 40), (30, 29), (89, 9)]
        testParam.forEach { answer, guess in
            let appModel = AppModel(generator: GeneratorStub(answer: answer))
            appModel.setInput(.mode(.single))
            appModel.setInput(.guess(guess))
            
            XCTAssertEqual(appModel.flushOutput(), "Your guess is too low." + "\n" + "Enter yout guess: ")
        }
    }
    
    func test_CollectlyPrint_tooHighMessage_in_single_player_game() {
        typealias Param = (answer: Int, guess: Int)
        
        let testParam: [Param] = [(50, 60), (80, 81)]
        testParam.forEach { answer, guess in
            let appModel = AppModel(generator: GeneratorStub(answer: answer))
            appModel.setInput(.mode(.single))
            appModel.setInput(.guess(guess))
            
            XCTAssertEqual(appModel.flushOutput(), "Your guess is too high." + "\n" + "Enter yout guess: ")
        }
    }
    
    func test_CollectlyPrint_collectMessage_in_single_player_game() {
        let testParam: [Int] = [1, 3, 10, 100]
        
        testParam.forEach { answer in
            let appModel = AppModel(generator: GeneratorStub(answer: answer))
            appModel.setInput(.mode(.single))
            appModel.setInput(.guess(answer))
            
            XCTAssertTrue(appModel.flushOutput().contains("Correct! "))
        }
    }
    
    func test_CollectlyPrint_guessCount_if_single_player_game_finished() {
        let fails = [1, 10, 100]
        let answer = 50
        
        let appModel = AppModel(generator: GeneratorStub(answer: answer))
        appModel.setInput(.mode(.single))
        
        fails.forEach { fail in
            appModel.setInput(.guess(fail))
        }
        
        appModel.setInput(.guess(answer))
        
        XCTAssertTrue(appModel.flushOutput().contains("\(fails.count + 1)" + " guesses." + "\n"))
    }
    
    func test_CollectlyPrint_one_guess_if_single_player_game_finished() {
        let answer = 50
        let appModel = AppModel(generator: GeneratorStub(answer: answer))
        appModel.setInput(.mode(.single))
        appModel.setInput(.guess(answer))
        
        XCTAssertTrue(appModel.flushOutput().contains("1 guess."))
    }
    
    func test_print_select_mode_message_if_single_player_game_finished() {
        let answer = 50
        let appModel = AppModel(generator: GeneratorStub(answer: answer))
        appModel.setInput(.mode(.single))
        appModel.setInput(.guess(answer))
        
        XCTAssertTrue(appModel.flushOutput().contains("1: Single Player Game" + "\n" + "2: Multyplayer Game" + "\n" + "3: Exit" + "\n" + "Enter selcetion: "))
    }
    
    func test_returns_to_mode_selection_if_single_player_game_finished() {
        let answer = 50
        let appModel = AppModel(generator: GeneratorStub(answer: answer))
        
        appModel.setInput(.mode(.single))
        appModel.setInput(.guess(answer))
        appModel.setInput(.mode(.modeSelection))
        
        XCTAssertTrue(appModel.isCompleted())
    }
    
    func test_generates_answer_for_each_game() {
        let testParam: [Int] = [100, 10, 1]
        let appModel = AppModel(generator: GeneratorStub(answers: testParam))
        
        testParam.forEach { param in
            appModel.setInput(.mode(.single))
            appModel.setInput(.guess(param))
        }
        
        XCTAssertTrue(appModel.flushOutput().contains("Correct! "))
    }
    
    func test_CollectlyPrint_multiplayer_game_setup_message() {
        let appModel = AppModel(generator: GeneratorStub(answer: 50))
        appModel.setInput(.mode(.multiple))
        
        XCTAssertEqual(appModel.flushOutput(), "Multiplayer game" + "\n" + "Enter player names separated with commas: ")
    }
    
    func test_CollectlyPrint_multiplayer_game_start_message() {
        let appModel = AppModel(generator: GeneratorStub(answer: 50))
        appModel.setInput(.mode(.multiple))
        appModel.setInput(.players(["Foo", "Bar"]))
        
        XCTAssertTrue(appModel.flushOutput().contains("I'm thinking of a number between 1 and 100."))
    }
    
    func test_CollectlyPrompts_firstPlayer_name() {
        let players: [String] = ["Foo", "Bar", "Baz", "Bar", "Baz", "Foo", "Baz", "Foo", "Bar"]
        let appModel = AppModel(generator: GeneratorStub(answer: 50))
        appModel.setInput(.mode(.multiple))
        appModel.setInput(.players(players))
        
        XCTAssertTrue(appModel.flushOutput().contains("Enter " + players[0] + "'s guess: "))
    }
    
    func test_CollectlyPrompts_SecondPlayer_name() {
        let players: [String] = ["Foo", "Bar", "Baz", "Bar", "Baz", "Foo", "Baz", "Foo", "Bar"]
        let appModel = AppModel(generator: GeneratorStub(answer: 50))
        appModel.setInput(.mode(.multiple))
        appModel.setInput(.players(players))
        appModel.setInput(.guess(70))
        
        XCTAssertTrue(appModel.flushOutput().contains("Enter " + players[1] + "'s guess: "))
    }
    
    func test_CollectlyPrompts_thirdPlayer_name() {
        let players: [String] = ["Foo", "Bar", "Baz", "Bar", "Baz", "Foo", "Baz", "Foo", "Bar"]
        let appModel = AppModel(generator: GeneratorStub(answer: 50))
        appModel.setInput(.mode(.multiple))
        appModel.setInput(.players(players))
        appModel.setInput(.guess(90))
        appModel.setInput(.guess(90))
        
        XCTAssertTrue(appModel.flushOutput().contains("Enter " + players[2] + "'s guess: "))
    }
    
    func test_CollectlyRounds_players() {
        let players: [String] = ["Foo", "Bar", "Baz"]
        let appModel = AppModel(generator: GeneratorStub(answer: 50))
        appModel.setInput(.mode(.multiple))
        appModel.setInput(.players(players))
        appModel.setInput(.guess(10))
        appModel.setInput(.guess(10))
        appModel.setInput(.guess(10))
        
        XCTAssertTrue(appModel.flushOutput().contains("Enter " + players[0] + "'s guess: "))
    }
}
