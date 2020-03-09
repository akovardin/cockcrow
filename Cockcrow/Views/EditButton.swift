//
// Created by Artem Kovardin on 26.01.2020.
// Copyright (c) 2020 Artem Kovardin. All rights reserved.
//

import Foundation
import UIKit

class EditButton: UIButton {
    override func layoutSubviews() {
        super.layoutSubviews()
        if imageView != nil {
            imageView?.frame = CGRect(x: bounds.width/2 - 17, y: 13, width: 34, height: 16)
            titleLabel?.frame = CGRect(x: bounds.width/2 - 94, y: 31, width: 188, height: 31)
            titleLabel?.textAlignment = .center
        }
    }
}