//
//  ViewController.swift
//  StopNow
//
//  Created by Daniel Fuentes on 07-01-16.
//  Copyright (c) 2016 Cumsensu. All rights reserved.
//

import UIKit
import MapKit

class MapaController: UIViewController, MKMapViewDelegate {
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var btnAccion: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        mapView.mapType = MKMapType.Standard
        //mapView.showsUserLocation = true
        //mapView.setUserTrackingMode(MKUserTrackingMode.Follow, animated: true)
        ultimaLocacion()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func ultimaLocacion() {
        let defaults = NSUserDefaults.standardUserDefaults()
        if let det = defaults.stringForKey("det") {
            if det=="1" {
                btnAccion.setTitle("Reactivar Vehículo", forState: UIControlState.Normal)
            }else{
                btnAccion.setTitle("Detener Vehículo", forState: UIControlState.Normal)
            }
        }else{
            btnAccion.setTitle("Detener Vehículo", forState: UIControlState.Normal)
        }
        if let persona_id = defaults.stringForKey("pid") {
            let json = ""
            let url : String = "http://soswapp.cl/stopcar/api/last-location.php?uid="+persona_id
            
            let myURLString = url
            guard let myURL = NSURL(string: myURLString) else {
                print("Error: \(myURLString) doesn't seem to be a valid URL")
                return
            }
            
            do {
                let nData = try String(contentsOfURL: myURL)
                var result = nData.componentsSeparatedByString("|")
                var lat = ((result[2] ) as NSString).doubleValue
                var lng = ((result[3] ) as NSString).doubleValue
                lat = round(lat * 1000000) / 1000000
                lng = round(lng * 1000000) / 1000000
                var location = CLLocationCoordinate2D()
                location.latitude = lat
                location.longitude = lng
                defaults.setObject(location.latitude, forKey: "carLat")
                defaults.setObject(location.longitude, forKey: "carLng")
                let anotation = MKPointAnnotation()
                anotation.coordinate = location
                anotation.title = "PPU "+result[0]
                anotation.subtitle = "Fecha " + (result[0])
                mapView.removeAnnotations(mapView.annotations.filter {$0 !== self.mapView.userLocation})
                let artwork = CustomAnn(title: "PPU " + result[0],
                                        locationName: "Fecha " + (result[1]),
                                        coordinate: location)
                mapView.addAnnotation(artwork)
                let spanX = 0.03
                let spanY = 0.03
                let newRegion = MKCoordinateRegion(center: location, span: MKCoordinateSpanMake(spanX, spanY))
                mapView.setRegion(newRegion, animated: true)
            } catch let error as NSError {
                print("Error: \(error)")
            }
            
            /*
            let fileUrl = NSURL(string: url)
            let request = NSMutableURLRequest(URL: fileUrl!, cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData, timeoutInterval: 5)
            var response: NSURLResponse?
            var error: NSError?
            //var data: NSData?
            request.HTTPBody = json.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
            request.HTTPMethod = "POST"
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            var puntosCargados = false;
            var cant = 0;
            // send the request
            while (puntosCargados == false) {
                do {
                    let data = try NSURLConnection.sendSynchronousRequest(request, returningResponse: &response)
                    if let nData = NSString(data: data, encoding: NSUTF8StringEncoding){
                        if let httpResponse = response as? NSHTTPURLResponse {
                            print(nData)
                            var result = nData.componentsSeparatedByString("|")
                            var lat = ((result[2] ) as NSString).doubleValue
                            var lng = ((result[3] ) as NSString).doubleValue
                            lat = round(lat * 1000000) / 1000000
                            lng = round(lng * 1000000) / 1000000
                            var location = CLLocationCoordinate2D()
                            location.latitude = lat
                            location.longitude = lng
                            defaults.setObject(location.latitude, forKey: "carLat")
                            defaults.setObject(location.longitude, forKey: "carLng")
                            let anotation = MKPointAnnotation()
                            anotation.coordinate = location
                            anotation.title = "PPU "+result[0]
                            anotation.subtitle = "Fecha " + (result[0])
                            mapView.removeAnnotations(mapView.annotations.filter {$0 !== self.mapView.userLocation})
                            //mapView.addAnnotation(anotation)
                            
                            let artwork = CustomAnn(title: "PPU " + result[0],
                                locationName: "Fecha " + (result[1]),
                                coordinate: location)//CLLocationCoordinate2D(latitude: 21.283921, longitude: -157.831661))
                            mapView.addAnnotation(artwork)
                            let spanX = 0.03
                            let spanY = 0.03
                            let newRegion = MKCoordinateRegion(center: location, span: MKCoordinateSpanMake(spanX, spanY))
                            mapView.setRegion(newRegion, animated: true)
                            puntosCargados = true
                        }
                    }
                } catch let error1 as NSError {
                    error = error1
                    puntosCargados = false
                }
            }*/
        }
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView! {
        if let annotation = annotation as? CustomAnn {
            let identifier = "pin"
            var view: MKAnnotationView
            if let dequeuedView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier) { // 2
                dequeuedView.annotation = annotation
                view = dequeuedView
                view.image=UIImage(named:"carpin.png")
                
            } else {
                // 3
                view = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                view.canShowCallout = true
                view.calloutOffset = CGPoint(x: -5, y: 5)
                view.rightCalloutAccessoryView = UIButton(type: UIButtonType.DetailDisclosure) as UIView
                view.image=UIImage(named:"carpin.png")
                
                //view.leftCalloutAccessoryView = UIButton.buttonWithType(UIButtonType.ContactAdd) as! UIView
            }
            return view
        }
        return nil
    }

}

