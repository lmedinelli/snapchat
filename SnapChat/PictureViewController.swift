//
//  PictureViewController.swift
//  SnapChat
//
//  Created by Luis Medinelli on 3/6/17.
//  Copyright © 2017 iBeacon Solutions. All rights reserved.
//

import UIKit
import FirebaseStorage
import AVFoundation
import ImageIO

class PictureViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var nextButton: UIButton!
    
    let imageViewThumbnail = UIImage()
    
    var imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        imagePicker.delegate=self
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage

        //picker.dismissViewControllerAnimated(true, completion: nil)
        
        imageView.image = image
        
        imageView.backgroundColor = UIColor.clear
        
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cameraTapped(_ sender: Any) {
        imagePicker.sourceType = .savedPhotosAlbum
        imagePicker.allowsEditing = false
        present(imagePicker, animated: true, completion: nil)
        
    }

    @IBAction func nextTapped(_ sender: Any) {
        
        nextButton.setTitle("Uploading ...", for: .normal)
        nextButton.isEnabled = false
        // addUpdateButton.setTitle("Update", for: .normal)
        
        let imagesFolder = FIRStorage.storage().reference().child("images")
        
        //let imageData = UIImagePNGRepresentation(imageView.image!)!
        //let size = (imageView.image?.size)!.applying(CGAffineTransform(scaleX: 0.5, y: 0.5))
        //let imageData = imageWithImage(image: imageView.image!, scaledToSize: size)
        

        let imageData = UIImageJPEGRepresentation(imageView.image!, 0.1)!
        //thumbnail
        
        let thumbImage = self.resizeImage(image: imageView.image!, targetSize: CGSize(width: 200.0, height: 200.0))
        
        
        // Create file metadata to update
        let newMetadata = FIRStorageMetadata()
        newMetadata.cacheControl = "public,max-age=300";
        newMetadata.contentType = "image/jpeg";
        newMetadata.customMetadata = ["Thumbnail": "false"]
        
        let idImageBase = NSUUID().uuidString // base for both, normal and thumbnail
        
        // load normal image
        imagesFolder.child("\(idImageBase).jpg").put(imageData, metadata: newMetadata) { (metadata, error) in
            print("Trying to upload")
            if error != nil{
                print("Have an error:\(error)")
            }else{
                print(metadata!.downloadURL()!)
                //self.performSegue(withIdentifier: "selectUserSegue", sender: nil)
            }
        }
        newMetadata.customMetadata = ["Thumbnail": "true"]

        // load thumb image
        imagesFolder.child("\(idImageBase)_thumb.jpg").put(UIImageJPEGRepresentation(thumbImage, 1)!, metadata: newMetadata) { (metadata, error) in
            print("Trying to upload")
            if error != nil{
                print("Have an error:\(error)")
            }else{
                print(metadata!.downloadURL()!)
                self.performSegue(withIdentifier: "selectUserSegue", sender: nil)
            }
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        nextButton.setTitle("Next", for: .normal)
        nextButton.isEnabled = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    
    
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio  = targetSize.width  / image.size.width
        let heightRatio = targetSize.height / image.size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio, height: size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        //let rect = CGRect(0, 0, newSize.width, newSize.height)
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    

    
    
}
