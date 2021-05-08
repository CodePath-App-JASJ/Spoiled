//
//  FridgeViewController.swift
//  Spoiled
//
//  Created by Ahmed Kaddoura on 4/12/21.
//

import UIKit
import Parse
import NotificationBannerSwift

class FridgeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var ingredientTableView: UITableView!
    var ingredients = [PFObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ingredientTableView.delegate = self
        ingredientTableView.dataSource = self
       
    }
    

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let query = PFQuery(className: "Ingredients")
        query.whereKey("author", equalTo: PFUser.current())
        query.includeKeys(["name", "expiration"])
        query.limit = 20
        
        query.findObjectsInBackground{ (ingredients, error) in
            if ingredients != nil{
                self.ingredients = ingredients!
                self.ingredientTableView.reloadData()
            }
            
        }
        
        let banner = GrowingNotificationBanner(title: "Alert!",
                                        subtitle: "An ingredient is expiring soon.",
                                        leftView: nil,
                                        rightView: nil,
                                        style: .danger,
                                        colors: nil)
        
        banner.autoDismiss = false
        banner.dismissOnTap = true
        banner.show(queuePosition: .front,
                    bannerPosition: .top,
                    queue: .default,
                    on: self)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
            banner.dismiss()
        })
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return ingredients.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            //TODO add implementation
        let ingredient = ingredients[indexPath.section]
        let cell = tableView.dequeueReusableCell(withIdentifier: "IngredientCell") as! IngredientCell
                
                
        //let user = ingredient["author"] as! PFUser
        cell.ingredientName.text = ingredient["name"] as? String
        cell.expirationDate.text = ingredient["expiration"] as? String
                
        return cell
    }
    
    
    @IBAction func addButtonSegue(_ sender: Any) {
        self.performSegue(withIdentifier: "addIngredientSegue", sender: nil)
    }
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

//extension FridgeViewController: UITableViewDelegate {
//
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: IndexPath, animated: true)
//    }
//
//}
//
//extension FridgeViewController: UITableViewDataSource {
//
//}
