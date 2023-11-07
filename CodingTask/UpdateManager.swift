//
//  UpdateManager.swift
//  CodingTask
//
//  Created by Denis Aleshyn on 07/11/2023.
//

import Foundation

protocol Updater {
    associatedtype T: Equatable
    func typeOfUpdate(for collection: [T], itemsToUpdate toUpdate: [T]) -> UpdateType<T>?
    func updated(collection: [T], with newValues: [T], typeOfUpdate: UpdateType<T>?) -> [T]
}

struct UpdateManager: Updater {
    typealias T = ConfigItemModel
    
    func typeOfUpdate(for collection: [ConfigItemModel], itemsToUpdate: [ConfigItemModel]) -> UpdateType<ConfigItemModel>? {
        var type: UpdateType<ConfigItemModel>? = nil
        for index in 0..<itemsToUpdate.count {
            let consideredItem = itemsToUpdate[index]
            if // Update condition:
                let indexOfEntryInCollection = collection.firstIndex(of: consideredItem),
                consideredItem.image != nil
            {
                type = .editing(element: consideredItem, atIndex: indexOfEntryInCollection)
            }
            else if // addition condition:
                collection.firstIndex(of: consideredItem) == nil,
                // the condition below prevents an obgject of beeing added if it is not included in defaults but just got deleted from config.
                // For inst: remote config has 7 items, the app is alloved to show (and does show) only 6 items
                // Admin deleted 7th item from config. In that case the entry object will have valid key but image field will be nil
                consideredItem.image != nil,
                collection.count <= 5
            {
                type = .addition(element: consideredItem)
            }
            else if // deletion condition:
                let indexOfEntryInCollection = collection.firstIndex(of: consideredItem),
                consideredItem.image == nil
            {
                type = .deletion(atIndex: indexOfEntryInCollection)
            }
        }
        return type
    }
    
    func updated(collection: [ConfigItemModel], with newValues: [ConfigItemModel], typeOfUpdate: UpdateType<ConfigItemModel>?) -> [ConfigItemModel] {
        guard let typeOfUpdate = typeOfUpdate else { return collection }
        var mutableCollection = collection
        switch typeOfUpdate {
        case .addition(let elementToAdd):
            mutableCollection.append(elementToAdd)
            return mutableCollection
        case .editing(element: let elementToReplace, atIndex: let index):
            mutableCollection[index] = elementToReplace
            return mutableCollection
        case .deletion(atIndex: let index):
            mutableCollection.remove(at: index)
            return mutableCollection
        }
    }
}
    
