//
//  ViewController.swift
//  CodingTask
//
//  Created by Denis Aleshyn on 06/11/2023.
//

import UIKit

protocol ViewProtocol: AnyObject {
    func reload()
    func reloadAtIndexPath(_ indexPath: [IndexPath])
}

class MainViewController: UIViewController {
    
    private var presenter: PresenterProtocol
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero,collectionViewLayout: ColumnFlowLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.dataSource = self
        collectionView.register(MainScreenCollectionViewCell.self, forCellWithReuseIdentifier: String(describing: MainScreenCollectionViewCell.self))
        return collectionView
    }()
    
    init(presenter: PresenterProtocol) {
        self.presenter = presenter
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    
        presenter.view = self
        presenter.start()
    }
}

extension MainViewController: ViewProtocol {
    func reload() {
        collectionView.reloadData()
    }
    
    func reloadAtIndexPath(_ indexPath: [IndexPath]) {
        collectionView.performBatchUpdates { [weak collectionView] in
            collectionView?.reloadItems(at: indexPath)
        }
    }
}

extension MainViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        presenter.screenItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellViewModel = presenter.screenItems[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: MainScreenCollectionViewCell.self), for: indexPath) as! MainScreenCollectionViewCell
        cell.configureWith(cellViewModel.imageParameters?.url)
        return cell
    }
}





