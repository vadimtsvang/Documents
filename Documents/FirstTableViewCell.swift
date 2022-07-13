//
//  FirstTableViewCell.swift
//  Documents
//
//  Created by Vadim on 13.07.2022.
//

import UIKit

class FirstTableViewCell: UITableViewCell {

    private lazy var image: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        return image
    }()

    private lazy var dateCreated: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .semibold)
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViewElements()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViewElements() {
        contentView.addSubviews(image, dateCreated)

        NSLayoutConstraint.activate([
            image.topAnchor.constraint(equalTo: contentView.topAnchor),
            image.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            image.widthAnchor.constraint(equalToConstant: 100),
            image.heightAnchor.constraint(equalTo: image.widthAnchor),

            dateCreated.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            dateCreated.leadingAnchor.constraint(equalTo: image.trailingAnchor, constant: 10),
            dateCreated.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
        ])
    }

    func configCell(_ file: Document) {
        image.image = file.image
        dateCreated.text = Date.formatedDate(file.date)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

extension UIView {
    func addSubviews(_ views: UIView...) {
        views.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview($0)
        }
    }
}

extension Date {
    static func formatedDate(_ dateString: String) -> String {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "dd.MM.yyyy"

        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "dd.MM.yyyy"

        let date: Date? = dateFormatterGet.date(from: dateString)
        print(dateFormatterPrint.string(from: date ?? Date()))
        return dateFormatterPrint.string(from: date ?? Date())
    }
}
