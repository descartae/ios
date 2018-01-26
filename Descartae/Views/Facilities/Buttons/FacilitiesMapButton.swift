//
//  FacilitiesMapButton.swift
//  Descartae
//
//  Created by Filipe Alvarenga on 26/01/18.
//  Copyright © 2018 Filipe Alvarenga. All rights reserved.
//

import UIKit

class FacilitiesMapButton: UIButton {

    lazy var loadingIndicator: UIActivityIndicatorView = {
        let activity = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        return activity
    }()

    var shadowLayer: CAShapeLayer!
    var isLoading = false
    var titleBeforeLoading: String?

    override func layoutSubviews() {
        super.layoutSubviews()

        if shadowLayer == nil {
            shadowLayer = CAShapeLayer()
            shadowLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: 6).cgPath
            shadowLayer.fillColor = UIColor.white.cgColor

            shadowLayer.shadowColor = UIColor.darkGray.cgColor
            shadowLayer.shadowPath = shadowLayer.path
            shadowLayer.shadowOffset = CGSize(width: 0, height: 2)
            shadowLayer.shadowOpacity = 0.5
            shadowLayer.shadowRadius = 2

            layer.insertSublayer(shadowLayer, at: 0)
        }
    }

    func startLoading(considerVariableWidth variableWidth: CGFloat? = nil) {
        isLoading = true
        titleBeforeLoading = title(for: UIControlState())
        setTitle(nil, for: UIControlState())

        var width = frame.width
        if let variableWidthValue = variableWidth { width = variableWidthValue }
        loadingIndicator.frame = CGRect(
                x: (width / 2 - loadingIndicator.frame.width / 2),
                y: (frame.height / 2 - loadingIndicator.frame.height / 2),
                width: loadingIndicator.frame.width,
                height: loadingIndicator.frame.height
        )
        addSubview(loadingIndicator)
        loadingIndicator.startAnimating()
    }

    func stopLoading() {
        isLoading = false
        loadingIndicator.stopAnimating()
        loadingIndicator.removeFromSuperview()
        setTitle(titleBeforeLoading, for: UIControlState())
    }


}
