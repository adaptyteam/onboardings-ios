//
//  SplashController.swift
//  OctoflowsDemo-UIKit
//
//  Created by Aleksey Goncharov on 02.08.2024.
//

import UIKit

final class SplashController: UIViewController {
    @IBOutlet var activityIndicator: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()

        activityIndicator.alpha = 0.0
        activityIndicator.startAnimating()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        UIView.animate(withDuration: 0.3, delay: 0.0) {
            self.activityIndicator.alpha = 1.0
        }
    }
}

extension SplashController {
    private static let storyboard = UIStoryboard(name: "Main", bundle: nil)

    static func instantiate() -> SplashController {
        storyboard.instantiateViewController(identifier: "SplashController") as! SplashController
    }
}
