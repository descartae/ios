//
//  IntroViewController.swift
//  Descartae
//
//  Created by Filipe Alvarenga on 31/01/18.
//  Copyright © 2018 Filipe Alvarenga. All rights reserved.
//

import UIKit
import RazzleDazzle
import ChameleonFramework

class IntroViewController: AnimatedPagingScrollViewController {

    // MARK: Properties

    static let identifier = String(describing: IntroViewController.self)

    @IBOutlet weak var pageControl: UIPageControl!

    lazy var firstPage: IntroContentView = {
        guard let page = IntroContentView.instantiateFromNib() else {
            return IntroContentView()
        }

        page.onboardingImage.image = UIImage(named: "onboarding1")
        page.title.text = localized("first_page_title")
        page.subtitle.text = localized("first_page_subtitle")
        return page
    }()

    lazy var secondPage: IntroContentView = {
        guard let page = IntroContentView.instantiateFromNib() else {
            return IntroContentView()
        }

        let attributedString = NSMutableAttributedString(string: localized("second_page_subtitle"))
        var location: Int = 0

        if StateManager.isPtBr {
            location = 24
        } else if StateManager.isEn {
            location = 31
        }

        if StateManager.isEn || StateManager.isPtBr {
            attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 17.0, weight: .bold), range: NSRange(location: location, length: 9))
            page.subtitle.attributedText = attributedString
        } else {
            page.subtitle.text = localized("second_page_subtitle")
        }

        page.onboardingImage.image = UIImage(named: "onboarding3")
        page.title.text = localized("second_page_title")
        return page
    }()

    lazy var thirdPage: IntroContentView = {
        guard let page = IntroContentView.instantiateFromNib() else {
            return IntroContentView()
        }

        page.onboardingImage.image = UIImage(named: "onboarding4")
        page.startButton.isHidden = false
        page.title.text = localized("third_page_title")
        page.subtitle.text = localized("third_page_subtitle")
        page.start = {
            guard let appDelegate  = UIApplication.shared.delegate as? AppDelegate, let window = appDelegate.window else {
                return
            }

            UIView.transition(with: window, duration: 0.5, options: .transitionCrossDissolve, animations: { () -> Void in
                let oldState = UIView.areAnimationsEnabled
                UIView.setAnimationsEnabled(false)
                let tabBar = UIStoryboard.mainStoryboard.instantiateInitialViewController()
                window.rootViewController = tabBar
                UIView.setAnimationsEnabled(oldState)
                StateManager.appIntroHasBeenPresented = true
            }, completion: nil)
        }

        return page
    }()

    override func numberOfPages() -> Int {
        return 3
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    // MARK: Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupPageView()
    }

    // MARK: Initial setup

    func setupPageView() {
        add(subview: firstPage, toPage: 1)
        add(subview: secondPage, toPage: 2)
        add(subview: thirdPage, toPage: 3)

        let firstPageTop = UIColor(red: 49/255, green: 185/255, blue: 91/255, alpha: 1)
        let firstPageBottom = UIColor(red: 26/255, green: 120/255, blue: 79/255, alpha: 1)
        let secondPageTop = UIColor(red: 116/255, green: 194/255, blue: 53/255, alpha: 1)
        let secondPageBottom = UIColor(red: 20/255, green: 103/255, blue: 54/255, alpha: 1)

        let frame = UIScreen.main.bounds
        let darkerGradient = GradientColor(.topToBottom, frame: frame, colors: [firstPageTop, firstPageBottom])
        let lighterGradient = GradientColor(.topToBottom, frame: frame, colors: [secondPageTop, secondPageBottom])
        let alphaAnimation = AlphaAnimation(view: view)
        alphaAnimation[0] = 1
        alphaAnimation[0.5] = 0.9
        alphaAnimation[1] = 1
        alphaAnimation[1.5] = 0.9
        alphaAnimation[2] = 1
        let backgroundAnimation = BackgroundColorAnimation(view: view)
        backgroundAnimation[0] = darkerGradient
        backgroundAnimation[0.5] = lighterGradient
        backgroundAnimation[1] = lighterGradient
        backgroundAnimation[1.5] = darkerGradient

        animator.addAnimation(backgroundAnimation)
        animator.addAnimation(alphaAnimation)
    }

    func add(subview: UIView, toPage page: CGFloat) {
        contentView.addSubview(subview)

        var centerXConstant: CGFloat = 0
        switch page {
        case 1:
            centerXConstant = -UIScreen.main.bounds.width
        case 2:
            centerXConstant = 0
        case 3:
            centerXConstant = UIScreen.main.bounds.width
        default:
            break
        }

        subview.translatesAutoresizingMaskIntoConstraints = false
        subview.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0).isActive = true
        subview.centerXAnchor.constraint(equalTo: contentView.centerXAnchor, constant: centerXConstant).isActive = true
        subview.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height).isActive = true
        subview.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width).isActive = true
    }

    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        super.scrollViewDidScroll(scrollView)

        let currentPage = Int(scrollView.contentOffset.x / pageWidth)
        pageControl.currentPage = currentPage
    }

}
