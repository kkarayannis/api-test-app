import Combine
import Foundation
import SwiftUI

import ImageLoader

final class ImageLoaderFake: ImageLoading {
    var image = UIImage(systemName: "heart")!
    func loadImage(for url: URL) -> AnyPublisher<UIImage, Error> {
        Just(image)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}
