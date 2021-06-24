//
//  RatingControl.swift
//  myPlaces
//
//  Created by Артем Хребтов on 05.06.2021.
//

import UIKit

@IBDesignable class RatingControl: UIStackView {
    
    //MARK: Properties
    
    private var ratigButtons = [UIButton]()
    var rating = 0 {
        didSet {
            updateButtonSelectionState()
        }
    }
    
    @IBInspectable var starSize: CGSize = CGSize(width: 44.0, height: 44.0){
        didSet {
            setupButtons()
        }
    }
    @IBInspectable var starCount: Int = 5{
        didSet {
            setupButtons()
        }
    }
    
    
    //MARK: Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButtons()
    }
    required init(coder: NSCoder) {
        super.init(coder: coder)
        setupButtons()
    }
    
    //MARK: Button action
    @objc func ratindButtonTapped(button: UIButton){
        guard let index = ratigButtons.firstIndex(of: button) else { return }
        //Calculat the rating
        let selectedRating = index + 1
        if selectedRating == rating {
            rating = 0
        } else {
            rating = selectedRating
        }
        
    }
    //MARK: Private buttons
    private func setupButtons() {
        //Create button
        for button in ratigButtons {
            removeArrangedSubview(button)
            button.removeFromSuperview()
        }
        ratigButtons.removeAll()
        //Load button image
        let bundle = Bundle(for: type(of: self))
        let filledStar = UIImage(named: "filledStar", in: bundle, compatibleWith: self.traitCollection)
        let emptyStar = UIImage(named: "emptyStar", in: bundle, compatibleWith: self.traitCollection)
        let highlightedStar = UIImage(named: "highlightedStar", in: bundle, compatibleWith: self.traitCollection)
        
        for _ in 0..<starCount {
            let button = UIButton()
            
            button.setImage(emptyStar, for: .normal)
            button.setImage(filledStar, for: .selected)
            button.setImage(highlightedStar, for: .highlighted)
            button.setImage(highlightedStar, for: [.highlighted,.selected])
            
            
            
            //Add constraint
            button.translatesAutoresizingMaskIntoConstraints = false
            button.heightAnchor.constraint(equalToConstant: starSize.height).isActive = true
            button.widthAnchor.constraint(equalToConstant: starSize.width).isActive = true
            //Button action
            button.addTarget(self, action: #selector(ratindButtonTapped(button:)), for: .touchUpInside)
            
            //Add button to the stack
            addArrangedSubview(button)
            ratigButtons.append(button)
        }
        updateButtonSelectionState()
    }
    private func updateButtonSelectionState() {
        for (index, button) in ratigButtons.enumerated() {
            button.isSelected = index < rating
        }
    }
}
