//
//  article_protocol.swift
//  Report.
//
//  Created by Amogh Kalyan on 12/10/21.
//

import Foundation
import UIKit

protocol imageConverterDelegate {
    func imageReceived(_ sender:imageConverter)
}

class imageConverter {
    var url:String
    var image:UIImage?
    
    var delegate:imageConverterDelegate?
    
    init(url:String) {
        self.url = url
    }
    
    func convertImage() {
        let urlConvert = URL(string: url)!
        let data = try? Data(contentsOf: urlConvert)

        if let imageData = data {
            let image = UIImage(data: imageData)
            self.image = image
        }
        
        func gotImage() {
            delegate?.imageReceived(self)
        }
    }
    
    
    
}
