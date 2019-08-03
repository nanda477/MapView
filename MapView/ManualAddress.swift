//
//  ManualAddress.swift
//  MapView
//
//  Created by Ramanan D2V on 2/8/19.
//  Copyright © 2019 D2V Software Solutions pvt ltd. All rights reserved.
//

import UIKit

protocol manualAddressDelegate {
    
    func manualAddressReturn(data: String, name: String, street: String, city: String, state: String, pincode: String)// what ever you want u can pass here to viewcontroller
}

class ManualAddress: UIViewController {
    
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var stTF: UITextField!
    @IBOutlet weak var cityTF: UITextField!
    @IBOutlet weak var stateTF: UITextField!
    @IBOutlet weak var pincodeTF: UITextField!
    
    
    var mDelegate: manualAddressDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Enter your Address"
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "X", style: .done, target: self, action: #selector(closeVC))

        // Do any additional setup after loading the view.
    }
    
    
    @objc func closeVC() {
        loadData()
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func submitAction(_ sender: Any) {
        loadData()
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func loadData() {
        self.mDelegate?.manualAddressReturn(data: "M", name: nameTF.text!, street: stTF.text!, city: cityTF.text!, state: stateTF.text!, pincode: pincodeTF.text!)
    }
    

}
