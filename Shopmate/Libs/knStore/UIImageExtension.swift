//
//  UIImage.swift
//  kLibrary
//
//  Created by Ky Nguyen on 8/26/16.
//  Copyright © 2016 Ky Nguyen. All rights reserved.
//

import UIKit
import Kingfisher

extension UIImageView {
    func downloadImage(from url: String?, placeholder: UIImage? = nil) {
        guard let url = url, let nsurl = URL(string: url) else { return }
        kf.setImage(with: ImageResource(downloadURL: nsurl), placeholder: placeholder)
    }
    
    func blur() {
        layoutIfNeeded()
        let darkBlur = UIBlurEffect(style: UIBlurEffect.Style.dark)
        let blurView = UIVisualEffectView(effect: darkBlur)
        blurView.frame = frame
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(blurView)
    }
    
    func changeColor(to color: UIColor) {
        guard let image = image else { return }
        self.image = image.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        tintColor = color
    }
}

extension UIImage {
    func scale(scale: CGFloat, compressionQuality quality: CGFloat = 0.5) -> UIImage {
        let newSize = CGSize(width: size.width * scale, height: size.height * scale)
        let imageView = UIImageView(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: newSize))
        imageView.contentMode = UIView.ContentMode.scaleAspectFit
        imageView.image = self
        UIGraphicsBeginImageContext(imageView.bounds.size)
        imageView.layer.render(in: UIGraphicsGetCurrentContext()!)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        if let imageData: Data = img?.jpegData(compressionQuality: quality) {
            UIGraphicsEndImageContext()
            return UIImage(data: imageData) ?? self
        }
        
        return self
    }
    
    func resize(to targetSize: CGSize) -> UIImage {
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio,
                             height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,
                             height: size.height * widthRatio)
        }
        let rect = CGRect(origin: CGPoint.zero, size: newSize)
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
    
    /**
     Scale image to new size without keeping ratio
     */
    
    func scale(to newSize:CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let result:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return result
    }
    
    func saveImage(name: String){
        let fileManager = FileManager.default
        let path = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(name)
        let imageData = pngData()
        fileManager.createFile(atPath: path as String, contents: imageData, attributes: nil)
    }
    
    static func get(name: String) -> UIImage? {
        let directory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString
        let path = directory.appendingPathComponent(name)
        return UIImage(contentsOfFile: path)
    }

    static func delete(name: String) {
        let fileManager = FileManager.default
        do { try fileManager.removeItem(atPath: name) }
        catch let error as NSError {
            print("Ooops! Something went wrong: \(error)")
        }
    }
    
    func resize(toWidth width: CGFloat, compressionQuality quality: CGFloat = 0.5) -> UIImage {
        let newSize = CGSize(width: width, height: CGFloat(ceil(width / size.width * size.height)))
        let imageView = UIImageView(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: newSize))
        imageView.contentMode = UIView.ContentMode.scaleAspectFit
        imageView.image = self
        UIGraphicsBeginImageContext(imageView.bounds.size)
        imageView.layer.render(in: UIGraphicsGetCurrentContext()!)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        if let imageData = img?.jpegData(compressionQuality: quality) {
            UIGraphicsEndImageContext()
            return UIImage(data: imageData) ?? self
        }
        return self
    }
    
    func changeColor() -> UIImage {
        return withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
    }
    
    static func createImage(from color: UIColor) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()!
        context.setFillColor(color.cgColor)
        context.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }

    static func createImage(from color: UIColor, size: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFill(CGRect(origin: CGPoint.zero, size: size))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
    func createImage(with newSize: CGSize, radius: CGFloat,
                     byRoundingCorners: UIRectCorner? = nil) -> UIImage {
        let widthRatio  = newSize.width  / size.width
        let heightRatio = newSize.height / size.height
        
        let targetSize = widthRatio > heightRatio ?
            CGSize(width: size.width * heightRatio,
                   height: size.height * heightRatio) :
            CGSize(width: size.width * widthRatio,
                   height: size.height * widthRatio)
        
        UIGraphicsBeginImageContextWithOptions(targetSize, false, 0.0)
        let imgRect = CGRect(x: 0, y: 0, width: targetSize.width, height: targetSize.height)
        if let roundingCorners = byRoundingCorners {
            UIBezierPath(roundedRect: imgRect, byRoundingCorners: roundingCorners, cornerRadii: CGSize(width: radius, height: radius)).addClip()
        } else {
            UIBezierPath(roundedRect: imgRect, cornerRadius: radius).addClip()
        }
        draw(in: imgRect)
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return result!
    }
    
    func crop(to size: CGSize) -> UIImage {
        let contextImage = UIImage(cgImage: cgImage!)
        let contextSize = contextImage.size
        var posX: CGFloat = 0.0
        var posY: CGFloat = 0.0
        var cgwidth: CGFloat = CGFloat(size.width)
        var cgheight: CGFloat = CGFloat(size.height)
        
        if contextSize.width > contextSize.height {
            posX = ((contextSize.width - contextSize.height) / 2)
            posY = 0
            cgwidth = contextSize.height
            cgheight = contextSize.height
        } else {
            posX = 0
            posY = ((contextSize.height - contextSize.width) / 2)
            cgwidth = contextSize.width
            cgheight = contextSize.width
        }
        
        let rect: CGRect = CGRect(x: posX, y: posY, width: cgwidth, height: cgheight)
        let imageRef: CGImage = contextImage.cgImage!.cropping(to: rect)!
        let image = UIImage(cgImage: imageRef, scale: scale, orientation: imageOrientation)
        
        return image
    }
}
