//
//  ViewController.swift
//  Match! App
//
//  Created by Tassia Paschoal on 12/26/17.
//  Copyright © 2017 Tassia Paschoal. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var countdownLabel: UILabel!
    
    var model = CardModel()
    var cardArray = [Card]()
    var firstFlippedCardIndex:IndexPath?
    var timer:Timer?
    var countdown = 10
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //call the getCards methods of the Card model
        cardArray = model.getCards()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        //set the countdown label
        countdownLabel.text = String(countdown)
        
        //create and schedule timer
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerUpdate), userInfo: nil, repeats: true)
    }
    
    @objc func timerUpdate() {
        countdown -= 1
        
        if countdown == 0 {
            //stop the match game, check if user has matched all cards
            timer?.invalidate()
            
            var userHasMatchedAllCards = true
            for card in cardArray {
                if card.isMatched == false {
                    userHasMatchedAllCards = false
                    break
                }
            }
            
            if userHasMatchedAllCards == true {
                //game is won
            } else{
                //game is lost
            }
            
        }
        
        //update label
        countdownLabel.text = String(countdown)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - UICollectionView Protocol methods

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return cardArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        //Get a CardCollecitonView Cell object
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardCell", for: indexPath) as! CardCollectionViewCell
        
        //Get the card that the collection is trying to display
        let card = cardArray[indexPath.row]
        
        //Set the card for the cell
        cell.setCard(card)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        //check if countdown is zero
        if countdown == 0 {
            return
        }
        
        //Get the cell the user selected
        let cell = collectionView.cellForItem(at: indexPath) as! CardCollectionViewCell
        
        //Get the card that the user selected
        let card = cardArray[indexPath.row]
        
        if card.isFlipped == false && card.isMatched == false {
            
            //flip the card
            cell.flip()
            
            //Set status of the card
            card.isFlipped = true
            
            //Determine if it's the first card of second card that's flipped over
            if firstFlippedCardIndex == nil {
                //This is the first card being flipped
                firstFlippedCardIndex = indexPath
            } else {
                // This is the second card being flipped. Perform matching logic
                checkForMatches(indexPath)
            }
            
        }
    
    }
    
    // MARK: - Game Logic method
    func checkForMatches(_ secondFlippedCardIndex:IndexPath) {
        
        //Get the cells for the two cards that were revealed
        let cardOneCell = collectionView.cellForItem(at: firstFlippedCardIndex!) as? CardCollectionViewCell
        
        let cardTwoCell = collectionView.cellForItem(at: secondFlippedCardIndex) as? CardCollectionViewCell
        
        //Get the cards for the two cards that were revealed
        let cardOne = cardArray[firstFlippedCardIndex!.row]
        let cardTwo = cardArray[secondFlippedCardIndex.row]
        
        //Compare the cards
        if cardOne.imageName == cardTwo.imageName {
            //It's a match. Set the statuses of the cards
            cardOne.isMatched = true
            cardTwo.isMatched = true
        
            //remove the cards from the grid
            cardOneCell?.remove()
            cardTwoCell?.remove()
            
        } else {
            
            //It's not a match. Set the status of the cards
            cardOne.isFlipped = false
            cardTwo.isFlipped = false
            
            //Flip both cards
            cardOneCell?.flipBack()
            cardTwoCell?.flipBack()
            
        }
        
        //Tell the collectionview to reload the cell of the first card if it is nil
        if cardOneCell == nil {
            collectionView.reloadItems(at: [firstFlippedCardIndex!])
        }
        
        //Reset the property that tracks the first card flipped
        firstFlippedCardIndex = nil
        

    }
    
}

