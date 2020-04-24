//
//  ProfileViewController.swift
//  FamilyJira
//
//  Created by George Ivannikov on 4/12/20.
//  Copyright © 2020 George Ivannikov. All rights reserved.
//

import Foundation
import UIKit
import Combine
import Photos

class ProfileViewController: UIViewController {
    private var profileViewModel: ProfileViewModelProtocol!
    private let profileView = ProfileView()
    private let doneButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "Done",
                                     style: .plain,
                                     target: self,
                                     action: nil)
        button.action = #selector(doneTapped)
        button.isEnabled = false
        return button
    }()
    private let imagePicker = UIImagePickerController()
    
    private var subscriptions = Set<AnyCancellable>()
    
    static func instantiate(profileViewModel: ProfileViewModelProtocol) -> ProfileViewController {
        let viewController: ProfileViewController = ProfileViewController()
        viewController.profileViewModel = profileViewModel
        return viewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        setupBinds()
        dismissKeyboardAfterTap()
        profileViewModel.viewDidLoad()
    }
    
    private func setupLayout() {
        title = "Profile"
        view.backgroundColor = .backgroundBlue
        
        navigationItem.rightBarButtonItem = doneButton
        
        view.addSubview(profileView)
        profileView.snp.makeConstraints { make in
            make.trailing.leading.bottom.top.equalToSuperview()
        }
    }
    
    private func setupBinds() {
        profileViewModel.user
            .map { $0.username }
            .assign(to: \.text, on: profileView.usernameTextField)
            .store(in: &subscriptions)
        
        profileViewModel.user
            .compactMap { $0.photoData as Data? }
            .map { UIImage(data: $0) }
            .assign(to: \.image, on: profileView.profilePhoto)
            .store(in: &subscriptions)
        
        profileViewModel.user
            .map { $0.role }
            .assign(to: \.text, on: profileView.roleTextField)
            .store(in: &subscriptions)
        
        profileViewModel.choosenPhoto
            .assign(to: \.image, on: profileView.profilePhoto)
            .store(in: &subscriptions)
        
        profileViewModel.presentError
            .sink(receiveValue: { [weak self] _ in
                self?.view.hideToastActivity()
            })
            .store(in: &subscriptions)
        
        Publishers.Merge3(NotificationCenter.default.publisher(for: UITextField.textDidChangeNotification,
                                                               object: profileView.usernameTextField),
                         NotificationCenter.default.publisher(for: UITextField.textDidChangeNotification,
                                                              object: profileView.roleTextField),
                         profileViewModel.choosenPhoto
                            .map { _ in NotificationCenter.Publisher.Output(name: .profileImagePickedDismissed) })
            .withLatestFrom(profileViewModel.user)
            .map { [weak self] in
                $0.username != self?.profileView.usernameTextField.text ||
                    $0.role != self?.profileView.roleTextField.text ||
                    $0.photoData as Data? != self?.profileView.profilePhoto.image?.pngData()
            }
            .assign(to: \.isEnabled, on: doneButton)
            .store(in: &subscriptions)
        
        profileView.chooseButton
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
    
    @objc func doneTapped(sender: UIBarButtonItem) {
        view.makeToastActivity(.center)
        let profileDTO = ProfileDTO(username: profileView.usernameTextField.text,
                                    role: profileView.roleTextField.text,
                                    photoData: profileView.profilePhoto.image?.mediumQualityJPEGNSData)
        profileViewModel.doneTapped.send(profileDTO)
    }
}

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    public func imagePickerController(_ picker: UIImagePickerController,
                                      didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        let imageUrl = info[.imageURL] as? NSURL
        
        let image = UIImage(url: imageUrl)
        profileViewModel.choosenPhoto.send(image)
        dismiss(animated: true, completion: nil)
    }
}
