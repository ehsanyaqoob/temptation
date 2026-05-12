//
//  Utilities.swift
//  temptation
//
//  Created by ehsanyaqoob on 12/05/2026.
//
import Foundation
import UIKit

final class Utilities {
    static let shared = Utilities()
    private init() { }

    @MainActor
    class func topViewController(controller: UIViewController? = nil) -> UIViewController? {
        // Find the active window scene to get the rootViewController
        let root = controller ?? UIApplication.shared.connectedScenes
            .filter { $0.activationState == .foregroundActive }
            .compactMap { $0 as? UIWindowScene }
            .first?.windows
            .filter { $0.isKeyWindow }.first?.rootViewController
        
        if let navigationController = root as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = root as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = root?.presentedViewController {
            return topViewController(controller: presented)
        }
        return root
    }
}
