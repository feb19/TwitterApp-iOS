//
//  ViewController.swift
//  TwitterApp
//
//  Created by TakahashiNobuhiro on 2018/06/18.
//  Copyright © 2018 feb19. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // シンプルにツイートしたい時に使う
//        openTwitterComposer()
        
        loginCheck()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func openTwitterComposer() {
        let composer = TWTRComposer()
        composer.setText("test tweeeeeet")
        composer.show(from: self) { result in
            // Tweet finished.
        }
    }
    
    @IBAction func loginButtonWasTapped(_ sender: Any) {
        login()
    }
    
    func login() {
        Twitter.sharedInstance().logIn { session, error in
            guard let session = session else {
                if let error = error {
                    print("エラーが起きました => \(error.localizedDescription)")
                }
                return
            }
            print("logined: @\(session.userName)")
            self.loggedIn()
        }
    }
    
    func loggedIn() {
        let nex : AnyObject! = self.storyboard!.instantiateViewController(withIdentifier: "TimerlineNavigationController")
        self.present(nex as! UIViewController, animated: true, completion: nil)
    }
    
    func loginCheck() {
        if let session = Twitter.sharedInstance().sessionStore.session() {
            print(session.userID)
            self.loggedIn()
        } else {
            print("アカウントはありません")
        }
    }
    
}

