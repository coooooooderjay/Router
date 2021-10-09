//
//  RouterRule.swift
//  RouterDemo
//
//  Created by buff on 2021/9/27.
//

import Foundation
import UIKit

struct RouterRule {
    
    var pattern: String?
    var classOfRule: AnyClass?
    
    func matches(urlString: String) -> Bool {
        
        let trimmedUrlString = urlString.trimmingCharacters(in: .whitespacesAndNewlines)
        guard let url = URL(string: trimmedUrlString), let scheme = url.scheme else { return false }
        
        if !Router.support(scheme: scheme) { return false }
        
        let path = trimmedUrlString.pathWithScheme
        return path.elementsEqual(pattern ?? "")
    }
    
}
