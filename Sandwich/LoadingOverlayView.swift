//
//  LoadingOverlayView.swift
//  Sandwich
//
//  Created by Jason Welch on 7/16/17.
//  Copyright © 2017 JasonCanCode. All rights reserved.
//

import UIKit

protocol LoadingOverlayDisplayable: AnyObject {
    var loadingOverlayView: LoadingOverlayView? { get set }
}

extension LoadingOverlayDisplayable {

    func addLoadingOverlay(to view: UIView) {
        let loadingOverlayView = LoadingOverlayView(frame: view.frame)
        view.addSubview(loadingOverlayView)

        loadingOverlayView.translatesAutoresizingMaskIntoConstraints = false
        loadingOverlayView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: 0).isActive = true
        loadingOverlayView.heightAnchor.constraint(equalTo: view.heightAnchor, constant: 0).isActive = true
        loadingOverlayView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        loadingOverlayView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0).isActive = true

        self.loadingOverlayView = loadingOverlayView
    }

    func updateLoadingSpinner(isLoading: Bool) {
        if isLoading {
            loadingOverlayView?.begin()
        } else {
            loadingOverlayView?.end()
        }
    }
}

extension LoadingOverlayDisplayable where Self: UIViewController {
    
    func addLoadingOverlay() {
        addLoadingOverlay(to: view)
    }
}

class LoadingOverlayView: UIView {
    private var currentProcessesCount: UInt = 0 {
        willSet {
            self.isHidden = newValue == 0
        }
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        self.configure()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.configure()
    }

    private func configure() {
        isHidden = true
        backgroundColor = UIColor.clear

        let dimmerView = UIView(frame: frame)
        dimmerView.backgroundColor = UIColor.black
        dimmerView.alpha = 0.4
        addSubview(dimmerView)

        let indicator = UIActivityIndicatorView(style: .large)
        indicator.startAnimating()
        addSubview(indicator)

        dimmerView.translatesAutoresizingMaskIntoConstraints = false
        dimmerView.widthAnchor.constraint(equalTo: self.widthAnchor, constant: 0).isActive = true
        dimmerView.heightAnchor.constraint(equalTo: self.heightAnchor, constant: 0).isActive = true
        dimmerView.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0).isActive = true
        dimmerView.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0).isActive = true

        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0).isActive = true
        indicator.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0).isActive = true
    }

    func begin() {
        if currentProcessesCount == 0 {
            isUserInteractionEnabled = false
        }
        currentProcessesCount += 1

    }

    func end() {
        if currentProcessesCount > 0 {
            currentProcessesCount -= 1
        }
        if currentProcessesCount == 0 {
            isUserInteractionEnabled = true
        }
    }
}

