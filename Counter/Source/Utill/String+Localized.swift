//
//  String+Localized.swift
//  Counter
//
//  Created by Monzy Zhang on 2020/12/10.
//

import Foundation

extension String {
    
    var localized: Self { NSLocalizedString(self, comment: "") }
    
}
