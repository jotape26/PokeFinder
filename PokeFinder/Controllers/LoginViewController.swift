//
//  LoginViewController.swift
//  PokeFinder
//
//  Created by João Leite on 03/02/21.
//

import UIKit
import RxSwift
import RxCocoa

class LoginViewController: UIViewController {
    
    private var txtEmail : UnderlineTextfield = {
        let textField = UnderlineTextfield(highlightColor: .systemPink)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.heightAnchor.constraint(equalToConstant: 30.0).isActive = true
        return textField
    }()
    
    private var txtPassword : UnderlineTextfield = {
        let textField = UnderlineTextfield(highlightColor: .systemPink)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.isSecureTextEntry = true
        textField.heightAnchor.constraint(equalToConstant: 30.0).isActive = true
        return textField
    }()
    
    private lazy var emailStack : UIStackView = {
        let innerStack = UIStackView()
        innerStack.translatesAutoresizingMaskIntoConstraints = false
        innerStack.distribution = .fill
        innerStack.axis = .vertical
        
        let title = UILabel()
        title.text = "E-mail"
        title.textColor = .lightGray
        title.heightAnchor.constraint(equalToConstant: 20.0).isActive = true
        title.font = UIFont.systemFont(ofSize: 15.0)
        
        innerStack.addArrangedSubview(title)
        innerStack.addArrangedSubview(txtEmail)
        
        return innerStack
    }()
    
    private var lbTextoAjuda : UILabel = {
        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.text = nil
        title.textColor = .lightGray
        title.numberOfLines = 0
        title.font = UIFont.systemFont(ofSize: 13.0)
        return title
    }()
    
    private lazy var passwordStack : UIStackView = {
        let innerStack = UIStackView()
        innerStack.translatesAutoresizingMaskIntoConstraints = false
        innerStack.distribution = .fill
        innerStack.axis = .vertical
        
        let title = UILabel()
        title.text = "Senha"
        title.textColor = .lightGray
        title.heightAnchor.constraint(equalToConstant: 20.0).isActive = true
        title.font = UIFont.systemFont(ofSize: 15.0)
        
        innerStack.addArrangedSubview(title)
        innerStack.addArrangedSubview(txtPassword)
        
        innerStack.isHidden = true
        
        return innerStack
    }()
    
    private lazy var fieldsStack : UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.spacing = 10.0
        stack.addArrangedSubview(emailStack)
        stack.addArrangedSubview(passwordStack)
        return stack
    }()
    
    private var btnLogin : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 5.0
        button.backgroundColor = UIColor.systemPink
        button.setTitle("Acessar", for: .normal)
        return button
    }()
    
    private lazy var buttonsStack : UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.spacing = 10.0
        stack.addArrangedSubview(btnLogin)
        stack.addArrangedSubview(lbTextoAjuda)
        return stack
    }()
    
    private var disposeBag : DisposeBag = DisposeBag()
    private var viewModel  : LoginViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view
        
        if let oldModel = LoginModel.loadUser() {
            viewModel = LoginViewModel(oldModel)
        } else {
            viewModel = LoginViewModel(LoginModel())
        }
        
        txtEmail.rx
            .text
            .orEmpty
            .bind(to: viewModel.emailRelay)
            .disposed(by: disposeBag)
        
        txtPassword.rx
            .text
            .orEmpty
            .bind(to: viewModel.passwordRelay)
            .disposed(by: disposeBag)
        
        btnLogin.rx
            .tap
            .bind {
                if let error = self.viewModel.canMakeLogin() {
                    if error.errorCode == -20 {
                        self.passwordStack.isHidden = false
                        self.txtPassword.becomeFirstResponder()
                        self.lbTextoAjuda.text = error.errorMessage
                        self.lbTextoAjuda.isHidden = error.errorMessage == nil
                    } else {
                        let alert = UIAlertController(title: "Atenção",
                                                      message: error.errorMessage, preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        
                        self.present(alert, animated: true, completion: nil)
                    }
                } else {
                    self.viewModel.makeLogin {
                        DispatchQueue.main.async {
                            let listController = UINavigationController(rootViewController: PokedexViewController())
                            listController.navigationBar.prefersLargeTitles = true
                            (self.parent as? RootViewController)?.replaceController(old: self,
                                                                                    new: listController)
                        }
                    }
                }

            }.disposed(by: disposeBag)
        
        viewModel.loginIsValid
            .drive(onNext: { formValid in
                UIView.animate(withDuration: 0.1) {
                    self.btnLogin.backgroundColor = formValid ? .systemPink : .lightGray
                }
            }).disposed(by: disposeBag)
        
        
        view.addSubview(fieldsStack)
        view.addSubview(buttonsStack)
        
        NSLayoutConstraint.activate([
        
            fieldsStack.leadingAnchor.constraint(equalTo: view.leadingAnchor,
                                                 constant: 20.0),
            fieldsStack.trailingAnchor.constraint(equalTo: view.trailingAnchor,
                                                  constant: -20.0),
            fieldsStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,
                                             constant: 30.0),
            
            buttonsStack.leadingAnchor.constraint(equalTo: fieldsStack.leadingAnchor),
            buttonsStack.trailingAnchor.constraint(equalTo: fieldsStack.trailingAnchor),
            buttonsStack.topAnchor.constraint(equalTo: fieldsStack.bottomAnchor,
                                              constant: 20.0)
        ])
    }

}

