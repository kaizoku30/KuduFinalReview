//
//  TutorialVC.swift
//  Kudu
//
//  Created by Admin on 11/05/22.
//

import UIKit

class TutorialVC: BaseVC {
    @IBOutlet private weak var baseView: TutorialView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        baseView.setupView(delegate: self)
        handleActions()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        weak var weakSelf = self.navigationController as? BaseNavVC
        weakSelf?.disableSwipeBackGesture = false
    }
    
    private func handleActions() {
        baseView.handleViewActions = { [weak self] in 
            if $0 == .continueButtonPressed {
                Router.shared.goToLoginVC(fromVC: self)
            }
        }
    }
}

extension TutorialVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueCell(with: TutorialCollectionViewCell.self, indexPath: indexPath)
        return cell
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        baseView.handleScrollViewDidEndDragging(scrollView, withVelocity: velocity, targetContentOffset: targetContentOffset)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        baseView.handleScrollViewScrolled(scrollView)
    }
}
