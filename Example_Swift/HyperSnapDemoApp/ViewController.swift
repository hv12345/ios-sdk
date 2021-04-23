//
//  ViewController.swift
//  HyperSecureDocsParentApp
//
//  Created by Srinija on 27/02/18.
//  Copyright © 2018 hyperverge. All rights reserved.
//


import UIKit
import HyperSnapSDK
import CoreLocation

//Landing Screen of the sample app. You can find implementation steps for face capture, liveness check and document capture here. For OCR Call and Face Match methods, please refer to 'ResultsViewController.swift'
class ViewController: UIViewController {
    @IBOutlet weak var startCaptureButton: UIButton!
    
    @IBOutlet weak var onlyDocCaptureLabel: UILabel!
    @IBOutlet weak var onlyFaceCaptureButton: UIButton!
    
    @IBOutlet weak var livenessButton: UIButton!
    
    @IBOutlet weak var faceMatchButton: UIButton!
    
    @IBOutlet weak var livenessFaceMatchOCRButton: UIButton!
    
    @IBOutlet weak var onlyDocCaptureButton: UIButton!
    
    @IBOutlet weak var docCaptureAndOCRButton: UIButton!
    
    @IBOutlet weak var changeDocumentButton: UIButton!
    
    @IBOutlet weak var documentLabel: UILabel!
    
    
    var shouldMakeOCRCall = false
    var shouldMakeFaceMatchCall = false
    var shouldMakeLivenessCall = false
    var faceCapture = true
    
    
    var livenessResult : [String:AnyObject]? = nil
    var faceMatchResult : [String:AnyObject]? = nil
    var ocrResult : [String:AnyObject]? = nil
    
    var livenessError : HVError? = nil
    var faceMatchError : HVError? = nil
    var ocrError : HVError? = nil
    
    var livenessHeader : [String:String]? = nil
    var faceMatchHeader : [String:String]? = nil
    var ocrHeader : [String:String]? = nil
    
    var faceImageUri : String?
    var docImageUri : String?
    
    let locationManager: CLLocationManager = CLLocationManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        documentLabel.text = "OCR - \(Global.shared.currentDocument.getNameString())"
        
