//
//  StoryBoard.swift
//

import Foundation
import UIKit



func getController(storyBoard : String , controllerIdentifier : String) -> UIViewController{
    
    print("storyBoard \(storyBoard) controllerIdentifier \(controllerIdentifier) ")
    let story = UIStoryboard(name: storyBoard, bundle: nil)
    let controller = story.instantiateViewController(withIdentifier: controllerIdentifier)
    
    return controller
}
