//
//  ViewController.swift
//  ATM Finder
//
//  Created by Colloque Tsui on 03/08/2015.
//  Copyright (c) 2015 Colloque Tsui. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit
import CoreData

class MapViewController: UIViewController, CLLocationManagerDelegate, UISearchBarDelegate, UISearchResultsUpdating {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet var filterButton: UIBarButtonItem!
    @IBOutlet var tableView: UITableView!
    
    var searchController = UISearchController(searchResultsController: nil)
    var manager = CLLocationManager()
    var initATMArray:[ATM] = []
    var selectedATM:ATM = ATM(bank: "", address: "", service: "", currency: "", coordinate: CLLocationCoordinate2D(latitude: 22.3593252, longitude: 114.1408686))
    var banks:[String] = []
    var selectedBanks:[String] = []
    var defaults = NSUserDefaults.standardUserDefaults()
    var firstLoad:Bool = true
    var searchResultArray:[ATM] = []
    var selectBanksArray:[ATM] = []
    
    
    let regionRadius: CLLocationDistance = 300
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
            regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateToLocation newLocation: CLLocation!, fromLocation oldLocation: CLLocation!) {
        
        centerMapOnLocation(newLocation)
        
        // get distance from user location to each ATM
        if selectBanksArray.count > 0 {
            var distanceArray = selectBanksArray.filter { (atm:ATM) -> Bool in
                var atmLocation:CLLocation = CLLocation(latitude: atm.coordinate.latitude, longitude: atm.coordinate.longitude)
                var distance:CLLocationDistance = atmLocation.distanceFromLocation(newLocation)
                atm.distance = distance
                return true
            }
            
            // sort array by distance and select the first item (closest ATM)
            distanceArray.sort({$0.distance < $1.distance})
            mapView.selectAnnotation(distanceArray[0], animated: true)
        }
        
        manager.stopUpdatingLocation()
    }
    
    func initATMs(language:String) {

        let appDelegate =
        UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext!
        let entity =  NSEntityDescription.entityForName("ATM_\(language)",
            inManagedObjectContext:
            managedContext)

        if let xmlPath = NSBundle.mainBundle().pathForResource("all_\(language)", ofType: "xml") {
            if let data = NSData(contentsOfFile: xmlPath) {
                var error: NSError?
                
                if let xmlDoc = AEXMLDocument(xmlData: data, error: &error) {
                    if let atms = xmlDoc.root["atm"].all {
                        if let firstLat = xmlDoc.root["atm"]["latitude"].value, firstLng = xmlDoc.root["atm"]["longitude"].value {
                            
                            for atm in atms {
                                if let latitude = atm["latitude"].value, longitude = atm["longitude"].value, bankName = atm["ob_name"].value, address = atm["addr"].value {
                                    
                                    var atmCore = NSManagedObject(entity: entity!,
                                        insertIntoManagedObjectContext:managedContext)
                                    
                                    var servicesString = ""
                                    var currencyString = ""
                                    
                                    if atm["supp_tran"].count > 0 {
                                        var services:[String] = []
                                        for tran in atm["supp_tran"].children {
                                            if let service = tran.value {
                                                services.append(service)
                                            }
                                        }
                                        servicesString = "/".join(services)
                                        atmCore.setValue(servicesString, forKey: "service")
                                    }
                                    
                                    if atm["currencies"].count > 0 {
                                        var currencies:[String] = []
                                        for currency in atm["currencies"].children {
                                            if let currency = currency.value {
                                                currencies.append(currency)
                                            }
                                        }
                                        currencyString = "/".join(currencies)
                                        atmCore.setValue(currencyString, forKey: "currency")
                                    }
                                    
                                    atmCore.setValue(bankName, forKey: "bank")
                                    atmCore.setValue(address, forKey: "address")
                                    atmCore.setValue((latitude as NSString).doubleValue, forKey: "latitude")
                                    atmCore.setValue((longitude as NSString).doubleValue, forKey: "longitude")

                                    var error: NSError?
                                    if !managedContext.save(&error) {
                                        println("Could not save \(error), \(error?.userInfo)")
                                    }
                                    
                                    var atmClass = ATM(bank: bankName, address: address, service: servicesString, currency: currencyString, coordinate: CLLocationCoordinate2D(latitude: (latitude as NSString).doubleValue, longitude: (longitude as NSString).doubleValue))
                                    initATMArray.append(atmClass)
                                    if !contains(banks, bankName) {
                                        banks.append(bankName)
                                    }
                                }
                            }
                            
                        }
                    }
                } else {
                    println("description: \(error?.localizedDescription)\ninfo: \(error?.userInfo)")
                }
            }
        }
        
        defaults.setObject(banks, forKey: "banks_\(language)")
        defaults.setObject(banks, forKey: "userBanks_\(language)")
        selectedBanks = banks
        defaults.synchronize()
    }
    
    @IBAction func closeOptions(exitSegue: UIStoryboardSegue) {
    }
    
    @IBAction func doneOptions(exitSegue: UIStoryboardSegue) {
        let optionsViewController = exitSegue.sourceViewController as! FilterViewController
        
        // get selected banks from filter
        selectedBanks = optionsViewController.selectedBanks
        
        // apply to map
        mapView.removeAnnotations(mapView.annotations)
        
        selectBanksArray = []
        
        for bank in self.selectedBanks {
            for atm in self.initATMArray {
                if atm.bank == bank {
                    selectBanksArray.append(atm)
                }
            }
        }
        
        mapView.addAnnotations(selectBanksArray)
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // show loading hud
        let loadingNotification = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        loadingNotification.mode = MBProgressHUDMode.Indeterminate
        loadingNotification.labelText = NSLocalizedString("Loading ATMs...", comment: "Loading text")
        
        manager.requestWhenInUseAuthorization()
        manager.delegate = self
        mapView.showsUserLocation = true
        mapView.delegate = self
        tableView.hidden = true
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.estimatedRowHeight = 60
        tableView.rowHeight = UITableViewAutomaticDimension
        
        var negativeSpace:UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FixedSpace, target: nil, action: nil)
        negativeSpace.width = -7.0
        
        // insert tracking button onto navigation bar
        var trackingButton:MKUserTrackingBarButtonItem = MKUserTrackingBarButtonItem(mapView: mapView)
        navigationItem.leftBarButtonItems = [negativeSpace, trackingButton]
        
        // insert search bar onto navigation bar
        searchController.searchBar.placeholder = NSLocalizedString("address", comment: "Search bar placeholder")
        searchController.dimsBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.searchBarStyle = UISearchBarStyle.Minimal
        searchController.searchBar.setImage(UIImage(named: "search"), forSearchBarIcon: UISearchBarIcon.Search, state: UIControlState.Normal)
        searchController.searchBar.setImage(UIImage(named: "cancel"), forSearchBarIcon: UISearchBarIcon.Clear, state: UIControlState.Normal)
        
        var textFieldInsideSearchBar = searchController.searchBar.valueForKey("searchField") as? UITextField
        textFieldInsideSearchBar?.textColor = UIColor.whiteColor()
        var textFieldInsideSearchBarLabel = textFieldInsideSearchBar!.valueForKey("placeholderLabel") as? UILabel
        textFieldInsideSearchBarLabel?.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.5)
        
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        
        navigationItem.titleView = searchController.searchBar
        
        
    }
    
    override func viewDidAppear(animated: Bool) {
        
        // only do this when app first load, so switching between tabs won't trigger this
        if firstLoad {
            
            var language:String = ""
            if let userLanguage = defaults.objectForKey("AppleLanguages") as? String {
                language = userLanguage
            } else {
                language = NSLocale.preferredLanguages()[0] as! String
                defaults.setObject([language], forKey: "AppleLanguages")
                defaults.synchronize()
            }
            
            let range = Range(start: language.startIndex, end: advance(language.startIndex, 2))
            var languageCode = language.substringWithRange(range)
            
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            let managedContext = appDelegate.managedObjectContext!
            let fetchRequest = NSFetchRequest(entityName: "ATM_\(languageCode)")
            var error: NSError?
            let fetchedResults =
            managedContext.executeFetchRequest(fetchRequest,
                error: &error) as? [NSManagedObject]
            
            // check if ATMs already in CoreData, if yes then append to initArray
            if let results = fetchedResults {
                if results.count != 0 {
                    for result in results {
                        var annotation = ATM(bank: result.valueForKey("bank") as! String, address: result.valueForKey("address") as! String, service: result.valueForKey("service") as! String, currency: result.valueForKey("currency") as! String, coordinate: CLLocationCoordinate2D(latitude: result.valueForKey("latitude") as! Double, longitude: result.valueForKey("longitude") as! Double))
                        initATMArray.append(annotation)
                    }
                    //                for result in results {
                    //                    managedContext.deleteObject(result)
                    //                }
                } else {
                    // if not already in CoreData then import from XML
                    initATMs(languageCode)
                }
            } else {
                println("Could not fetch \(error), \(error!.userInfo)")
            }
            
            // check if user already set their banks
            if let userBanks = defaults.objectForKey("userBanks_\(languageCode)") as? [String] {
                println("already set banks")
                println(languageCode)
                println(userBanks)
                selectedBanks = userBanks
                selectBanksArray = initATMArray.filter({ (atm:ATM) -> Bool in
                    if contains(userBanks, atm.bank) {
                        return true
                    } else {
                        return false
                    }
                })
                mapView.addAnnotations(selectBanksArray)
            } else {
                mapView.addAnnotations(initATMArray)
            }
            
            //        managedContext.save(nil)
            MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
            
            // no longer first load
            firstLoad = false
            
            // start update user location
            manager.startUpdatingLocation()
        }
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "toATMDetails") {
            var dvc = (segue.destinationViewController as! ATMViewController)
            dvc.atm = selectedATM
        }
        
        if (segue.identifier == "toFilter") {
            let navVC = (segue.destinationViewController as! UINavigationController)
            let dvc = navVC.viewControllers.first as! FilterViewController
            dvc.selectedBanks = selectedBanks
        }
    }
}

