//
//  SceneDelegate.swift
//  CodingTask
//
//  Created by Denis Aleshyn on 06/11/2023.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = scene as? UIWindowScene else { return }
        // Here is a place to set a number of scrren items to show.
        let values = [
            ConfigStringValue(key: "image1", value: ""),
            ConfigStringValue(key: "image2", value: ""),
            ConfigStringValue(key: "image3", value: ""),
            ConfigStringValue(key: "image4", value: ""),
            ConfigStringValue(key: "image5", value: ""),
            ConfigStringValue(key: "image6", value: ""),
        ]
        let firebaseDataSource = FirebaseDataSource(defaultValues: values)
        let presenter = Presenter(dataSource: firebaseDataSource)
        let vc = MainViewController(presenter: presenter)
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = vc
        window?.makeKeyAndVisible()
    }
}
