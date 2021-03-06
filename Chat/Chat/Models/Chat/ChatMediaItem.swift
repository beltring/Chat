//
//  ImageMediaItem.swift
//  Chat
//
//  Created by User on 9/1/21.
//

import Foundation
import MessageKit

struct ChatMediaItem: MediaItem {
    var url: URL?
    var image: UIImage?
    var placeholderImage: UIImage
    var size: CGSize
    
    init(image: UIImage) {
        self.image = image
        self.size = CGSize(width: 250, height: 250)
        self.placeholderImage = UIImage()
    }
    
    init(url: URL) {
        self.url = url
        self.size = CGSize(width: 250, height: 250)
        self.placeholderImage = UIImage()
    }
}
