//
//  PageContainerVC.swift
//  Salesken
//
//  Created by Anup on 17/03/20.
//  Copyright © 2020 Salesken.ai. All rights reserved.
//

import UIKit

class PageContainerVC: UIViewController {

    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var headerLabel: UILabel!
    
    @IBOutlet weak var skipBtn: UIButton!
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var nextBtn: SaleskenButton!
    
    
    var introductionVC: IntroductionPageVC? {
        didSet {
            introductionVC?.introductionDelegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pageControl.tintColor = .gray
        pageControl.currentPageIndicatorTintColor = .primaryColor
        pageControl.addTarget(self, action: #selector(PageContainerVC.didChangePageControlValue), for: .valueChanged)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let introductionPageVC = segue.destination as? IntroductionPageVC {
            self.introductionVC = introductionPageVC
        }
    }
    
    @objc func didChangePageControlValue() {
        introductionVC?.scrollToViewController(index: pageControl.currentPage)
    }
    
    @IBAction func onClickSkip(_ sender: Any) {
        let newStoryBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
         let VC = newStoryBoard.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
         VC.modalPresentationStyle = .fullScreen
         self.present(VC, animated: true, completion: nil)
    }
    
    @IBAction func onClickNext(_ sender: Any) {
        introductionVC?.scrollToNextViewController()
    }
    

}
extension PageContainerVC: IntroductionDelegate{
    func introductionPageVC(introductionPageVC: IntroductionPageVC, didUpdatePageCount count: Int) {
        pageControl.numberOfPages = count
    }
    
    func introductionPageVC(introductionPageVC: IntroductionPageVC, didUpdatePageIndex index: Int) {
        pageControl.currentPage = index
    }
    
    
}
