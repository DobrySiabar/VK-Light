/*
import UIKit

private let reuseIdentifier = "Cell"

class PhotoGridPostCollectionView: UICollectionView, LayoutForRowDelegate {
    func collectionView(_ collectionView: UICollectionView, photoAtIndexPath indexPath: IndexPath) -> CGSize {
        guard let width = photo?.width, let height = photo?.height else { return CGSize.zero }
        return CGSize(width: width, height: height)
    }
    
    var photo: PostCellPhotoAttachementViewModel?
    
    init() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let rowLayout = LayoutForRow()
        super.init(frame: .zero, collectionViewLayout: rowLayout)
        delegate = self
        dataSource = self
        
        backgroundColor = .black
        register(PhotoGridPostCollectionViewCell.self, forCellWithReuseIdentifier: PhotoGridPostCollectionViewCell.reuseId)
        
        if let rowLayout = collectionViewLayout as? LayoutForRow {
            rowLayout.delegate = self
        }
    }
    
    func set(photos: [PostCellPhotoAttachementViewModel]) {
        guard let photo = photos.first else { return }
        self.photo = photo
        contentOffset = .zero
        reloadData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension PhotoGridPostCollectionView: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.width, height: frame.height)
    }
}

extension PhotoGridPostCollectionView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = dequeueReusableCell(withReuseIdentifier: PhotoGridPostCollectionViewCell.reuseId, for: indexPath) as! PhotoGridPostCollectionViewCell
        cell.set(imageUrl: photo?.photoUrlString)
        cell.layoutIfNeeded()
        return cell
    }
}
*/
