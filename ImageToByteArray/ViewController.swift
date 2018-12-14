//
//  ViewController.swift
//  ImageToByteArray
//
//  Created by Marcelo Sampaio on 14/12/18.
//  Copyright © 2018 Marcelo Sampaio. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    // MARK: - Properties
    private var imagePicker: UIImagePickerController!
    
    // Enums
    enum ImageSource {
        case photoLibrary
        case camera
    }
    
    // MARK: - Outlets
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var convertImageButton: UIBarButtonItem!
    
    
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        convertImageButton.isEnabled = false
        
    }
    
    // MARK: - UI Action
    @IBAction func takePicture(_ sender: Any) {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            selectImageFrom(.photoLibrary)
            return
        }
        selectImageFrom(.camera)
    }
    
    @IBAction func converImageToByteArray(_ sender: Any) {
        print("✅ conver to byte array action")
        _ = convertImage(imageView.image!)

    }
    
    
    
    // MARK: - Image Converter
    private func convertImage(_ image: UIImage) -> NSMutableArray {
        
        let imageData = image.pngData()
        let count = imageData!.count / MemoryLayout<UInt8>.size
        // create array of appropriate length:
        var bytes = [UInt8](repeating: 0, count: count)
        // copy bytes into array
        (imageData! as NSData).getBytes(&bytes, length:count)
        
        let byteArray : NSMutableArray = NSMutableArray()

        for i in stride(from: 0, to: count, by: 1) {
            
            print("🚥 byte: \(NSNumber(value: bytes[i]))")
            byteArray.add(NSNumber(value: bytes[i]))
            
            
        }
        
        return byteArray
        
        
    }
    
    
    
    // MARK: - Capture Image Helper
    func selectImageFrom(_ source: ImageSource){
        imagePicker =  UIImagePickerController()
        imagePicker.delegate = self
        switch source {
        case .camera:
            imagePicker.sourceType = .camera
        case .photoLibrary:
            imagePicker.sourceType = .photoLibrary
        }
        present(imagePicker, animated: true, completion: nil)
    }
    
    
   
    
    // MARK: - Image Picker Delegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        imagePicker.dismiss(animated: true, completion: nil)
        guard let selectedImage = info[.originalImage] as? UIImage else {
            print("❌ Image not found!")
            return
        }
        self.imageView.image = selectedImage
        convertImageButton.isEnabled = true
    }
    
    
    
}

