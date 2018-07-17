//
//  BDWebviewViewController.swift
//  BestDocUser
//
//  Created by nitheesh.u on 07/06/18.
//  Copyright © 2018 nitheesh.u. All rights reserved.
//

import UIKit
import WebKit
class BDWebviewViewController: UIViewController,WKNavigationDelegate {
    
    var request:URLRequest?
    
    @IBOutlet weak var webView: UIWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
       // let url = URL(string:request)!
        webView.loadRequest(request!)
        
        // Do any additional setup after loading the view.
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
