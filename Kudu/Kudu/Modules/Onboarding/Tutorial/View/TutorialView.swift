//
//  TutorialView.swift
//  Kudu
//
//  Created by Admin on 11/05/22.
//

import UIKit

class TutorialView: UIView {
    @IBOutlet private weak var tutorialCollectionView: UICollectionView!
    @IBOutlet private weak var foodDeliveryLabel: UILabel!
    @IBOutlet private weak var greatTasteLabel: UILabel!
    @IBOutlet private weak var continueButton: AppButton!
    @IBOutlet var page1Yes: [UIView]!
    @IBOutlet var page1No: [UIView]!
    @IBOutlet weak var page2Yes: UIView!
    @IBOutlet weak var page2No: UIView!
    @IBOutlet var page3No: [UIView]!
    @IBOutlet var page3Yes: [UIView]!
    
    
    var handleViewActions: ((ViewActions) -> Void)?
    
    enum ViewActions {
        case continueButtonPressed
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        foodDeliveryLabel.text = LS.TutorialVC.getFoodDelivery
        greatTasteLabel.text = LS.TutorialVC.greatTasteLabel
        continueButton.setTitleForAllMode(title: LS.TutorialVC.continueButtonTitle)
    }
    
    func handleScrollViewDidEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let flowLayout = tutorialCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        let cellWidthIncludingSpacing = flowLayout.itemSize.width + flowLayout.minimumLineSpacing
        var offset = targetContentOffset.pointee
        let index = (offset.x + scrollView.contentInset.left)/cellWidthIncludingSpacing
        let roundedIndex = index.rounded()
        offset = CGPoint(x: roundedIndex*cellWidthIncludingSpacing - scrollView.contentInset.left, y: scrollView.contentInset.top)
        targetContentOffset.pointee = offset
    }
    
    func handleScrollViewScrolled(_ scrollView: UIScrollView) {
        let page = scrollView.contentOffset.x / scrollView.bounds.width
        let progressInPage = scrollView.contentOffset.x - (page * scrollView.bounds.width)
        let progress = CGFloat(page) + progressInPage
        let handleNegativeProgress = progress < 0 ? 0 : progress
        let actualPage = handleNegativeProgress.rounded() + 1
        mainThread {
            self.changePageControl(pageNo: Int(actualPage))
        }
    }
    
    func changePageControl(pageNo: Int) {
        switch pageNo {
        case 1:
            page3Yes.forEach({ $0.isHidden = true})
            page3No.forEach({ $0.isHidden = false})
            page2Yes.isHidden = true
            page2No.isHidden = false
            page1No.forEach({ $0.isHidden = true})
            page1Yes.forEach({ $0.isHidden = false})
        case 2:
            page3Yes.forEach({ $0.isHidden = true})
            page3No.forEach({ $0.isHidden = false})
            page2No.isHidden = true
            page2Yes.isHidden = false
            page1Yes.forEach({ $0.isHidden = true})
            page1No.forEach({ $0.isHidden = false})
        case 3:
            page1Yes.forEach({ $0.isHidden = true})
            page1No.forEach({ $0.isHidden = false})
            page2Yes.isHidden = true
            page2No.isHidden = false
            page3No.forEach({ $0.isHidden = true})
            page3Yes.forEach({ $0.isHidden = false})
        default:
            break
        }
    }
    
    func setupView(delegate: TutorialVC) {
        continueButton.handleBtnTap = {
            [weak self] in
            guard let view = self else { return }
            view.handleViewActions?(.continueButtonPressed)
        }
        tutorialCollectionView.delegate = delegate
        tutorialCollectionView.dataSource = delegate
        let flowLayout = tutorialCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        let cellWidth = self.width - (48*2)
        flowLayout.itemSize = CGSize(width: cellWidth, height: tutorialCollectionView.height - 20)
        tutorialCollectionView.contentInset = UIEdgeInsets(top: 0, left: (self.width - cellWidth)/2.0, bottom: 0, right: (self.width - cellWidth)/2.0)
        tutorialCollectionView.decelerationRate = .fast
    }
    
}
