//
//  NoBoardViewController.swift
//  FamilyJira
//
//  Created by George Ivannikov on 4/16/20.
//  Copyright © 2020 George Ivannikov. All rights reserved.
//

import Foundation
import UIKit
import Combine
import Toast_Swift

class NoBoardViewController: UIViewController {
    private var noBoardViewModel: NoBoardViewModelProtocol!
    private let noBoardView = NoBoardView()
    private let createBoardPopUp = CreateBoardPopUp()
    private let imagePicker = UIImagePickerController()

    private var subscriptions = Set<AnyCancellable>()

    static func instantiate(
        noBoardViewModel: NoBoardViewModelProtocol
    ) -> NoBoardViewController {
        let viewController: NoBoardViewController = NoBoardViewController()
        viewController.noBoardViewModel = noBoardViewModel
        return viewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpLayout()
        setUpBinds()
        dismissKeyboardAfterTap()
    }

    private func setUpLayout() {
        view.backgroundColor = .backgroundBlue
        navigationItem.setHidesBackButton(true, animated: false)

        view.addSubview(noBoardView)
        noBoardView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        view.addSubview(createBoardPopUp)
        createBoardPopUp.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    private func setUpBinds() {
        noBoardView.createButton
            .publisher(for: .touchUpInside)
            .sink(receiveValue: { [weak self] _ in
                self?.createBoardPopUp.animateIn()
            })
            .store(in: &subscriptions)

        noBoardView.joinButton
            .publisher(for: .touchUpInside)
            .sink(receiveValue: { [weak self] _ in
                self?.noBoardViewModel.joinBoardTapped.send()
            })
            .store(in: &subscriptions)

        createBoardPopUp.createButton
            .publisher(for: .touchUpInside)
            .map { [weak self] _ in
                BoardBasicInfoDTO(name: self?.createBoardPopUp.nameTextField.text,
                                  photoData: self?.createBoardPopUp.boardPhoto.image?.mediumQualityJPEGNSData)
            }
            .sink(receiveValue: { [weak self] in
                self?.view.makeToastActivity(.center)
                self?.noBoardViewModel.createTapped.send($0)
            })
            .store(in: &subscriptions)

        noBoardViewModel.presentError
            .sink(receiveValue: { [weak self] _ in
                self?.view.hideToastActivity()
            })
            .store(in: &subscriptions)

        createBoardPopUp.chooseButton
            .publisher(for: .touchUpInside)
            .sink(receiveValue: { [weak self] _ in
                guard let imagePicker = self?.imagePicker else {
                    return
                }
                imagePicker.delegate = self
                imagePicker.mediaTypes = ["public.image"]
                imagePicker.allowsEditing = false
                self?.present(imagePicker, animated: true, completion: nil)
            })
            .store(in: &subscriptions)
    }
}

extension NoBoardViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    public func imagePickerController(_ picker: UIImagePickerController,
                                      didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        let imageUrl = info[.imageURL] as? NSURL
        let image = UIImage(url: imageUrl)
        createBoardPopUp.boardPhoto.image = image
        dismiss(animated: true, completion: nil)
    }
}
