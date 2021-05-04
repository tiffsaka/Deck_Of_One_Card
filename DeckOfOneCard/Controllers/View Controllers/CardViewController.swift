//
//  CardViewController.swift
//  DeckOfOneCard
//
//  Created by Tiffany Sakaguchi on 5/4/21.
//  Copyright © 2021 Warren. All rights reserved.
//

import UIKit

class CardViewController: UIViewController {

    //MARK: - Outlets
    @IBOutlet weak var cardLabel: UILabel!
    @IBOutlet weak var cardImageView: UIImageView!
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    
    //MARK: - Properties
    
 
    
    //MARK: - Actions
    
    @IBAction func drawButtonTapped(_ sender: UIButton) {
        CardController.fetchCard { (result) in
            
            DispatchQueue.main.async {
                switch result {
                case .success(let card):
                    self.fetchImageAndUpdateViews(for: card)
                case .failure(let error):
                    self.presentErrorToUser(localizedError: error)
                }
            }
        }
    }
    
    //MARK: - Functions
    
    func fetchImageAndUpdateViews(for card: Card) {
        
        CardController.fetchImage(for: card) { (result) in
            
            DispatchQueue.main.async {
                switch result {
                case .success(let image):
                    self.cardImageView.image = image
                    self.cardLabel.text = "\(card.value) of \(card.suit)"
                case .failure(let error):
                    self.presentErrorToUser(localizedError: error)
                }
            }
        }
    }
    
    
    
    

}//End of class

