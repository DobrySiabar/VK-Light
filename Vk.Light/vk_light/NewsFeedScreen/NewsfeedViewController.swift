import UIKit

protocol NewsfeedDisplayLogic: AnyObject {
    func displayData(viewModel: Newsfeed.Model.ViewModel.ViewModelData)
}

class NewsfeedViewController: UIViewController, NewsfeedDisplayLogic, NewsfeedCodeCellDelegate {
    
    var interactor: NewsfeedBusinessLogic?
    var router: (NSObjectProtocol & NewsfeedRoutingLogic)?
    
    // MARK: Private vaiables
    
    private var newsfeedViewModel = NewsfeedViewModel.init(cells: [], footerTitle: nil)
    
    private var titleView = TitleView()
    private lazy var footerView = FooterView()
    
    private var refreshControl: UIRefreshControl = {
       let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        return refreshControl
    }()
    
    // MARK: Outlets
    
    @IBOutlet weak var newsfeedTableView: UITableView!
    
    // MARK: Setup
    
    private func setup() {
        let viewController        = self
        let interactor            = NewsfeedInteractor()
        let presenter             = NewsfeedPresenter()
        let router                = NewsfeedRouter()
        viewController.interactor = interactor
        viewController.router     = router
        interactor.presenter      = presenter
        presenter.viewController  = viewController
        router.viewController     = viewController
    }
    
    // MARK: Routing
    
    
    // MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupTableView()
        setupTopBars()
        
        interactor?.makeRequest(request: Newsfeed.Model.Request.RequestType.getNewsfeed)
        interactor?.makeRequest(request: Newsfeed.Model.Request.RequestType.getUser)
    }
    
    private func setupTableView() {
        let topInset: CGFloat = 8
        newsfeedTableView.contentInset.top = topInset
        
        newsfeedTableView.register(UINib(nibName: "NewsfeedCell", bundle: nil), forCellReuseIdentifier: NewsfeedCell.reuseId)
        newsfeedTableView.register(NewsfeedCodeCell.self, forCellReuseIdentifier: NewsfeedCodeCell.reuseId)
        
        newsfeedTableView.separatorStyle = .none
        newsfeedTableView.backgroundColor = .clear
        
        newsfeedTableView.addSubview(refreshControl)
        newsfeedTableView.tableFooterView = footerView
    }
    
    private func setupTopBars() {
        self.navigationController?.hidesBarsOnSwipe = true
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationItem.titleView = titleView
    }
    
    @objc private func refresh() {
        interactor?.makeRequest(request: Newsfeed.Model.Request.RequestType.getNewsfeed)
    }
    
    func displayData(viewModel: Newsfeed.Model.ViewModel.ViewModelData) {
        
        switch viewModel {
        case .displayNewsfeed(let newsfeedViewModel):
            self.newsfeedViewModel = newsfeedViewModel
            footerView.setTitle(newsfeedViewModel.footerTitle)
            newsfeedTableView.reloadData()
            refreshControl.endRefreshing()
        case .displayUser(let userViewModel):
            titleView.set(userViewModel: userViewModel)
        case .displayFooterLoader:
            footerView.showLoader()
        }
    }
    
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView.contentOffset.y > scrollView.contentSize.height / 1.1 {
            interactor?.makeRequest(request: Newsfeed.Model.Request.RequestType.getNextBatch)
        }
    }
    
    // MARK: NewsfeedCodeCellDelegate
    
    func revealPost(for cell: NewsfeedCodeCell) {
        guard let indexPath = newsfeedTableView.indexPath(for: cell) else { return }
        let cellViewModel = newsfeedViewModel.cells[indexPath.row]
        interactor?.makeRequest(request: Newsfeed.Model.Request.RequestType.revealPostIds(postId: cellViewModel.postId))
    }
    
}

extension NewsfeedViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("count \(newsfeedViewModel.cells.count)")
        return newsfeedViewModel.cells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell = tableView.dequeueReusableCell(withIdentifier: NewsfeedCell.reuseId, for: indexPath) as! NewsfeedCell
        let cell = tableView.dequeueReusableCell(withIdentifier: NewsfeedCodeCell.reuseId, for: indexPath) as! NewsfeedCodeCell
        let cellViewModel = newsfeedViewModel.cells[indexPath.row]
        cell.set(viewModel: cellViewModel)
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cellViewModel = newsfeedViewModel.cells[indexPath.row]
        return cellViewModel.sizes.totalHeight
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        let cellViewModel = newsfeedViewModel.cells[indexPath.row]
        return cellViewModel.sizes.totalHeight
    }
}
