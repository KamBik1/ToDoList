//
//  ToDoListViewController.swift
//  ToDoList
//
//  Created by Kamil Biktineyev on 23.08.2024.
//

import UIKit

protocol ToDoListViewControllerProtocol: AnyObject {
    func reloadToDoList()
    func addToDoItemWithAnimation()
    func deleteToDoItemWithAnimation(row: Int)
    func presentAlert(alert: UIAlertController)
    func focusOnCell(indexPath: IndexPath)
}

final class ToDoListViewController: UIViewController, ToDoListViewControllerProtocol {
    
    private lazy var toDoListItemsTableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(TableViewCell.self, forCellReuseIdentifier: TableViewCell.reuseIdentifier)
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        tableView.backgroundColor = .freshPurple
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private lazy var addToDoButton: UIButton = {
        let button = UIButton()
        button.setTitle("Add task", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .purple
        button.layer.cornerRadius = 5
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(addToDoButtonTouched), for: .touchDown)
        button.addTarget(self, action: #selector(addToDoButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var navBarDoneButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(navBarDoneButtonTapped))
        button.tintColor = .clear
        return button
    }()
    
    var isEditingTitle: Bool = false {
        didSet {
            if isEditingTitle {
                addToDoButton.backgroundColor = .gray
                navBarDoneButton.tintColor = .purple
            } else {
                addToDoButton.backgroundColor = .purple
                navBarDoneButton.tintColor = .clear
            }
        }
    }
    
    var presenter: ToDoListPresenterProtocol
    
    init(presenter: ToDoListPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    // Этот инициализатор обязателен при использовании кастомных инициализаторов
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackgroundColor()
        createNavigationBar()
        setupAddToDoButton()
        setupToDoListItemsTableView()
        setupKeyboardNotification()
        fetchAPIToDoItems()
    }
    
    private func setupBackgroundColor() {
        view.backgroundColor = .freshPurple
    }
    
    private func fetchAPIToDoItems() {
        presenter.fetchAPIToDoItems()
    }
    
    // Определяем внешний вид NavigationBar
    private func createNavigationBar() {
        title = "Your things to do"
        navigationItem.rightBarButtonItem = navBarDoneButton
    }
    
    // Добавляем NoteViewController в центр сообщений как наблюдателя за сообщениями о появлении и исчезновении клавиатуры
    private func setupKeyboardNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(moveToDoListUp), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(moveToDoListDown), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // Определяем метод для поднятия контента ToDoList при появлении клавиатуры
    @objc private func moveToDoListUp(notification: NSNotification) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        let keyboardHeight = keyboardFrame.height
        let contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardHeight, right: 0)
        toDoListItemsTableView.contentInset = contentInset
        toDoListItemsTableView.scrollIndicatorInsets = contentInset
    }
    
    // Определяем метод для опускания ToDoList при исчезновении клавиатуры
    @objc private func moveToDoListDown(notification: NSNotification) {
        let contentInset = UIEdgeInsets.zero
        toDoListItemsTableView.contentInset = contentInset
        toDoListItemsTableView.scrollIndicatorInsets = contentInset
    }
    
    // Определяем действие при нажатии кнопки addToDoButton
    @objc private func addToDoButtonTouched() {
        if isEditingTitle {
        } else {
            addToDoButton.alpha = 0.8
        }
    }
    
    // Определяем действие при отпускании кнопки addToDoButton
    @objc private func addToDoButtonTapped() {
        if isEditingTitle {
        } else {
            addToDoButton.alpha = 1
            presenter.addToDoItem()
        }
    }
    
    // Определяем действие при нажатии кнопки navBarDoneButton
    @objc private func navBarDoneButtonTapped() {
        view.endEditing(true)
    }
    
    // Фокусируемся на нужной ячейке
    func focusOnCell(indexPath: IndexPath) {
        if let cell = self.toDoListItemsTableView.cellForRow(at: indexPath) as? TableViewCell {
            cell.focusTitle()
        }
    }
    
    func reloadToDoList() {
        toDoListItemsTableView.reloadData()
    }
    
    func addToDoItemWithAnimation() {
        let indexPath = IndexPath(row: 0, section: 0)
        toDoListItemsTableView.insertRows(at: [indexPath], with: .top)
        toDoListItemsTableView.scrollToRow(at: indexPath, at: .top, animated: true)
        focusOnCell(indexPath: indexPath)
    }
    
    func deleteToDoItemWithAnimation(row: Int) {
        let indexPath = IndexPath(row: row, section: 0)
        toDoListItemsTableView.deleteRows(at: [indexPath], with: .left)
    }
    
    func presentAlert(alert: UIAlertController) {
        present(alert, animated: true, completion: nil)
    }
    
    // Определяем располжение AddTaskButton
    private func setupAddToDoButton() {
        view.addSubview(addToDoButton)
        NSLayoutConstraint.activate([
            addToDoButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5),
            addToDoButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5),
            addToDoButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -5),
            addToDoButton.heightAnchor.constraint(equalToConstant: 45)
        ])
    }
    
    // Определяем располжение ToDoListItemsTableView
    private func setupToDoListItemsTableView() {
        view.addSubview(toDoListItemsTableView)
        NSLayoutConstraint.activate([
            toDoListItemsTableView.topAnchor.constraint(equalTo: addToDoButton.bottomAnchor, constant: 3),
            toDoListItemsTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            toDoListItemsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            toDoListItemsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0)
        ])
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
}

extension ToDoListViewController: UITableViewDataSource, UITableViewDelegate{
    // Определяем количество строк в таблице
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.countItemsInToDoList()
    }
    
    // Определяем как будет выглядеть ячейка таблицы
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = toDoListItemsTableView.dequeueReusableCell(withIdentifier: TableViewCell.reuseIdentifier, for: indexPath) as! TableViewCell
        let cellData = presenter.fetchToDoItems()[indexPath.row]
        cell.configureCell(id: cellData.id, title: cellData.title, dateOfCreation: cellData.dateOfCreationString, isCompleted: cellData.isCompleted, cellIndexPath: indexPath)
        cell.delegate = self
        cell.selectionStyle = .none
        cell.backgroundColor = .clear
        cell.contentView.backgroundColor = .white
        return cell
    }
    
    // Определяем возможность удаления ячейки из таблицы
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            presenter.deleteToDoItem(index: indexPath.row)
        }
    }
    
}

extension ToDoListViewController: TableViewCellDelegate {
    
    // Обновляем размеры ячейки после изменения размеров title
    func updateCellSize() {
        toDoListItemsTableView.beginUpdates()
        toDoListItemsTableView.endUpdates()
    }
    
    // Изменяем статус выполнено/не выполнено в ячейке
    func changeStatusOfToDoItem(id: UUID) {
        presenter.changeStatusOfToDoItem(id: id)
    }
    
    // Сохраняем изменения title в ячейке
    func saveToDoItemChanges(id: UUID, title: String) {
        presenter.saveToDoItemChanges(id: id, title: title)
    }
    
    func showEmptyTitleAlert(indexPath: IndexPath) {
        let alertTitle = "Error"
        let alertMessage = "The title cannot be empty"
        presenter.showEmptyTitleAlert(title: alertTitle, message: alertMessage, indexPath: indexPath)
    }
}
