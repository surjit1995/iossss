
import UIKit
import CoreData
import MapKit

class HomeViewController: UIViewController {
    
    

    
    // Variables
    static var managedContext: NSManagedObjectContext!
    
    var userDataArray = [UserData]()
    var filterArray = [UserData]()
    var selectedPinView: MKAnnotation!
    var selectedPinIndex = 0
    var singleUserDataObject = UserData()
    let locationManager = CLLocationManager()
    var formatter = DateFormatter()
    var noData = false
    var goToUpdate = false
    var date1 = ""
    var newIndex = 0
    
    //Outlets
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var segment: UISegmentedControl!
    @IBOutlet weak var listView: UIView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    setAnnonation()
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // nib files
         
        tableview.delegate = self
             tableview.dataSource = self
             
         
             
             listView.isHidden = true
             mapView.isHidden = false
             
             searchBar.delegate = self
             
             if tableview.isHidden == false{
                 segment.selectedSegmentIndex = 0
             }else{
                 segment.selectedSegmentIndex = 1
             }
             fetchAndUpdateTable()
                   //setAnnonation()
             
            
             
             
             
             let nib1 = UINib.init(nibName: "NoDataCell", bundle: nil)
             self.tableview.register(nib1, forCellReuseIdentifier: "NoDataCell")
             
             let nib = UINib.init(nibName: "ListDetailCell", bundle: nil)
             self.tableview.register(nib, forCellReuseIdentifier: "ListDetailCell")
        updateLocations()
    }
    
    
}



// TableView Datasources and Delegates

extension HomeViewController: UITableViewDataSource,UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if (filterArray.count <= 0){
            noData = false
            return 1
        }else{
            noData = true
        }
        
        return filterArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if !noData{
            
            let cell1 = tableView.dequeueReusableCell(withIdentifier: "NoDataCell") as! NoDataCell
            return cell1
            
        }else{
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "ListDetailCell") as! ListDetailCell
            let userdata = filterArray[indexPath.row]
            
            formatter.dateStyle = .long
            formatter.timeStyle = .none
            cell.nameTxt?.text = userdata.name
            cell.imgView.image = userdata.photoImage
            cell.birthdayTxt.text =  formatter.string(from: userdata.birthday!)
            cell.countryTxt.text = userdata.country
            cell.genderTxt.text = userdata.gender
            cell.latitudeTxt.text = userdata.latitude.description
            cell.longitudeTxt.text = userdata.longitude.description
            cell.imageView?.layer.cornerRadius = 150
            
            return cell
        }
        
        
        
    }
    
    //delete the data
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete{
            
            let locationData = userDataArray[indexPath.row]
            deleteRecord(user: locationData)
            fetchAndUpdateTable()
            
        }
    }
    //did select call moving to update controller
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "UpdateViewController") as? UpdateViewController {
            
            viewController.singleUserObject = userDataArray[indexPath.row]
            viewController.getToUpdate = true
            
            if let navigator = navigationController {
                navigator.pushViewController(viewController, animated: true)
            }
        }
    }
}

// Map Delegate functons

extension HomeViewController: CLLocationManagerDelegate,MKMapViewDelegate{
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is UserData else {
          return nil
        }
        let identifier = "Location"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        if annotationView == nil {
          let pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
          pinView.isEnabled = true
          pinView.canShowCallout = true
          pinView.animatesDrop = false
          pinView.pinTintColor = UIColor(red: 0.32, green: 0.82, blue: 0.4, alpha: 1)
            
            // right button set
          let rightButton = UIButton(type: .detailDisclosure)
          rightButton.addTarget(self, action: #selector(annoBtnPressed), for: .touchUpInside)
          pinView.rightCalloutAccessoryView = rightButton
          annotationView = pinView
            
            
        }
        // tag get kita
        
        if let annotationView = annotationView {
          annotationView.annotation = annotation
          let button = annotationView.rightCalloutAccessoryView as! UIButton
            
            if let index = userDataArray.firstIndex (of: annotation as! UserData){
            button.tag = index
                }
        
        
        }
        return annotationView
    }
    
  
    //i button
    @objc func annoBtnPressed(_ sender : UIButton){
        
                
        if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "UpdateViewController") as? UpdateViewController {
            
            let btn = sender as! UIButton
            let data = filterArray[btn.tag]
            viewController.getToUpdate = true
             viewController.singleUserObject = data

            if let navigator = navigationController {
                navigator.pushViewController(viewController, animated: true)
            }
        }
    }
    
    @objc func deleteBtnPressed(){
        
        self.view.layoutIfNeeded()
        
        if let m = selectedPinView.title{
            if let t = m{
                for i in 0..<self.userDataArray.count{
                    let title = "\(userDataArray[i].name!.description + "  " +  userDataArray[i].gender!  + "  " +  userDataArray[i].country!.description  )"
                    if(title == t){
                        self.deleteRecord(user: self.userDataArray[i])
                        
                        fetchAndUpdateTable()
                       // self.setAnnonation()
                        
                        break
                    }
                }
            }
        }
        
    }
    
    
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        let annotation = view.annotation
        let index = (self.mapView.annotations as NSArray).index(of: annotation!)
        print ("Annotation Index = \(index)")
        selectedPinIndex = index
        print(selectedPinIndex)
        selectedPinView = annotation
        
    }
    
    //delete record function
    func deleteRecord( user : UserData){
        
        try HomeViewController.managedContext.delete(user)
        try! HomeViewController.managedContext.save()
    }
    
}

