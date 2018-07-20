//
//  ViewController.swift
//  WatsonImageRecognizer
//
//  Created by madi on 7/20/18.
//  Copyright © 2018 madi. All rights reserved.
//

import UIKit
import VisualRecognitionV3
import SVProgressHUD

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var classifyLabel: UILabel!
    
    let imagePicker = UIImagePickerController()
    var classification: [[String: Double]] = []
    
    let apiKey = ""
    let version = "2018-07-19"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
    }
    
    @IBAction func cameraTapped(_ sender: Any) {
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = false
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        SVProgressHUD.show()
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.image = image
            imagePicker.dismiss(animated: true, completion: nil)
            
            let visualRecognition = VisualRecognition(version: version, apiKey: apiKey)
            visualRecognition.classify(image: image) { (classifiedImages) in
                let classes = classifiedImages.images.first!.classifiers.first!.classes
                self.classification = []
                
                for index in 0..<classes.count {
                    let className = classes[index].className
                    let score = classes[index].score ?? 0.0
                    self.classification.append([className: score])
                }
                
                print(self.classification)
                
                var classifyText = ""
                for index in 0..<self.classification.count {
                    classifyText.append("\(self.classification[index])")
                }

                DispatchQueue.main.async {
                    self.classifyLabel.text = classifyText
                    SVProgressHUD.dismiss()
                }
            }
        } else {
            print("Error picking image")
        }
    }

}
