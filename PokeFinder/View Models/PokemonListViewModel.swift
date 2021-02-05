//
//  PokemonListViewModel.swift
//  PokeFinder
//
//  Created by João Leite on 04/02/21.
//

import UIKit
import RxSwift
import RxCocoa

class PokemonListViewModel {
    
    private let listRelay : BehaviorRelay<[PokemonViewModel]> = BehaviorRelay(value: [])
    private let showingFavoritesRelay : BehaviorRelay<Bool> = BehaviorRelay(value: false)
    
    var showingFavoritesDriver : Driver<Bool> {
        get {
            return showingFavoritesRelay.asDriver()
        }
    }
    
    var isShowingFavorites : Bool {
        get {
            return showingFavoritesRelay.value
        }
        set {
            showingFavoritesRelay.accept(newValue)
        }
    }
    
    var pokemonList : Observable<[PokemonViewModel]> {
        get {
            return showingFavoritesRelay
                .map { (_) -> [PokemonViewModel] in
                    return self.getListArray()
                }
        }
    }
    
    init() {
        PokemonModel.downloadPokemonList { (pokemonList) in
            let favoritePokemons = PokemonModel.loadFavoritesFromDB()
            
            pokemonList.forEach({ poke in
                poke.listViewModel = self
                if favoritePokemons.contains(where: {$0.number == poke.number }) {
                    poke.toggleFavorite()
                }
            })
            
            self.listRelay.accept(pokemonList)
            self.showingFavoritesRelay.accept(false)
        } failure: {
            
        }
    }
    
    private func getListArray() -> [PokemonViewModel] {
        if showingFavoritesRelay.value {
            return self.listRelay.value.filter({ $0.favoriteStatus })
        } else {
            return self.listRelay.value
        }
    }
    
    func prepareDetails(index: Int) {
        self.listRelay.value[index].loadDetails()
    }
    
    func updateFavoriteList() {
        if showingFavoritesRelay.value {
            showingFavoritesRelay.accept(true)
        }
    }
}
