//
//  ContentView.swift
//  RequestAPI_MVVM_SwiftUI_Demo
//
//  Created by Papon Supamongkonchai on 30/7/2566 BE.
//

import SwiftUI

struct ContentView: View {
    //MARK: - PROPERTY
    @StateObject private var vm = ContentViewModel()
    
    var body: some View {
        NavigationView {
            ScrollView(.vertical, showsIndicators: false) {
                
                VStack(spacing: 16) {
                    ForEach(vm.users, id: \.id) { user in
                        VStack() {
                            Image(systemName: "globe")
                                .imageScale(.large)
                                .foregroundColor(.accentColor)
                            
                            AsyncImage(
                                url: vm.getURLSpecificImageLoad(
                                    id: Int.random(in: 0...1000)
                                )
                            )
                            .cornerRadius(10)
                            
                            
                            Text("name : \(user.name)")
                            
                        }
                    }
                    .padding(.all)
                }
            }
            .padding()
            .navigationTitle("USERS")
        }
        .task {
            await vm.fetchUser()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
