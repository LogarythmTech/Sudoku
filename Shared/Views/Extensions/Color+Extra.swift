//
//  Color+Extra.swift
//  Sudoku (iOS)
//
//  Created by Logan Richards on 1/20/22.
//

import SwiftUI

extension Color {
    
    /// Allows for hexidecimal imput for color
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
    
    public static var shadow: Color {
        return Color(.sRGBLinear, white: 0, opacity: 0.13)
    }
    
    
    //MARK: - Blue
    public static var logAqua: Color {return Color(hex: "00FFFF")}
    public static var logAquamarine: Color {return Color(hex: "7FFFD4")}
    public static var logBlue: Color {return Color(hex: "0000FF")}
    public static var logCadetBlue: Color {return Color(hex: "5F9EA0")}
    public static var logCornFlowerBlue: Color {return Color(hex: "6495ED")}
    
    public static var logCyan: Color {return Color(hex: "00FFFF")}
    public static var logDarkBlue: Color {return Color(hex: "00008B")}
    public static var logDarkTurquoise: Color {return Color(hex: "00CED1")}
    public static var logDeepSkyBlue: Color {return Color(hex: "00BFFF")}
    public static var logDodgerBlue: Color {return Color(hex: "1E90FF")}
    
    public static var logLightBlue: Color {return Color(hex: "ADD8E6")}
    public static var logLightCyan: Color {return Color(hex: "E0FFFF")}
    public static var logLightSkyBlue: Color {return Color(hex: "87CEFA")}
    public static var logLightSteelBlue: Color {return Color(hex: "B0C4DE")}
    
    public static var logMediumBlue: Color {return Color(hex: "0000CD")}
    public static var logMediumSlateBlue: Color {return Color(hex: "7B68EE")}
    public static var logMediumTurquoise: Color {return Color(hex: "48D1CC")}
    
    public static var logMidnightBlue: Color {return Color(hex: "191970")}
    public static var logNavy: Color {return Color(hex: "000080")}
    public static var logPaleTurquoise: Color {return Color(hex: "AFEEEE")}
    
    public static var logPowderBlue: Color {return Color(hex: "B0E0E6")}
    public static var logRoyalBlue: Color {return Color(hex: "4169E1")}
    public static var logSkyBlue: Color {return Color(hex: "87CEEB")}
    public static var logSteelBlue: Color {return Color(hex: "4682B4")}
    public static var logTurquoise: Color {return Color(hex: "40E0D0")}
}
