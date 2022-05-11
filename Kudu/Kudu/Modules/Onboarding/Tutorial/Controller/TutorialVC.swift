//
//  TutorialVC.swift
//  Kudu
//
//  Created by Admin on 11/05/22.
//

import UIKit

class TutorialVC: BaseVC {
    @IBOutlet var baseView: TutorialView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        baseView.setupView(delegate: self)
        handleActions()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self.navigationController as? UIGestureRecognizerDelegate
    }
    
    private func handleActions() {
        baseView.handleViewActions = {
            if $0 == .continueButtonPressed {
                debugPrint("Move To Sign In")
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
