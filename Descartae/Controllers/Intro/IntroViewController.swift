//
//  IntroViewController.swift
//  Descartae
//
//  Created by Filipe Alvarenga on 31/01/18.
//  Copyright © 2018 Filipe Alvarenga. All rights reserved.
//

import UIKit
import RazzleDazzle

class IntroViewController: AnimatedPagingScrollViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let background = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        background.backgroundColor = .red

        contentView.addSubview(background)

        background.translatesAutoresizingMaskIntoConstraints = false
        background.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        background.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        background.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        background.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true

        keepView(background, onPages: [1, 2])

        let backgroundAnimation = BackgroundColorAnimation(view: background)
        backgroundAnimation[0] = .red
        backgroundAnimation[1] = .blue
        animator.addAnimation(backgroundAnimation)
    }

}
