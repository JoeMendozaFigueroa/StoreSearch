//
//  SlideOutAnimationController.swift
//  StoreSearch
//
//  Created by Josue Mendoza on 10/2/21.
//

import UIKit

class SlideOutAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }
    //This method is for the animated "slideOut" effect that the pop-up view will initiate
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        if let fromView = transitionContext.view(forKey: UITransitionContextViewKey.from) {
            let containerView = transitionContext.containerView
            let time = transitionDuration(using: transitionContext)
            UIView.animate(withDuration: time,
                       animations: {fromView.center.y -= containerView.bounds.size.height
                        fromView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
                   }, completion: {finished in transitionContext.completeTransition(finished)
               }
            )
        }
    }
}

