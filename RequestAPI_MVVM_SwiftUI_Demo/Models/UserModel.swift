//
//  UserModel.swift
//  RequestAPI_MVVM_SwiftUI_Demo
//
//  Created by Papon Supamongkonchai on 30/7/2566 BE.
//

import Foundation

struct User: Codable {
    
    let id: Int
    let name: String
    let email: String
    let company: Company
    
}

struct Company: Codable {
    let name: String
}
