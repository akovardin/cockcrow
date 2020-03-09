//
// Created by Artem Kovardin on 26.01.2020.
// Copyright (c) 2020 Artem Kovardin. All rights reserved.
//

import Foundation
import UIKit

class Style {
    public enum Colors {

        public static let label: UIColor = {
            if UIScreen.main.traitCollection.userInterfaceStyle == .dark {
                return UIColor(red: 0.933, green: 0.914, blue: 0.914, alpha: 1)
            }
            return UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        }()

        public static let background: UIColor = {
            if UIScreen.main.traitCollection.userInterfaceStyle == .dark {
                return UIColor(red: 0.138, green: 0.119, blue: 0.119, alpha: 0.92)
            }
            return UIColor(red: 0.933, green: 0.914, blue: 0.914, alpha: 1)
        }()

        public static let white: UIColor = {
            if UIScreen.main.traitCollection.userInterfaceStyle == .dark {
                return .white
            }
            return .white
        }()

        public static let black: UIColor = {
            if UIScreen.main.traitCollection.userInterfaceStyle == .dark {
                return .black
            }
            return .black
        }()

        public static let disable: UIColor = {
            if UIScreen.main.traitCollection.userInterfaceStyle == .dark {
                return .gray
            }
            return UIColor(red: 0.692, green: 0.692, blue: 0.692, alpha: 1)
        }()

        public static let red: UIColor = {
            return UIColor(red: 0.742, green: 0.372, blue: 0.164, alpha: 1)
        }()
    }
}