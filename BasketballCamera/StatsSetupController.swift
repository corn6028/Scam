//
//  StatsSetupController.swift
//  BasketballCamera
//
//  Created by 陳昱銘 on 2017/1/7.
//  Copyright © 2017年 Corn. All rights reserved.
//

import UIKit

class StatsSetupController: UIViewController {
    
    @IBOutlet weak var periodTime: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.hideKeyboardWhenTappedAround()
        
        let cameraview = cameraView(orientation: .portrait ,isBlur: true)
        view.addSubview(cameraview)
        view.sendSubview(toBack: cameraview)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func startRecoding(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "TutorialViewController") as! TutorialViewController
        self.present(controller, animated: true, completion: nil)
    }

}
