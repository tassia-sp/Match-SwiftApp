//
//  CardCollectionViewCell.swift
//  Match! App
//
//  Created by Tassia Paschoal on 12/26/17.
//  Copyright © 2017 Tassia Paschoal. All rights reserved.
//

import UIKit

class CardCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var frontImageView: UIImageView!
    
    @IBOutlet weak var backImageView: UIImageView!
    
    var card:Card?
    
    func setCard(_ card:Card) {
        self.card = card
        
        if card.isMatched == true {
            //make the iamge views invisible
            backImageView.alpha = 0
            frontImageView.alpha = 0
            return
        } else {
            //Make cards/imageviews visible
            backImageView.alpha = 1
            frontImageView.alpha = 1
        }
        
        frontImageView.image = UIImage(named: card.imageName)
        
        //Determine if the card is in a flipped state or flipped down state
        if card.isFlipped == true {
            //Make sure the front image view is on top
            UIView.transition(from: backImageView, to: frontImageView, duration: 0.3, options: [.transitionFlipFromLeft, .showHideTransitionViews], completion: nil)
        } else {
            //make sure the backImageview is on top
            UIView.transition(from: frontImageView, to: backImageView, duration: 0.3, options: [.showHideTransitionViews, .transitionFlipFromLeft], completion: nil)
        }
        
    }
    
    func flip() {
        
        UIView.transition(from: backImageView, to: frontImageView, duration: 0.3, options: [.transitionFlipFromLeft, .showHideTransitionViews], completion: nil)
        
    }
    
    func flipBack() {
        
        //Delay flip so user notices it
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
            
            UIView.transition(from: self.frontImageView, to: self.backImageView, duration: 0.3, options: [.transitionFlipFromRight, .showHideTransitionViews], completion: nil)
            
        }
        
    }
    
    func remove() {
        
        //Set opacity to 0 to make the card "invisible"
        backImageView.alpha = 0
        frontImageView.alpha = 0
        
        // animate it
        UIView.animate(withDuration: 0.3, delay: 0.4, options: .curveEaseOut,
                       animations: {self.frontImageView.alpha = 0}, completion: nil)
        
    }
    
}
