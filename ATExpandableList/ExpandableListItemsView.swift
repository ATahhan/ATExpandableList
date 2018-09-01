//
//  ExpandableListItemsView.swift
//  CSVA
//
//  Created by Ammar AlTahhan on 10/07/2018.
//  Copyright © 2018 Ammar AlTahhan. All rights reserved.
//

import UIKit

public class ExpandableListItemsView: UIView {
    
    @IBOutlet weak var expandCollapseButton: UIButton!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    @IBOutlet weak var itemsStackView: UIStackView!
    @IBOutlet weak var itemsStackViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak public var sideBarView: UIView!
    @IBOutlet weak var gradientView: UIView!
    
    let COLLAPSED_HEIGHT: CGFloat = 160
    let TWO_ITEMS_HEIGHT: CGFloat = 140
    let ONE_ITEM_HEIGHT: CGFloat = 100
    let ZERO_ITEMS_HEIGHT: CGFloat = 45
    var itemsList: [(String, String)] = [] {
        didSet {
            if itemsList.count < 3 {
                expandCollapseButton.isHidden = true
                gradientView.isHidden = true
            } else {
                expandCollapseButton.isHidden = false
                gradientView.isHidden = false
            }
            addItems()
        }
    }
    private (set) var isCollapsed: Bool!
    var moreTitle: String = "Show More"
    var lessTitle: String = "Show Less"
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    public func setTraits(itemsList: [(String, String)], mainColor: UIColor, moreTitle: String, lessTitle: String) {
        setState(isCollapsed: true)
        expandCollapseButton.setTitleColor(mainColor, for: .normal)
        sideBarView.backgroundColor = mainColor
        itemsStackView.spacing = 8
        heightConstraint.constant = ZERO_ITEMS_HEIGHT
        self.itemsList = itemsList
        self.moreTitle = moreTitle
        self.lessTitle = lessTitle
    }
    
    @IBAction func expandCollapseButtonTapped(_ sender: UIButton) {
        setState(isCollapsed: !isCollapsed)
    }
    
    func addItems() {
        itemsStackView.removeAllArrangedSubviews()
        for item in itemsList {
            let stackView = UIStackView()
            let innerStackView = UIStackView()
            
            let label = UILabel()
            label.text = item.0
            label.textColor = UIColor.greyContent
            label.font = UIFont.systemFont(ofSize: 16)
            stackView.addArrangedSubview(label)
            
            if let progressFloat = Float(item.1) {
                let progress = UIProgressView()
                progress.progress = progressFloat/100
                progress.tintColor = .mainColor
                innerStackView.addArrangedSubview(progress)
                let label = UILabel()
                label.text = "\(Int(progressFloat))%"
                label.textColor = UIColor.mainColor
                label.font = UIFont.systemFont(ofSize: 12)
                label.setContentHuggingPriority(UILayoutPriority.init(rawValue: 249), for: .vertical)
                label.setContentCompressionResistancePriority(UILayoutPriority.init(rawValue: 752), for: .vertical)
                label.addConstraint(NSLayoutConstraint(item: label, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: 40))
                label.textAlignment = .center
                innerStackView.addArrangedSubview(label)
                innerStackView.axis = .horizontal
                innerStackView.spacing = 6
                innerStackView.alignment = .center
                stackView.addArrangedSubview(innerStackView)
            }
            
//            let stackView = UIStackView(arrangedSubviews: [label, progress])
            stackView.axis = .vertical
            stackView.spacing = 3
            itemsStackView.addArrangedSubview(stackView)
            
            if itemsStackViewHeightConstraint != nil {
                if itemsStackView.arrangedSubviews.count == 1 {
                    heightConstraint.constant = ONE_ITEM_HEIGHT
                } else if itemsStackView.arrangedSubviews.count == 2 {
                    heightConstraint.constant = TWO_ITEMS_HEIGHT
                    itemsStackViewHeightConstraint.isActive = true
                    itemsStackViewHeightConstraint.constant = 70
                } else if itemsStackView.arrangedSubviews.count == 3 {
                    heightConstraint.constant = COLLAPSED_HEIGHT
                    itemsStackViewHeightConstraint.isActive = false
                }
            }
        }
    }
    
    //TODO: Send a signal to the controller to scroll its scollView accordingly if the expanded view extends out of screen bounds using delegation
    func setState(isCollapsed: Bool) {
        self.isCollapsed = isCollapsed
        if isCollapsed {
            self.heightConstraint.constant = self.COLLAPSED_HEIGHT
            self.expandCollapseButton.setTitle(moreTitle, for: .normal)
        } else {
            self.heightConstraint.constant = self.COLLAPSED_HEIGHT + (self.itemsStackView.frame.height - self.COLLAPSED_HEIGHT) + 100
            self.expandCollapseButton.setTitle(lessTitle, for: .normal)
        }
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.85, initialSpringVelocity: 0, options: .curveEaseOut, animations: {
            self.layoutIfNeeded()
        }, completion: nil)
    }
    
}
