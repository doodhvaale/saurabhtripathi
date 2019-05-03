//
//   DataModel.swift
//  Doodhvale
//
//  Created by localadmin on 4/9/19.
//  Copyright © 2019 appzpixel. All rights reserved.
//

import Foundation
class DataModel {
var change  : Int?
var  product : String?

var delivery : String?
var subscriptionvalue: Int?


    init(change: Int!, product: String! ,delivery : String! ,subscriptionvalue : Int!  ) {
    self.change = change
    self.product = product
    self.delivery = delivery
    self.subscriptionvalue = subscriptionvalue
    
   }
}
