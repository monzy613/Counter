//
//  CounterViewController.swift
//  Counter
//
//  Created by Monzy Zhang on 2020/12/8.
//

import UIKit

let countValueUserDefaultsKey = "com.monzy.zhang.Counter.countValue"

class CounterViewController: UIViewController {
    
    private lazy var count: Int = UserDefaults.standard.integer(forKey: countValueUserDefaultsKey) {
        didSet {
            minusButton.isEnabled = count != 0
            resetButton.isEnabled = count != 0
            label.text = "\(count)"
            UserDefaults.standard.setValue(count, forKey: countValueUserDefaultsKey)
        }
    }
    
    private lazy var label: UILabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 100, weight: .ultraLight)
        view.adjustsFontSizeToFitWidth = true
        view.numberOfLines = 2
        view.textAlignment = .center
        view.text = "\(count)"
        view.textColor = Color.backgroundInvertion
        return view
    }()
    
    private lazy var plusButton: OvalButton = {
        let view = OvalButton(type: .system)
        view.backgroundColor = Color.plus
        view.setImage(UIImage(named: "plus"), for: .normal)
        view.onTap = { [weak self] in
            self?.impactOccurred(.medium)
            self?.count += 1
        }
        return view
    }()
    
    private lazy var minusButtonBackgroundView: OvalButton = {
        let view = OvalButton(type: .system)
        view.backgroundColor = Color.background
        return view
    }()
    
    private lazy var minusButton: OvalButton = {
        let view = OvalButton(type: .system)
        view.isEnabled = count != 0
        view.backgroundColor = Color.red
        view.setImage(UIImage(named: "minus"), for: .normal)
        view.onTap = { [weak self] in
            guard let self = self else { return }
            guard self.count - 1 >= 0 else { return }
            self.impactOccurred(.light)
            self.count -= 1
        }
        return view
    }()
    
    private lazy var resetButton: UIButton = {
        let view = UIButton(type: .system)
        view.isEnabled = count != 0
        view.tintColor = Color.backgroundInvertion
        view.setImage(UIImage(named: "reset"), for: .normal)
        view.showsMenuAsPrimaryAction = true
        view.menu = UIMenu(
            options: [ .displayInline ],
            children: [
                UIAction(title: "Reset", attributes: .destructive, handler: { [weak self] _ in
                    self?.impactOccurred(.medium)
                    self?.count = 0
                }),
                UIAction(title: "Cancel", handler: { [weak self] _ in
                    self?.impactOccurred(.medium)
                }),
            ]
        )
        view.addAction(
            .init { [weak self] _ in
                self?.impactOccurred(.light)
            },
            for: .menuActionTriggered
        )
        return view
    }()
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension CounterViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
    }
    
    private func setupViews() {
        view.backgroundColor = Color.background
        [
            label,
            resetButton,
            plusButton,
            minusButtonBackgroundView,
            minusButton
        ].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        view.addConstraints([
            label.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 15),
            label.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -15),
            label.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 15),
            label.bottomAnchor.constraint(equalTo: plusButton.topAnchor, constant: -15),
            
            resetButton.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -15),
            resetButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -30),
            
            plusButton.heightAnchor.constraint(equalTo: plusButton.widthAnchor),
            plusButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 270 / 375),
            plusButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            plusButton.bottomAnchor.constraint(equalTo: resetButton.topAnchor, constant: -50),
            
            minusButtonBackgroundView.heightAnchor.constraint(equalTo: minusButtonBackgroundView.widthAnchor),
            minusButtonBackgroundView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 110 / 375),
            minusButtonBackgroundView.bottomAnchor.constraint(equalTo: plusButton.bottomAnchor),
            minusButtonBackgroundView.rightAnchor.constraint(equalTo: plusButton.rightAnchor),
            
            minusButton.heightAnchor.constraint(equalTo: minusButton.widthAnchor),
            minusButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 100 / 375),
            minusButton.centerXAnchor.constraint(equalTo: minusButtonBackgroundView.centerXAnchor),
            minusButton.centerYAnchor.constraint(equalTo: minusButtonBackgroundView.centerYAnchor),
        ])
    }
    
    private func impactOccurred(_ style: UIImpactFeedbackGenerator.FeedbackStyle) {
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.prepare()
        generator.impactOccurred()
    }
    
}

extension CounterViewController {
    
    class OvalButton: UIButton {
        
        var onTap: (() -> Void)?
        
        override init(frame: CGRect) {
            super.init(frame: frame)
         
            addTarget(self, action: #selector(onTapped(_:forEvent:)), for: .touchUpInside)
            tintColor = Color.background
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        override func layoutSubviews() {
            super.layoutSubviews()
            
            layer.cornerRadius = self.bounds.width / 2
        }
        
        @objc private func onTapped(_ sender: UIControl, forEvent event: UIEvent) {
            onTap?()
        }
        
    }
    
}
