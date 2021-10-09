//
//  StringExtensions.swift
//  RouterDemo
//
//  Created by buff on 2021/9/29.
//

import Foundation

extension String {
    
    var pathWithoutScheme: String {
        let url = URL(string: self)
        let path = url?.path ?? ""
        let host = url?.host ?? ""
        return "\(host)\(path)"
    }
    
    var pathWithScheme: String {
        let url = URL(string: self)
        let scheme = url?.scheme ?? ""
        let path = url?.path ?? ""
        let host = url?.host ?? ""
        return "\(scheme)://\(host)\(path)"
    }
    
    var urlParams: [String: String]? {
        guard let url = URL(string: self) else { return nil }
        return url.queryParameters
    }
}
