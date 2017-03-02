//
//  ViewController.swift
//  RxErrorHandling
//
//  Created by Adam Borek on 01.03.2017.
//  Copyright © 2017 Adam Borek. All rights reserved.
//

import UIKit
import RxSwift
import RxSwiftExt
import RxCocoa

struct SampleError: Swift.Error {}

class ViewController: UIViewController {
    let disposeBag = DisposeBag()
    @IBOutlet weak var successessCountLabel: UILabel!
    @IBOutlet weak var failuresCountLabel: UILabel!
    @IBOutlet weak var successButton: UIButton!
    @IBOutlet weak var failureButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let successessCount = Observable
            .of(successButton.rx.tap.map { true }, failureButton.rx.tap.map { false })
            .merge()
            .flatMap { [unowned self] performWithSuccess in
                return self.performAction(shouldEndWithSuccess: performWithSuccess)
            }.scan(0) { accumulator, _ in
                return accumulator + 1
            }.map { "\($0)" }
        
        successessCount.bindTo(successessCountLabel.rx.text)
            .disposed(by: disposeBag)
    }
    
    private func performAction(shouldEndWithSuccess: Bool) -> Observable<Void> {
        if shouldEndWithSuccess {
            return .just(())
        } else {
            return .error(SampleError())
        }
    }
}

