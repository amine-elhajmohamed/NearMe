//
//  LoadingButton.swift
//  NearMe
//
//  Created by MedAmine on 12/6/18.
//  Copyright © 2018 amine. All rights reserved.
//

import UIKit

class LoadingButton: CustomButton {

    static private let ADD_VALUE_TO_WIDTH_CONSTRAINT: CGFloat = 50
    
    private var isAnimatingLoading = false
    
    private var actIndicator:UIActivityIndicatorView?
    
    //MARK: - View configuration
    private func configureActIndicator(){
        guard actIndicator == nil else {
            return
        }
        
        actIndicator = UIActivityIndicatorView(style: .white)
        
        addSubview(actIndicator!)
        
        actIndicator?.translatesAutoresizingMaskIntoConstraints = false
        
        addConstraint(NSLayoutConstraint(item: self, attribute: .centerY, relatedBy: .equal, toItem: actIndicator, attribute: .centerY, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: self, attribute: .right, relatedBy: NSLayoutConstraint.Relation.equal, toItem: actIndicator, attribute: NSLayoutConstraint.Attribute.right, multiplier: 1, constant: 15))
        
        layoutIfNeeded()
    }
    
    private func addValueToWidthConstarint(value: CGFloat){
        for constarint in constraints {
            if constarint.firstAttribute == .width {
                constarint.constant += value
            }
        }
    }
    
    public func startAnimating(onComplition:@escaping (()->()) = {}){
        guard !isAnimatingLoading else {
            return
        }
        
        isAnimatingLoading = true
        
        if actIndicator == nil {
            configureActIndicator()
        }
        
        actIndicator?.startAnimating()
        
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 0.5, options: [.curveEaseInOut], animations: {
            self.addValueToWidthConstarint(value: LoadingButton.ADD_VALUE_TO_WIDTH_CONSTRAINT)
            self.layoutIfNeeded()
        }, completion: { (b) in
            onComplition()
        })
        
    }
    
    public func stopAnimating(onComplition:@escaping (()->()) = {}){
        guard isAnimatingLoading else {
            return
        }
        
        isAnimatingLoading = false
        
        actIndicator?.stopAnimating()
        
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 0.5, options: [.curveEaseInOut], animations: {
            self.addValueToWidthConstarint(value: -LoadingButton.ADD_VALUE_TO_WIDTH_CONSTRAINT)
            self.layoutIfNeeded()
        }, completion: { (b) in
            onComplition()
        })
        
    }

}
