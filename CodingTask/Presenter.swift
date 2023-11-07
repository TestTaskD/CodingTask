//
//  Presenter.swift
//  CodingTask
//
//  Created by Denis Aleshyn on 06/11/2023.
//

import Foundation

protocol PresenterProtocol {
    var view: ViewProtocol? { get set }
    var screenItems: [ConfigItemModel] { get }
    
    func start()
}

final class Presenter {
    private var dataSource: DataSourceProtocol
    private var items = [ConfigItemModel]()
    
    weak var view: ViewProtocol?
    
    var screenItems: [ConfigItemModel] {
        get {
            return items.filter({ $0.image?.isHidden == false })
        }
    }

    init(dataSource: DataSourceProtocol) {
        self.dataSource = dataSource
        
        setup()
    }
    
    private func update(_ objects: [ConfigItemModel]) {
        let updateManager = UpdateManager()
        let updateType = updateManager.typeOfUpdate(for: items, itemsToUpdate: objects)
        items = updateManager.updated(collection: items, with: objects, typeOfUpdate: updateType)
        view?.reload()
    }
    
    private func setup() {
        dataSource.onConfigUpdate = { [weak self ] result in
            switch result {
            case .success(let screenItemModels):
                self?.update(screenItemModels)
            case .failure(_):
                print("")
            }
        }
    }
}

extension Presenter: PresenterProtocol{

    func start()  {
        Task { @MainActor in
            do {
                items = try await dataSource.getAll()
                print("Conficg fetched")
                items.forEach({
                    print("item key recieved: \($0.key)")
                })
                view?.reload()
            } catch {
                print("error: \(error)")
            }
            
        }
    }
}

struct ConfigItemModel: ConfigItem {
    var key: String
    var image: ImageParameters?
}

extension ConfigItemModel: Equatable {
    static func == (lhs: ConfigItemModel, rhs: ConfigItemModel) -> Bool {
        return lhs.key == rhs.key
    }
}


extension ConfigItemModel {
    init?(dictionary: [String: Any]?, key: String) {
        if let dict = dictionary,
           let imageUrl = dict[Constants.imageURL] as? String,
           let isHidden = dict[Constants.isHidden] as? Bool {
           self.image = ImageParameters(url: imageUrl, isHidden: isHidden)
        } else {
            self.image = nil
        }
        self.key = key
    }
    
    private enum Constants {
        static let imageURL = "imageURL"
        static let isHidden = "isHidden"
    }
}

struct ImageParameters {
    let url: String
    let isHidden: Bool
}

protocol Keyable: Equatable {
    var key: String { get set }
}

protocol ConfigImage: Equatable {
    var image: ImageParameters? { get set }
}

typealias ConfigItem = Keyable & ConfigImage

protocol Updater {
    associatedtype T: Equatable
    func typeOfUpdate(for collection: [T], itemsToUpdate toUpdate: [T]) -> UpdateType<T>?
    func updated(collection: [T], with newValues: [T], typeOfUpdate: UpdateType<T>?) -> [T]
   
}

enum UpdateType<T> {
    case addition(element:T), editing(element:T, atIndex: Array.Index ), deletion(atIndex: Array.Index )
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
    
