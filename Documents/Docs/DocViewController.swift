//
//  DocViewController.swift
//  Documents
//
//  Created by Vadim on 13.07.2022.
//

import UIKit

class DocViewController: UIViewController {
    
    var manager = FileManagerService()
    
    private var jpegFiles: [Document] = []
    var identifier = String(describing: DocTableViewCell.self)

    private lazy var tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .plain)
        table.rowHeight = UITableView.automaticDimension
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(DocTableViewCell.self, forCellReuseIdentifier: identifier)
        configNavBar()
        setupTableView()
        getFiles()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        sorted()
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
            let name = (file.path as NSString).lastPathComponent.split(separator: "-")[0]
            let size = atributes[.size] ?? 0
            let mb = Float(String(describing: size))! / 1000000
            let formatSize = String(format: "Size: %.2f Mb", mb)

            jpegFiles.append(Document(image: image ?? UIImage(),
                                      name: "\(name).jpg",
                                      size: formatSize,
                                      path: file.path))
        }
    }
    
    private func sorted() {
        if UserDefaults.standard.bool(forKey: "sorted") {
            jpegFiles.sort(by: {$0.name > $1.name })
        } else {
            jpegFiles.sort(by: {$0.name < $1.name })
        }
        tableView.reloadData()
    }
}

extension DocViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return jpegFiles.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? DocTableViewCell else { return UITableViewCell()}
        cell.configCell(jpegFiles[indexPath.row])
        return cell
    }
}

extension DocViewController: UITableViewDelegate {

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

extension DocViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

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

