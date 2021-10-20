
import UIKit

class FeedViewController: UIViewController {
    
    var news = [CellModel]()
    var revealedPosts = [Int]()

    var authenticationService: AuthenticationService!
    let dataFetcher = FeedDataFetcher()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(PostCell.self, forCellReuseIdentifier: PostCell.reuseId)
        tableView.isHidden = false
        return tableView
    }()
    
    override func viewDidAppear(_ animated: Bool) {
        tabBarController?.navigationItem.title = "Новости"
        tabBarController?.navigationController?.isNavigationBarHidden = false
        tabBarController?.navigationController?.hidesBarsOnSwipe = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .white
        tableView.frame = view.bounds
        view.addSubview(tableView)
        view.backgroundColor = .green
        
        dataFetcher.getData { [weak self] response in
            guard let feedResponse = response else { return }
            self?.news = feedResponse
            self?.tableView.reloadData()
        }
    }
    
    private func setupTableView() {
        let topInset: CGFloat = 8
        tableView.contentInset.top = topInset
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
    }
}

extension FeedViewController:  UITableViewDelegate {
    
}

extension FeedViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return news.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PostCell.reuseId, for: indexPath) as! PostCell
        cell.set(viewModel: news[indexPath.row])
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cellViewModel = news[indexPath.row]
        if !cellViewModel.isRevealed, let minifiedHeight = cellViewModel.sizes.minifiedHeight {
            return minifiedHeight
        }
        return cellViewModel.sizes.totalHeight
    }
}

// MARK: PostCellDelegate
extension FeedViewController: PostCellDelegate {
    
    func revealPost(for cell: PostCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        var cellNews = news[indexPath.row]
        cellNews.isRevealed = true
        news[indexPath.row] = cellNews
        tableView.reloadData()
    }
}
