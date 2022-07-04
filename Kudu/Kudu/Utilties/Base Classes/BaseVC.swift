import UIKit
import IQKeyboardManagerSwift
import AVFoundation
import FBSDKLoginKit
import GoogleSignIn

class BaseVC: UIViewController {
    
    var isApiHitting = false
    
    func hitApi(viewsToDisable: [UIView], block: (() -> Void)?) {
        isApiHitting = true
        block?()
        viewsToDisable.forEach({$0.isUserInteractionEnabled = false})
    }
    
    func responseReceived(viewsToEnable: [UIView], block:(() -> Void)?) {
        isApiHitting = false
        block?()
        viewsToEnable.forEach({$0.isUserInteractionEnabled = true})
    }
    
    func getNavController() -> BaseNavVC? {
        return self.navigationController as? BaseNavVC
    }
    
    func push(vc: BaseVC, animated: Bool = true) {
        self.navigationController?.pushViewController(vc, animated: animated)
    }
    
    func pop(animated: Bool = true) {
        self.navigationController?.popViewController(animated: animated)
    }
    
    @discardableResult
    func popToSpecificViewController(kindOf viewController: UIViewController.Type, animated: Bool = true) -> Bool {
        if self.navigationController.isNil {
            return false }
        
        for vc in self.navigationController!.viewControllers where vc.isKind(of: viewController.classForCoder()) {
            self.navigationController!.popToViewController(vc, animated: animated)
            return true
        }
        return false
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNeedsStatusBarAppearanceUpdate()
        self.setupToHideKeyboardOnTapOnView()
        self.observeFor(.pushLoginVC, selector: #selector(pushLogin(notification:)))
    }
    
    @objc private func pushLogin(notification: NSNotification) {
        let msg = notification.userInfo?["msg"] as? String ?? ""
        let loginVC = LoginVC.instantiate(fromAppStoryboard: .Onboarding)
        let currentLanguage: LanguageSelectionView.LanguageButtons = AppUserDefaults.selectedLanguage() == .ar ? .arabic : .english
        loginVC.viewModel = LoginVM(selectedLang: currentLanguage, _delegate: loginVC, _expiryError: msg)
        let fbLoginManager = LoginManager()
        fbLoginManager.logOut()
        GIDSignIn.sharedInstance.signOut()
        AppUserDefaults.removeValue(forKey: .loginResponse)
        self.push(vc: loginVC)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    
    override var shouldAutorotate: Bool {
        false
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        .portrait
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        if let touch = touches.first, let view = touch.view, view.isKind(of: UITextField.self) || view.isKind(of: UITextView.self) {
        self.view.endEditing(true)
        }
    }
}

extension BaseVC {
    
    func animateWithKeyboard(
        notification: NSNotification,
        animations: ((_ keyboardFrame: CGRect) -> Void)?
    ) {
        // Extract the duration of the keyboard animation
        let durationKey = UIResponder.keyboardAnimationDurationUserInfoKey
        let duration = notification.userInfo![durationKey] as! Double
        
        // Extract the final frame of the keyboard
        let frameKey = UIResponder.keyboardFrameEndUserInfoKey
        let keyboardFrameValue = notification.userInfo![frameKey] as! NSValue
        
        // Extract the curve of the iOS keyboard animation
        let curveKey = UIResponder.keyboardAnimationCurveUserInfoKey
        let curveValue = notification.userInfo![curveKey] as! Int
        let curve = UIView.AnimationCurve(rawValue: curveValue)!

        // Create a property animator to manage the animation
        let animator = UIViewPropertyAnimator(
            duration: duration,
            curve: curve
        ) {
            // Perform the necessary animation layout updates
            animations?(keyboardFrameValue.cgRectValue)
            
            // Required to trigger NSLayoutConstraint changes
            // to animate
            self.view?.layoutIfNeeded()
        }
        
        // Start the animation
        animator.startAnimation()
    }
}

extension BaseVC {
    func setupToHideKeyboardOnTapOnView() {
           let tap: UITapGestureRecognizer = UITapGestureRecognizer(
               target: self,
               action: #selector(BaseVC.dismissKeyboard))

           tap.cancelsTouchesInView = false
           view.addGestureRecognizer(tap)
       }

       @objc func dismissKeyboard() {
           view.endEditing(true)
       }
}
