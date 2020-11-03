//
//  ImageDetailViewController.swift
//  ImageSearch
//
//  Created by Kang Mingu on 2020/11/02.
//

import UIKit

private let CellID = "DetailCell"

class ImageDetailViewController: UIViewController {
    
    // MARK: - Properties
    
    private var imageInfo: Results
    
    lazy var detailImage: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        return iv
    }()
    
    private let siteName: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .white
        label.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        return label
    }()
    
    private let dateTime: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .white
        label.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        return label
    }()
    
    private let exitButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
        btn.imageView?.contentMode = .scaleToFill
        btn.addTarget(self, action: #selector(handleCancel), for: .touchUpInside)
        return btn
    }()
    
    private let scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.maximumZoomScale = 3.0
        sv.alwaysBounceHorizontal = false
        sv.alwaysBounceVertical = false
        return sv
    }()
    
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    init(imageInfo: Results) {
        self.imageInfo = imageInfo
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Selectors
    
    @objc func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
    
    
    // MARK: - Helpers
    
    func configureUI() {
        
        view.backgroundColor = .black
        
        let stack = UIStackView(arrangedSubviews: [siteName, dateTime])
        stack.axis = .vertical
        stack.spacing = 2
        stack.distribution = .fillEqually
        stack.alignment = .center
        
        scrollView.delegate = self
        view.addSubview(scrollView)
        scrollView.addSubview(detailImage)
        view.addSubview(exitButton)
        view.addSubview(stack)
        
        scrollView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor,
                          bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor)
        detailImage.addConstraintsToFillView(scrollView)
        detailImage.centerY(inView: scrollView)
        stack.centerX(inView: view)
        stack.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor)
        exitButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor,
                          paddingTop: 12, paddingLeft: 18)
        
        let viewModel = ImageDetailViewModel(imageInfo: imageInfo, view: view)
        
        detailImage.kf.setImage(with: viewModel.detailImageURL)
        siteName.text = viewModel.siteName
        dateTime.text = viewModel.dateTime
    }

}

// MARK: - UIScrollViewDelegate

extension ImageDetailViewController: UIScrollViewDelegate {
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return detailImage
    }
    
}
