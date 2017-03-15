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
        //failWillCloseTheStream()
        usingMaterialize()
    }

    private func failWillCloseTheStream() {
        let successesCount = Observable
            .of(successButton.rx.tap.map { true }, failureButton.rx.tap.map { false })
            .merge()
            .flatMap { [unowned self] performWithSuccess in
                return self.performAPICall(shouldEndWithSuccess: performWithSuccess)
            }.scan(0) { accumulator, _ in
                return accumulator + 1
            }.map { "\($0)" }

        successesCount.bindTo(successessCountLabel.rx.text)
            .disposed(by: disposeBag)
    }

    private func usingMaterialize() {
        let result = Observable
            .of(successButton.rx.tap.map { true }, failureButton.rx.tap.map { false })
            .merge()
            .flatMap { [unowned self] performWithSuccess in
                return self.performAPICall(shouldEndWithSuccess: performWithSuccess)
                    .materialize()
            }.share()

        result.elements()
            .scan(0) { accumulator, _ in
                return accumulator + 1
            }.map { "\($0)" }
            .bindTo(successessCountLabel.rx.text)
            .disposed(by: disposeBag)

        result.errors()
            .scan(0) { accumulator, _ in
                return accumulator + 1
            }.map { "\($0)" }
            .bindTo(failuresCountLabel.rx.text)
            .disposed(by: disposeBag)
    }

    private func performAPICall(shouldEndWithSuccess: Bool) -> Observable<Void> {
        if shouldEndWithSuccess {
            return .just(())
        } else {
            return .error(SampleError())
        }
    }
}

