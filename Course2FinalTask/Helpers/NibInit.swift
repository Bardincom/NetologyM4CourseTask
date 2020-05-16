//
//  NibInit.swift
//  Course2FinalTask
//
//  Created by Aleksey Bardin on 27.02.2020.
//  Copyright © 2020 Bardincom. All rights reserved.
//

import UIKit

protocol NibInit {}
// swiftlint:disable force_cast
extension NibInit where Self: UIView {

    static func initFromNib() -> Self {
        let nibName = String(describing: Self.self)
        let nib = UINib(nibName: nibName, bundle: nil)
        return nib.instantiate(withOwner: nil, options: nil)[0] as! Self
    }
}

extension NibInit where Self: UIViewController {

    static func initFromNib() -> Self {
        let nibName = String(describing: Self.self)
        return self.init(nibName: nibName, bundle: nil)
    }
}
