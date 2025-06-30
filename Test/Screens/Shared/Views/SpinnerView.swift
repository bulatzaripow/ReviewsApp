//
//  SpinnerView.swift
//  Test
//
//  Created by Bulat Zaripov on 30.06.2025.
//

import UIKit

final class SpinnerView: UIView {

    private let shapeLayer = CAShapeLayer()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayer()
        startAnimating()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupLayer() {
        shapeLayer.lineWidth = 5
        shapeLayer.strokeColor = UIColor.label.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineCap = .round
        shapeLayer.strokeEnd = 0.75

        let side = min(bounds.width, bounds.height)
        let radius = (side - shapeLayer.lineWidth) / 2
        shapeLayer.path = UIBezierPath(
            arcCenter: center,
            radius: radius,
            startAngle: 0,
            endAngle: 2 * .pi,
            clockwise: true
        ).cgPath
        shapeLayer.frame = bounds

        layer.addSublayer(shapeLayer)
    }

    func startAnimating() {
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotationAnimation.fromValue = 0
        rotationAnimation.toValue = CGFloat.pi * 2
        rotationAnimation.duration = 1.0
        rotationAnimation.repeatCount = .infinity
        rotationAnimation.timingFunction = CAMediaTimingFunction(name: .linear)
        shapeLayer.add(rotationAnimation, forKey: "rotationAnimation")
    }
}
