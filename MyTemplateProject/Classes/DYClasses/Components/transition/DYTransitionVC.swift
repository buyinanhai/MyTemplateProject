//
//  DYTransitionVC.swift
//  TeacherAssistant
//
//  Created by 汪宁 on 2020/5/11.
//  Copyright © 2020 newcloudnet. All rights reserved.
//

import UIKit



enum DYTransitionStyle: Int {
    case presented
    case dismissed
}

/**
    自定义转场动画控制器 暂时只支持present的方式
 */
@objcMembers
class DYTransitionVC: UIViewController {

    
    public var dy_transitionAnimationTimeInterval: TimeInterval = 0.25;
    
    public var dy_transitionStyle: DYTransitionStyle?
    
    public var dy_transitionBackgroundType: DYBackGroundViewType = .dimming;
    
    /** 到外面自定义动画效果*/
    public var customTransitionAnimationCallback: ((_ transitionContext: UIViewControllerContextTransitioning,_ fromView: UIView,_ toView:UIView,_ style: DYTransitionStyle) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
        setupTransition()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupTransition()
    }
    
    private func setupTransition() {
        self.transitioningDelegate = self
        self.modalPresentationStyle = .custom
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension DYTransitionVC: UIViewControllerTransitioningDelegate {
    
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        
        return DYPresentationVC.init(presentedViewController: presented, presentingViewController: presenting, backViewType: self.dy_transitionBackgroundType);
        
    }
    
    
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        self.dy_transitionStyle = .presented;
        return self;
        
    }
    
    
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        self.dy_transitionStyle = .dismissed;
        return self;
        
    }
    
    
    
}


extension DYTransitionVC: UIViewControllerAnimatedTransitioning {
    
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        
        return self.dy_transitionAnimationTimeInterval;
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
       
        guard let fromVC = transitionContext.viewController(forKey: .from) else { return }
        
        guard let fromVCView = fromVC.view else {
            return;
        }
        guard let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) else { return }
        guard let toVCView = toVC.view else { return }
        let containerView = transitionContext.containerView
            
        if self.dy_transitionStyle == .presented {
            toVCView.frame = transitionContext.finalFrame(for: toVC)
            containerView.addSubview(toVCView)
        }
        
        //具体动画细节留给外面去做
        self.customTransitionAnimationCallback?(transitionContext,fromVCView, toVCView,self.dy_transitionStyle ?? .dismissed);
        
    }
    
    
}
