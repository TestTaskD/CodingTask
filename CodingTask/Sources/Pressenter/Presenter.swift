//
//  Presenter.swift
//  CodingTask
//
//  Created by Denis Aleshyn on 06/11/2023.
//

import Foundation

protocol PresenterProtocol {
    var view: ViewProtocol? { get set }
    var screenItems: [String] { get }
    
    func start()
}

final class Presenter {
    private var dataSource: DataSourceProtocol
    private var items = [ConfigItemModel]()
    
    weak var view: ViewProtocol?

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
    var screenItems: [String] {
        get {
            return items
                .filter({ $0.image?.isHidden == false })
                .compactMap({ $0.image?.url })
        }
    }
    
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
