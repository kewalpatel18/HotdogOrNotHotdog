//
//  ViewController.swift
//  HotdogOrNotHotdog
//
//  Created by Kewal Patel on 12/1/21.
//

import UIKit
import CoreML
import Vision


class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    // Delegation design pattern -> Text field: Properties
    
    // Steps to implement a delegate:
    // 1. Create an object
    
    let imagePicker = UIImagePickerController()
    var results : [VNClassificationObservation] = []
        
    
// Type Annotation //[0.8, 0.4, 0.3] -> 0.8 -> Hotdog
    
    // 3. Implement its functions
    
    
    
    
    @IBOutlet weak var imageView: UIImageView!
    
    
    @IBAction func cameraPressed(_ sender: UIBarButtonItem) {
        
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = false
        
        present(imagePicker, animated: true, completion: nil)

        
        
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        imagePicker.delegate = self
        // 2. Initialize the delegate in View Did load
        // Do any additional setup after loading the view
        
    }

    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            // 2. Convert this image from UIImage data type into CIImage
            // 3. Detect (CIImage)
    
        // 1. Select the image
        if let image = info[.originalImage] as? UIImage {
                        
            //Display the selected image on the screen
            imageView.image = image
                        
            //Dismiss imagePicker after capturing the image
            imagePicker.dismiss(animated : true , completion : nil)
                        
            // 2. Convert this image from UIImage data type into CIImage
                        
            guard let ciImage = CIImage(image : image) else {return}
                        
            // 3. Detect (CIImage)
                        
            detect(image : ciImage)
            
        }
    }
        
        
        // Detect function:
        // 1. Model
        // 2. Request
        // 3. Result
        // 4. Handler
        
        func detect(image: CIImage) {
            //initialize model
            
            if let model = try? VNCoreMLModel(for : Inceptionv3().model){
                
                //Request the result
                
                let request = VNCoreMLRequest(model: model, completionHandler: { (request, error) in
                    
                    // Results -> (0.8, 0.7 0.3) -> 0.8: Hot Dog
                    
                    guard let results = request.results as? [VNClassificationObservation], let topResult = results.first   else {return}
                                    
                                    
                    if topResult.identifier.contains("hotdog") {
                                        //Main Thread   -   | | | |  | | |
                        DispatchQueue.main.async {
                            self.navigationItem.title = "Hotdog"
                                            
                                        }
                                    }
                                    
                    else {
                                        
                                        
                        DispatchQueue.main.async {
                            self.navigationItem.title = " Not Hotdog"
                                            
                                        }
                                    }
                })
                    //Handler
                
                    let handler = VNImageRequestHandler(ciImage : image)
                    do {
                        try handler.perform([request])
                    }
                                
                    catch {
                                    
                            print(error)
                    }
                
                
            }
        }
}
