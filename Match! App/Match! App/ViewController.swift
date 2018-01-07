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
    
    @IBOutlet weak var timerLabel: UILabel!
    
    var model = CardModel()
    var cardArray = [Card]()
    var firstFlippedCardIndex:IndexPath?
    var timer:Timer?
    var milliseconds:Float = 40 * 1000 //40 seconds
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //call the getCards methods of the Card model
        cardArray = model.getCards()
   
        collectionView.delegate = self
        collectionView.dataSource = self

        //create timer
        timer = Timer.scheduledTimer(timeInterval: 0.001, target: self, selector: #selector(timerElapsed), userInfo: nil, repeats: true)
        RunLoop.main.add(timer!, forMode: .commonModes)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
     
        SoundManager.playSound(.shuffle)
        
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
        
        //check if there is any time left
        if milliseconds <= 0 {
            return
        }
        
        //Get the cell the user selected
        let cell = collectionView.cellForItem(at: indexPath) as! CardCollectionViewCell
        
        //Get the card that the user selected
        let card = cardArray[indexPath.row]
        
        if card.isFlipped == false && card.isMatched == false {
    
            cell.flip()
            
            SoundManager.playSound(.flip)
            
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
            
            SoundManager.playSound(.match)
            
            //set statuses of the cards
            cardOne.isMatched = true
            cardTwo.isMatched = true
            
            //remove the cards from the grid
            cardOneCell?.remove()
            cardTwoCell?.remove()
            
            checkGameEnded()
            
        } else {
            //It's not a match
            
            SoundManager.playSound(.nomatch)
            
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
    
    @objc func timerElapsed() {
        milliseconds -= 1
        
        //convert to seconds
        let seconds = String(format: "%.2f", milliseconds/1000)
        
        //set label
        timerLabel.text = "Time Remaining: \(seconds)"
        
        //stop when timer reaches 0
        if milliseconds <= 0 {
            timer?.invalidate()
            timerLabel.textColor = UIColor.red
            
            //check if there are any cards unmatched
            checkGameEnded()
        }
    }
    
    func checkGameEnded() {
        
        //check if all the pairs have been matched
        var isWon = true
        var title = ""
        var message = ""
        
        for card in cardArray {
            
            if !card.isMatched {
                isWon = false
                break
            }
        }
        
        if isWon {
            
            if milliseconds > 0 {
                timer?.invalidate()
            }
            
                title = "Congratulations"
                message = "You've won"
                
            } else {
            
                if milliseconds > 0 {
                    return
                }
                
                title = "Game Over"
                message = "You've lost"
            }
        
        showAlert(title, message)
        
    }
    
    func showAlert(_ title:String, _ message:String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let alertAction = UIAlertAction(title: "Ok", style: .cancel, handler: {(alert) in self.restart()})
        
        alert.addAction(alertAction)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    func restart() {
        
        cardArray = model.getCards()
        
        milliseconds = 40 * 1000
        
        timer = Timer.scheduledTimer(timeInterval: 0.001, target: self, selector: #selector(timerElapsed), userInfo: nil, repeats: true)
        RunLoop.main.add(timer!, forMode: .commonModes)
        
        SoundManager.playSound(.shuffle)
        
        collectionView.reloadData()
        
    }
    
}

