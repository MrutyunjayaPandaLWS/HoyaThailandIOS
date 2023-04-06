//
//  HYT_DashboardVC.swift
//  Hoya Thailand
//
//  Created by syed on 14/02/23.
//

import UIKit
import AVFoundation
import Photos
import SDWebImage
import LanguageManager_iOS
import ImageSlideshow

class HYT_DashboardVC: BaseViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate & UINavigationControllerDelegate,LanguageDropDownDelegate {

    func didtappedLanguageBtn(item: HYT_LanguageDropDownVC) {
        localization()
        setUpMenuList()
        dashboardMenuTableView.reloadData()
        
    }
    
    
    @IBOutlet weak var offersSlideShow: ImageSlideshow!
    @IBOutlet weak var menuListView: UIView!
    
    @IBOutlet weak var offersDetailsLbl: UILabel!
    @IBOutlet weak var membershipId: UILabel!
    @IBOutlet weak var membershipIdTitleLbl: UILabel!
    @IBOutlet weak var roleLbl: UILabel!
    @IBOutlet weak var roleTitleLbl: UILabel!
    @IBOutlet weak var profileNameLbl: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var pointsLbl: UILabel!
    @IBOutlet weak var pointsTitleLbl: UILabel!
    @IBOutlet weak var topView: UIView!
//    @IBOutlet weak var menuTableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var dashboardMenuTableView: UITableView!
    
    let imagePicker = UIImagePickerController()
    var strdata1 = ""
    var menuList : [MenuListModel] = []
    var cellHeight = 0.0
    var VM = HYT_DashboardVM()
    var sourceArray = [AlamofireSource]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.VM.VC = self
        dashboardMenuTableView.delegate = self
        dashboardMenuTableView.dataSource = self
        topView.clipsToBounds = true
        topView.layer.cornerRadius = 24
        topView.layer.maskedCorners = [.layerMaxXMaxYCorner,.layerMinXMaxYCorner]
//        profileImage.image = UIImage(named: "Image-3")
        imagePicker.delegate = self
        tokendata()
        dashboardOffersApi()
        setUpMenuList()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setUpMenuList()
        tokendata()
        
    }
    

    @IBAction func didTappedLogoutBtn(_ sender: UIButton) {
        let domain = Bundle.main.bundleIdentifier!
        UserDefaults.standard.removePersistentDomain(forName: domain)
        UserDefaults.standard.synchronize()
        if #available(iOS 13.0, *){
            let sceneDelegate = self.view.window?.windowScene?.delegate as! SceneDelegate
            sceneDelegate.setInitialViewAsRootViewController()
        }else{
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.setInitialViewAsRootViewController()
        }
        
    }
    @IBAction func didTappedNotificationBtn(_ sender: UIButton) {
        
        let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(identifier: "HistoryNotificationsViewController") as? HistoryNotificationsViewController
        navigationController?.pushViewController(vc!, animated: true)
    }
    
    @IBAction func didTappedLanguageBtn(_ sender: UIButton) {
        let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "HYT_LanguageDropDownVC") as? HYT_LanguageDropDownVC
        vc!.modalPresentationStyle = .overFullScreen
        vc!.modalTransitionStyle = .crossDissolve
        vc?.delegate = self
        present(vc!, animated: true)
    }
    
    @IBAction func didTappedProfileEditBtn(_ sender: UIButton) {
        
        let alert = UIAlertController(title: "Choose any option", message: "", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default , handler:{ (UIAlertAction)in
            self.openCamera()
        }))
        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler:{ (UIAlertAction)in
            self.openGallery()
        }))
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler:{ (UIAlertAction)in
        }))
        self.present(alert, animated: true, completion: {
            print("completion block")
        })
    }
    
    func profileImageUpdateAPI(){
        let parameter : [String : Any] = [
            
                "ActorId": userId,
                "ObjCustomerJson": [
                    "DisplayImage": strdata1,
                    "LoyaltyId": loyaltyId
                ]
        ]
        self.VM.profileaImageUpdateApi(parameter: parameter)
        
    }
    
    func dashboardApi(){
        let parameter : [String : Any] = [
                "ActorId": userId
        ]
        self.VM.dashBoardApi(parameter: parameter)
    }
    
    
    func dashboardOffersApi(){
        let parameter : [String : Any] = [
            "ActionType": 99,
            "ActorId": userId,
            "PromotionUserType": "HOYA"
        ]
        self.VM.dashbaordOffers(parameter: parameter)
    }
    
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return menuList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HYT_DashboardMenuTVCell", for: indexPath) as! HYT_DashboardMenuTVCell
        if indexPath.row == 0{
            cell.lineView.isHidden = true
        }else{
            cell.lineView.isHidden = false
        }
        cell.menuItemNameLbl.text = menuList[indexPath.row].itemName
        cell.menuLogo.image = UIImage(named: menuList[indexPath.row].itemImage)
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        print(menuListView.bounds.size.height/Double(menuList.count),"row height")
        return (menuListView.bounds.size.height - 20.0)/Double(menuList.count)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch menuList[indexPath.row].id{
        case 1:
            let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "HYT_MyStaffVC") as? HYT_MyStaffVC
            self.navigationController?.pushViewController(vc!, animated: true)
        case 2:
            let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "HYT_PromotionListVC") as? HYT_PromotionListVC
            self.navigationController?.pushViewController(vc!, animated: true)
        case 3:
            let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "HYT_MyEarningsVC") as? HYT_MyEarningsVC
            self.navigationController?.pushViewController(vc!, animated: true)
        case 4:
            let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "HYT_VoucherVC") as? HYT_VoucherVC
            self.navigationController?.pushViewController(vc!, animated: true)
        case 5:
            let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "HYT_MyRedemptionVC") as? HYT_MyRedemptionVC
            self.navigationController?.pushViewController(vc!, animated: true)
        case 6:
            let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "HYT_PointsExpiryReportVC") as? HYT_PointsExpiryReportVC
            self.navigationController?.pushViewController(vc!, animated: true)
        case 7:
            let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "HYT_S_PromotionVC") as? HYT_S_PromotionVC
            self.navigationController?.pushViewController(vc!, animated: true)
        
        default:
            print("no screan is available")
        }
    }
    
    func ImageSetups(){
        self.sourceArray.removeAll()
        if self.VM.dashboardOffers.count > 0 {
            for image in self.VM.dashboardOffers {
                print("\(PROMO_IMG1)\(image.proImage ?? ""), offerImgUrl")
                let imageURL = image.proImage ?? ""
                let filteredURLArray = imageURL.dropFirst(3)
                let replaceString = "\(PROMO_IMG1)\(filteredURLArray)".replacingOccurrences(of: " ", with: "%20")
                self.sourceArray.append(AlamofireSource(urlString: "\(replaceString)", placeholder: UIImage(named: "ic_default_img (1)"))!)
            }
            offersSlideShow.setImageInputs(self.sourceArray)
            offersSlideShow.slideshowInterval = 3.0
            offersSlideShow.zoomEnabled = true
            offersSlideShow.contentScaleMode = .scaleToFill
            offersSlideShow.pageControl.currentPageIndicatorTintColor = primaryColor // UIColor(red: 230/255, green: 27/255, blue: 34/255, alpha: 1)
            offersSlideShow.pageControl.pageIndicatorTintColor = UIColor.lightGray
        }else{
            offersSlideShow.setImageInputs([
                ImageSource(image: UIImage(named: "ic_default_img (1)")!)
            ])
        }
    }
    
    
    
    @objc func didTap() {
        if self.VM.dashboardOffers.count > 0 {
//            offersSlideShow.presentFullScreenController(from: self)
            let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "HYT_OffersVC") as? HYT_OffersVC
            navigationController?.pushViewController(vc!, animated: true)
        }
    }
    
    func avFoundation(){
        if AVCaptureDevice.authorizationStatus(for: .video) ==  AVAuthorizationStatus.authorized {
            // Already Authorized
        } else {
            AVCaptureDevice.requestAccess(for: .video) { _ in
                
            }
        }
    }


}

