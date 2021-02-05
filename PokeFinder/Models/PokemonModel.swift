//
//  PokemonModel.swift
//  PokeFinder
//
//  Created by João Leite on 04/02/21.
//

import UIKit
import RealmSwift

class PokemonModel: Object {
    @objc dynamic var number   : Int = 0
    @objc dynamic var name     : String = ""
    
    var imageURL : String = ""
    var types    : [String] = []
    
    var favorite : Bool = false
    
    var height   : Double = 0.0
    var weight   : Double = 0.0
    
    private var detailURL : String = ""
    
    convenience init(number: Int,
                     name: String,
                     detailsURL: String) {
        self.init()
        self.number = number
        self.name = name
        self.detailURL = detailsURL
    }
    
    class func downloadPokemonList(success: @escaping([PokemonViewModel]) -> (),
                                   failure: @escaping() -> ()) {
        guard let url = URL(string: "https://pokeapi.co/api/v2/pokemon?limit=100") else { return }
        let urlRequest = URLRequest(url: url)
        
        let dataTask = URLSession.shared.dataTask(with: urlRequest, completionHandler: { (data, response, error) in
            
            if let err = error {
                print("Erro na requisicao: \(err.localizedDescription)")
                return
            }
            
            if let data = data {
                do {
                    let jsonData = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String : Any]
                    
                    if let pokemonList = jsonData?["results"] as? [[String : Any]] {

                        let pokemons = pokemonList.enumerated().compactMap { (index, details) -> PokemonModel? in
                            if let pokeName = details["name"] as? String, let pokeUrl = details["url"] as? String {
                                return PokemonModel(number: index, name: pokeName, detailsURL: pokeUrl)
                            }
                            return nil
                        }.map({ PokemonViewModel(model: $0) })
                        
                        success(pokemons)
                        return
                    }
                    
                } catch let exception {
                    print(exception.localizedDescription)
                }
            }
            
            failure()
        })

        dataTask.resume()
    }
    
    func downloadDetails() {
        guard let url = URL(string: detailURL) else { return }
        let urlRequest = URLRequest(url: url)
        
        let dataTask = URLSession.shared.dataTask(with: urlRequest, completionHandler: { (data, response, error) in
            
            if let err = error {
                print("Erro na requisicao: \(err.localizedDescription)")
                return
            }
            
            if let data = data {
                do {
                    let jsonData = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String : Any]
                    
                    if let heightVal = jsonData?["height"] as? Double {
                        self.height = heightVal
                    }
                    
                    if let weightVal = jsonData?["weight"] as? Double {
                        self.weight = weightVal
                    }
                    
                    if let spritesList = jsonData?["sprites"] as? [String : Any] {
                        if let otherSprites = spritesList["other"] as? [String : Any],
                           let originial = otherSprites["official-artwork"] as? [String : Any] {
                            self.imageURL = originial["front_default"] as? String ?? ""
                        }
                    }
                    
                    if let typesArr = jsonData?["types"] as? [[String : Any]] {
                        
                        typesArr.forEach { (obj) in
                            if let typeInfo = obj["type"] as? [String : Any] {
                                if let typeName = typeInfo["name"] as? String {
                                    print(typeName)
                                    self.types.append(typeName)
                                }
                            }
                        }
                    }
                    
                } catch let exception {
                    print(exception.localizedDescription)
                }
            }
        })

        dataTask.resume()
    }
    
    func downloadPokemonImage(imageAcquired: @escaping(UIImage) -> ()) {
        guard let url = URL(string: imageURL) else { return }
        let urlRequest = URLRequest(url: url)
        
        let dataTask = URLSession.shared.dataTask(with: urlRequest, completionHandler: { (data, response, error) in
            
            if let err = error {
                print("Erro na requisicao: \(err.localizedDescription)")
                return
            }
            
            if let data = data {
                if let pokemonImage = UIImage(data: data) {
                    imageAcquired(pokemonImage)
                }
            }
        })

        dataTask.resume()
    }
    
    func saveFavorite(newStatus: Bool) {
        if let realm = try? Realm() {
            
            realm.beginWrite()
            if newStatus {
                if realm.objects(PokemonModel.self).first(where: { $0.number == self.number }) == nil {
                    realm.add(self)
                }
            } else {
                realm.delete(realm.objects(PokemonModel.self).compactMap({ $0.number == self.number ? $0 : nil}))
            }
            
            self.favorite = newStatus
            try? realm.commitWrite()
        }
    }
    
    class func loadFavoritesFromDB() -> [PokemonModel] {
        if let realm = try? Realm() {
            return realm.objects(PokemonModel.self).map({ $0 })
        }
        
        return []
    }
}
