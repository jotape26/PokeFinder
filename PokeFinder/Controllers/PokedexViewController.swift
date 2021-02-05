//
//  PokedexViewController.swift
//  PokeFinder
//
//  Created by João Leite on 04/02/21.
//

import UIKit
import RxSwift

class PokedexViewController: UITableViewController {
    
    private var viewModel : PokemonListViewModel = PokemonListViewModel()
    private var disposeBag : DisposeBag = DisposeBag()
    
    private lazy var favoriteButton : UIBarButtonItem = {
        let button = UIBarButtonItem()
        
        viewModel.showingFavoritesDriver
            .drive(onNext: { showing in
                button.image = UIImage(systemName: showing ? "list.number" : "list.star")
                button.tintColor = .systemPink
            })
            .disposed(by: disposeBag)
        
        
        button.rx
            .tap
            .bind {
                self.viewModel.isShowingFavorites = !self.viewModel.isShowingFavorites
            }.disposed(by: disposeBag)
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Pokédex"
        self.navigationItem.setRightBarButton(favoriteButton, animated: true)
        
        tableView.delegate = nil
        tableView.dataSource = nil
        
        tableView.register(PokemonCell.self, forCellReuseIdentifier: "pokemonCell")
        
        viewModel.pokemonList
            .bind(to: tableView.rx.items(cellIdentifier: "pokemonCell")) { index, pokemon, cell in
                if let pokeCell = cell as? PokemonCell {
                    pokeCell.bind(pokemon: pokemon)
                }
            }.disposed(by: disposeBag)
        
        tableView.rx.willDisplayCell
            .asObservable()
            .bind { (cell, indexPath) in
                self.viewModel.prepareDetails(index: indexPath.row)
            }.disposed(by: disposeBag)
        
        tableView.rx.modelSelected(PokemonViewModel.self)
            .bind { [self] (pokemon) in
                if let selectedPath = tableView.indexPathForSelectedRow {
                    tableView.deselectRow(at: selectedPath, animated: true)
                }
                
                self.present(PokemonDetailViewController(viewModel: pokemon),
                             animated: true, completion: nil)
            }.disposed(by: disposeBag)
    }
}
