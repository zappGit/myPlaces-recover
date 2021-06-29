//
//  NewPlaceViewController.swift
//  myPlaces
//
//  Created by Артем Хребтов on 23.05.2021.
//

import UIKit

class NewPlaceViewController: UITableViewController {
    
    var curentCoctail: Coctail!
    
    var imageIsChanged = false
    
    @IBOutlet weak var coctailImage: UIImageView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var coctailName: UITextField!
    @IBOutlet weak var coctailType: UITextField!
    @IBOutlet weak var ingridients: UITextField!
    
    @IBOutlet weak var ratingControl: RatingControl!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 1))
       
        saveButton.isEnabled = false
        coctailName.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        setupEditScreen()
        
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let actionSheet = UIAlertController(title: nil,
                                                message: nil,
                                                preferredStyle: .actionSheet)
            let cameraIcon = #imageLiteral(resourceName: "camera")
            let photoIcon = #imageLiteral(resourceName: "photo")
            let camera = UIAlertAction(title: "Camera", style: .default) { _ in
                self.chooseImagePicker(source: .camera)
            }
            camera.setValue(cameraIcon, forKey: "image")
            camera.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")
            let photo = UIAlertAction(title: "Photo", style: .default) { [self] _ in
                chooseImagePicker(source: .photoLibrary)
            }
            photo.setValue(photoIcon, forKey: "image")
            photo.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")
            let cancel = UIAlertAction(title: "Cancel", style: .cancel)
            actionSheet.addAction(camera)
            actionSheet.addAction(photo)
            actionSheet.addAction(cancel)
            present(actionSheet, animated: true )
            
        } else {
            view.endEditing(true)
        }
    }
    
    //MARK: Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier != "showMap" { return }
        let mapVC = segue.destination as! MapViewController
        mapVC.coctail.name = coctailName.text!
        mapVC.coctail.ingridients = ingridients.text
        mapVC.coctail.type = coctailType.text
        mapVC.coctail.imageData = coctailImage.image?.pngData()
    }
    
    func saveCoctail() {
        
        
        let image = imageIsChanged ? coctailImage.image : #imageLiteral(resourceName: "imagePlaceholder")
        
     
        let imageData = image?.pngData()
        
        let newCoctail = Coctail(name: coctailName.text!,
                                 type: coctailType.text,
                                 ingridients: ingridients.text,
                                 imageData: imageData,
                                 rating: Double(ratingControl.rating))
        
        if curentCoctail != nil {
            try! realm.write {
                curentCoctail?.name = newCoctail.name
                curentCoctail?.type = newCoctail.type
                curentCoctail?.ingridients = newCoctail.ingridients
                curentCoctail?.imageData = newCoctail.imageData
                curentCoctail?.rating = newCoctail.rating
            }
            
        } else {
            StorageManager.saveObject(newCoctail)
        }
    }
    
    
    
    
    private func setupEditScreen() {
        if curentCoctail != nil {
            setupNavigationBar()
            imageIsChanged = true
            guard let data = curentCoctail?.imageData, let image = UIImage(data: data) else { return }
            coctailImage.image = image
            coctailImage.contentMode = .scaleAspectFill
            coctailName.text = curentCoctail?.name
            coctailType.text = curentCoctail?.type
            ingridients.text = curentCoctail?.ingridients
            ratingControl.rating = Int(curentCoctail.rating)
            
        }
    }
    private func setupNavigationBar() {
        if let topItem = navigationController?.navigationBar.topItem{
            topItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        }
        navigationItem.leftBarButtonItem = nil
        title = curentCoctail?.name
        saveButton.isEnabled = true
        
    }
    
    
    @IBAction func cancelAction(_ sender: Any) {
        dismiss(animated: true)
    }
}

// MARK: Text field delegate

extension NewPlaceViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    @objc private func textFieldChanged() {
        if coctailName.text?.isEmpty == false {
            saveButton.isEnabled = true
        } else {
            saveButton.isEnabled = false
        }
        
    }
}

//MARK: Work with image
extension NewPlaceViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func chooseImagePicker (source: UIImagePickerController.SourceType) {
        if UIImagePickerController.isSourceTypeAvailable(source) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            imagePicker.sourceType = source
            present(imagePicker, animated: true )
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        coctailImage.image = info[.editedImage] as? UIImage
        coctailImage.contentMode = .scaleAspectFill
        coctailImage.clipsToBounds = true
        imageIsChanged = true
        dismiss(animated: true)
    }
}



