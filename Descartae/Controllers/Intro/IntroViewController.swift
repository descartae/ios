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
        page.title.text = "Pontos de coleta"
        page.subtitle.text = "Finalmente você contrará onde\ndescatar lixos como eletrônicos,\npilhas e móveis nos pontos mais\npróximos de onde você está"
        return page
    }()

    lazy var secondPage: IntroContentView = {
        guard let page = IntroContentView.instantiateFromNib() else {
            return IntroContentView()
        }

        let attributedString = NSMutableAttributedString(string: "Isso mesmo! Os dados do Descartaê\nsão alimentados pelos bibliotecários\n voluntários de cada cidade  ")
        attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 17.0, weight: .bold), range: NSRange(location: 24, length: 9))

        page.onboardingImage.image = UIImage(named: "onboarding3")
        page.title.text = "Feito na Biblioteca"
        page.subtitle.attributedText = attributedString
        return page
    }()

    lazy var thirdPage: IntroContentView = {
        guard let page = IntroContentView.instantiateFromNib() else {
            return IntroContentView()
        }

        page.onboardingImage.image = UIImage(named: "onboarding4")
        page.startButton.isHidden = false
        page.title.text = "Junte-se a nós!"
        page.subtitle.text = "Clique no botão abaixo para começar\na deixar sua vida mais fácil e green"
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
