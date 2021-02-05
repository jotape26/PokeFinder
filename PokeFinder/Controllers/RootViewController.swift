//
//  RootViewController.swift
//  PokeFinder
//
//  Created by João Leite on 04/02/21.
//

import UIKit

class RootViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startApp()
    }
    
    private func startApp() {
        let login = LoginViewController()
        login.willMove(toParent: self)
        
        self.addChild(login)
        
        login.view.frame = self.view.bounds
        self.view.addSubview(login.view)
    }
    
    func replaceController(old: UIViewController,
                           new: UIViewController) {
        
        
        old.willMove(toParent: nil)
        new.willMove(toParent: self)
        
        self.addChild(new)
        
        new.view.frame = self.view.bounds
        self.view.addSubview(new.view)
        
        new.view.alpha = 0
        self.transition(from: old, to: new, duration: 0.5, options: [], animations: {
            new.view.alpha = 1
        }) { (finished) in
            old.removeFromParent()
            new.didMove(toParent: self)
        }
    }
    
    
}
