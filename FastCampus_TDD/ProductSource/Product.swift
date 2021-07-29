//
//  Product.swift
//  FastCampus_TDD
//
//  Created by 송종훈 on 2021/07/28.
//

import Foundation


struct Product: Equatable {
    private(set) var supplierName: String
    private(set) var productCode: String
    private(set) var productName: String
    private(set) var price: Int
    
    init(supplierName: String,
         productCode: String,
         productName: String,
         price: Int) {
        self.supplierName = supplierName
        self.productCode = productCode
        self.productName = productName
        self.price = price
    }
    
    func getSupplierName() -> String {
        supplierName
    }
    
    func getProductCode() -> String {
        productCode
    }
    
    func getProductName() -> String {
        productName
    }
    
    func getPrice() -> Int {
        price
    }
}