// SearchBar Delegate

extension HomeViewController: UISearchBarDelegate{
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterArray = searchText.isEmpty ? userDataArray : userDataArray.filter({ (userDetailString: UserData) -> Bool in
            
            return userDetailString.name?.range(of: searchText, options:  .caseInsensitive) != nil
        })
        
        if (filterArray.count <= 0){
            noData = false
        }else{
            noData = true
        }
        tableview.reloadData()
    }
}


extension HomeViewController{
    
    // Button Actions to move to the next controller
    
    @IBAction func addDetailBtnTapped(_ sender: UIBarButtonItem) {
        if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddDetailViewController") as? AddDetailViewController {
            
            if let navigator = navigationController {
                navigator.pushViewController(viewController, animated: true)
            }
        }
        
    }
    
    // Segment Actions
    
    @IBAction func typeSegment(_ sender: UISegmentedControl) {
       
        
        switch sender.selectedSegmentIndex {
        case 0:
            // Show Map
           
            listView.isHidden = true
            mapView.isHidden = false
           // setAnnonation()
            break
            
        case 1:
            // Show List
            listView.isHidden = false
            mapView.isHidden = true
            break
            
        default:
            // Show List
            listView.isHidden = false
            mapView.isHidden = true
            tableview.reloadData()
            break
        }
    }
    
   
    
    func fetchAndUpdateTable(){
        userDataArray = fetchRecords()
        filterArray = userDataArray
        
        if (filterArray.count <= 0){
            noData = false
        }else{
            noData = true
            
        }
        tableview.reloadData()
        setAnnonation()
    }
    
    // For inserting Data in Core Data
    
    func insertRecord(name:String, country:String,latitude: Double,longitude: Double,gender:String,birthday: Date,userImage: NSNumber){
        
        let userData = UserData(context: HomeViewController.managedContext)
        
        userData.name = name
        userData.country = country
        userData.gender = gender
        userData.latitude = latitude
        userData.longitude = longitude
        userData.birthday = birthday
        userData.photoID = userImage
        
        try! HomeViewController.managedContext.save()
    }
    
    // For Updating Data in Core Data
    func updateRecord(userData : UserData, name: String, gender: String,country:String, latitude:Double,longitude:Double, birthday:Date,userImg: NSNumber){
        
        userData.name = name
        userData.country = country
        userData.gender = gender
        userData.latitude = latitude
        userData.longitude = longitude
        userData.birthday = birthday
        try! HomeViewController.managedContext.save()
    }
    
    // For Fetching Data in Core Data
    func fetchRecords() -> [UserData]{
        var arrPerson = [UserData]()
        let fetchRequest = NSFetchRequest<UserData>(entityName: "UserData")
        
        do{
            arrPerson  =  try HomeViewController.managedContext.fetch(fetchRequest)//
            
        }catch{
            print(error)
        }
        return arrPerson
    }
    // Set  Annonation on Map
    
    
    func updateLocations() {
      mapView.removeAnnotations(userDataArray)
      let entity = UserData.entity()
      let fetchRequest = NSFetchRequest<UserData>()
      fetchRequest.entity = entity
        userDataArray = try! HomeViewController.managedContext.fetch(fetchRequest)
      mapView.addAnnotations(userDataArray)
    }
 func setAnnonation() {
     
     var locValue:CLLocationCoordinate2D = CLLocationCoordinate2D()

     print("latitude" + "\(locValue.latitude)")
     print("latitude" + "\(locValue.longitude)")


     var pinPoint = [MKPointAnnotation]()

     userDataArray = fetchRecords()
     mapView.removeAnnotations(mapView.annotations)

     //Set Multiple Pins on Map
     for i in 0..<userDataArray.count{
         let annotation = MKPointAnnotation()

         locValue.latitude = userDataArray[i].latitude
         locValue.longitude = userDataArray[i].longitude

         annotation.coordinate = locValue
         mapView.isZoomEnabled = false

         date1 = formatter.string(from: userDataArray[i].birthday!)
//         annotation.title = "\(userDataArray[i].name!.description + "  " +  userDataArray[i].gender!  + "  " +  userDataArray[i].country!.description  )"
//         annotation.subtitle = userDataArray[i].country

         self.mapView.showAnnotations(self.mapView.annotations, animated: true)

         pinPoint.append(annotation)
     }

     mapView.addAnnotations(pinPoint)



     // For Zoom out from Map

     let loc = CLLocationCoordinate2DMake(locValue.latitude,
                                          locValue.longitude)
     let coordinateRegion = MKCoordinateRegion(center: loc,
                                               latitudinalMeters: 4000000, longitudinalMeters: 4000000)
     mapView.setRegion(coordinateRegion, animated: true)
}
 
 
    
    
}

