//
//  TutorialViewController.swift
//  BasketballCamera
//
//  Created by 陳昱銘 on 2017/1/12.
//  Copyright © 2017年 Corn. All rights reserved.
//

import UIKit

class TutorialViewController: UIViewController {
    
    var imageArray: [String] = ["t1.png","t2.png","t3.png","t4.png","t5.png","t6.png"]
    var offset:Int = 1
    
    @IBOutlet weak var bgImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.hideKeyboardWhenTappedAround()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapped))
        tap.numberOfTapsRequired = 1
        view.addGestureRecognizer(tap)
        bgImage.image = UIImage(named: imageArray[0])
        bgImage.frame = CGRect(x: 0, y: 0, width: 735, height: 375)
    }
    
    func tapped() {
        // do something cool here
        if(offset >= 6){
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "GameViewController") as! GameViewController
            self.present(controller, animated: true, completion: nil)
        }else{

            bgImage.image = UIImage(named: imageArray[offset])
            offset += 1
        }
    }
    
    override var shouldAutorotate: Bool {
        return false
    }
    
    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        return .landscapeRight
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
