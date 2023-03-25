//
//  RatingViewController.swift
//  PublicSquare
//
//  Created by Dave Sanyal on 3/24/23.
//

import UIKit
import CoreData

protocol RatingViewControllerDelegate: AnyObject {
    func ratingViewControllerDidDismiss()
}


class RatingViewController: UIViewController {
    
    weak var delegate: RatingViewControllerDelegate?
    
    var currentRatingName: String?
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    @IBOutlet weak var ratingNumber: UILabel!
    @IBOutlet weak var ratingSlider: UISlider!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBAction func closeTouchUp(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = "Select a rating for \(currentRatingName ?? "nil")"
        // Do any additional setup after loading the view.
    }
    
    @IBAction func sliderChanged(_ sender: UISlider) {
        let value = round(sender.value * 2) / 2
        
        ratingNumber.text = "\(value)"
    }
    
    @IBAction func touchSubmitButton(_ sender: Any) {
        
        let sliderValue = Double(ratingNumber.text ?? "0.0")
        print(sliderValue!)
        
        let request = NSFetchRequest<Location>(entityName: "Location")
        request.predicate = NSPredicate(format: "name == %@", currentRatingName!)
        
        do {
            
            let result = try context.fetch(request)
            print(result.count)
            if let entity = result.first {
                
                print(entity.totalratings)
                
                if entity.totalratings == 0 {
                    entity.avgrating = sliderValue ?? 0.0
                    print("Avg rating changed")
                    entity.totalratings += 1
                }
                else {
                    
                    var totalOfAll = entity.avgrating * Double(entity.totalratings)
                    totalOfAll += sliderValue ?? 0.0
                    entity.totalratings += 1
                    
                    totalOfAll /= Double(entity.totalratings)
                    entity.avgrating = roundToNearestHalf(number: totalOfAll)
                   
                }
                
                try context.save()
                
                print(entity.avgrating)
            }
            else {
                print("Entity not found")
            }
        }
        catch {
            print("Error fetching entity: \(error)")
        }
        
        
        let alert = UIAlertController(title: "Submitted Successfully!", message: nil, preferredStyle: .alert)

        let okayAction = UIAlertAction(title: "OK", style: .default) { action in
            // dismiss the alert when the user taps "OK"
            alert.dismiss(animated: true, completion: nil)
            self.dismiss(animated: true, completion: {
                self.delegate?.ratingViewControllerDidDismiss()
            })
        }

        alert.addAction(okayAction)

        present(alert, animated: true, completion: nil)
    }
    
    func roundToNearestHalf(number: Double) -> Double {
        return round(number * 2) / 2
    }
}
