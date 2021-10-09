//
//  Router.swift
//  RouterDemo
//
//  Created by buff on 2021/9/17.
//

import Foundation
import UIKit
import SwifterSwift

struct Router {
    
    enum Method {
        case push
        case present
    }
    
    static var rules: [RouterRule]!
    static var defaultRule: RouterRule!
    
    
    /// if a url's scheme is not in the supported schemes, Router will not directly push
    /// or present a view controller. Instead, the application's openURL:options: method or the default route rule will be tried
    fileprivate static var supportedSchemes: [String]!
    
    /// if a scheme is reserved, it implies the url scheme needs to be modified or be specially handled  in some way
    fileprivate static var reservedSchemes: [String]!
    
    fileprivate static func initial() {
        rules = [RouterRule]()
        defaultRule = RouterRule()
        defaultRule.classOfRule = BridgedWebViewController.classForCoder()
        supportedSchemes = [String]()
        reservedSchemes = [String]()
    }
    
    static func config(with defaultViewClass: UIViewController.Type, supportedSchemes: [String]) {
        initial()
        setDefault(viewClass: defaultViewClass)
        self.supportedSchemes.append(contentsOf: supportedSchemes)
    }
    
    static func support(scheme: String) -> Bool {
        supportedSchemes.contains(scheme)
    }
    
    static func setDefault(viewClass: AnyClass) {
        defaultRule.classOfRule = viewClass
    }
    
    static func register(pattern: String, for viewClass: AnyClass) {
        let components = pattern.components(separatedBy: "://")
        assert((components.first?.count ?? 0) != 0 && Router.support(scheme: components.first ?? ""), "不支持的 scheme")
        
        let rule = RouterRule(pattern: pattern, classOfRule: viewClass)
        rules.append(rule)
    }
    
    static func register(pattern: String, for viewClassString: String) {
        guard let appName = Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as? String else { return }
        
        let classString = appName + "." + viewClassString
        guard let nsclass = NSClassFromString(classString) else {
            return
        }
        
        register(pattern: pattern, for: nsclass)
    }
    
    static func match(urlString: String) -> RouterRule {
        for rule in rules {
            if rule.matches(urlString: urlString) {
                return rule
            }
        }
        return defaultRule
    }
    
    static func view(for urlStr: String) -> UIViewController {
        let rule = Router.match(urlString: urlStr)
        let viewType: UIViewController.Type = rule.classOfRule as! UIViewController.Type
        var params = urlStr.urlParams
        params?[State.Key.url] = urlStr
        params?[State.Key.pattern] = rule.pattern
        let view = viewType.init()
        State.set(params: params ?? [:], for: view)
        return view
    }
    
    static func supports(urlStr: String) -> Bool {
        for rule in rules {
            if rule.matches(urlString: urlStr) {
                return true
            }
        }
        return false
    }
    
    static func route(url: String, with viewController: UIViewController? = nil, params: [String: String]? = [:], method: Method? = .push, animated: Bool = true) {
        let joinedUrl = join(urlStr: url, with: params)
        
        let vc = viewController ?? Utils.topViewController
        if joinedUrl.count > 0 {
            if supports(urlStr: joinedUrl) {
                switch method {
                case .present:
                    let view = view(for: joinedUrl)
                    view.modalPresentationStyle = .fullScreen
                    if vc?.navigationController != nil {
                        vc?.navigationController?.present(view, animated: animated) {}
                    }else {
                        vc?.present(view, animated: animated) {}
                    }
                default:
                    if (vc?.navigationController == nil) {
                        let nav = UINavigationController(rootViewController: view(for: joinedUrl))
                        vc?.present(nav, animated: animated) {}
                    }else {
                        vc?.navigationController?.pushViewController(view(for: joinedUrl), animated: animated)
                    }
                }
            }else {
                var reserved = false
                for scheme in reservedSchemes {
                    if joinedUrl.hasPrefix(scheme) {
                        reserved = true
                        break
                    }
                }
                
                guard let url = URL(string: joinedUrl) else { return }
                let canOpenUrl = UIApplication.shared.canOpenURL(url)
                if !joinedUrl.hasPrefix("http") && !reserved && canOpenUrl {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }else {
                    switch method {
                    case .present:
                        let view = view(for: joinedUrl)
                        view.modalPresentationStyle = .fullScreen
                        if vc?.navigationController != nil {
                            vc?.navigationController?.present(view, animated: animated) {}
                        }else {
                            vc?.present(view, animated: animated) {}
                        }
                    default:
                        if (vc?.navigationController == nil) {
                            let nav = UINavigationController(rootViewController: view(for: joinedUrl))
                            vc?.present(nav, animated: animated) {}
                        }else {
                            vc?.navigationController?.pushViewController(view(for: joinedUrl), animated: animated)
                        }
                    }
                }
            }
        }
    }
    
    private static func join(urlStr: String, with params: [String: String]?) -> String {
        guard let unwrappedParams = params else { return urlStr }
        var items = [String]()
        for (key, value) in unwrappedParams {
            let encodedValue = value.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            items.append("\(key)=\(encodedValue)")
        }
        
        if urlStr.contains("?") {
            return "\(urlStr)&\(items.joined(separator: "&"))"
        }
        
        return "\(urlStr)?\(items.joined(separator: "&"))"
    }
}