extension HYT_DashboardVC{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let imagePicked = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            profileImage.image = imagePicked.resized(withPercentage: 0.5)
            profileImage.contentMode = .scaleToFill
            let imageData = imagePicked.resized(withPercentage: 0.1)
            let imageData1: NSData = imageData!.pngData()! as NSData
            self.strdata1 = imageData1.base64EncodedString(options: .lineLength64Characters)
            profileImageUpdateAPI()
        }
        dismiss(animated: true)
    }
    
    func openCamera(){
        DispatchQueue.main.async {
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                AVCaptureDevice.requestAccess(for: AVMediaType.video) { response in
                    if response {
                        if AVCaptureDevice.authorizationStatus(for: AVMediaType.video) ==  AVAuthorizationStatus.authorized {
                            DispatchQueue.main.async {
                                self.imagePicker.allowsEditing = false
                                self.imagePicker.sourceType = UIImagePickerController.SourceType.camera
                                self.imagePicker.mediaTypes = UIImagePickerController.availableMediaTypes(for: self.imagePicker.sourceType)!
                                self.imagePicker.sourceType = .camera
                                self.imagePicker.mediaTypes = ["public.image"]
                                self.present(self.imagePicker,animated: true,completion: nil)
                            }
                        }            } else {
                            DispatchQueue.main.async {
                                let alertVC = UIAlertController(title: "Need Camera Access", message: "Allow Camera Access", preferredStyle: .alert)
                                let okAction = UIAlertAction(title: "Allow", style: UIAlertAction.Style.default) {
                                    UIAlertAction in
                                    UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
                                }
                                let cancelAction = UIAlertAction(title: "DisAllow", style: UIAlertAction.Style.cancel) {
                                    UIAlertAction in
                                }
                                alertVC.addAction(okAction)
                                alertVC.addAction(cancelAction)
                                self.present(alertVC, animated: true, completion: nil)
                            }
                        }
                }} else {
                    self.noCamera()
                }
        }
    }
    
    func noCamera(){
        DispatchQueue.main.async {
            let alertVC = UIAlertController(title: "No Camera", message: "Sorry no device", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style:.default, handler: nil)
            alertVC.addAction(okAction)
            self.present(alertVC, animated: true, completion: nil)
        }
    }
    
    func openGallery() {
        DispatchQueue.main.async {
            PHPhotoLibrary.requestAuthorization({
                (newStatus) in
                if newStatus ==  PHAuthorizationStatus.authorized {
                    DispatchQueue.main.async {
                        self.imagePicker.allowsEditing = false
                        self.imagePicker.sourceType = .photoLibrary
//                        self.imagePicker.mediaTypes = ["public.image"]
                        self.present(self.imagePicker, animated: true, completion: nil)
                    }
                }else{
                    DispatchQueue.main.async {
                        let alertVC = UIAlertController(title: "Need Gallary access", message: "Allow Gallery Access", preferredStyle: .alert)
                        let okAction = UIAlertAction(title: "Allow", style: UIAlertAction.Style.default) {
                            UIAlertAction in
                            UIApplication.shared.open(URL.init(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
                        }
                        let cancelAction = UIAlertAction(title: "DisAllow", style: UIAlertAction.Style.cancel) {
                            UIAlertAction in
                        }
                        alertVC.addAction(okAction)
                        alertVC.addAction(cancelAction)
                        self.present(alertVC, animated: true, completion: nil)
                    }
                }
            })
        }
        
    }
    
    
    func tokendata(){
            if MyCommonFunctionalUtilities.isInternetCallTheApi() == false{
            }else{
                let parameters : Data = "username=\(username)&password=\(password)&grant_type=password".data(using: .utf8)!

            let url = URL(string: tokenURL)!
            let session = URLSession.shared
            var request = URLRequest(url: url)
            request.httpMethod = "POST"

            do {
                request.httpBody = parameters
            } catch let error {
                print(error.localizedDescription)
            }
            request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
           
            let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in

                guard error == nil else {
                    return
                }
                guard let data = data else {
                    return
                }
                do{
                    let parseddata = try JSONDecoder().decode(TokenModels.self, from: data)
                        print(parseddata.access_token ?? "")
                        UserDefaults.standard.setValue(parseddata.access_token ?? "", forKey: "TOKEN")
                    DispatchQueue.main.async {
                        self.dashboardApi()
                        
                    }
                     }catch let parsingError {
                    print("Error", parsingError)
                }
            })
            task.resume()
        }
        }
    
    private func localization(){
        pointsTitleLbl.text = "points".localiz()
        membershipIdTitleLbl.text = "membershipId".localiz()
        roleTitleLbl.text = "role".localiz()
        offersDetailsLbl.text = "offerDetails".localiz()
    }
    
    func setUpMenuList(){
        if customerTypeID != 54{
            menuList = [
                MenuListModel(itemName: "scan_upload_invoice".localiz(), itemImage: "Group 8101", id: 2),
                MenuListModel(itemName: "myEarning".localiz(), itemImage: "Group 8095", id: 3),
                MenuListModel(itemName: "redeem_Voucher".localiz(), itemImage: "Group 8099", id: 4),
                MenuListModel(itemName: "myredeemption".localiz(), itemImage: "Group 8093", id: 5),
                MenuListModel(itemName: "pointExpireReport".localiz(), itemImage: "Group 8196", id: 6)
            ]
        }else{
            menuList = [
                MenuListModel(itemName: "mystaff".localiz(), itemImage: "Group 8102", id: 1),
                MenuListModel(itemName: "redeem_Voucher".localiz(), itemImage: "Group 8099", id: 4),
                MenuListModel(itemName: "myredeemption".localiz(), itemImage: "Group 8093", id: 5),
                MenuListModel(itemName: "My_Promotions".localiz(), itemImage: "Group 8098", id: 7),
                MenuListModel(itemName: "myEarning".localiz(), itemImage: "Group 8095", id: 3),
                MenuListModel(itemName: "pointExpireReport".localiz(), itemImage: "Group 8196", id: 6)
            ]
        }
    }
    
}


struct MenuListModel{
    let itemName : String
    let itemImage : String
    let id : Int
}
