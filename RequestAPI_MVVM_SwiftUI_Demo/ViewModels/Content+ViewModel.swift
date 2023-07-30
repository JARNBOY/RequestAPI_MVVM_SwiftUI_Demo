//
//  Content+ViewModel.swift
//  RequestAPI_MVVM_SwiftUI_Demo
//
//  Created by Papon Supamongkonchai on 30/7/2566 BE.
//

import Foundation

@MainActor class ContentViewModel : ObservableObject {
    @Published var users: [User] = []
    @Published var hasError = false
    @Published var error: UserError?
    
    func fetchUser() async {
        //endpoint
        let urlString: String = "https://jsonplaceholder.typicode.com/users"
        
        //request
        do {
            let data = try await APIManager.shared.request(endpoint: urlString, method: .get, headers: nil, body: nil)
            
            //data
            do {
                let response = try JSONDecoder().decode([User].self, from: data)
                print(response)
                self.users = response
            } catch (let error) {
                print("Error decoding JSON: \(error)")
                if let err = error as? ContentViewModel.UserError {
                    self.error = err
                } else {
                    self.error = ContentViewModel.UserError.custom(error: error)
                }
            }
            
        } catch (let error) {
            print("Error decoding JSON: \(error)")
            if let err = error as? ContentViewModel.UserError {
                self.error = err
            } else {
                self.error = ContentViewModel.UserError.failedNilData
            }
        }
        
    }
    
    func getURLSpecificImageLoad(
        id: Int ,
        widthImg: Int = widthImage,
        heightImg: Int = heightImage
    ) -> URL? {
        let idPath = "/id/\(id)"
        let widthHeightPath = "/\(widthImg)/\(heightImg)"
        return URL(string: "\(rootImageURL)\(pathImageURL)\(idPath)\(widthHeightPath)")
    }
    
}

extension ContentViewModel {
    enum UserError: LocalizedError {
        case custom(error: Error)
        case failedToResponse
        case failedToDecode
        case failedInvalid
        case failedNilData
        case failedRequest(httpResponse: HTTPURLResponse)
        
        var errorDescription: String? {
            switch self {
                
            case .custom(error: let error):
                return error.localizedDescription
            case .failedToDecode:
                return "Failed to decode response"
            case .failedInvalid:
                return "Failed to Invalid URL"
            case .failedToResponse:
                return "Failed to response"
            case .failedRequest(httpResponse: let httpResponse):
                return "Failed to request API request failed with status code \(httpResponse.statusCode) : \(httpResponse.description)"
            case .failedNilData:
                return "Response is nil data"
            }
        }
    }
}
