//
//  LoginModel.swift
//  PokeFinder
//
//  Created by João Leite on 04/02/21.
//

import Foundation
import RealmSwift

class LoginModel: Object {
    var email    : String = ""
    @objc dynamic var password : String = ""
    
    func login(success: @escaping()->(),
               failure: @escaping()->()) {
        
        guard let url = URL(string: "https://reqres.in/api/users?page=1") else { return }
        let urlRequest = URLRequest(url: url)
        
        let dataTask = URLSession.shared.dataTask(with: urlRequest, completionHandler: { (data, response, error) in
            
            if let err = error {
                print("Erro na requisicao: \(err.localizedDescription)")
                return
            }
            
            if let data = data {
                do {
                    let jsonData = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String : Any]
                    
                    if let users = jsonData?["data"] as? [[String : Any]] {
                        if users.contains(where: { ($0["email"] as? String) ?? "" == self.email }) {
                            success()
                            return
                        }
                    }
                } catch let exception {
                    print(exception.localizedDescription)
                }
            }
            
            failure()
        })

        dataTask.resume()
    }
    
    class func loadUser() -> LoginModel? {
        let uiRealm = try? Realm()
        return uiRealm?.objects(LoginModel.self).first
    }
    
    func save(email: String, password: String) {
        if let realm = try? Realm() {
            
            realm.beginWrite()
            
            self.password = password
            self.email = email
            
            if realm.objects(LoginModel.self).first == nil {
                realm.add(self)
            }
            
            try? realm.commitWrite()
        }
    }
}
