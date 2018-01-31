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

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()

//        let background = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
//        background.backgroundColor = .red
////        view.backgroundColor = .flatGreen
//        contentView.addSubview(background)
//
//        background.translatesAutoresizingMaskIntoConstraints = false
//        background.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
//        background.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
//        background.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
//        background.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
//
//        keepView(background, onPages: [1, 2])

        let firstPageTop = UIColor(red: 49/255, green: 185/255, blue: 91/255, alpha: 1)
        let firstPageBottom = UIColor(red: 26/255, green: 120/255, blue: 79/255, alpha: 1)
        let secondPageTop = UIColor(red: 116/255, green: 194/255, blue: 53/255, alpha: 1)
        let secondPageBottom = UIColor(red: 20/255, green: 103/255, blue: 54/255, alpha: 1)

        var frame = UIScreen.main.bounds
//        frame.size.width += 100
        let c = GradientColor(.topToBottom, frame: frame, colors: [firstPageTop, firstPageBottom])
        let d = GradientColor(.topToBottom, frame: frame, colors: [secondPageTop, secondPageBottom])
        let alphaAnimation = AlphaAnimation(view: view)
        alphaAnimation[0] = 1
        alphaAnimation[0.5] = 0.8
        alphaAnimation[1] = 1
        let backgroundAnimation = BackgroundColorAnimation(view: view)
        backgroundAnimation[0] = c
        backgroundAnimation[0.5] = d
        animator.addAnimation(backgroundAnimation)
        animator.addAnimation(alphaAnimation)
    }

//    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        super.scrollViewDidScroll(scrollView)
//        animator.animate(scrollView.contentOffset.x)
//    }

}
