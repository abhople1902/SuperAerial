//
//  ViewController.swift
//  SuperAerial
//
//  Created by Ayush Bhople on 08/12/23.
//

import UIKit
import CoreML
import Vision

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let imagePicker = UIImagePickerController()

    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let userPickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            guard let convertedCIImage = CIImage(image: userPickedImage) else {
                fatalError("cannot convert to CIImage.")
            }
            detect(image: convertedCIImage)
            imageView.image = userPickedImage
        }
        
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    func detect(image: CIImage){
        guard let model = try? VNCoreMLModel(for: mlaic().model) else {
            fatalError("Cannot import model")
        }
        let request = VNCoreMLRequest(model: model) { (request, error) in
            let classification = request.results?.first as? VNClassificationObservation
            
            self.navigationItem.title = classification?.identifier
        }
        
        let handler = VNImageRequestHandler(ciImage: image)
        do {
            try handler.perform([request])
        }
        catch {
            print(error)
        }
        
        
    }
    
    
    @IBAction func cameraTapped(_ sender: UIBarButtonItem) {
        present(imagePicker, animated: true, completion: nil)
    }
    
}

