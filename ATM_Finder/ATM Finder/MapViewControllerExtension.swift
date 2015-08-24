//
//  MapViewControllerExtension.swift
//  ATM Finder
//
//  Created by Colloque Tsui on 21/8/15.
//  Copyright (c) 2015 Colloque Tsui. All rights reserved.
//

import Foundation
import MapKit

extension MapViewController: MKMapViewDelegate, UITableViewDelegate, UITableViewDataSource, UISearchControllerDelegate {
    
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        if let annotation = annotation as? ATM {
            let identifier = "ATM"
            var view: MKPinAnnotationView
            if let dequeuedView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier)
                as? MKPinAnnotationView { // 2
                    dequeuedView.annotation = annotation
                    view = dequeuedView
            } else {
                // 3
                view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                view.canShowCallout = true
                view.image = UIImage(named: "ATM")
                view.calloutOffset = CGPoint(x: 0, y: 0)
                view.rightCalloutAccessoryView = UIButton.buttonWithType(.DetailDisclosure) as! UIView
            }
            return view
        }
        return nil
    }
    
    func mapView(mapView: MKMapView!, annotationView view: MKAnnotationView!,
        calloutAccessoryControlTapped control: UIControl!) {
            let location = view.annotation as! ATM
            selectedATM = location
            performSegueWithIdentifier("toATMDetails", sender: self)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchResultArray.count > 10 {
            return 10
        } else {
            return searchResultArray.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("resultATM", forIndexPath: indexPath) as! SearchResultCell
        
        let df = MKDistanceFormatter()
        df.unitStyle = .Abbreviated
        df.units = .Metric
        
        cell.bankNameLabel?.text = searchResultArray[indexPath.row].bank + " - " + df.stringFromDistance(searchResultArray[indexPath.row].distance)
        cell.bankAddressLabel?.text = searchResultArray[indexPath.row].address
        cell.distanceLabel?.text = df.stringFromDistance(searchResultArray[indexPath.row].distance)
        
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var location = CLLocation(latitude: searchResultArray[indexPath.row].coordinate.latitude, longitude: searchResultArray[indexPath.row].coordinate.longitude)
        searchController.searchBar.resignFirstResponder()
        searchController.searchBar.setShowsCancelButton(false, animated: false)
        mapView.selectAnnotation(searchResultArray[indexPath.row], animated: true)
        centerMapOnLocation(location)
        searchResultArray.removeAll(keepCapacity: false)
        tableView.reloadData()
    }
    
    func searchBarShouldBeginEditing(searchBar: UISearchBar) -> Bool {
        searchBar.setShowsCancelButton(true, animated: false)
        navigationItem.setRightBarButtonItem(nil, animated: true)
        tableView.hidden = false
        return true
    }
    
    func searchBarShouldEndEditing(searchBar: UISearchBar) -> Bool {
        navigationItem.rightBarButtonItem = filterButton
        tableView.hidden = true
        return true
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        navigationItem.rightBarButtonItem = filterButton
        searchBar.resignFirstResponder()
        searchBar.setShowsCancelButton(false, animated: false)
//        searchBar.text = ""
    }
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        searchResultArray.removeAll(keepCapacity: false)

        if searchController.searchBar.text != nil {
            searchResultArray = selectBanksArray.filter { (atm: ATM) -> Bool in
                if let range = atm.address.lowercaseString.rangeOfString(searchController.searchBar.text) {
                    return true
                } else {
                    return false
                }
            }
            
            if let userLocation = mapView.userLocation {
                searchResultArray = searchResultArray.filter { (atm:ATM) -> Bool in
                    var atmLocation:CLLocation = CLLocation(latitude: atm.coordinate.latitude, longitude: atm.coordinate.longitude)
                    var userLocationCLLocation = CLLocation(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
                    var distance:CLLocationDistance = atmLocation.distanceFromLocation(userLocationCLLocation)
                    atm.distance = distance
                    return true
                }
                
                // sort array by distance and select the first item (closest ATM)
                searchResultArray.sort({$0.distance < $1.distance})
            }
        }
        
        tableView.reloadData()
    }
}