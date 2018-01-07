//
//  CardModel.swift
//  Match! App
//
//  Created by Tassia Paschoal on 12/26/17.
//  Copyright © 2017 Tassia Paschoal. All rights reserved.
//

import Foundation

@objcMembers
class CardModel: NSObject {
    
    func getCards() -> [Card] {
        
        //declare an array to store number we've already generated
        var generatedNumbersArray = [Int]()
        
        // Declare an array to store the generated cards
        var generatedCardsArray = [Card]()
        
        // Randomly generate pairs of cards
        while generatedNumbersArray.count < 8 {
            
            // Get a random number
            let randomNumber = arc4random_uniform(13) + 1
            
            //ensure that teh random number isn't one we already have
            if generatedNumbersArray.contains(Int(randomNumber)) == false {
                
                // Log the number
                print(randomNumber)
                
                generatedNumbersArray.append(Int(randomNumber))
                
                // Create the first card object
                let cardOne = Card()
                cardOne.imageName = "card\(randomNumber)"
                
                generatedCardsArray.append(cardOne)
                
                // Create the second card object
                let cardTwo = Card()
                cardTwo.imageName = "card\(randomNumber)"
                
                generatedCardsArray.append(cardTwo)
            }
     
        }
        
        // Randomize the array
        
        for i in 0...generatedCardsArray.count-1 {
            //find a random index to swap with
            let randomNumber = Int(arc4random_uniform(UInt32(generatedCardsArray.count)))
            //swap the two cards
            let temporaryStorage = generatedCardsArray[i]
            generatedCardsArray[i]  = generatedCardsArray[randomNumber]
            generatedCardsArray[randomNumber] = temporaryStorage
        }
        
        // Return the array
        return generatedCardsArray
    }
    
}
