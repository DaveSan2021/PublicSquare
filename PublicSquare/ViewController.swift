//
//  ViewController.swift
//  PublicSquare
//
//  Created by Dave Sanyal on 3/20/23.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, RatingViewControllerDelegate {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    @IBOutlet weak var enterratinglabel: UILabel!
    //connection to the table view in the first page
    @IBOutlet weak var tableView: UITableView!
    
    private var models = [Location]()
    var tempData = [
        (title: "North Diner", imageName: "icons8-star-filled-48", textRating: "4/5"),
        (title: "Cortez", imageName: "icons8-star-filled-48", textRating: "3/5"),
        (title: "South Campus Diner", imageName: "icons8-star-filled-48 1", textRating: "3.5/5")]
    
    var managedObjectContext: NSManagedObjectContext!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        //setting row height to accommodate the custom cells
        let nib = UINib(nibName: "CustomTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "CustomTableViewCell")
        
        deleteEntireStore()
        printStore()
        initData()
        printStore()
        /*
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.frame = view.bounds
         */
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 98
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return models.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        print("row selected")
        
        let cell = tableView.cellForRow(at: indexPath) as! CustomTableViewCell
        
        let ratingView = RatingViewController()
        ratingView.currentRatingName = cell.titleLabel.text
        
        ratingView.delegate = self
        present(ratingView, animated: true)
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomTableViewCell", for: indexPath) as! CustomTableViewCell
        
        let item = models[indexPath.row]
        
        let wholeNumbers = Int(floor(item.avgrating))
        print(wholeNumbers)
        
        let hasHalf = (item.avgrating - Double(wholeNumbers)) == 0.5
        
        print(hasHalf)
        
        cell.titleLabel.text = item.name
        
        let imageInputs = assignImages(wholes: wholeNumbers, half: hasHalf)
        
        cell.firstImageView.image = UIImage(named: imageInputs[0])
        cell.secondImageView.image = UIImage(named: imageInputs[1])
        cell.thirdImageView.image = UIImage(named: imageInputs[2])
        cell.forthImageView.image = UIImage(named: imageInputs[3])
        cell.fifthImageView.image = UIImage(named: imageInputs[4])
        
        cell.textRating.text = String(item.avgrating)
        
        return cell
    }
    
    func assignImages (wholes: Int, half: Bool) -> [String]{
        
        var toReturn = Array(repeating: "icons8-star-empty-48", count: 5)
        
        for i in 0..<wholes {
            toReturn[i] = "icons8-star-filled-48"
        }
        
        if wholes < 5 && half {
            toReturn[wholes] = "icons8-star-half-empty-48"
        }
            
        return toReturn
    }
    
    //registers the nib file where I created my custom cell
        
    @IBAction func ReloadButton(_ sender: Any) {
        print("Reloading table view")
        
        ratingViewControllerDidDismiss()
    }
    
    func initData() {
        
        let location1 = Location(context: context)
        location1.name = "251 North Diner"
        location1.avgrating = 0.0
        location1.totalratings = 0
        
        let location2 = Location(context: context)
        location2.name = "Yahentamitsi"
        location2.avgrating = 0.0
        location2.totalratings = 0
        
        let location3 = Location(context: context)
        location3.name = "South Campus Diner"
        location3.avgrating = 0.0
        location3.totalratings = 0
        
        do {
            try context.save()
        }
        catch {
            print("error saving")
        }
        
        models = [location1, location2, location3]
    }
    
 
    func getAllLocations() {
        do {
            models = try context.fetch(Location.fetchRequest())
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        catch {
            print("Error")
        }
    }
    
    func createLocation(name: String) {
        let newLocation = Location(context: context)
        newLocation.name = name
        
        do {
            try context.save()
        }
        catch {
            print("error saving")
        }
    }
    
    func deleteLocation(loc: Location) {
        context.delete(loc)
        
        do {
            try context.save()
        }
        catch {
            print("error deleting")
        }
    }
    
    func updateLocation(item: Location, newName: String) {
        item.name = newName
        
        do {
            try context.save()
        }
        catch {
            print("error updating")
        }
    }
    
    func deleteEntireStore () {
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Location")
        
        do {
            let result = try context.fetch(fetchRequest)
                for data in result as! [NSManagedObject] {
                    context.delete(data)
                }
        }
        catch {
            print("Failed")
        }
    }
    
    func printStore () {
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Location")
        
        do {
            let result = try context.fetch(fetchRequest)
                for data in result as! [NSManagedObject] {
                    for (key, _) in data.entity.attributesByName {
                        let attributeValue = data.value(forKey: key)
                        print("\(key): \(attributeValue ?? "nil")")
                    }
                }
            let count = try context.count(for: fetchRequest)
            print("Number of entities: \(count)")
        }
        catch {
            print("Failed")
        }
    }
    
    func ratingViewControllerDidDismiss() {
        
        let request = NSFetchRequest<Location>(entityName: "Location")
        do {
            models = try context.fetch(request)
        } catch {
            print("Error fetching data: \(error)")
        }
        tableView.reloadData()
    }
}

