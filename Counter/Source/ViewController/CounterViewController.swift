//
//  CounterViewController.swift
//  Counter
//
//  Created by Monzy Zhang on 2020/12/8.
//

import UIKit
import AudioToolbox

let countValueUserDefaultsKey = "com.monzy.zhang.Counter.countValue"

class CounterViewController: UIViewController {
    
    private var countdown: Int = 0 {
        didSet {
            countdownTimer?.invalidate()
            countdownTimer = nil
            currentCountdown = countdown
            countdownLabel.text = countdown == 0 ? "" : "\(countdown)"
        }
    }
    private var currentCountdown: Int = 0
    private var countdownTimer: Timer?
    
    private lazy var count: Int = UserDefaults.standard.integer(forKey: countValueUserDefaultsKey) {
        didSet {
            minusButton.isEnabled = count != 0
            resetButton.isEnabled = count != 0
            label.text = "\(count)"
            UserDefaults.standard.setValue(count, forKey: countValueUserDefaultsKey)
            if count == 0 {
                countdown = 0
            }
        }
    }
    
    private lazy var label: UILabel = {
        let view = UILabel()
        view.font = .monospacedDigitSystemFont(ofSize: 100, weight: .ultraLight)
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
        view.setImage(
            UIImage(
                systemName: "plus",
                withConfiguration: UIImage.SymbolConfiguration(pointSize: 50, weight: .thin)
            ),
            for: .normal
        )
        view.onTap = { [weak self] in
            guard let self = self else { return }
            self.impactOccurred(.medium)
            self.count += 1
            self.countdownTimer?.invalidate()
            self.countdownTimer = nil
            if self.countdown > 0 {
                self.currentCountdown = self.countdown
                self.countdownLabel.text = "\(self.currentCountdown)"
                self.countdownTimer = Timer.scheduledTimer(
                    withTimeInterval: 1,
                    repeats: true
                ) { _ in
                    if self.currentCountdown > 1 {
                        self.currentCountdown -= 1
                    } else {
                        // complete countdown
                        AudioServicesPlaySystemSound(1304)
                        self.countdownTimer?.invalidate()
                        self.countdownTimer = nil
                        self.currentCountdown = 0
                    }
                    self.countdownLabel.text = "\(self.currentCountdown)"
                }
            }
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
        view.setImage(
            UIImage(
                systemName: "minus",
                withConfiguration: UIImage.SymbolConfiguration(pointSize: 40, weight: .thin)
            ),
            for: .normal
        )
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
        let img = UIImage(
            systemName: "arrow.clockwise",
            withConfiguration: UIImage.SymbolConfiguration(pointSize: 20, weight: .light)
        )
        view.setImage(img, for: .normal)
        view.showsMenuAsPrimaryAction = true
        view.menu = UIMenu(
            options: [ .displayInline ],
            children: [
                UIAction(title: "reset".localized, attributes: .destructive, handler: { [weak self] _ in
                    self?.impactOccurred(.medium)
                    self?.count = 0
                }),
                UIAction(title: "cancel".localized, handler: { [weak self] _ in
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
    
    private lazy var countdownButton: UIButton = {
        let view = UIButton(type: .system)
        view.tintColor = Color.backgroundInvertion
        let img = UIImage(
            systemName: "clock.arrow.circlepath",
            withConfiguration: UIImage.SymbolConfiguration(pointSize: 20, weight: .light)
        )
        view.setImage(img, for: .normal)
        view.addTarget(
            self,
            action: #selector(countdownButtonPressed),
            for: .touchUpInside
        )
        return view
    }()
    
    private lazy var countdownLabel: UILabel = {
        let view = UILabel()
        view.font = .monospacedDigitSystemFont(ofSize: 40, weight: .ultraLight)
        view.adjustsFontSizeToFitWidth = true
        view.numberOfLines = 1
        view.textAlignment = .center
        view.textColor = Color.backgroundInvertion
        return view
    }()
    
    deinit {
        countdownTimer?.invalidate()
    }
    
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
            countdownButton,
            countdownLabel,
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
            
            countdownButton.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -15),
            countdownButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30),
            
            countdownLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            countdownLabel.centerYAnchor.constraint(equalTo: countdownButton.centerYAnchor),
            
            resetButton.centerYAnchor.constraint(equalTo: countdownButton.centerYAnchor),
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
    
    @objc private func countdownButtonPressed() {
        impactOccurred(.light)
        let alert = UIAlertController(
            title: "",
            message: "countdownMessage".localized,
            preferredStyle: .alert
        )
        alert.addTextField {
            $0.placeholder = "countdownPlaceholder".localized
            $0.keyboardType = .numberPad
        }
        alert.addAction(UIAlertAction(title: "cancel".localized, style: .cancel))
        alert.addAction(UIAlertAction(title: "confirm".localized, style: .default) { [weak alert, self] _ in
            guard let text = alert?.textFields?.first?.text, !text.isEmpty else { return }
            guard let seconds = Int(text), seconds > 0 else { return }
            self.countdown = seconds
        })
        present(alert, animated: true)
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
