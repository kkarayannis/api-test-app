import Combine
import SwiftUI

import ImageLoader

struct CoverView: View {
    private let viewModel: CoverViewModel
    @State private var image: UIImage? = nil
    
    init(viewModel: CoverViewModel) {
        self.viewModel = viewModel
        
        image = nil
        viewModel.load()
    }
    
    var body: some View {
        Group {
            if let image {
                Image(uiImage: image)
                    .resizable()
                    .shadow(radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
            } else {
                Color.gray
            }
        }
        .aspectRatio(0.67, contentMode: .fit)
        .onReceive(viewModel.$image) {
            image = $0
        }
    }
}

final class CoverViewModel {
    let url: URL?
    private let imageLoader: ImageLoading
    
    @Published var image: UIImage?
    private var cancellable: Cancellable?
    
    init(url: URL?, imageLoader: ImageLoading) {
        self.url = url
        self.imageLoader = imageLoader
    }
    
    func load() {
        guard let url else {
            return
        }
        cancellable = imageLoader.loadImage(for: url)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in }, receiveValue: { [weak self] in
                self?.image = $0
            })
    }
    
    #if DEBUG
    static var example: Self {
        self.init(url: URL(string: "https://covers.openlibrary.org/b/id/8167231-S.jpg")!, imageLoader: ImageLoader.fake)
    }
    #endif
}
