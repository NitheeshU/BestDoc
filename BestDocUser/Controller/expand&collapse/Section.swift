//
//  Section.swift
//  BestDocUser
//
//  Created by nitheesh.u on 13/01/18.
//  Copyright © 2018 nitheesh.u. All rights reserved.
//

import Foundation
import UIKit
struct Section{
    var genre:String!
    var movies:[String]!
    var imageD:[UIImage]!
    var expanded: Bool!
    init(genre:String,movies:[String],imageD:[UIImage],expanded:Bool){
        self.genre = genre
        self.movies = movies
        self.imageD = imageD
        self.expanded = expanded
    }
    
}
