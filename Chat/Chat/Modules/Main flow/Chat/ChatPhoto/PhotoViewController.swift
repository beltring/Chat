//
//  PhotoViewController.swift
//  Chat
//
//  Created by User on 9/13/21.
//

import UIKit

class PhotoViewController: UIViewController {

    @IBOutlet private weak var messagePhoto: UIImageView!

    var photoImage: UIImage!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareUI()
    }
    
    // MARK: - Setup
    private func prepareUI() {
        messagePhoto.image = photoImage
    }

    // MARK: - Navigation
    @IBAction private func sharePhotoTapped(_ sender: UIButton) {
        let shareController = UIActivityViewController(activityItems: [photoImage!], applicationActivities: nil)
        
        present(shareController, animated: true, completion: nil)
    }
}
