//
//  PokemonViewModel.swift
//  PokeFinder
//
//  Created by João Leite on 04/02/21.
//

import UIKit
import RxSwift
import RxCocoa

class PokemonViewModel {
    
    internal var model : PokemonModel!
    weak var listViewModel : PokemonListViewModel?
    
    init(model m: PokemonModel) {
        model = m
        favoriteRelay.accept(model.favorite)
    }
    
    var number : Int {
        get {
            return model.number
        }
    }
    
    var name : String {
        get {
            return model.name
        }
    }
    
    var favoriteStatus : Bool {
        get {
            return model.favorite
        }
    }
    
    var pokemonWeight : Double {
        get {
            return model.weight
        }
    }
    
    var pokemonHeight : Double {
        get {
            return model.height
        }
    }
    
    var pokemonTypeString : String {
        get {
            return model.types
                .map({ $0.capitalized })
                .joined(separator: " / ")
        }
    }

    private var favoriteRelay : BehaviorRelay = BehaviorRelay(value: false)
    var isFavorite : Driver<Bool> {
        get {
            return favoriteRelay.asDriver()
        }
    }
    
    private var pokemonImage : PublishSubject<UIImage> = PublishSubject()
    var imageDriver : Driver<UIImage> {
        get {
            return pokemonImage.asDriver(onErrorJustReturn: UIImage())
        }
    }
    
    
    func toggleFavorite() {
        model.favorite = !model.favorite
        model.saveFavorite(newStatus: model.favorite)
        
        favoriteRelay.accept(model.favorite)
        listViewModel?.updateFavoriteList()
    }
    
    func loadDetails() {
        model.downloadDetails()
    }
    
    func requestPokemonImage() {
        model.downloadPokemonImage { (newImage) in
            self.pokemonImage.onNext(newImage)
        }
    }
    
    func getAttributedName(mainColor: UIColor,
                           highlightColor: UIColor,
                           fontSize: CGFloat) -> NSAttributedString {
        let attString = NSMutableAttributedString(string: "#\(number + 1)\n\(model.name.capitalized)",
                                                  attributes: [.foregroundColor : highlightColor,
                                                               .font : UIFont.systemFont(ofSize: fontSize - 4)])
        
        attString.addAttributes([.foregroundColor : mainColor,
                                 .font : UIFont.systemFont(ofSize: fontSize)],
                                range: (attString.string as NSString).range(of: model.name.capitalized))
        
        return attString
    }
}
