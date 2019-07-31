//
//  ViewController.swift
//  MapView
//

import UIKit
import GooglePlaces
import GoogleMaps

class ViewController: UIViewController {

    @IBOutlet weak var mapView: GMSMapView!
  //  @IBOutlet weak var locationLabel: UILabel!
    
    let locationArray = [[
        "area_id" : "1",
        "area_name" : "Kodambakkam",
        "city_id" : "1",
        "city_name" : "Chennai"
        ],[
            "area_id" : "2",
            "area_name" : "T. nager",
            "city_id" : "1",
            "city_name" : "Chennai"
        ],[
            "area_id" : "3",
            "area_name" : "Adyar",
            "city_id" : "1",
            "city_name" : "Chennai"
        ],[
            "area_id" : "4",
            "area_name" : "Porur",
            "city_id" : "1",
            "city_name" : "Chennai"
        ],[
            "area_id" : "5",
            "area_name" : "Srirangam",
            "city_id" : "2",
            "city_name" : "Tiruchirappalli"
        ],[
            "area_id" : "6",
            "area_name" : "Samayapuram",
            "city_id" : "2",
            "city_name" : "Tiruchirappalli"
        ]]
    override func viewDidLoad() {
        super.viewDidLoad()

    }


    @IBAction func addressAction(_ sender: Any) {
        
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        let filter = GMSAutocompleteFilter()
        filter.country = "IND"
        autocompleteController.autocompleteFilter = filter
        self.present(autocompleteController, animated: false, completion: nil)
        
    }
}

extension ViewController: GMSAutocompleteViewControllerDelegate {

    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace)
    {
        // not checking just allowing location to display in map
        mapView.clear()
        let position = CLLocationCoordinate2D(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
        let marker = GMSMarker(position: position)
        marker.title = place.name
        marker.map = mapView
        self.mapView.animate(toLocation: position)
        self.mapView.animate(toZoom: 20.0)
        dismiss(animated: true, completion: nil)
        
        guard validateLocation(locName: place.name!) else {
            dismiss(animated: true, completion: nil)
            print("Unable to delivery to this location, please select different location")
            self.showAlert(msg: "Unable to delivery to this location, please select different location")
            return
        }
        
        
        
       //self.locationLabel.text = place.formattedAddress
        
//        mapView.clear()
//        let position = CLLocationCoordinate2D(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
//        let marker = GMSMarker(position: position)
//        marker.title = place.name
//        marker.map = mapView
//        self.mapView.animate(toLocation: position)
//        self.mapView.animate(toZoom: 20.0)
//       dismiss(animated: true, completion: nil)
        
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
  
        print("Error: ", error.localizedDescription)
    }

    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        
        dismiss(animated: false) {
        }
    }
    
    
        func validateLocation(locName: String) -> Bool {
            
            //======= NEW METHOD ========
            //1 method
            let validData = locationArray.filter { ( $0["area_name"] == locName)}
            if validData.count > 0 {
                return true
            }
            
            
            
            // ========= OLD METHOD =========
           // ~~~~~~~~~~~~~~~~~~~~~~~ or ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
                                // 2nd method
            /*
                    for i in 0..<locationArray.count {
                        let dict = locationArray[i]
                        if dict["area_name"] == locName {
                            return true
                        }
                    }
            */
            
            return false
    }
    
    func showAlert(msg: String) {
        
        let alert = UIAlertController(title: "Warning..!", message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Select Another Address", style: .default, handler: { (addAction) in
            let autocompleteController = GMSAutocompleteViewController()
            autocompleteController.delegate = self
            let filter = GMSAutocompleteFilter()
            filter.country = "IND"
            autocompleteController.autocompleteFilter = filter
            self.present(autocompleteController, animated: false, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
        
    }
}



