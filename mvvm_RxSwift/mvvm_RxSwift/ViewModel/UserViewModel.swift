//
//  UserViewModel.swift
//  mvvm_RxSwift
//
//  Created by Eslam Ali  on 22/03/2022.
//

import Foundation
import RxSwift
import RxCocoa

class UserViewModel {

    var users = BehaviorSubject(value: [User]())
    
    func fetchUsers()  {
        let url = " https://jsonplaceholder.typicode.com/posts"
        guard let urlString = URL(string: url) else  {return}
        
        let task = URLSession.shared.dataTask(with: urlString) {data , _ , error in
            guard let data = data else {return}
            do {
                let responseData = try JSONDecoder().decode([User].self, from: data)
                self.users.on(.next(responseData))
            }catch {
                print(error.localizedDescription)
            }
        }
        task.resume()
        
        
    }
    
    
    func deleteUser(index : Int) {
        guard var users = try?  users.value() else {
            return
        }
        users.remove(at: index)
        self.users.on(.next(users))
    }
    
    
    
}
