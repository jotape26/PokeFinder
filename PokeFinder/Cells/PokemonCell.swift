//
//  PokemonCell.swift
//  PokeFinder
//
//  Created by João Leite on 04/02/21.
//

import UIKit
import RxSwift

class PokemonCell: UITableViewCell {
    
    private var disposeBag : DisposeBag!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        disposeBag = DisposeBag()
    }
    
    func bind(pokemon: PokemonViewModel) {
        prepareForReuse()
        
        textLabel?.numberOfLines = 0
        textLabel?.attributedText = pokemon.getAttributedName(mainColor: .label,
                                                              highlightColor: .lightGray,
                                                              fontSize: 16.0)
        
        accessoryView = { () -> UIView in
            let button = UIButton()
            button.frame = CGRect(x: 0, y: 0, width: frame.height, height: frame.height)
            
            pokemon.isFavorite
                .drive(onNext: { favoriteStatus in
                    button.setImage(UIImage(systemName: favoriteStatus ? "star.fill" : "star"),
                                    for: .normal)
                    button.tintColor = .systemYellow
                })
                .disposed(by: disposeBag)
            
            button.rx
                .tap
                .bind {
                    pokemon.toggleFavorite()
                }.disposed(by: self.disposeBag)
            
            return button
        }()
    }

}
