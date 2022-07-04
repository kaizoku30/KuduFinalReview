//
//  TutorialPage3View.swift
//  Kudu
//
//  Created by Admin on 14/06/22.
//

import UIKit

class TutorialPage3View: UIView {
    enum ViewActions {
        case continueButtonPressed
    }
    var handleViewActions: ((ViewActions) -> Void)?
    @IBOutlet weak var pageControlImgView: UIImageView!
    @IBOutlet weak var getStartedButton: UIButton!
    
    @IBAction func continueButtonPressed(_ sender: Any) {
        NotificationCenter.default.post(name: Notification.Name.init(rawValue: Constants.NotificationObservers.endTutorialFlow.rawValue), object: nil)
    }
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func checkForOverlap(inVC vc: BaseVC) {
        if self.pageControlImgView.overlaps(other: getStartedButton, in: vc) {
            pageControlImgView.isHidden = true
        }
        let distance = pageControlImgView.distanceFromBottomToTheTopOfUIView(getStartedButton, in: vc)
        debugPrint(distance)
        if distance < 0 {
            pageControlImgView.isHidden = true
        }
    }
    
}
