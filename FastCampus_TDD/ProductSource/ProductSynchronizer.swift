//
//  ProductSynchronizer.swift
//  FastCampus_TDD
//
//  Created by 송종훈 on 2021/07/28.
//

import Foundation


class ProductValidator {
    private let lowerBound: Int
    
    init(lowerBound: Int = 0) {
        self.lowerBound = lowerBound
    }
    
    func isValid(_ product: Product) -> Bool {
        lowerBound < product.getPrice()
    }
}

protocol ProductInventory {
    func upsertProduct(_ product: Product)
}


class ProductSynchronizer {
    private let importer: ProductImporter
    private let validator: ProductValidator
    private let inventory: ProductInventory
    
    init(importer: ProductImporter, validator: ProductValidator, inventory: ProductInventory) {
        self.importer = importer
        self.validator = validator
        self.inventory = inventory
    }
    
    func run() {
        importer.fetchProductSource().forEach {
            if validator.isValid($0) {
                inventory.upsertProduct($0)
            }
        }
    }
}
