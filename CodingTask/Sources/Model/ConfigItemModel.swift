//
//  ConfigItemModel.swift
//  CodingTask
//
//  Created by Denis Aleshyn on 07/11/2023.
//

import Foundation




protocol Keyable: Equatable {
    var key: String { get set }
}

protocol ConfigImage: Equatable {
    var image: ImageParameters? { get set }
}

typealias ConfigItem = Keyable & ConfigImage

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
