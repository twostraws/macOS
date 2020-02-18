//
//  StarFormatter.swift
//  Project16
//
//  Created by TwoStraws on 26/10/2016.
//  Copyright © 2016 Paul Hudson. All rights reserved.
//

import Cocoa

class StarFormatter: Formatter {
	override func string(for obj: Any?) -> String {
		if let obj = obj {
			if let number = Int(String(describing: obj)) {
				return String(repeating: "⭐️", count: number)
			}
		}

		return ""
	}
}
