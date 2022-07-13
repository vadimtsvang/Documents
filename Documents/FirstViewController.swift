//
//  FirstViewController.swift
//  Documents
//
//  Created by Vadim on 13.07.2022.
//

import UIKit

class FirstViewController: UIViewController {
    
    var manager = FileManagerService()
    
    private var jpegFiles: [Document] = []
    var identifier = String(describing: FirstTableViewCell.self)

    private lazy var tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .plain)
        table.rowHeight = UITableView.automaticDimension
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(FirstTableViewCell.self, forCellReuseIdentifier: identifier)
        configNavBar()
        setupTableView()
        getFiles()
    }

    private func setupTableView() {
        view.backgroundColor = .lightGray
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    private func configNavBar() {
        title = "Documents"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                                            target: self,
                                                            action: #selector(showImagePicker))
    }

    private func getFiles() {
        jpegFiles.removeAll()
        guard let files = manager.getFiles() else { return }

        var atributes = [FileAttributeKey : Any]()
        for file in files {
            do {
                atributes = try FileManager.default.attributesOfItem(atPath: file.path)
            } catch {
                print(error.localizedDescription)
            }
            let image = UIImage(contentsOfFile: file.path)
            let date = atributes[.creationDate]

            jpegFiles.append(Document(image: image ?? UIImage(),
                                      date: String(describing: date),
                                      path: file.path))
        }
    }
}

extension FirstViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return jpegFiles.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? FirstTableViewCell else { return UITableViewCell()}
        cell.configCell(jpegFiles[indexPath.row])
        return cell
    }
}

extension FirstViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let file = jpegFiles[indexPath.row].path

        if editingStyle == .delete {
            manager.remove(file) {
                self.jpegFiles.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
}

extension FirstViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @objc private func showImagePicker() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        present(imagePicker, animated: true)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            manager.createFile(image) {
                self.getFiles()
                self.tableView.reloadData()
            }
        }
        picker.dismiss(animated: true)
    }
}

