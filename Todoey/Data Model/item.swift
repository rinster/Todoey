//
//  item.swift
//  Todoey
//
//  Created by Erine Natnat on 9/17/18.
//  Copyright © 2018 Erine Natnat. All rights reserved.
//

import Foundation

class Item : Codable {
    var title: String = ""
    //by default items will start off as not being not - so false
    var done: Bool = false
}
