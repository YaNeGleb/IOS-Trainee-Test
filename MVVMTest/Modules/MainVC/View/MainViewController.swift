import UIKit

class MainViewController: UIViewController {
    
    // MARK: - Properties
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.estimatedRowHeight = 200
        let nib = UINib(nibName: "PostTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "PostTableViewCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private var viewModel: MainViewModelProtocol
    private var sortButton: UIBarButtonItem!
    
    // MARK: - Initialization
    init(viewModel: MainViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Posts"
        view.backgroundColor = .white
        
        setUpTableView()
        setupSortButton()
        fetchPosts()
    }

    // MARK: - Methods
    private func setUpTableView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        configureTableView()
    }
    
    private func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    
    private func fetchPosts() {
        viewModel.fetchPosts {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    private func setupSortButton() {
        let sortButtonImage = UIImage(systemName: "list.bullet")
        sortButton = UIBarButtonItem(image: sortButtonImage, style: .plain, target: self, action: #selector(showSortingOptions))
        navigationItem.rightBarButtonItem = sortButton
    }
    
    @objc private func sortByDate() {
        viewModel.sortPostsByDate()
        tableView.reloadData()
    }
    
    @objc private func sortByRating() {
        viewModel.sortPostsByRating()
        tableView.reloadData()
    }
    
    @objc private func showSortingOptions() {
        let alertController = UIAlertController(title: "Sort Options", message: nil, preferredStyle: .actionSheet)
        
        let sortByDateAction = UIAlertAction(title: "Sort by Date", style: .default) { [weak self] _ in
            self?.sortByDate()
        }
        
        let sortByRatingAction = UIAlertAction(title: "Sort by Rating", style: .default) { [weak self] _ in
            self?.sortByRating()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(sortByDateAction)
        alertController.addAction(sortByRatingAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
}


//MARK: - Extensions
extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfPosts()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostTableViewCell", for: indexPath) as! PostTableViewCell
        cell.configure(with: viewModel.post(at: indexPath.row))
        cell.delegate = self
        cell.moreButtonDelegate = self
        cell.selectionStyle = .none
        cell.tag = indexPath.row
        
        let isExpanded = viewModel.isCellExpanded(at: indexPath.row)
        cell.changeLabel.numberOfLines = isExpanded ? 0 : 2
        cell.myButton.setTitle(isExpanded ? "read less" : "read more", for: .normal)
        return cell
    }
}

//MARK: Extension UITableViewDelegate
extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension

    }
}

//MARK: Extension PostTableViewCellDelegate
extension MainViewController: PostTableViewCellDelegate {
    func didTapButton(in cell: PostTableViewCell) {
        if let indexPath = tableView.indexPath(for: cell) {
            tableView.deselectRow(at: indexPath, animated: true)
            viewModel.toggleCellExpansion(at: indexPath.row)
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
    }
}

//MARK: Extension MoreButtonProtocol
extension MainViewController: MoreButtonProtocol {
    func moreButtonTapped(in cell: PostTableViewCell) {
        if let indexPath = tableView.indexPath(for: cell) {
            viewModel.moreButtonTapped(at: indexPath) { [weak self] result in
                guard let self = self else { return }
                
                switch result {
                case .success(let postDetails):
                    let detailViewController = ModuleBuilder.buildDetailVC(post: postDetails)
                    self.navigationController?.pushViewController(detailViewController, animated: true)
                case .failure(let error):
                    print("Error fetching post details: \(error.localizedDescription)")
                }
            }
        }
    }
}

