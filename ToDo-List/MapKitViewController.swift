//
//  MapKitViewController.swift
//  ToDo-List
//
//  Created by Steffen Süß on 11.01.17.
//  Copyright © 2017 Steffen Süß. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation


class MapKitViewController: UIViewController, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate {
    
    let locationManager = CLLocationManager()
    
    @IBOutlet weak var searchResultsTableView: UITableView!
    @IBOutlet weak var mapView: MKMapView!
    
    var searchController:UISearchController!
    var searchTableViewController:UITableViewController!
    var annotation:MKAnnotation!
    var localSearchRequest:MKLocalSearchRequest!
    var localSearch:MKLocalSearch!
    var localSearchResponse:MKLocalSearchResponse!
    var error:NSError!
    var pointAnnotation:MKPointAnnotation!
    var pinAnnotationView:MKPinAnnotationView!
    var searchCompleter = MKLocalSearchCompleter()
    var searchResults = [MKLocalSearchCompletion]()
    var tableView: UITableView  =   UITableView()
    
    
    @IBAction func showSearchBAr(_ sender: Any) {
        
        searchController = UISearchController(searchResultsController: nil)
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = false
        self.searchController.searchBar.delegate = self
        present(searchController, animated: true, completion: nil)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
     
        self.mapView.mapType = .standard
        
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        
        if(pointAnnotation == nil){
            self.locationManager.startUpdatingLocation()
        }
        else{
            navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Löschen", style: .plain, target: self, action: #selector(doPerformSegue))
            self.pinAnnotationView = MKPinAnnotationView(annotation: self.pointAnnotation, reuseIdentifier: nil)
            self.mapView.centerCoordinate = self.pointAnnotation.coordinate
            self.mapView.addAnnotation(self.pinAnnotationView.annotation!)
            let region = MKCoordinateRegion(center: pointAnnotation.coordinate, span: MKCoordinateSpanMake(0.5, 0.5))
            mapView.setRegion(region, animated: true)
        }
        
        self.mapView.showsUserLocation = true
        
        searchCompleter.delegate = self
        searchCompleter.region = mapView.region

        searchResultsTableView.dataSource = self
        searchResultsTableView.delegate = self
        searchResultsTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        searchResultsTableView.isHidden = true
        self.view.addSubview(searchResultsTableView)
        
    }
    
    func doPerformSegue(){
        self.performSegue(withIdentifier: "unwindLocationToList", sender: self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - LocationManager Delegate Methods
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last
        
        let center = CLLocationCoordinate2D(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)
        
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1))
        
        self.mapView.setRegion(region, animated: true)
        
        self.locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Errors " + error.localizedDescription)
    }
    
    
    // MARK: - SearchController Delegate Methods
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchResultsTableView.isHidden = true
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if(!searchText.isEmpty){
            searchCompleter.queryFragment = searchText
        }
        else{
            searchResultsTableView.isHidden = true
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar){
        
        searchBar.resignFirstResponder()
        searchResultsTableView.isHidden = true
        
        localSearchRequest = MKLocalSearchRequest()
        localSearchRequest.naturalLanguageQuery = searchBar.text
        searchLocationAndMakeAnnotation(title: searchBar.text!, subtitle: "")
    }
    
    // MARK: - TableView Delegate Methods
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell=UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "cell")
        cell.textLabel!.text = searchResults [indexPath.row].title
        cell.detailTextLabel?.text = searchResults[indexPath.row].subtitle
        return cell;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        searchResultsTableView.isHidden = true
        
                localSearchRequest = MKLocalSearchRequest(completion: searchResults[indexPath.row])
        searchLocationAndMakeAnnotation(title: self.searchResults[indexPath.row].title, subtitle: self.searchResults[indexPath.row].subtitle)
        
    }
    
    // MARK - Searching for Location and Set Annotation
    
    func searchLocationAndMakeAnnotation(title: String, subtitle: String){
        //1 Once you click the keyboard search button, the app will dismiss the presented search controller you were presenting over the navigation bar. Then, the map view will look for any previously drawn annotation on the map and remove it since it will no longer be needed.

        dismiss(animated: true, completion: nil)
        if self.mapView.annotations.count != 0{
            annotation = self.mapView.annotations[0]
            self.mapView.removeAnnotation(annotation)
        }
        
        //2 After that, the search process will be initiated asynchronously by transforming the search bar text into a natural language query, the ‘naturalLanguageQuery’ is very important in order to look up for -even an incomplete- addresses and POI (point of interests) like restaurants, Coffeehouse, etc.

        localSearch = MKLocalSearch(request: localSearchRequest)
        localSearch.start { (localSearchResponse, error) -> Void in
            
            if localSearchResponse == nil{
                let alertController = UIAlertController(title: nil, message: "Place Not Found", preferredStyle: UIAlertControllerStyle.alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
                self.present(alertController, animated: true, completion: nil)
                return
            }
            
            //3 Mainly, If the search API returns a valid coordinates for the place, then the app will instantiate a 2D point and draw it on the map within a pin annotation view
            self.pointAnnotation = MKPointAnnotation()
            self.pointAnnotation.title = title
            self.pointAnnotation.subtitle = subtitle
            self.pointAnnotation.coordinate = CLLocationCoordinate2D(latitude: localSearchResponse!.boundingRegion.center.latitude, longitude:     localSearchResponse!.boundingRegion.center.longitude)
            
            
            self.pinAnnotationView = MKPinAnnotationView(annotation: self.pointAnnotation, reuseIdentifier: nil)
            self.mapView.centerCoordinate = self.pointAnnotation.coordinate
            self.mapView.addAnnotation(self.pinAnnotationView.annotation!)
        }

    }

    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
        if(navigationItem.leftBarButtonItem?.title == "Löschen" && segue.identifier == "unwindLocationToList"){
            let controller = segue.destination as! AddItemTableViewController
            controller.todoItem.pointAnnotation = nil
            let indexpath = IndexPath(row: 0, section: 3)
            let cell = controller.tableView.cellForRow(at: indexpath)
            cell?.textLabel?.text = "Standort..."
            cell?.textLabel?.textColor = UIColor.lightGray
            cell?.detailTextLabel?.text = ""
            controller.tableView.reloadData()
        }
     }
    
    
}

extension MapKitViewController: MKLocalSearchCompleterDelegate {
    
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        searchResults = completer.results
        searchResultsTableView.reloadData()
        if(searchResults.count == 0){
            searchResultsTableView.isHidden = true
        }
        else{
            searchResultsTableView.isHidden = false
        }
        
    }
    
    private func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: NSError) {
        // handle error
    }
}

