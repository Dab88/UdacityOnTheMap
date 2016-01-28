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
    
    func setup(student: StudentInformation){
        
        //Set cell.studentFullname
        var fullname:String = student.firstName != nil ? student.firstName! + " " : ""
        fullname = student.lastName != nil ? fullname + student.lastName! : ""
        studentFullname.text = fullname
        
        //Set name
        studentLink.text = student.mediaURL
    }

    
}
