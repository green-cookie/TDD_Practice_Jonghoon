//
//  ProductImporter.swift
//  FastCampus_TDD
//
//  Created by 송종훈 on 2021/07/28.
//

import Foundation


class ProductImporter {
    private let dataSource: ProductDataSource
    
    init(dataSource: ProductDataSource) {
        self.dataSource = dataSource
    }
    
    func fetchProductSource() -> [Product] {
        return dataSource.fetchProductSource()
    }
}
