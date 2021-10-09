//
//  UIViewControllerExtensions.swift
//  RouterDemo
//
//  Created by buff on 2021/9/29.
//

import UIKit

struct Utils {
    static var topViewController: UIViewController? {
        get {
            var window = UIApplication.shared.delegate?.window
                //是否为当前显示的window
            if window??.windowLevel != UIWindow.Level.normal {
                let windows = UIApplication.shared.windows
                for  windowTemp in windows{
                    if windowTemp.windowLevel == UIWindow.Level.normal {
                        window = windowTemp
                        break
                    }
                }
            }

            let vc = window??.rootViewController
            return getTopMostViewController(with: vc)
        }
    }
    
    private static func getTopMostViewController(with viewController: UIViewController?) -> UIViewController? {
            
        if viewController == nil {
            return nil
        }else if let presentVC = viewController?.presentedViewController {
            return getTopMostViewController(with: presentVC)
        }
        else if let tabVC = viewController as? UITabBarController {
            if let selectVC = tabVC.selectedViewController {
                return getTopMostViewController(with: selectVC)
            }
            return nil
        } else if let nav = viewController as? UINavigationController {
            return getTopMostViewController(with: nav.visibleViewController)
        }
        else {
            return viewController
        }
    }
}
