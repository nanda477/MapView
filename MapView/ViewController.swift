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
    
    @IBOutlet weak var addressLabel: UILabel!
    var addressEntry = "G"// or // "M"
    
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
    
    
    var marker = GMSMarker()
    var SourceLat = 12.9716
    var SourceLong = 77.5946
    var rectagle = GMSPolyline()
    //var snackBar: MJSnackBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let camara: GMSCameraPosition = GMSCameraPosition.camera(withLatitude: SourceLat, longitude: SourceLong, zoom: 12.0)
        
        mapView.camera = camara
        
        let position = CLLocationCoordinate2DMake(SourceLat, SourceLong)
        self.marker = GMSMarker(position: position)
        self.marker.icon = GMSMarker.markerImage(with: .green)
        
        self.marker.map = self.mapView
    }

    @IBAction func manualAddressAtion(_ sender: Any) {
        
        let mAddressView = storyboard?.instantiateViewController(withIdentifier: "ManualAddress_ID") as! ManualAddress
        mAddressView.mDelegate = self
        let mANav = UINavigationController(rootViewController: mAddressView)
        self.present(mANav, animated: true, completion: nil)
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
        // assign to label
        
//        addressLabel.text = place.formattedAddress
//
//
//        // not checking just allowing location to display in map
//        mapView.clear()
//        let position = CLLocationCoordinate2D(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
//        let marker = GMSMarker(position: position)
//        marker.title = place.name
//        marker.map = mapView
//        self.mapView.animate(toLocation: position)
//        self.mapView.animate(toZoom: 20.0)
//        dismiss(animated: true, completion: nil)
//
//        // check your logic here
//        checkLOcationValidator(fromView: "G")
//
//        guard validateLocation(locName: place.name!) else {
//            dismiss(animated: true, completion: nil)
//            print("Unable to delivery to this location, please select different location")
//            self.showAlert(msg: "Unable to delivery to this location, please select different location")
//            return
//        }
        
        self.dismiss(animated: true) {
            let position = place.coordinate
               self.marker = GMSMarker(position: position)
               self.marker.title = place.name
               self.marker.map = self.mapView
               
               let camaras: GMSCameraPosition = GMSCameraPosition.camera(withLatitude: place.coordinate.latitude, longitude: place.coordinate.longitude, zoom: 12.0)
               
            self.mapView.camera = camaras
               
               
            //   let urlString = "https://maps.googleapis.com/maps/api/directions/json?origin=\(SourceLat),\(SourceLong)&destination=\(place.coordinate.latitude),\(place.coordinate.longitude)&sensor=false"
               
               let urlString = "https://maps.googleapis.com/maps/api/directions/json?" +
                "origin=\(self.SourceLat),\(self.SourceLong)&destination=\(place.coordinate.latitude),\(place.coordinate.longitude)&" +
               "key=XXXXXXXXXXXXX"

               guard let url = URL(string: urlString) else {
                   return
               }
               
               let urlReqest = URLRequest(url: url)
               
               let config = URLSessionConfiguration.default
               let session = URLSession(configuration: config)
               
               session.dataTask(with: urlReqest) { (mData, mResponse, mError) in
                   
                   do{
                       guard let data = mData else{
                           return
                       }
                       
                       guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary else{
                           return
                       }
                       
                       let arrayRoutes = json["routes"] as? NSArray ?? []
                       let arrLegs = (arrayRoutes[0] as? NSDictionary ?? [:]).object(forKey: "legs") as! NSArray
                       let arrSteps = arrLegs[0] as? NSDictionary ?? [:]
                       
                       let dicDistance = arrSteps["distance"] as! NSDictionary
                       let distance = dicDistance["text"] as! String
                       
                       let dicDuration = arrSteps["duration"] as! NSDictionary
                       let duration = dicDuration["text"] as! String
                       
                       DispatchQueue.global(qos: .background).async {
                           
                           let array = json["routes"] as? NSArray ?? []
                           let dic = array[0] as? NSDictionary ?? [:]
                           let dic1 = dic["overview_polyline"] as? NSDictionary ?? [:]
                           let points = dic1["points"] as? String ?? ""
                           
                           
                           
                           DispatchQueue.main.async {
                               
                               let path = GMSPath(fromEncodedPath: points)
                               self.rectagle.map = nil
                               self.rectagle = GMSPolyline(path: path)
                               self.rectagle.strokeWidth = 4
                               self.rectagle.strokeColor = .blue
                               self.rectagle.map = self.mapView
                           
                               
                           }
                       }
                       
                       
                       
                       
                   }catch{
                       print("Error")
                   }
               }.resume()
        }
        
        
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
    
    
    func checkLOcationValidator(fromView: String) {
        //addressEntry = "G" && fromview = "G"
        // addressEntry is "G"
        if addressEntry == "G" {
            
            if addressEntry == fromView {
                // TODO: your logic here
                print("User Also selected address from Google")
            }else{
                // TODO: your logic here
                print("User selected address from Manual")
            }
            
        }// addressEntry is "M"
        else{
            
            if addressEntry == fromView {
                // TODO: your logic here
                print("User Also selected address from Manual")
            }else{
                // TODO: your logic here
                print("User selected address from Google")
            }
            
            
        }
        
        
    }
}

extension ViewController: manualAddressDelegate {
    func manualAddressReturn(data: String, name: String, street: String, city: String, state: String, pincode: String) {
        checkLOcationValidator(fromView: data)
        
        
        // 1 method
        //addressLabel.text = "Name: \(name)\n" + "Street: \(street)\n" + "City: \(city)\n" + "State: \(state)\n" + "Pincode: \(pincode)\n"
        
        //2 method
        //addressLabel.text = "\(name),\(street),\(city),\(state),\(pincode)".trimmingCharacters(in: .init(charactersIn: ","))
        
        //3 mehood
        
        //addressLabel.text = "\(name),\(street),\(city),\(state),\(pincode)".replacingOccurrences(of: ",,,,", with: ",").replacingOccurrences(of: ",,,", with: ",").replacingOccurrences(of: ",,", with: ",").trimmingCharacters(in: .init(charactersIn: ","))
        
            
        // 4 method
//        let nameS = name != "" ? (name + ",") : ""
//        let streetS = street != "" ? (street + ",") : ""
//        let cityS = city != "" ? (city + ",") : ""
//        let stateS = state != "" ? (state + ",") : ""
//        let pincode = pincode != "" ? (pincode + ",") : ""
//        addressLabel.text = nameS + streetS + cityS + stateS + pincode
        
        // method 5
        
        let nameS = name
        let streetS = street != "" ? ("," + street) : ""
        let cityS = city != "" ? ( "," + city) : ""
        let stateS = state != "" ? ("," + state) : ""
        let pincode = pincode != "" ? ("," + pincode) : ""
        addressLabel.text = nameS + streetS + cityS + stateS + pincode
        
    }


}



