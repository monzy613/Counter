//
//  Color.swift
//  Counter
//
//  Created by Monzy Zhang on 2020/12/8.
//

import UIKit

enum Color {
    
    static let red = UIColor(hex: 0xF96149)
    
    static let blue = UIColor(hex: 0x19A3FF)
    
    static let backgroundInvertion = UIColor {
        switch $0.userInterfaceStyle {
        case .dark:
            return .white
        default:
            return .black
        }
    }
    
    static let background = UIColor {
        switch $0.userInterfaceStyle {
        case .dark:
            return .black
        default:
            return .white
        }
    }

    static let plus = UIColor {
        switch $0.userInterfaceStyle {
        case .dark:
            return .white
        default:
            return Color.blue
        }
    }
    
}

extension UIColor {
    
    public convenience init(red: Int, green: Int, blue: Int, alpha: CGFloat = 1) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: alpha)
    }

    public convenience init(hexString: String, alpha: CGFloat = 1.0) {
        var hex = hexString.trimmingCharacters(in: .whitespacesAndNewlines)

        if hex.hasPrefix("#") {
            hex.removeFirst()
        }

        if hex.count == 3 {
            let r = hex[hex.index(hex.startIndex, offsetBy: 0)]
            let g = hex[hex.index(hex.startIndex, offsetBy: 1)]
            let b = hex[hex.index(hex.startIndex, offsetBy: 2)]
            hex = .init([r, r, g, g, b, b])
        }

        if hex.isEmpty || hex.count != 6 {
            self.init(white: 0, alpha: 0)
            return
        }

        let scanner = Scanner(string: hex)
        var color: UInt32 = 0
        scanner.scanHexInt32(&color)
        self.init(hex: Int(color), alpha: alpha)
    }
    
    public convenience init(hex: Int, alpha: CGFloat = 1) {
        self.init(red: (hex >> 16) & 0xFF, green: (hex >> 8) & 0xFF, blue: hex & 0xFF, alpha: alpha)
    }
    
}
