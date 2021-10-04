//
//  BounceAnimationController.swift
//  StoreSearch
//
//  Created by Josue Mendoza on 10/2/21.
//

import UIKit

//This is the class for the bounce action
class BounceAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.4
    }
    //This method is for the animated bouncing effect that the pop-up view will initiate
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        if let toViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to),
            let toView = transitionContext.view(forKey: UITransitionContextViewKey.to) {
            let containerView = transitionContext.containerView
            toView.frame = transitionContext.finalFrame(for: toViewController)
            containerView.addSubview(toView)
            toView.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
            
            //This section are the keyframes for the bounce animation
            UIView.animateKeyframes(withDuration: transitionDuration(using: transitionContext), delay: 0, options: .calculationModeCubic, animations: {UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.334) {
                toView.transform = CGAffineTransform (
                    scaleX: 1.2, y: 1.2)
            }
            UIView.addKeyframe(withRelativeStartTime: 0.334, relativeDuration: 0.333) {
                toView.transform = CGAffineTransform (
                    scaleX: 0.9, y: 0.9)
            }
            UIView.addKeyframe(withRelativeStartTime: 0.666, relativeDuration: 0.333) {
                toView.transform = CGAffineTransform (
                    scaleX: 1.0, y: 1.0)
            }
        }, completion: { finished in transitionContext.completeTransition(finished)
            })
        }
    }
}
