//
//  TableViewCell.swift
//  ToDoList
//
//  Created by Kamil Biktineyev on 24.08.2024.
//

import UIKit

protocol TableViewCellDelegate: AnyObject {
    var isEditingTitle: Bool { get set }
    func updateCellSize()
    func changeStatusOfToDoItem(id: UUID)
    func saveToDoItemChanges(id: UUID, title: String)
    func showEmptyTitleAlert(indexPath: IndexPath)
}

final class TableViewCell: UITableViewCell {
    
    static let reuseIdentifier = "ToDoListTableViewCell"
    var id: UUID!
    var isCompleted: Bool! {
        didSet {
            updateIsCompletedButton()
            updateTitle()
        }
    }
    var cellIndexPath: IndexPath!
    weak var delegate: TableViewCellDelegate?
   
    private lazy var title: UITextView = {
        let textView = UITextView()
        textView.delegate = self
        textView.isScrollEnabled = false
        textView.textColor = .black
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.textContainer.lineFragmentPadding = 0
        textView.textContainerInset = UIEdgeInsets.zero
        textView.textAlignment = .left
        textView.isEditable = true
        textView.isSelectable = true
        textView.autocorrectionType = .no
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    private lazy var dateOfCreation: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.font = UIFont(name: "Arial", size: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var isCompletedButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(isCompletedButtonTapped), for: .touchUpInside)
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupIsCompletedButton()
        setupTitle()
        setupDateOfCreation()
    }
    
    // Этот инициализатор обязателен при использовании кастомных инициализаторов
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Определяем метод, который позволяет настроить расположение и размер подвидов ячейки
    override func layoutSubviews() {
        super.layoutSubviews()
        setupCellSize()
    }
    
    // MARK: Определяем метод, который обнуляет ячейку перед повторным использованием
    override func prepareForReuse() {
        super.prepareForReuse()
        isCompleted = false
        title.text = ""
    }
    
    // Определяем метод, который изменяет форму ячейки (contentView)
    private func setupCellSize() {
        contentView.layer.cornerRadius = 5
        contentView.layer.masksToBounds = true
        contentView.layer.borderWidth = 1.0
        contentView.layer.borderColor = UIColor.white.cgColor
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 2.5, left: 5, bottom: 2.5, right: 5))
    }
    
    // Обновляем внешний вид isCompletedButton при нажатии
    private func updateIsCompletedButton() {
        let image = isCompleted ? "checkmark.circle.fill" : "circle.dashed"
        isCompletedButton.setImage(UIImage(systemName: image), for: .normal)
        let color: UIColor = isCompleted ? .purple : .gray
        isCompletedButton.tintColor = color
    }
    
    // Определяем действие при отпускании кнопки isCompletedButton
    @objc private func isCompletedButtonTapped() {
        isCompleted.toggle()
        delegate?.changeStatusOfToDoItem(id: id)
    }
    
    // Обновляем внешний вид title при нажатии isCompletedButton
    private func updateTitle() {
        let font = UIFont.systemFont(ofSize: 16)
        let attributedString = NSMutableAttributedString(string: title.text, attributes: [.font: font])
        if isCompleted {
            attributedString.addAttribute(.strikethroughStyle, value: NSUnderlineStyle.single.rawValue, range: NSMakeRange(0, attributedString.length))
            title.isEditable = false
        } else {
            attributedString.removeAttribute(.strikethroughStyle, range: NSMakeRange(0, attributedString.length))
            title.isEditable = true
        }
        title.attributedText = attributedString
    }
    
    // Проверяем что title ячейки не пустой
    func isTitleNotEmpty() -> Bool {
        let trimmedText = title.text.trimmingCharacters(in: .whitespacesAndNewlines)
        return !trimmedText.isEmpty
    }
    
    // Определяем метод для пердачи данных в TableViewCell
    func configureCell(id: UUID, title: String, dateOfCreation: String, isCompleted: Bool, cellIndexPath: IndexPath) {
        self.id = id
        self.title.text = title
        self.dateOfCreation.text = dateOfCreation
        self.isCompleted = isCompleted
        self.cellIndexPath = cellIndexPath
    }
    
    // Фокусировка на title
    func focusTitle() {
        title.becomeFirstResponder()
    }

    // Определяем располжение isCompletedButton
    private func setupIsCompletedButton() {
        contentView.addSubview(isCompletedButton)
        NSLayoutConstraint.activate([
            isCompletedButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            isCompletedButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            isCompletedButton.widthAnchor.constraint(equalToConstant: 23),
            isCompletedButton.heightAnchor.constraint(equalToConstant: 23)
        ])
    }
    
    // Определяем располжение title
    private func setupTitle() {
        contentView.addSubview(title)
        NSLayoutConstraint.activate([
            title.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            title.leadingAnchor.constraint(equalTo: isCompletedButton.trailingAnchor, constant: 10),
            title.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10)
        ])
    }
    
    // Определяем располжение dateOfCreation
    private func setupDateOfCreation() {
        contentView.addSubview(dateOfCreation)
        NSLayoutConstraint.activate([
            dateOfCreation.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 5),
            dateOfCreation.leadingAnchor.constraint(equalTo: isCompletedButton.trailingAnchor, constant: 10),
            dateOfCreation.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            dateOfCreation.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5)
        ])
    }
    
}

extension TableViewCell: UITextViewDelegate {
    // Вызывается каждый раз, когда текст внутри UITextView изменяется
    func textViewDidChange(_ textView: UITextView) {
        delegate?.updateCellSize()
    }
    
    // Вызывается каждый раз как только пользователь начал изменять UITextView
    func textViewDidBeginEditing(_ textView: UITextView) {
        delegate?.isEditingTitle = true
    }
    
    // Вызывается каждый раз как только пользователь завершил изменять UITextView
    func textViewDidEndEditing(_ textView: UITextView) {
        delegate?.isEditingTitle = false
        
        if isTitleNotEmpty() {
            delegate?.saveToDoItemChanges(id: id, title: textView.text)
        } else {
            delegate?.showEmptyTitleAlert(indexPath: cellIndexPath)
        }
    }
    
    // Определяем метод, который убирает клавиатуру при нажатии на кнопку return
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
}
