//
//  Functions.swift
//  GameDB
//
//  Created by Cem Kılıç on 11.03.2022.
//

import Foundation
import SystemConfiguration 
import UIKit

func isOnboarded() -> Bool{
    var onboarded : Bool = userDefaults.object(forKey: "onboarded") as? Bool ?? false
    return onboarded
}

func setOnboarded(){
    userDefaults.set(true, forKey: "onboarded")
    userDefaults.synchronize()
}

public func showAlert(_ storyboard: String,_ identifier: String,_ mps : UIModalPresentationStyle?,_ mts: UIModalTransitionStyle?) -> UIViewController {
    let storyboard = UIStoryboard(name: storyboard, bundle: nil)
    let customAlert = storyboard.instantiateViewController(withIdentifier: identifier)
    customAlert.providesPresentationContextTransitionStyle = true
    customAlert.definesPresentationContext = true
    if mps != nil {
        customAlert.modalPresentationStyle = mps!
    }
    if mts != nil {
        customAlert.modalTransitionStyle = mts!
    }
    return customAlert
}

func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
    let size = image.size
    
    let widthRatio  = targetSize.width  / size.width
    let heightRatio = targetSize.height / size.height
    
    // Figure out what our orientation is, and use that to form the rectangle
    var newSize: CGSize
    if(widthRatio > heightRatio) {
        newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
    } else {
        newSize = CGSize(width: size.width * widthRatio, height: size.height * widthRatio)
    }
    
    // This is the rect that we've calculated out and this is what is actually used below
    let rect = CGRect(origin: .zero, size: newSize)
    
    // Actually do the resizing to the rect using the ImageContext stuff
    UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
    image.draw(in: rect)
    let newImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    return newImage!
}

///Gets image from documents, with gaved string.
func getSavedImage(named: String) -> UIImage? {
    if let dir = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) {
        return UIImage(contentsOfFile: URL(fileURLWithPath: dir.absoluteString).appendingPathComponent(named).path)
    }
    return nil
}

///Saves image with given name
///returns bool
func saveImage(image: UIImage, name: String) -> Bool {
    guard let data = image.jpegData(compressionQuality: 1) ?? image.pngData() else {
        return false
    }
    guard let directory = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) as NSURL else {
        return false
    }
    do {
        try data.write(to: directory.appendingPathComponent(name)!)
        return true
    } catch {
        print(error.localizedDescription)
        return false
    }
}

/// Shows spinner from main storyboard, with given delay
/*
func showSpinner(delayBeforeClosing delay : Double)-> UIViewController{
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let spinner = storyboard.instantiateViewController(withIdentifier: "Spinner") as! Spinner
    spinner.providesPresentationContextTransitionStyle = true
    spinner.definesPresentationContext = true
    spinner.modalTransitionStyle = .crossDissolve
    spinner.modalPresentationStyle = .overCurrentContext
    spinner.delayBeforeClosing = delay
    return spinner
}
*/
