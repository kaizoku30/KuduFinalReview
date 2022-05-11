//
//  ScaledVisibleCellsCollectionView.swift
//  ScaledVisibleCellsCollectionView
//
//  Created by Mai Ikeda on 2015/08/22.
//  Copyright (c) 2015年 mai_ikeda. All rights reserved.
//

import UIKit

public enum SC_ScaledPattern {
    case HorizontalCenter
    case HorizontalLeft
    case HorizontalRight
    case VerticalCenter
    case VerticalBottom
    case VerticalTop
}

public class ScaledVisibleCellsCollectionView: UICollectionView {
    // static let sharedInstance = ScaledVisibleCellsCollectionView()
    
    static var maxScale: CGFloat = 1.0
    static var minScale: CGFloat = 0.5
    
    static var maxAlpha: CGFloat = 1.0
    static var minAlpha: CGFloat = 0.5
    
    static var scaledPattern: SC_ScaledPattern = .VerticalCenter
}

extension UICollectionView {
    
    /**
    Please always set
    */
    public func setScaledDesginParam(scaledPattern pattern: SC_ScaledPattern, maxScale: CGFloat, minScale: CGFloat, maxAlpha: CGFloat, minAlpha: CGFloat) {
        ScaledVisibleCellsCollectionView.scaledPattern = pattern
        ScaledVisibleCellsCollectionView.maxScale = maxScale
        ScaledVisibleCellsCollectionView.minScale = minScale
        ScaledVisibleCellsCollectionView.maxAlpha = maxAlpha
        ScaledVisibleCellsCollectionView.minAlpha = minAlpha
    }
    
    /**
    Please call at any time
    */
    public func scaledVisibleCells() {
        switch ScaledVisibleCellsCollectionView.scaledPattern {
        case .HorizontalCenter, .HorizontalLeft, .HorizontalRight:
            scaleCellsForHorizontalScroll(visibleCells: visibleCells)
        case .VerticalCenter, .VerticalTop, .VerticalBottom:
            self.scaleCellsForVerticalScroll(visibleCells: visibleCells)
        }
    }
}

extension UICollectionView {
    
    private func scaleCellsForHorizontalScroll(visibleCells: [UICollectionViewCell]) {
        
        let scalingAreaWidth = bounds.width / 2
        let maximumScalingAreaWidth = (bounds.width / 2 - scalingAreaWidth) / 2
        
        for cell in visibleCells {
            var distanceFromMainPosition: CGFloat = 0
            
            switch ScaledVisibleCellsCollectionView.scaledPattern {
            case .HorizontalCenter:
                distanceFromMainPosition = horizontalCenter(cell: cell)
            case .HorizontalLeft:
                distanceFromMainPosition = abs(cell.frame.midX - contentOffset.x - (cell.bounds.width / 2))
            case .HorizontalRight:
                distanceFromMainPosition = abs(bounds.width / 2 - (cell.frame.midX - contentOffset.x) + (cell.bounds.width / 2))
            default:
                return
            }
            let preferredAry = scaleCells(distanceFromMainPosition: distanceFromMainPosition, maximumScalingArea: maximumScalingAreaWidth, scalingArea: scalingAreaWidth)
            let preferredScale = preferredAry[0]
            let preferredAlpha = preferredAry[1]
            cell.transform = CGAffineTransform(scaleX: preferredScale, y: preferredScale)
            cell.alpha = preferredAlpha
        }
    }
    
    private func scaleCellsForVerticalScroll(visibleCells: [UICollectionViewCell]) {
        
        let scalingAreaHeight = bounds.height / 2
        let maximumScalingAreaHeight = (bounds.height / 2 - scalingAreaHeight) / 2
        
        for cell in visibleCells {
            var distanceFromMainPosition: CGFloat = 0
            
            switch ScaledVisibleCellsCollectionView.scaledPattern {
            case .VerticalCenter:
                distanceFromMainPosition = verticalCenter(cell: cell)
            case .VerticalBottom:
                distanceFromMainPosition = abs(bounds.height - (cell.frame.midY - contentOffset.y + (cell.bounds.height / 2)))
            case .VerticalTop:
                distanceFromMainPosition = abs(cell.frame.midY - contentOffset.y - (cell.bounds.height / 2))
            default:
                return
            }
            let preferredAry = scaleCells(distanceFromMainPosition: distanceFromMainPosition, maximumScalingArea: maximumScalingAreaHeight, scalingArea: scalingAreaHeight)
            let preferredScale = preferredAry[0]
            let preferredAlpha = preferredAry[1]
            
            cell.transform = CGAffineTransform(scaleX: preferredScale, y: preferredScale)
            cell.alpha = preferredAlpha
        }
    }
    
    private func scaleCells(distanceFromMainPosition: CGFloat, maximumScalingArea: CGFloat, scalingArea: CGFloat) -> [CGFloat] {
        var preferredScale: CGFloat = 0.0
        var preferredAlpha: CGFloat = 0.0
        
        let maxScale = ScaledVisibleCellsCollectionView.maxScale
        let minScale = ScaledVisibleCellsCollectionView.minScale
        let maxAlpha = ScaledVisibleCellsCollectionView.maxAlpha
        let minAlpha = ScaledVisibleCellsCollectionView.minAlpha
        
        if distanceFromMainPosition < maximumScalingArea {
            // cell in maximum-scaling area
            preferredScale = maxScale
            preferredAlpha = maxAlpha
            
        } else if distanceFromMainPosition < (maximumScalingArea + scalingArea) {
            // cell in scaling area
            let multiplier = abs((distanceFromMainPosition - maximumScalingArea) / scalingArea)
            preferredScale = maxScale - multiplier * (maxScale - minScale)
            preferredAlpha = maxAlpha - multiplier * (maxAlpha - minAlpha)
            
        } else {
            // cell in minimum-scaling area
            preferredScale = minScale
            preferredAlpha = minAlpha
        }
        return [ preferredScale, preferredAlpha ]
    }
}

extension UICollectionView {
    
    private func horizontalCenter(cell: UICollectionViewCell) -> CGFloat {
        return abs(bounds.width / 2 - (cell.frame.midX - contentOffset.x))
    }
    
    private func verticalCenter(cell: UICollectionViewCell) -> CGFloat {
        return abs(bounds.height / 2 - (cell.frame.midY - contentOffset.y))
    }
}
