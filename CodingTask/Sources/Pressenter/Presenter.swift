//
//  Presenter.swift
//  CodingTask
//
//  Created by Denis Aleshyn on 06/11/2023.
//

import Foundation

public protocol PresenterProtocol {
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
    
    func update(_ objects: [ConfigItemModel]) {
        let updateManager = UpdateManager()
        for index in 0..<objects.count {
            let consideredItem = objects[index]
            let updateType = updateManager.typeOfUpdate(for: items, itemToUpdate: consideredItem)
            items = updateManager.updated(items, with: objects, typeOfUpdate: updateType)
        }
        view?.reload()
    }
    
    private func setup() {
        dataSource.onConfigUpdate = { [weak self ] result in
            switch result {
            case .success(let screenItemModels):
                self?.update(screenItemModels)
            case .failure(let error):
                self?.view?.show(error)
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
                view?.reload()
            } catch {
                view?.show(error)
            }
        }
    }
}
