//
//  VStack.swift
//  TaxTracker
//
//  Created by Nicholas Wong on 11/17/19.
//  Copyright © 2019 Nicholas Wong. All rights reserved.
//

import UIKit

class VStack: UIStackView {
    init(arrangedSubviews: [UIView], spacing: CGFloat = 0) {
        super.init(frame: .zero)
        arrangedSubviews.forEach({ addArrangedSubview($0) })
        self.axis = .vertical
        self.spacing = spacing
    }

    required init(coder: NSCoder) {
        fatalError()
    }
}
