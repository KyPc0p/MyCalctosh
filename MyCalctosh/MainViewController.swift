//
//  ViewController.swift
//  MyCalctosh
//
//  Created by Артём Харченко on 05.09.2022.
//

import UIKit

protocol MainViewControllerDeleagte: AnyObject {
    func numButtonPressed(withValue value: String)
    func operationPressed(withTag tag: Int)
    func clearButtonPressed()
    func dotButtonPressed()
}

class MainViewController: UIViewController {

    var firstNumber: Double = 0
    var secondNumber: Double = 0 //???? что это
    var perfomMath = false
    var currentOperation: Operation?
    var operationIsActive = false
    
    enum Operation {
        case add, subtract, miltiply, devide
    }
    
    lazy var titleLabel = createTitle(text: "Calculator", size: 60, color: .white)
    private lazy var titleRect = createView(backColor: .black, borderColor: UIColor.white.cgColor)
    private lazy var patternView = createView(backColor: .systemGray4, borderColor: UIColor.clear.cgColor, cRadius: 15)
    private lazy var resultView = createView(backColor: .white, borderColor: UIColor.black.cgColor)
    private lazy var resultLabel = createTitle(text: "0", size: 45, color: .black)
    private let numPadView = NumPadView()
    
    //MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setConstraints()
        numPadView.mainVCDelegate = self
    }
    
    //MARK: - Methods
    private func setupViews(){
        view.backgroundColor = .black
        view.addSubview(titleLabel)
        view.addSubview(titleRect)
        view.addSubview(patternView)
        patternView.addSubview(resultView)
        resultView.addSubview(resultLabel)
        patternView.addSubview(numPadView)
    }

    private func createView(backColor: UIColor, borderColor: CGColor, cRadius: CGFloat = 0) -> UIView {
        let view = UIView()
        view.backgroundColor = backColor
        view.layer.borderColor = borderColor
        view.layer.borderWidth = 3
        view.layer.cornerRadius = cRadius
        return view
    }
    
    private func createTitle(text: String = "", size: CGFloat, color: UIColor) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = UIFont(name: "sysfont", size: size)
        label.textColor = color
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.7
        label.textAlignment = .right
        return label
    }
}

//MARK: - MainViewControllerDeleagte
extension MainViewController: MainViewControllerDeleagte {
    func numButtonPressed(withValue value: String) {
        
        //проблема в проверке, он видит что не 0 и ДОБАВЛЯЕТ символы к строке
        
        
        if resultLabel.text == "0" {
            resultLabel.text = value //печатает 1 новый символ
        } else if let text = resultLabel.text {
            resultLabel.text = "\(text)\(value)" //печать с объединением старых символов
        }

        print("Нажата кнопка \(resultLabel.text!)")
    }
    
    func operationPressed(withTag tag: Int) {
        var interTag = tag
        if let text = resultLabel.text, let value = Double(text), firstNumber == 0 {
            firstNumber = value
            resultLabel.text = "0"
        } else {
            interTag = 0
            print("tag изменен и операция перешла на =")
        }
        
        if interTag == 0 {
            if let operation = currentOperation {
                if let text = resultLabel.text, let value = Double(text) {
                    secondNumber = value
                }
                switch operation {
                case .devide:
                    resultLabel.text = "\(firstNumber / secondNumber)"
                    
                    interTag = tag
                case .miltiply:
                    resultLabel.text = "\(firstNumber * secondNumber)"
                    
                    interTag = tag
                case .subtract:
                    resultLabel.text = "\(firstNumber - secondNumber)"

                    interTag = tag
                case .add:
                    resultLabel.text = "\(firstNumber + secondNumber)"
                    
                    interTag = tag
                }
            }
        }else if interTag == 1 {
            currentOperation = .devide
        }else if interTag == 2 {
            currentOperation = .miltiply
        }else if interTag == 3 {
            currentOperation = .subtract
        }else if interTag == 4 {
            currentOperation = .add
        }
        
        print("нажата операция \(currentOperation),f \(firstNumber), sec \(secondNumber), в окне выведено \(resultLabel.text!) ")
    }
    
    func dotButtonPressed() {
        if resultLabel.text == "0" {
            resultLabel.text = "0."
        } else if let text = resultLabel.text {
            resultLabel.text = "\(text)."
        }
    }
    
    func clearButtonPressed() {
        resultLabel.text = "0"
        currentOperation = nil
        firstNumber = 0
        secondNumber = 0
    }
}

//MARK: - Constraints Adjusting
extension MainViewController {
    
    func setConstraints() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15),
            titleLabel.leadingAnchor.constraint(greaterThanOrEqualTo: titleRect.trailingAnchor, constant: 25),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -45),
            titleLabel.heightAnchor.constraint(equalToConstant: 70)
        ])
        
        titleRect.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleRect.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor, constant: -3),
            titleRect.heightAnchor.constraint(equalTo: titleLabel.heightAnchor, multiplier: 0.6),
            titleRect.widthAnchor.constraint(equalTo: titleRect.heightAnchor),
            titleRect.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
        ])
        
        patternView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            patternView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            patternView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            patternView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            patternView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        resultView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            resultView.topAnchor.constraint(equalTo: patternView.topAnchor, constant: 25),
            resultView.leadingAnchor.constraint(equalTo: patternView.leadingAnchor, constant: 35),
            resultView.trailingAnchor.constraint(equalTo: patternView.trailingAnchor, constant: -40),
            resultView.bottomAnchor.constraint(equalTo: patternView.topAnchor, constant: 110)
        ])
        
        resultLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            resultLabel.topAnchor.constraint(equalTo: resultView.topAnchor, constant: 25),
            resultLabel.leadingAnchor.constraint(equalTo: resultView.leadingAnchor, constant: 15),
            resultLabel.trailingAnchor.constraint(equalTo: resultView.trailingAnchor, constant: -15),
            resultLabel.bottomAnchor.constraint(equalTo: resultView.bottomAnchor, constant: -20)
        ])
        
        numPadView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            numPadView.topAnchor.constraint(equalTo: resultView.bottomAnchor, constant: 20),
            numPadView.leadingAnchor.constraint(equalTo: patternView.leadingAnchor, constant: 40),
            numPadView.trailingAnchor.constraint(equalTo: patternView.trailingAnchor, constant: -45),
            numPadView.bottomAnchor.constraint(equalTo: patternView.bottomAnchor, constant: -50)
        ])
    }
}
