//
//  PokemonDetailViewController.swift
//  PokeFinder
//
//  Created by João Leite on 04/02/21.
//

import UIKit
import RxSwift
import RxCocoa

class PokemonDetailViewController: UIViewController {

    private weak var viewModel : PokemonViewModel!
    
    private let accentColor : BehaviorRelay<UIColor> = BehaviorRelay(value: .white)
    
    private var imgPokemon : UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var lbPokemonName : UILabel = {
        let title = UILabel()
        
        title.translatesAutoresizingMaskIntoConstraints = false
        title.font = UIFont.systemFont(ofSize: 25.0, weight: .semibold)
        title.numberOfLines = 0
        
        self.accentColor
            .asDriver()
            .drive(onNext: {
                title.textColor = $0
            })
            .disposed(by: disposeBag)
        return title
    }()
    
    private lazy var lbPokemonTypes : UILabel = {
        let title = UILabel()
        
        title.translatesAutoresizingMaskIntoConstraints = false
        title.font = UIFont.systemFont(ofSize: 16.0)
        title.numberOfLines = 0
        title.text = viewModel.pokemonTypeString
        
        self.accentColor
            .asDriver()
            .drive(onNext: {
                title.textColor = $0
            })
            .disposed(by: disposeBag)
        return title
    }()
    
    private lazy var weightStack : UIStackView = {
        let mainStack = UIStackView()
        mainStack.translatesAutoresizingMaskIntoConstraints = false
        mainStack.axis = .horizontal
        mainStack.spacing = 5.0
        
        let iconImage = UIImageView(image: UIImage(named: "weight-icon"))
        iconImage.translatesAutoresizingMaskIntoConstraints = false
        iconImage.contentMode = .scaleAspectFit
        iconImage.tintColor = .lightGray
        iconImage.widthAnchor.constraint(equalTo: iconImage.heightAnchor).isActive = true
        
        let labelStack = UIStackView()
        labelStack.translatesAutoresizingMaskIntoConstraints = false
        labelStack.axis = .vertical
        labelStack.spacing = 0.0
        labelStack.distribution = .fill
        
        let weightTitle = UILabel()
        weightTitle.textColor = .lightGray
        weightTitle.textAlignment = .center
        weightTitle.translatesAutoresizingMaskIntoConstraints = false
        weightTitle.font = UIFont.systemFont(ofSize: 13.0, weight: .semibold)
        weightTitle.numberOfLines = 0
        weightTitle.text = "Peso"
        
        let weightValue = UILabel()
        weightValue.textAlignment = .center
        weightValue.translatesAutoresizingMaskIntoConstraints = false
        weightValue.font = UIFont.systemFont(ofSize: 16.0)
        weightValue.numberOfLines = 0
        weightValue.text = "\(Int(viewModel.pokemonWeight).description)Kg"
        
        
        self.accentColor
            .asDriver()
            .drive(onNext: {
                weightValue.textColor = $0
            })
            .disposed(by: disposeBag)
        
        labelStack.addArrangedSubview(weightValue)
        labelStack.addArrangedSubview(weightTitle)
        
        mainStack.addArrangedSubview(iconImage)
        mainStack.addArrangedSubview(labelStack)
        mainStack.heightAnchor.constraint(equalToConstant: 35.0).isActive = true
        
        return mainStack
    }()
    
