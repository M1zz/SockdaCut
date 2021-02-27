//
//  ViewController.swift
//  SockdaCut
//
//  Created by 이현호 on 2021/02/27.
//

import UIKit
import Mantis

class ViewController: UIViewController {
    var image = UIImage(named: "sunflower.jpg")
    
    @IBOutlet weak var croppedImageView: UIImageView!
    var imagePicker: ImagePicker!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.imagePicker = ImagePicker(presentationController: self, delegate: self)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let nc = segue.destination as? UINavigationController,
           let vc = nc.viewControllers.first as? EmbeddedCropViewController {
            vc.image = image
            vc.didGetCroppedImage = {[weak self] image in
                self?.croppedImageView.image = image
                self?.dismiss(animated: true)
            }
        }
    }
    
    
    @IBAction func showImagePicker(_ sender: UIButton) {
        self.imagePicker.present(from: sender)
    }
    
    
    @IBAction func normalPresent(_ sender: Any) {
        guard let image = croppedImageView.image else {
            return
        }
        
        let config = Mantis.Config()
        let cropViewController = Mantis.cropViewController(image: image,
                                                           config: config)
        cropViewController.modalPresentationStyle = .fullScreen
        cropViewController.delegate = self
        present(cropViewController, animated: true)
    }
    
    
    @IBAction func alwayUserOnPresetRatioPresent(_ sender: Any) {
        guard let image = croppedImageView.image else {
            return
        }
        
        let config = Mantis.Config()
        
        let cropViewController = Mantis.cropViewController(image: image, config: config)
        cropViewController.modalPresentationStyle = .fullScreen
        cropViewController.delegate = self
        cropViewController.config.presetFixedRatioType = .alwaysUsingOnePresetFixedRatio(ratio: 9.0 / 9.0)
        present(cropViewController, animated: true)
    }
    
    
    @IBAction func downloadPNGImage(_ sender: Any) {
        let fileManager = FileManager.default
        let paths = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent("scan.jpg")

        let imageData = croppedImageView.image!.pngData()
        if let image = croppedImageView.image {
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
            fileManager.createFile(atPath: paths as String, contents: imageData, attributes: nil)
        }
    }
}


extension ViewController: CropViewControllerDelegate {
    
    func cropViewControllerDidCrop(_ cropViewController: CropViewController, cropped: UIImage, transformation: Transformation) {
        print(transformation);
        croppedImageView.image = cropped
        self.dismiss(animated: true)
    }
    
    
    func cropViewControllerDidCancel(_ cropViewController: CropViewController, original: UIImage) {
        self.dismiss(animated: true)
    }
}


extension ViewController: ImagePickerDelegate {
    
    func didSelect(image: UIImage?) {
        self.croppedImageView.image = image
    }
}
