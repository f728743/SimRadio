//
//  UIImage+Extensions.swift
//  SimRadio
//
//  Created by Alexey Vorobyov on 27.03.2022.
//

import UIKit

extension UIImage {
    func convertToRGBColorspace() -> UIImage? {
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
        let context = CGContext(
            data: nil,
            width: Int(size.width),
            height: Int(size.height),
            bitsPerComponent: 8,
            bytesPerRow: 0,
            space: CGColorSpaceCreateDeviceRGB(),
            bitmapInfo: UInt32(bitmapInfo.rawValue)
        )
        guard let context = context, let cgImage = cgImage else { return nil }
        context.draw(cgImage, in: CGRect(origin: CGPoint.zero, size: size))
        guard let convertedImage = context.makeImage() else { return nil }
        return UIImage(cgImage: convertedImage)
    }
}
