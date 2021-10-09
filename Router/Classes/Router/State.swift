//
//  State.swift
//  RouterDemo
//
//  Created by buff on 2021/9/22.
//

import UIKit


struct State {
    
    struct Key {
        static let url = "_url"
        static let pattern = "_pattern"
    }
    
    static var states: [String: [String: String]] = [String: [String: String]]()
    
    static func set(params:[String: String], for view: UIViewController) {
        let key = String(format: "%p", view)
        states[key] = params
    }
    
    static func remove(_ view: UIViewController) {
        let key = String(format: "%p", view)
        states.removeValue(forKey: key)
    }
    
    static func get(paramOf view: UIViewController, forKey: String) -> String? {
        let viewDesc = String(format: "%p", view)
        let params = states[viewDesc] ?? [String:String]()
        return params[forKey]
    }
    
}
