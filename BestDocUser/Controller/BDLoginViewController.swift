//
//  BDLoginViewController.swift
//  BestDocUser
//
//  Created by nitheesh.u on 04/05/18.
//  Copyright © 2018 nitheesh.u. All rights reserved.
//

import UIKit

class BDLoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func backAction(_ sender: UIButton) {
       navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
        //                    let vc = self.storyboard?.instantiateViewController(withIdentifier:"BDBookingSloteViewController" )as! BDBookingSloteViewController
        /// self.navigationController?.show(vc, sender: self)

       
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
