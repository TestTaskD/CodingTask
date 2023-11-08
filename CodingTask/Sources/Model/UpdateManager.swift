//
//  UpdateManager.swift
//  CodingTask
//
//  Created by Denis Aleshyn on 07/11/2023.
//

import Foundation

struct UpdateManager {
   
    func typeOfUpdate(for collection: [ConfigItemModel], itemToUpdate: ConfigItemModel) -> UpdateType<ConfigItemModel>? {
        var type: UpdateType<ConfigItemModel>? = nil
            if // Update condition:
                let indexOfEntryInCollection = collection.firstIndex(of: itemToUpdate),
                itemToUpdate.image != nil
            {
                type = .editing(element: itemToUpdate, atIndex: indexOfEntryInCollection)
            }
            else if // addition condition:
                collection.firstIndex(of: itemToUpdate) == nil,
                // the condition below prevents an obgject of beeing added if it is not included in defaults but just got deleted from config.
                // For inst: remote config has 7 items, the app is alloved to show (and does show) only 6 items
                // Admin deleted 7th item from config. In that case the entry object will have valid key but image field will be nil
                    itemToUpdate.image != nil,
                collection.count <= 5
            {
                type = .addition(element: itemToUpdate)
            }
            else if // deletion condition:
                let indexOfEntryInCollection = collection.firstIndex(of: itemToUpdate),
                itemToUpdate.image == nil
            {
                type = .deletion(atIndex: indexOfEntryInCollection)
            }
        return type
    }
    
    func updated(_ collection: [ConfigItemModel], with newValues: [ConfigItemModel], typeOfUpdate: UpdateType<ConfigItemModel>?) -> [ConfigItemModel] {
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
    
