//
//  IntroductionPageVC.swift
//  Salesken
//
//  Created by Anup on 17/03/20.
//  Copyright © 2020 Salesken.ai. All rights reserved.
//

import UIKit

struct Pages {
    static let first = "FirstVC"
    static let second = "SecondVC"
    static let third = "ThirdVC"
}


protocol IntroductionDelegate: class {
    //Called when the number of pages is updated.
    func introductionPageVC(introductionPageVC: IntroductionPageVC,didUpdatePageCount count: Int)
   //Called when the current index is updated.
    func introductionPageVC(introductionPageVC: IntroductionPageVC,didUpdatePageIndex index: Int)
}

class IntroductionPageVC: UIPageViewController {

    weak var introductionDelegate: IntroductionDelegate?
    
    private(set) lazy var pagesVC: [UIViewController] = {
        // The view controllers will be shown in this order
        return [self.initVC(Pages.first),
                self.initVC(Pages.second),
                self.initVC(Pages.third)
               ]
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        dataSource = self
        if let initialViewController = pagesVC.first {
            scrollToViewController(viewController: initialViewController)
        }
        introductionDelegate?.introductionPageVC(introductionPageVC: self, didUpdatePageCount: pagesVC.count)
    }
    

    func initVC(_ identifier: String) -> UIViewController {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: identifier)
    }
    
    func scrollToViewController(index newIndex: Int) {
        if let firstViewController = viewControllers?.first,
            let currentIndex = pagesVC.firstIndex(of: firstViewController) {
            let direction: UIPageViewController.NavigationDirection = newIndex >= currentIndex ? .forward : .reverse
                let nextViewController = pagesVC[newIndex]
                scrollToViewController(viewController: nextViewController, direction: direction)
        }
    }
    
    func scrollToNextViewController() {
        if let visibleViewController = viewControllers?.first,
            let nextViewController = pageViewController(self, viewControllerAfter: visibleViewController) {
                    scrollToViewController(viewController: nextViewController)
        }
    }
    
    private func scrollToViewController(viewController: UIViewController,
                                        direction: UIPageViewController.NavigationDirection = .forward){
        setViewControllers([viewController],direction: direction,animated: true,
            completion: { (finished) -> Void in
                // Setting the view controller programmatically does not fire
                // any delegate methods, so we have to manually notify the
                // 'introductionDelegate' of the new index.
                self.notifyTutorialDelegateOfNewIndex()
        })
    }
     
    private func notifyTutorialDelegateOfNewIndex() {
        if let firstViewController = viewControllers?.first,
            let index = pagesVC.firstIndex(of: firstViewController) {
            introductionDelegate?.introductionPageVC(introductionPageVC: self, didUpdatePageIndex: index)
        }
    }
     

}
extension IntroductionPageVC: UIPageViewControllerDelegate,UIPageViewControllerDataSource{
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = pagesVC.firstIndex(of: viewController) else {
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        
        // User is on the first view controller and swiped left to loop to
        // the last view controller.
        guard previousIndex >= 0 else {
            return pagesVC.last
        }
        
        guard pagesVC.count > previousIndex else {
            return nil
        }
        
        return pagesVC[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = pagesVC.firstIndex(of: viewController) else {
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        let totalPage = pagesVC.count
        
        // User is on the last view controller and swiped right to loop to
        // the first view controller.
        guard totalPage != nextIndex else {
            return pagesVC.first
        }
        
        guard totalPage > nextIndex else {
            return nil
        }
        
        return pagesVC[nextIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        notifyTutorialDelegateOfNewIndex()
    }
    
}
