//
//  Presenter.swift
//  CodingTask
//
//  Created by Denis Aleshyn on 06/11/2023.
//

import Foundation

protocol PresenterProtocol {
    var view: ViewProtocol? { get set }
    var items: [ScreenItemModel] { get set }
    
    func start()
}

class Presenter {
    private var dataSource: DataSourceProtocol
    
    var items: [ScreenItemModel] = []
    weak var view: ViewProtocol?
    
    
    init(dataSource: DataSourceProtocol) {
        self.dataSource = dataSource
        
        setup()
    }
    
    private func update(_ objects: [ScreenItemModel]) {
        
        
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
        Task {
            items = try await dataSource
                .getAll()
                .filter({ $0.isHidden == false })
            view?.reload()
        }
    }
}

struct ScreenItemModel: Equatable {
    let imageURL: String
    let isHidden: Bool
}

extension ScreenItemModel {
    init?(dictionary: [String: Any]?) {
        guard
            let dict = dictionary,
            let imageUrl = dict["imageURL"] as? String,
            let isHidden = dict["isHidden"] as? Bool
        else { return nil }
             
        self.imageURL = imageUrl
        self.isHidden = isHidden
    }
}
