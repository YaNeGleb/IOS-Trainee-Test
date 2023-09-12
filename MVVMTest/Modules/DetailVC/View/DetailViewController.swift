import UIKit

class DetailViewController: UIViewController {
    // MARK: - UI Elements
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let previewTextLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let likesCountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Properties
    
    var viewModel: DetailViewModelProtocol
    
    // MARK: - Initialization
    init(viewModel: DetailViewModelProtocol) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
      
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Description"
        view.backgroundColor = .white
        setUpConstraints()
        setUpData()
    }
    
    // MARK: - Public Methods
    func setUpData() {
        let viewModelPost = viewModel.postDetails
        titleLabel.text = viewModelPost.title
        previewTextLabel.text = viewModelPost.text
        likesCountLabel.text = "❤️" + " " + "\(viewModelPost.likesCount)"
        dateLabel.text = Date.dateString(fromTimestamp: viewModelPost.timeshamp)

        viewModel.loadImage { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let image):
                DispatchQueue.main.async {
                    self.imageView.image = image
                }
            case .failure(let error):
                print("Ошибка загрузки изображения: \(error.localizedDescription)")
            }
        }
    }
}

// MARK: - Constraints
extension DetailViewController {
    func setUpConstraints() {
        
        view.addSubview(scrollView)
        scrollView.addSubview(imageView)
        scrollView.addSubview(titleLabel)
        scrollView.addSubview(likesCountLabel)
        scrollView.addSubview(dateLabel)
        scrollView.addSubview(previewTextLabel)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
           ])
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 15),
            imageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 15),
            imageView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -15),
            imageView.heightAnchor.constraint(equalTo: scrollView.heightAnchor, multiplier: 0.3)
           ])
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: imageView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: imageView.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            previewTextLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            previewTextLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            previewTextLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            likesCountLabel.topAnchor.constraint(equalTo: previewTextLabel.bottomAnchor, constant: 20),
            likesCountLabel.leadingAnchor.constraint(equalTo: imageView.leadingAnchor),
            likesCountLabel.widthAnchor.constraint(equalToConstant: 200)

        ])
        
        NSLayoutConstraint.activate([
            dateLabel.topAnchor.constraint(equalTo: likesCountLabel.topAnchor),
            dateLabel.trailingAnchor.constraint(equalTo: imageView.trailingAnchor),
            dateLabel.widthAnchor.constraint(equalToConstant: 200),
            dateLabel.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
        ])
    }
}
