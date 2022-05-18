//
//  Extensions.swift
//  CoinCaper
//
//  Created by Cem Kılıç on 16.03.2022.
//

import Foundation

extension Double {
    /// Rounds the double to decimal places value
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}

extension String{
    func valueFormatter() -> String {
        guard let number = Double(self) else{
            return "Error occured"
        }
        if number > 10 {
            return String(number.rounded(toPlaces: 2))
        }
        else if number > 1{
            return String(number.rounded(toPlaces: 5))
        }
        else{
            var digit = number
            var digitCounter = 0
            while digit < 1{
                digit = digit*10
                digitCounter += 1
            }
            if digitCounter < 3{
                return String(number.rounded(toPlaces: 6))
            }
            else{
                var string = String(digit.rounded(toPlaces: 3))
                string += "*10^"
                string += String(digitCounter)
                return String(string)
            }
        }
    }
}
