//
//  ProductSource.swift
//  FastCampus_TDD
//
//  Created by 송종훈 on 2021/07/28.
//

import Foundation


protocol ProductDataSource {
    func fetchProductSource() -> [Product]
}
