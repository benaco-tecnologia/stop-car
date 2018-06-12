//
//  ViewController.swift
//  StopNow
//
//  Created by Daniel Fuentes on 07-01-16.
//  Copyright (c) 2016 Cumsensu. All rights reserved.
//

import UIKit

class LoginController: UIViewController {
    @IBOutlet weak var txtUser: UITextField!
    @IBOutlet weak var txtPass: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        let defaults = NSUserDefaults.standardUserDefaults()
        if let persona_id = defaults.stringForKey("pid")
        {
            if (persona_id != "" && persona_id.characters.count < 5) {
                self.view.hidden = true
            }
        }
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "DismissKeyboard")
        view.addGestureRecognizer(tap)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        let defaults = NSUserDefaults.standardUserDefaults()
        if let persona_id = defaults.stringForKey("pid")
        {
            if (persona_id != "" && persona_id.characters.count < 5) {
                self.view.hidden = true
                self.performSegueWithIdentifier("goto_login_map", sender: self)
            }
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func DismissKeyboard(){
        view.endEditing(true)
    }
    @IBAction func btnLogin(sender: UIButton) {
        if (txtUser.text == "" || txtPass.text == "") {
            let alertController = UIAlertController(title: "Aviso", message: "Debe ingresar todos los datos!", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default,handler: nil))
            self.presentViewController(alertController, animated: true, completion: nil)
        } else {
            let defaults = NSUserDefaults.standardUserDefaults()
            //if let deviceToken = defaults.stringForKey("dt")
                var u = txtUser.text
                var p = txtPass.text
                var url : String = "http://soswapp.cl/stopcar/api/login.php?u="+u!+"&p="+p!
            
            
            let myURLString = url
            guard let myURL = NSURL(string: myURLString) else {
                print("Error: \(myURLString) doesn't seem to be a valid URL")
                return
            }
            
            do {
                let nData = try String(contentsOfURL: myURL)
                print("nData: " + (nData as String))
                if (nData as String != "0" && nData as String != "") {
                    defaults.setObject(nData as String, forKey: "pid")
                    self.performSegueWithIdentifier("goto_login_map", sender: self)
                    return
                }
            } catch let error as NSError {
                print("Error: \(error)")
            }
            
            
            
            /*
                let fileUrl = NSURL(string: url)
                var request = NSMutableURLRequest(URL: fileUrl!, cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData, timeoutInterval: 5)
                var response: NSURLResponse?
                var error: NSError?
                var resultado:String?
                var jsonString = ""
                request.HTTPBody = jsonString.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
                request.HTTPMethod = "POST"
                request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
                do {
                    let data = try NSURLConnection.sendSynchronousRequest(request, returningResponse: &response)
                    if let nData = NSString(data: data, encoding: NSUTF8StringEncoding) {
                        if let httpResponse = response as? NSHTTPURLResponse {
                            print("nData: " + (nData as String))
                            if (nData as String != "0" && nData as String != "") {
                                defaults.setObject(nData as String, forKey: "pid")
                                self.performSegueWithIdentifier("goto_login_map", sender: self)
                                return
                            }
                        }
                    }
                } catch var error1 as NSError {
                    error = error1
                }*/
                let alertController = UIAlertController(title: "Aviso", message: "Los datos ingresados no corresponden a ninguna cuenta registrada, intente nuevamente!", preferredStyle: UIAlertControllerStyle.Alert)
                alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default,handler: nil))
                self.presentViewController(alertController, animated: true, completion: nil)
            //}
        }
    }
}

