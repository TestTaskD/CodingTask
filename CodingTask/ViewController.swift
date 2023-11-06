//
//  ViewController.swift
//  CodingTask
//
//  Created by Denis Aleshyn on 06/11/2023.
//

import UIKit

protocol ViewProtocol: AnyObject {
    func reload()
    func reloadAtIndexPath(_ indexPath: IndexPath)
}

class MainViewController: UIViewController {
    
    private var presenter: PresenterProtocol
    
    init(presenter: PresenterProtocol) {
        self.presenter = presenter
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.view = self
        presenter.start()
    }
}

extension MainViewController: ViewProtocol {
    func reload() {
        
    }
    
    func reloadAtIndexPath(_ indexPath: IndexPath) {
        
    }
}
