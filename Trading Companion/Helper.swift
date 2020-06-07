//
//  Helper.swift
//  Trading Companion
//
//  Created by owee on 26/05/2020.
//  Copyright © 2020 devios. All rights reserved.
//

import Foundation
import CoreData
import UIKit

extension Array where Element:Equatable {
    
    mutating func update(element:Element) {
        if let index = self.firstIndex(where: {$0 == element}) {
            self.remove(at: index)
            self.insert(element, at: index)
        }
    }
    
    mutating func update(elements:[Element]) {
        elements.forEach({self.update(element: $0)})
    }
}

extension AppDelegate {
    
    static var persistentContainer: NSPersistentContainer {
        return (UIApplication.shared.delegate as! AppDelegate).persistentContainer
    }
    
    static var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    static func saveContext() {
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
    }
}

func load(FileName:String) -> Data {
    
    let fileName        : String
    let fileExtension   : String?

    let tab = FileName.components(separatedBy: ".")

    fileName = tab[0]
    fileExtension = tab.count > 1 ? tab[1] : nil
    
    guard let url = Bundle.main.url(forResource: fileName, withExtension: fileExtension) else {
        fatalError("Could not load \(FileName)")
    }
    
    do {
        let data = try Data(contentsOf: url)
        return data
    } catch let error {
        fatalError("Load data from \(FileName) error -> \(error.localizedDescription)")
    }
}

/// Used for parse dynamic key for json.
struct DynamicKey : CodingKey {
    
    var intValue: Int?
    var stringValue: String

    init?(intValue: Int) {self.intValue = intValue ;self.stringValue = ""}
    init?(stringValue:String){self.stringValue = stringValue}
}

final class Helper {
    
    static func loadData(FileName:String) -> Data {
        
        let fileName        : String
        let fileExtension   : String?

        let tab = FileName.components(separatedBy: ".")

        fileName = tab[0]
        fileExtension = tab.count > 1 ? tab[1] : nil
        
        guard let url = Bundle.main.url(forResource: fileName, withExtension: fileExtension) else {
            fatalError("Could not load \(FileName)")
        }
        
        do {
            let data = try Data(contentsOf: url)
            return data
        } catch let error {
            fatalError("Load data from \(FileName) error -> \(error.localizedDescription)")
        }
    }
    
}
