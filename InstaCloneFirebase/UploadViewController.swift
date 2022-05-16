//
//  UploadViewController.swift
//  InstaCloneFirebase
//
//  Created by Hüseyin Kaya on 16.05.2022.
//

import UIKit
import Firebase

class UploadViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var commentText: UITextField!
    
    @IBOutlet weak var uploadButton: UIButton! //Görsel konmayana kadar aktif olmasın kodu eklemek istersem outlet olarak da gerekli.
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imageView.isUserInteractionEnabled = true //tıklanabilir
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(chooseImage))
        imageView.addGestureRecognizer(gestureRecognizer)
    }
    
    @objc func chooseImage () {
        
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = .photoLibrary
        present(pickerController, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imageView.image = info [.originalImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
    }
    
    func makeAlert(titleInput: String, messageInput: String) {
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }
    
    
    @IBAction func actionButtonClicked(_ sender: Any) {
 
    
    let storage = Storage.storage() //Auth'daki gibi storage'de de böyle oluyor. sınıftan objesini oluşturuyoruz.
    let storageReference = storage.reference()
    
        let mediaFolder = storageReference.child("media") //manuel olarak mediayı oluşturmayıp kodda böyle yazsaydık bizim yerimize de oluştururdu.
        
        if let data = imageView.image?.jpegData(compressionQuality: 0.5) {
            
            
            let uuid = UUID().uuidString //stringe çevirdik id'yi
            
            let imageReference = mediaFolder.child("\(uuid).jpg") // bunu uuid ile yapıyoruz çünkü her yüklenen resmin ID'si farklı olması gerekiyor.
            imageReference.putData(data, metadata: nil) { metadata, error in
                if error != nil {
                    self.makeAlert(titleInput: "Error", messageInput: error?.localizedDescription ?? "Error")
                } else {
                    
                    imageReference.downloadURL { url, error in
                        
                        if error == nil {
                            let imageUrl = url?.absoluteString //url'yi stringe çevir

                            //DATABASE
                            
                            let firestoreDatabase = Firestore.firestore() // storage.storage Auth.auth() gibi
                            
                            var firestoreReferance : DocumentReference? = nil
                            
                            let firestorePost = ["imageUrl" : imageUrl!, "postedBy" : Auth.auth().currentUser!.email!, "postComment" : self.commentText.text!, "date" : FieldValue.serverTimestamp(), "likes" : 0 ] as [String : Any] //Hepsi string olsa bile böyle yapmak zorundayım çünkü aşşağıda öyle istiyor
                            
                            firestoreReferance = firestoreDatabase.collection("Posts").addDocument(data: firestorePost, completion: { error in
                                if error != nil {
                                    
                                    self.makeAlert(titleInput: "Error", messageInput: error?.localizedDescription ?? "Error")
                                } else {
                                    
                                    self.imageView.image = UIImage(named: "addImage.png")
                                    self.commentText.text = ""
                                    self.tabBarController?.selectedIndex = 0 // 0 dersek feed 1 dersek upload 2 dersek settings
                                    
                                }
                            })
                            
                        }
                        
                    }
                    
                }
            }
            
        }
    
    
    }
  
}
