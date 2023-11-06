//
//  Presenter.swift
//  CodingTask
//
//  Created by Denis Aleshyn on 06/11/2023.
//

import Foundation

protocol PresenterProtocol {
    var view: ViewProtocol? { get set }
    var screenItems: [ScreenItemModel] { get }
    
    func start()
}

class Presenter {
    private var dataSource: DataSourceProtocol
    private var items = [ScreenItemModel]()
    
    weak var view: ViewProtocol?
    
    var screenItems: [ScreenItemModel] {
        get {
            return items.filter({ $0.imageParameters?.isHidden == false })
        }
    }

    init(dataSource: DataSourceProtocol) {
        self.dataSource = dataSource
        
        setup()
    }
    
    private func update(_ objects: [ScreenItemModel]) {
        for index in 0..<objects.count {
            let updatedItem = objects[index]
            if let indexOfUpdatedItemInExistingArray = items.firstIndex(of: updatedItem) {
                if updatedItem.imageParameters != nil {
                    items[indexOfUpdatedItemInExistingArray] = updatedItem
                } else {
                    items.remove(at: indexOfUpdatedItemInExistingArray)
                }
            } else {
                items.append(updatedItem)
            }
        }
        view?.reload()
    }
    
    private func fetchAll() {
        Task { @MainActor in
            items = try await dataSource
                .getAll()
            view?.reload()
        }
    }
    
    private func setup() {
        dataSource.onUpdate = { [weak self ] result in
            switch result {
            case .success(let screenItemModels):
                self?.update(screenItemModels)
            case .failure(_):
                print("")
            }
        }
    }
}

extension Presenter: PresenterProtocol {

    func start()  {
           fetchAll()
    }
}

struct ScreenItemModel {
    let key: String
    let imageParameters: ImageParameters?
}

extension ScreenItemModel: Equatable {
    static func == (lhs: ScreenItemModel, rhs: ScreenItemModel) -> Bool {
        return lhs.key == rhs.key
    }
}


extension ScreenItemModel {
    init?(dictionary: [String: Any]?, key: String) {
        if let dict = dictionary,
           let imageUrl = dict[Constants.imageURL] as? String,
           let isHidden = dict[Constants.isHidden] as? Bool {
           self.imageParameters = ImageParameters(url: imageUrl, isHidden: isHidden)
        } else {
            self.imageParameters = nil
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
