//
//  ATMViewController.swift
//  ATM Finder
//
//  Created by Colloque Tsui on 12/08/2015.
//  Copyright (c) 2015 Colloque Tsui. All rights reserved.
//

import UIKit
import MapKit

class ATMViewController: UIViewController, UITableViewDataSource, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var tableView: UITableView!
    
    var atm:ATM = ATM(bank: "", address: "", service: "", currency: "", coordinate: CLLocationCoordinate2D(latitude: 22.3593252, longitude: 114.1408686))
    var bankDetailArray:[String] = []
//    var typeArray:[String] = ["銀行", "地址", "服務", "貨幣"]
    var typeArray:[String] = [NSLocalizedString("Bank", comment: "Label for feild Bank"), NSLocalizedString("Address", comment: "Label for feild Address"), NSLocalizedString("Service", comment: "Service"), NSLocalizedString("Currency", comment: "Label for feild Currency")]
    
    let regionRadius: CLLocationDistance = 100
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
            regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        if let annotation = annotation as? ATM {
            let identifier = "ATM"
            var view: MKAnnotationView
            view = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view.canShowCallout = true
            
            view.image = UIImage(named: "ATM")
            view.calloutOffset = CGPoint(x: 0, y: 0)
            view.rightCalloutAccessoryView = UIButton.buttonWithType(.DetailDisclosure) as! UIView

            return view
        }
        return nil
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bankDetailArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ATMViewCellIdentifier", forIndexPath: indexPath) as! ATMViewCell
        
        cell.cellTypeLabel.text = typeArray[indexPath.row]
        cell.cellDetailLabel.text = bankDetailArray[indexPath.row]
//        cell.textLabel?.text = bankDetailArray[indexPath.row]
        
        return cell
    }
    
    func openInGoogleMapsAction(sender: UIBarButtonItem!) {
        if (UIApplication.sharedApplication().canOpenURL(NSURL(string:"comgooglemaps://")!)) {
            UIApplication.sharedApplication().openURL(NSURL(string:
                "comgooglemaps://?center=\(atm.coordinate.latitude),\(atm.coordinate.longitude)&zoom=14&views=traffic")!)
        } else {
            var alert = UIAlertController(title: "Alert", message: "Unable to detect Google Maps on your system", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    func openInAppleMapsAction(sender: UIBarButtonItem!) {
        
        let regionDistance:CLLocationDistance = 10000
        var coordinates = atm.coordinate
        let regionSpan = MKCoordinateRegionMakeWithDistance(coordinates, regionDistance, regionDistance)
        var options = [
            MKLaunchOptionsMapCenterKey: NSValue(MKCoordinate: regionSpan.center),
            MKLaunchOptionsMapSpanKey: NSValue(MKCoordinateSpan: regionSpan.span)
        ]
        var placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
        var mapItem = MKMapItem(placemark: placemark)
        mapItem.name = "ATM: \(atm.bank)"
        mapItem.openInMapsWithLaunchOptions(options)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        mapView.delegate = self
        mapView.addAnnotation(atm)
        centerMapOnLocation(CLLocation(latitude: atm.coordinate.latitude, longitude: atm.coordinate.longitude))
        bankDetailArray.append(atm.bank)
        bankDetailArray.append(atm.address)
        bankDetailArray.append(atm.service)
        bankDetailArray.append(atm.currency)
        
        tableView.estimatedRowHeight = 59.0
        tableView.rowHeight = UITableViewAutomaticDimension
        
        tableView.dataSource = self
        tableView.reloadData()
        
        if (UIApplication.sharedApplication().canOpenURL(NSURL(string:"comgooglemaps://")!)) {
            var openInGoogleMaps:UIBarButtonItem = UIBarButtonItem(title: "Open in Google Maps", style: .Plain, target: self, action: "openInGoogleMapsAction:")
            navigationItem.rightBarButtonItem = openInGoogleMaps
        } else {
            var openInAppleMaps:UIBarButtonItem = UIBarButtonItem(title: "Open in Maps", style: .Plain, target: self, action: "openInAppleMapsAction:")
            navigationItem.rightBarButtonItem = openInAppleMaps
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
