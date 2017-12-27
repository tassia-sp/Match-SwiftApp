//
//  CardModel.swift
//  Match! App
//
//  Created by Tassia Paschoal on 12/26/17.
//  Copyright © 2017 Tassia Paschoal. All rights reserved.
//

import Foundation

class CardModel {
    
    func getCards() -> [Card]{
        //Declare an array to store the generated cards
        var generatedCardsArray = [Card]()
        
        //Randomly generate pairs of cards
        for _ in 1...8 {
            let randomNumber = arc4random_uniform(13)+1
            
            //log the number
            print(randomNumber)
            
            //create first card object
            let cardOne = Card()
            cardOne.imageName = "card\(randomNumber)"
            
            generatedCardsArray.append(cardOne)
            
            //create second card object
            let cardTwo = Card()
            cardTwo.imageName = "card\(cardTwo)"
            
            generatedCardsArray.append(cardTwo)
            
            // TODO: Make it so we only have unique sets of cards
        }
        //TODO: Randomize the array
        
        //Return the array
        return generatedCardsArray
    }
}
