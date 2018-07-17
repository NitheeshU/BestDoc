//
//  BDSettingViewController.swift
//  BestDocUser
//
//  Created by nitheesh.u on 21/06/18.
//  Copyright © 2018 nitheesh.u. All rights reserved.
//

import UIKit

class BDSettingViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func sharewithUsAction(_ sender: UIButton) {
        "BestDoc".share()
    }
   
    @IBAction func helpCenterAction(_ sender: UIButton) {
        let vc = storyboard?.instantiateViewController(withIdentifier:"BDContactUsViewController")as! BDContactUsViewController
        
        navigationController?.show(vc, sender: self)
    }
    @IBAction func RateUsAction(_ sender: Any) {
        "BestDoc".share()
    }
    @IBAction func backAction(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    @IBAction func aboutUsAction(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "BDAboutUsViewController")as! BDAboutUsViewController
        self.navigationController?.show(vc, sender: self)
        
    }
    @IBAction func termsAction(_ sender: Any) {
        guard let url = URL(string: "https://bestdocapp.com/termsandconditions.php") else {
            return //be safe
        }
        
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
extension UIApplication {
    
    class var topViewController: UIViewController? {
        return getTopViewController()
    }
    
    private class func getTopViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return getTopViewController(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return getTopViewController(base: selected)
            }
        }
        if let presented = base?.presentedViewController {
            return getTopViewController(base: presented)
        }
        return base
    }
}

extension Equatable {
    func share() {
        let activity = UIActivityViewController(activityItems: [self], applicationActivities: nil)
        UIApplication.topViewController?.present(activity, animated: true, completion: nil)
    }
}
