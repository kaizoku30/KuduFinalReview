//
//  VIDAAlertView.swift
//  VIDA
//
//  Created by Admin on 21/02/22.
//

import UIKit

class AppPopUpView: UIView {

    enum AlertButton {
        case left
        case right
        case center
    }
    
    @IBOutlet private var mainContentView: UIView!
    @IBOutlet private weak var alertMessage: UILabel!
    @IBOutlet private weak var rightBtn: AppButton!
    @IBOutlet private weak var leftBtn: AppButton!
    private weak var containerView: UIView?
    
    var handleAction: ((AlertButton) -> Void)?
    
    static var PopUpHeight: CGFloat { 153 }
    static var HorizontalPadding: CGFloat { 2*28 }
    
    override init(frame: CGRect) {
         super.init(frame: frame)
         commonInit()
     }
     
     required init?(coder adecoder: NSCoder) {
         super.init(coder: adecoder)
         commonInit()
     }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("AppPopUpView", owner: self, options: nil)
        addSubview(mainContentView)
        mainContentView.frame = self.bounds
        mainContentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        leftBtn.handleBtnTap = {
            [weak self] in
            self?.handleAction?(.left)
            self?.removeFromContainer()
        }
        rightBtn.handleBtnTap = {
            [weak self] in
            self?.handleAction?(.right)
            self?.removeFromContainer()
        }
    }
    
    private func removeFromContainer() {
        self.containerView?.subviews.forEach({
            if $0.tag == Constants.CustomViewTags.alertTag {
                $0.removeFromSuperview()
            }
        })
        self.containerView?.subviews.forEach({
            if $0.tag == Constants.CustomViewTags.dimViewTag {
                $0.removeFromSuperview()
            }
        })
    }
    
    func configure(message: String, leftButtonTitle: String, rightButtonTitle: String, container view: UIView) {
        self.containerView = view
        let dimmedView = UIView(frame: view.frame)
        dimmedView.backgroundColor = .black.withAlphaComponent(0.5)
        dimmedView.tag = Constants.CustomViewTags.dimViewTag
        view.addSubview(dimmedView)
        self.tag = Constants.CustomViewTags.alertTag
        self.center = view.center
        view.addSubview(self)
        alertMessage.numberOfLines = 3
        alertMessage.text = message
        alertMessage.adjustsFontSizeToFitWidth = true
        leftBtn.setTitle(leftButtonTitle, for: .normal)
        rightBtn.setTitle(rightButtonTitle, for: .normal)
        
    }

}
