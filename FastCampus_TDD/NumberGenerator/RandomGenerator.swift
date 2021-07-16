//
//  RandomGenerator.swift
//  FastCampus_TDD
//
//  Created by 송종훈 on 2021/07/07.
//

import Foundation


public class RandomGenerator: PositiveIntegerGenerator {
    public func generateLessThanOrEqualToHundread() -> Int {
        return (1 ... 100).randomElement() ?? 1
    }
}
