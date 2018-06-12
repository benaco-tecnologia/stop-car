//
//  ViewController.swift
//  StopNow
//
//  Created by Daniel Fuentes on 07-01-16.
//  Copyright (c) 2016 Cumsensu. All rights reserved.
//

import UIKit

class ApagarController: UIViewController {
    @IBOutlet weak var btnAccion: UIButton!
    @IBOutlet weak var txtPin: UITextField!
    @IBOutlet weak var lblPin: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let defaults = NSUserDefaults.standardUserDefaults()
        if let det = defaults.stringForKey("det") {
            if det=="1" {
                btnAccion.setTitle("Reactivar Vehículo", forState: UIControlState.Normal)
                lblPin.text="Ingrese su PIN para reactivar el vehículo."
            }else{
                btnAccion.setTitle("Detener Vehículo", forState: UIControlState.Normal)
                lblPin.text="Ingrese su PIN para detener el vehículo."
            }
        }else{
            btnAccion.setTitle("Detener Vehículo", forState: UIControlState.Normal)
            lblPin.text="Ingrese su PIN para detener el vehículo."
        }
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "DismissKeyboard")
        view.addGestureRecognizer(tap)
    }
    
    func DismissKeyboard(){
        view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func apagarMotor(sender: UIButton) {
        let defaults = NSUserDefaults.standardUserDefaults()
        if let det = defaults.stringForKey("det") {
            if det=="1" {
                let alertController = UIAlertController(title: "StopCar", message: "¿Realmente desea reactivar su vehículo?", preferredStyle: UIAlertControllerStyle.Alert)
                alertController.addAction(UIAlertAction(title: "Aceptar", style: UIAlertActionStyle.Default, handler: reactivar))
                alertController.addAction(UIAlertAction(title: "Cancelar", style: UIAlertActionStyle.Cancel, handler: nil))
                self.presentViewController(alertController, animated: true, completion: nil)
            }else{
                let alertController = UIAlertController(title: "StopCar", message: "¿Realmente desea detener su vehículo?", preferredStyle: UIAlertControllerStyle.Alert)
                alertController.addAction(UIAlertAction(title: "Aceptar", style: UIAlertActionStyle.Default, handler: detener))
                alertController.addAction(UIAlertAction(title: "Cancelar", style: UIAlertActionStyle.Cancel, handler: nil))
                self.presentViewController(alertController, animated: true, completion: nil)
            }
        }else{
            let alertController = UIAlertController(title: "StopCar", message: "¿Realmente desea detener su vehículo?", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Aceptar", style: UIAlertActionStyle.Default, handler: detener))
            alertController.addAction(UIAlertAction(title: "Cancelar", style: UIAlertActionStyle.Cancel, handler: nil))
            self.presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
    func redireccionar(actionTarget: UIAlertAction){
        self.performSegueWithIdentifier("goto_map", sender: self)
    }
    
    func detener(actionTarget: UIAlertAction){
        let defaults = NSUserDefaults.standardUserDefaults()
        if let persona_id = defaults.stringForKey("pid") {
            let url : String = "http://http://soswapp.cl/stopcar/api/stop-car.php?uid="+persona_id+"&p="+txtPin.text!
            let myURLString = url
            guard let myURL = NSURL(string: myURLString) else {
                print("Error: \(myURLString) doesn't seem to be a valid URL")
                return
            }
            do {
                let nData = try String(contentsOfURL: myURL)
                if((nData as String)=="0"){
                    //Exito
                    defaults.setObject("1", forKey: "det")
                    let alertController = UIAlertController(title: "StopCar", message: "Su vehículo se detendrá en unos instantes, en el mapa se le mostrará su última ubicación.", preferredStyle: UIAlertControllerStyle.Alert)
                    alertController.addAction(UIAlertAction(title: "Aceptar", style: UIAlertActionStyle.Default, handler: redireccionar))
                    self.presentViewController(alertController, animated: true, completion: nil)
                }else{
                    //Error
                    defaults.setObject("0", forKey: "det")
                    let alertController = UIAlertController(title: "StopCar", message: "Ocurrió un error al intentar detener el vehículo, intente nuevamente", preferredStyle: UIAlertControllerStyle.Alert)
                    alertController.addAction(UIAlertAction(title: "Aceptar", style: UIAlertActionStyle.Default, handler: nil))
                    self.presentViewController(alertController, animated: true, completion: nil)
                }
            } catch let error as NSError {
                print("Error: \(error)")
            }
            
            
            /*
            let fileUrl = NSURL(string: url)
            let request = NSMutableURLRequest(URL: fileUrl!, cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData, timeoutInterval: 5)
            var response: NSURLResponse?
            var error: NSError?
            var resultado:String?
            let jsonString = ""
            request.HTTPBody = jsonString.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
            request.HTTPMethod = "POST"
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            do {
                let data = try NSURLConnection.sendSynchronousRequest(request, returningResponse: &response)
                if let nData = NSString(data: data, encoding: NSUTF8StringEncoding) {
                    if let httpResponse = response as? NSHTTPURLResponse {
                        if((nData as String)=="0"){
                            //Exito
                            defaults.setObject("1", forKey: "det")
                            let alertController = UIAlertController(title: "StopCar", message: "Su vehículo se detendrá en unos instantes, en el mapa se le mostrará su última ubicación.", preferredStyle: UIAlertControllerStyle.Alert)
                            alertController.addAction(UIAlertAction(title: "Aceptar", style: UIAlertActionStyle.Default, handler: redireccionar))
                            self.presentViewController(alertController, animated: true, completion: nil)
                        }else{
                            //Error
                            defaults.setObject("0", forKey: "det")
                            let alertController = UIAlertController(title: "StopCar", message: "Ocurrió un error al intentar detener el vehículo, intente nuevamente", preferredStyle: UIAlertControllerStyle.Alert)
                            alertController.addAction(UIAlertAction(title: "Aceptar", style: UIAlertActionStyle.Default, handler: nil))
                            self.presentViewController(alertController, animated: true, completion: nil)
                        }
                        
                    }
                }
            } catch let error1 as NSError {
                error = error1
            }*/
        }
    }
    
    func reactivar(actionTarget: UIAlertAction) {
        let defaults = NSUserDefaults.standardUserDefaults()
        if let persona_id = defaults.stringForKey("pid") {
            let url : String = "http://http://soswapp.cl/stopcar/api/start-car.php?uid="+persona_id+"&p="+txtPin.text!
            
            let myURLString = url
            guard let myURL = NSURL(string: myURLString) else {
                print("Error: \(myURLString) doesn't seem to be a valid URL")
                return
            }
            
            do {
                let nData = try String(contentsOfURL: myURL)
                if((nData as String)=="0"){
                    //Exito
                    defaults.setObject("0", forKey: "det")
                    let alertController = UIAlertController(title: "StopCar", message: "Su vehículo se reactivará en unos instantes, en el mapa se le mostrará su última ubicación.", preferredStyle: UIAlertControllerStyle.Alert)
                    alertController.addAction(UIAlertAction(title: "Aceptar", style: UIAlertActionStyle.Default, handler: redireccionar))
                    self.presentViewController(alertController, animated: true, completion: nil)
                }else{
                    //Error
                    defaults.setObject("1", forKey: "det")
                    let alertController = UIAlertController(title: "StopCar", message: "Ocurrió un error al intentar reactivar el vehículo, intente nuevamente", preferredStyle: UIAlertControllerStyle.Alert)
                    alertController.addAction(UIAlertAction(title: "Aceptar", style: UIAlertActionStyle.Default, handler: nil))
                    self.presentViewController(alertController, animated: true, completion: nil)
                }
            } catch let error as NSError {
                print("Error: \(error)")
            }
            /*
            let fileUrl = NSURL(string: url)
            let request = NSMutableURLRequest(URL: fileUrl!, cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData, timeoutInterval: 5)
            var response: NSURLResponse?
            var error: NSError?
            var resultado:String?
            let jsonString = ""
            request.HTTPBody = jsonString.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
            request.HTTPMethod = "POST"
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            do {
                let data = try NSURLConnection.sendSynchronousRequest(request, returningResponse: &response)
                if let nData = NSString(data: data, encoding: NSUTF8StringEncoding) {
                    if let httpResponse = response as? NSHTTPURLResponse {
                        if((nData as String)=="0"){
                            //Exito
                            defaults.setObject("0", forKey: "det")
                            let alertController = UIAlertController(title: "StopCar", message: "Su vehículo se reactivará en unos instantes, en el mapa se le mostrará su última ubicación.", preferredStyle: UIAlertControllerStyle.Alert)
                            alertController.addAction(UIAlertAction(title: "Aceptar", style: UIAlertActionStyle.Default, handler: redireccionar))
                            self.presentViewController(alertController, animated: true, completion: nil)
                        }else{
                            //Error
                            defaults.setObject("1", forKey: "det")
                            let alertController = UIAlertController(title: "StopCar", message: "Ocurrió un error al intentar reactivar el vehículo, intente nuevamente", preferredStyle: UIAlertControllerStyle.Alert)
                            alertController.addAction(UIAlertAction(title: "Aceptar", style: UIAlertActionStyle.Default, handler: nil))
                            self.presentViewController(alertController, animated: true, completion: nil)
                        }
                        
                    }
                }
            } catch let error1 as NSError {
                error = error1
            }*/
        }
    }
}

