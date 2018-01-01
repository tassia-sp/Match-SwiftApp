//
//  CardModel.swift
//  Match! App
//
//  Created by Tassia Paschoal on 12/26/17.
//  Copyright © 2017 Tassia Paschoal. All rights reserved.
//

import Foundation

class CardModel: NSObject {
    
    func getCards() -> [Card] {
        
        // Declare an array to store the generated cards
        var generatedCardsArray = [Card]()
        
        // Randomly generate pairs of cards
        for _ in 1...8 {
            
            // Get a random number
            let randomNumber = arc4random_uniform(13) + 1
            
            // Log the number
            print(randomNumber)
            
            // Create the first card object
            let cardOne = Card()
            cardOne.imageName = "card\(randomNumber)"
            
            generatedCardsArray.append(cardOne)
            
            // Create the second card object
            let cardTwo = Card()
            cardTwo.imageName = "card\(randomNumber)"
            
            generatedCardsArray.append(cardTwo)
            
        }
        
        // Randomize the array
        for index in 0...generatedCardsArray.count - 1 {
            //
            let randomNumber = Int(arc4random_uniform(UInt32(generatedCardsArray.count)))
            
            let randomCard = generatedCardsArray[randomNumber]
            
            generatedCardsArray[randomNumber] = generatedCardsArray[index]
            generatedCardsArray[index] = randomCard
            
        }
        
        // Return the array
        return generatedCardsArray
    }
    
}
