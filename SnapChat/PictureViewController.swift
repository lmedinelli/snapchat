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
        /*
        let imageURL = info[UIImagePickerControllerReferenceURL] as! NSURL
        let imageName = imageURL.lastPathComponent
        let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first! as String
        documentDirectory.path
        let localPath = documentDirectory.stringByAppendingPathComponent(imageName)!
        
        let image2 = info[UIImagePickerControllerOriginalImage] as! UIImage
        let data = UIImagePNGRepresentation(image2)
        data.writeToFile(localPath, atomically: true)
        
        let imageData = NSData(contentsOfFile: localPath)!
        //let photoURL = NSURL(fileURLWithPath: localPath)
        let imageWithData = UIImage(data: imageData)!
 */
        
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
        //let filePath: URL = imageView.
        
        
        // Create file metadata to update
        let newMetadata = FIRStorageMetadata()
        newMetadata.cacheControl = "public,max-age=300";
        newMetadata.contentType = "image/jpeg";
        
        imagesFolder.child("\(NSUUID().uuidString).jpg").put(imageData, metadata: newMetadata) { (metadata, error) in
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
    

    
    
}
