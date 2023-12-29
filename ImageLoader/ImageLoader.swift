import Foundation
import Combine
import SwiftUI

import DataLoader

public protocol ImageLoading {
    func loadImage(for url: URL) -> AnyPublisher<UIImage, Error>
}

enum ImageLoaderError: Error {
    case imageDecodingError
}

public final class ImageLoader: ImageLoading {
    private let dataLoader: DataLoader
    
    public init(dataLoader: DataLoader) {
        self.dataLoader = dataLoader
    }
    
    public func loadImage(for url: URL) -> AnyPublisher<UIImage, Error> {
        dataLoader.loadData(for: url)
            .tryMap {
                guard let image = UIImage(data: $0 ) else {
                    throw ImageLoaderError.imageDecodingError
                }
                return image
            }
            .eraseToAnyPublisher()
    }
    
    #if DEBUG
    private struct ImageLoaderFake: ImageLoading {
        enum PreviewError: Error {
            case unimplemented
        }
        func loadImage(for url: URL) -> AnyPublisher<UIImage, Error> {
            Fail(error: PreviewError.unimplemented)
                .eraseToAnyPublisher()
        }
    }
    public static var fake: ImageLoading { ImageLoaderFake() }
    #endif
}
