//
//  AppErrorToastView.swift
//  Kudu
//
//  Created by Admin on 27/06/22.
//

import UIKit

class AppErrorToastView: UIView {
    @IBOutlet var mainContentView: UIView!
    @IBOutlet weak var errorLabel: UILabel!
    private var toastVisible = false
    
    override init(frame: CGRect) {
         super.init(frame: frame)
         commonInit()
        
     }
     
     required init?(coder adecoder: NSCoder) {
         super.init(coder: adecoder)
         commonInit()
     }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("AppErrorToastView", owner: self, options: nil)
        addSubview(mainContentView)
        self.isHidden = true
        mainContentView.frame = self.bounds
        mainContentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    
    func showErrorToast(topAnchor: NSLayoutConstraint, heightAnchor: NSLayoutConstraint, message: String, extraDelay: TimeInterval?) {
        let textHeight = message.heightOfText(errorLabel.width, font: AppFonts.mulishMedium.withSize(14))
        errorLabel.text = message
        errorLabel.numberOfLines = 0
        let heightCalculated = textHeight + 20
        if heightCalculated > 48 {
            heightAnchor.constant = heightCalculated
            self.layoutIfNeeded()
        }
        self.isHidden = false
        UIView.animate(withDuration: 1, animations: {
            if !self.toastVisible {
                self.transform = CGAffineTransform.identity.translatedBy(x: 0, y: 210)
                self.toastVisible = true
            }
        }, completion: {
            if $0 {
                var delay: TimeInterval = 1
                if extraDelay.isNotNil {
                    delay += extraDelay!
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: {
                    self.hideErrorToast(topAnchor: topAnchor, heightAnchor: heightAnchor)
                })
            }
        })
    }
    
    private func hideErrorToast(topAnchor: NSLayoutConstraint, heightAnchor: NSLayoutConstraint) {
        if !toastVisible {
            return
        }
        UIView.animate(withDuration: 1, delay: 0, options: .curveEaseIn, animations: {
            self.transform = CGAffineTransform.identity.translatedBy(x: 0, y: -210)
        }, completion: { _ in
            self.isHidden = true
            self.toastVisible = false
        })
    }
}
