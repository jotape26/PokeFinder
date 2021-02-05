//
//  UnderlineTextfield.swift
//  PokeFinder
//
//  Created by João Leite on 04/02/21.
//

import UIKit

class UnderlineTextfield : UITextField {
    
    private(set) var highlightColor : UIColor!
    
    let underlineView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .lightGray
        return view
    }()
    
    convenience init(highlightColor color: UIColor) {
        self.init()
        highlightColor = color
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        delegate = self
        addSubview(underlineView)
        
        NSLayoutConstraint.activate([
            underlineView.leadingAnchor.constraint(equalTo: leadingAnchor),
            underlineView.trailingAnchor.constraint(equalTo: trailingAnchor),
            underlineView.bottomAnchor.constraint(equalTo: bottomAnchor),
            underlineView.heightAnchor.constraint(equalToConstant: 1.0)
        ])
    }
}

extension UnderlineTextfield : UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.1) {
            self.underlineView.backgroundColor = self.highlightColor
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.1) {
            self.underlineView.backgroundColor = .lightGray
        }
    }
}
