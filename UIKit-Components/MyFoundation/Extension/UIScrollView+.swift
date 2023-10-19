//
//  UIScrollView+.swift
//  MyFoundation
//
//  Created by 이서준 on 2022/05/18.
//

import UIKit

public enum ScrollDirection {
    case top
    case center
    case bottom
}

extension UIScrollView {
    func scroll(to direction: ScrollDirection) {

        DispatchQueue.main.async {
            switch direction {
            case .top:
                self.scrollToTop()
            case .center:
                self.scrollToCenter()
            case .bottom:
                self.scrollToBottom()
            }
        }
    }

    private func scrollToTop() {
        setContentOffset(.zero, animated: true)
    }

    private func scrollToCenter() {
        let centerOffset = CGPoint(x: 0, y: (contentSize.height - bounds.size.height) / 2)
        setContentOffset(centerOffset, animated: true)
    }

    private func scrollToBottom() {
        let bottomOffset = CGPoint(x: 0, y: contentSize.height - bounds.size.height + contentInset.bottom)
        if(bottomOffset.y > 0) {
            setContentOffset(bottomOffset, animated: true)
        }
    }
    
    func isNearBottomEdge(edgeOffset: CGFloat = 20.0) -> Bool {
        return self.contentOffset.y + self.frame.size.height + edgeOffset > self.contentSize.height
    }
}

extension UITableView {
    func scrollToTop() {
        let indexPath = NSIndexPath(row: NSNotFound, section: 0)
        scrollToRow(at: indexPath as IndexPath, at: .top, animated: true)
    }
}

extension UICollectionView {
    func scrollToTop() {
        let indexPath = NSIndexPath(row: NSNotFound, section: 0)
        scrollToItem(at: indexPath as IndexPath, at: .top, animated: true)
    }
}
