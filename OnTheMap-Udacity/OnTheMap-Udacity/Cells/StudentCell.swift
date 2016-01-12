//
//  studentCell.swift
//  OnTheMap-Udacity
//
//  Created by Daniela Velasquez on 1/12/16.
//  Copyright © 2016 Mahisoft. All rights reserved.
//

import UIKit

class StudentCell: UITableViewCell {

    @IBOutlet weak var studentFullname: UILabel!
    @IBOutlet weak var studentLink: UILabel!
    
    class var identifier: String { return String.className(self) }
    
    func setup(student: StudentLocationObject){
        
        //Set cell.studentFullname with student.fullname()
        studentFullname.text = student.fullname()
        
        //Set name
        studentLink.text = student.mediaURL
    }

    
}
