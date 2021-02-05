//
//  LoginViewModel.swift
//  PokeFinder
//
//  Created by João Leite on 04/02/21.
//

import Foundation
import RxSwift
import RxCocoa

typealias LoginError = (errorCode: Int, errorMessage: String?)

class LoginViewModel {
    
    internal var model : LoginModel!
    
    let emailRelay    : BehaviorRelay<String> = BehaviorRelay(value: "")
    let passwordRelay : BehaviorRelay<String> = BehaviorRelay(value: "")
    
    var emailValidated : Bool = false
    
    var loginIsValid : Driver<Bool> {
        get {
            return Driver.combineLatest(emailRelay.asDriver(),
                                        passwordRelay.asDriver()) { email, password in
                if self.emailValidated {
                    return !email.isEmpty && !password.isEmpty
                } else {
                    return !email.isEmpty
                }
            }
        }
    }
    
    private var protectedPassword : String? {
        get {
            return passwordRelay.value.data(using: .utf8)?.base64EncodedString()
        }
    }
    
    init(_ model: LoginModel) {
        self.model = model
    }
    
    func canMakeLogin() -> LoginError? {
        guard let protectedPassword = protectedPassword else { return (-30, "Erro ao criptografar a senha do usuário.")}

        if let oldUser = LoginModel.loadUser() {
            if self.passwordRelay.value.isEmpty {
                emailValidated = true
                return (-20, nil)
            } else if oldUser.password != protectedPassword {
                return (-10, "Senha Invalida. Por favor tente novamente")
            }
            
            return nil
        } else {
            if self.passwordRelay.value.isEmpty {
                emailValidated = true
                return (-20, "Primeiro login detectado. Por favor configure uma senha.")
            } else {
                return nil
            }
        }
    }
    
    func makeLogin(callback: @escaping()->()) {
        guard let protectedPassword = passwordRelay.value.data(using: .utf8)?.base64EncodedString() else { return }
        
        self.model.save(email: self.emailRelay.value, password: protectedPassword)
        
        model.login {
            callback()
        } failure: {
            print(false)
        }
    }
}
