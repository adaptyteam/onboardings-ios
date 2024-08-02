//
//  SceneDelegate.swift
//  OctoflowsDemo-UIKit
//
//  Created by Aleksey Goncharov on 02.08.2024.
//

import UIKit
import Octoflows

//import OSLog
//
//extension Log.Level {
//    var osLogLevel: OSLogType {
//        switch self {
//        case .error: .error
//        case .warn: .fault
//        case .info: .info
//        case .verbose: .debug
//        case .debug: .debug
//        }
//    }
//}
//
//final class ApplicationLogger {
//    
//}

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        Task {
            do {
                let configuration = try Octoflows.Configuration
                    .Builder(withAPIKey: "")
                    .with(loglevel: .verbose)
                    .build()
                
                try await Octoflows.activate(with: configuration)
            } catch {
                // handle the error
            }
        }
        
        let window = UIWindow(windowScene: windowScene)

        window.rootViewController = Octoflows.createOnboardingController()
        window.makeKeyAndVisible()

        self.window = window
    }
}