        let oldTag = UserDefaults.standard.integer(forKey: "captureConfigTag")
        setUpConfig(tag: oldTag)
//        onlyDocCaptureLabel.text = NSLocalizedString("sample", comment: "")

    }
    
    override func viewDidAppear(_ animated: Bool) {
        //SDK initialisation is required before calling any SDK method. Please check AppDeletegate.swift for the implementation
        if(Global.shared.appID == nil || Global.shared.appKey == nil || Global.shared.region == nil){
            let alert = UIAlertController.init(title: "Initialise SDK", message: "Please set SDK credentials in 'Global.swift'", preferredStyle: .alert)
            self.present(alert, animated: true, completion: nil)
        }
    
//        onlyDocCaptureButton.setTitle(NSLocalizedString("text", comment: ""), for: .normal)
    }
    
    //MARK: Implementation for Face capture by HyperSnapSDK
    func startFaceCapture(_ callingVC: UIViewController) {
        
        let hvFaceConfig = HVFaceConfig()
        
        if shouldMakeLivenessCall {
            hvFaceConfig.setLivenessMode(HyperSnapParams.LivenessMode.textureLiveness)
        }else{
            hvFaceConfig.setLivenessMode(HyperSnapParams.LivenessMode.none)
        }
        
        hvFaceConfig.setShouldReturnFullImageUri(true)

        let completionHandler:(_ error:HVError?,_ response:HVResponse?, _ viewController:UIViewController)->Void = {error, response, vcNew in
                if self.shouldMakeLivenessCall {
                    self.livenessResult = response?.apiResult
                    self.livenessHeader = response?.apiHeaders
                    self.livenessError = error
                }
                
            if let response = response, let imageUri = response.imageUri {
                    self.faceImageUri = imageUri
                }
                if self.shouldMakeFaceMatchCall {
                    self.startDocumentCapture(self)
                }else {
                    self.showResultsPage(self)
                }
                
        }
        HVFaceViewController.start(self, hvFaceConfig: hvFaceConfig, completionHandler: completionHandler)
    }
    
    
    //MARK: Implementation for Document capture by HyperSnapSDK
    func startDocumentCapture(_ presentingVC : UIViewController){
        
        
        let hvDocConfig = HVDocConfig()
        hvDocConfig.setDocumentType(Global.shared.currentDocument.getDocumentType())
        if Global.shared.currentDocument.getDocumentType() == .other{
            hvDocConfig.setAspectRatio(Global.shared.currentDocument.getAspectRatio())
        }
        let endpoint = "https://vnm-docs.hyperverge.co/v2/nationalID"
        hvDocConfig.setOCRAPIDetails(endpoint, documentSide:HVDocConfig.DocumentSide.front, params: nil, headers: nil)

        let completionHandler:(_ error:HVError?,_ response:HVResponse?,_ viewController:UIViewController)->Void = {error, response, vcNew in

            if(error != nil){/*Handle error*/
                //Error Code: error.errorCode, Error Message: error.errorMessage
              }
            if let response = response{
                
                self.docImageUri = response.imageUri //This is the document image stored in app memory
            
             }
        }

        HVDocsViewController.start(self, hvDocConfig: hvDocConfig, completionHandler: completionHandler)
    }
    
    
    @IBAction func startCapture(_ sender: UIButton){
        faceCapture ? startFaceCapture(self) : startDocumentCapture(self)
    }
    
    @IBAction func captureConfigSelected(_ sender: UIButton) {
        setUpConfig(tag: sender.tag)
    }
    
    func setUpConfig(tag:Int){
        onlyFaceCaptureButton.setImage(UIImage(named: "tick_off"), for: .normal)
        livenessButton.setImage(UIImage(named: "tick_off"), for: .normal)
        faceMatchButton.setImage(UIImage(named: "tick_off"), for: .normal)
        onlyDocCaptureButton.setImage(UIImage(named: "tick_off"), for: .normal)
        docCaptureAndOCRButton.setImage(UIImage(named: "tick_off"), for: .normal)
        livenessFaceMatchOCRButton.setImage(UIImage(named: "tick_off"), for: .normal)
        
        
        if tag == 0 { //Only Face Capture
            shouldMakeLivenessCall = false
            shouldMakeFaceMatchCall = false
            shouldMakeOCRCall = false
            faceCapture = true
            onlyFaceCaptureButton.setImage(UIImage(named: "tick_on"), for: .normal)
        }
        if tag == 1 {//Only Document Capture
            shouldMakeOCRCall = false
            shouldMakeLivenessCall = false
            shouldMakeFaceMatchCall = false
            faceCapture = false
            onlyDocCaptureButton.setImage(UIImage(named: "tick_on"), for: .normal)
        }
        
        if tag == 2 { //Liveness
            shouldMakeLivenessCall = true
            shouldMakeFaceMatchCall = false
            shouldMakeOCRCall = false
            faceCapture = true
            livenessButton.setImage(UIImage(named: "tick_on"), for: .normal)
        }
        
        if tag ==  3{//Face Match
            shouldMakeLivenessCall = false
            shouldMakeFaceMatchCall = true
            shouldMakeOCRCall = false
            faceCapture = true
            faceMatchButton.setImage(UIImage(named: "tick_on"), for: .normal)
        }
        
        if tag == 4 { //OCR
            shouldMakeOCRCall = true
            shouldMakeLivenessCall = false
            shouldMakeFaceMatchCall = false
            faceCapture = false
            docCaptureAndOCRButton.setImage(UIImage(named: "tick_on"), for: .normal)
        }
        
        
        if tag == 5 { //Liveness, FaceMatch and OCR
            shouldMakeLivenessCall = true
            shouldMakeFaceMatchCall = true
            shouldMakeOCRCall = true
            faceCapture = true
            livenessFaceMatchOCRButton.setImage(UIImage(named: "tick_on"), for: .normal)
        }
        
        UserDefaults.standard.set(tag, forKey: "captureConfigTag")
        
    }
    
    
    func showResultsPage(_ presentingVC : UIViewController){
        guard let resultsVC = self.storyboard?.instantiateViewController(withIdentifier: "ResultsViewController") as? ResultsViewController else {
            return
        }
        resultsVC.shouldMakeOCRCall = shouldMakeOCRCall
        resultsVC.shouldMakeFaceMatchCall = shouldMakeFaceMatchCall
        
        resultsVC.docImageUri = docImageUri
        resultsVC.faceImageUri = faceImageUri
        
        resultsVC.livenessResult = livenessResult
        resultsVC.livenessHeader = livenessHeader
        resultsVC.livenessError = livenessError
        
        presentingVC.present(resultsVC, animated: true, completion: nil)
        
    }
    
}
