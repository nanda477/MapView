//
//  ManualAddress.swift
//  MapView
//
//  Created by Ramanan D2V on 2/8/19.
//  Copyright © 2019 D2V Software Solutions pvt ltd. All rights reserved.
//

import UIKit

protocol manualAddressDelegate {
    
    func manualAddressReturn(data: String)// what ever you want u can pass here to viewcontroller
}

class ManualAddress: UIViewController {
    
    var mDelegate: manualAddressDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Enter your Address"
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "X", style: .done, target: self, action: #selector(closeVC))

        // Do any additional setup after loading the view.
    }
    
    @objc func closeVC() {
        self.mDelegate?.manualAddressReturn(data: "M")
        self.dismiss(animated: true, completion: nil)
    }
    

}