    private lazy var heightStack : UIStackView = {
        let mainStack = UIStackView()
        mainStack.translatesAutoresizingMaskIntoConstraints = false
        mainStack.axis = .horizontal
        mainStack.spacing = 5.0
        
        let iconImage = UIImageView(image: UIImage(named: "ruler-icon"))
        iconImage.translatesAutoresizingMaskIntoConstraints = false
        iconImage.contentMode = .scaleAspectFit
        iconImage.tintColor = .lightGray
        iconImage.widthAnchor.constraint(equalTo: iconImage.heightAnchor).isActive = true
        
        let labelStack = UIStackView()
        labelStack.translatesAutoresizingMaskIntoConstraints = false
        labelStack.axis = .vertical
        labelStack.spacing = 0.0
        labelStack.distribution = .fill
        
        let heightTitle = UILabel()
        heightTitle.textColor = .lightGray
        heightTitle.textAlignment = .center
        heightTitle.translatesAutoresizingMaskIntoConstraints = false
        heightTitle.font = UIFont.systemFont(ofSize: 13.0, weight: .semibold)
        heightTitle.numberOfLines = 0
        heightTitle.text = "Altura"
        
        let heightValue = UILabel()
        heightValue.textAlignment = .center
        heightValue.translatesAutoresizingMaskIntoConstraints = false
        heightValue.font = UIFont.systemFont(ofSize: 16.0)
        heightValue.numberOfLines = 0
        heightValue.text = "\(Int(viewModel.pokemonHeight).description)m"
        
        
        self.accentColor
            .asDriver()
            .drive(onNext: {
                heightValue.textColor = $0
            })
            .disposed(by: disposeBag)
        
        labelStack.addArrangedSubview(heightValue)
        labelStack.addArrangedSubview(heightTitle)
        
        mainStack.addArrangedSubview(iconImage)
        mainStack.addArrangedSubview(labelStack)
        mainStack.heightAnchor.constraint(equalToConstant: 35.0).isActive = true
        
        return mainStack
    }()
    
    private var contentView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 5.0
        view.backgroundColor = .white
        return view
    }()
    
    private var disposeBag : DisposeBag = DisposeBag()
    
    convenience init(viewModel vm: PokemonViewModel) {
        self.init()
        viewModel = vm
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.lbPokemonName.text = viewModel.name.capitalized
        
        view.backgroundColor = .white
        
        view.addSubview(contentView)
        view.addSubview(imgPokemon)
        view.addSubview(lbPokemonName)
        view.addSubview(lbPokemonTypes)
        
        contentView.addSubview(weightStack)
        contentView.addSubview(heightStack)

        NSLayoutConstraint.activate([
            imgPokemon.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imgPokemon.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            
            imgPokemon.heightAnchor.constraint(equalToConstant: 150),
            imgPokemon.widthAnchor.constraint(equalToConstant: 150),
            
            lbPokemonName.topAnchor.constraint(equalTo: imgPokemon.bottomAnchor, constant: 0),
            lbPokemonName.centerXAnchor.constraint(equalTo: imgPokemon.centerXAnchor),
            
            lbPokemonTypes.topAnchor.constraint(equalTo: lbPokemonName.bottomAnchor, constant: 5),
            lbPokemonTypes.centerXAnchor.constraint(equalTo: imgPokemon.centerXAnchor),
            
            contentView.topAnchor.constraint(equalTo: imgPokemon.bottomAnchor, constant: -75),
            contentView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 10),
            contentView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            contentView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            
            weightStack.trailingAnchor.constraint(equalTo: contentView.centerXAnchor, constant: -20),
            weightStack.topAnchor.constraint(equalTo: lbPokemonTypes.bottomAnchor, constant: 20),
            
            heightStack.topAnchor.constraint(equalTo: weightStack.topAnchor),
            heightStack.leadingAnchor.constraint(equalTo: contentView.centerXAnchor, constant: 20)
        ])
        
        viewModel.imageDriver
            .drive(onNext: { newImage in
                self.imgPokemon.image = newImage
                
                let colors = newImage.getColors()
                self.accentColor.accept(colors?.secondary ?? .white)
                
                UIView.animate(withDuration: 0.2) {
                    self.view.backgroundColor = colors?.background
                    self.lbPokemonName.textColor = colors?.secondary
                    
                    self.contentView.layer.shadowColor = UIColor.black.cgColor
                    self.contentView.layer.shadowOpacity = 0.5
                    self.contentView.layer.shadowOffset = .zero
                    self.contentView.layer.shadowRadius = 10
                }
            })
            .disposed(by: disposeBag)
        
        
        viewModel.requestPokemonImage()
        
    }
    
}
