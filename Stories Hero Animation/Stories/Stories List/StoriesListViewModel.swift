//
//  StoriesListViewModel.swift
//  Stories Hero Animation
//
//  Created by Torear797 on 18.04.2023.
//

import Foundation

final class StoriesListViewModel: ObservableObject {
    
    let stories: [Story] = [
        Story(title: "First", image: URL(string: "https://i.pinimg.com/originals/2d/f1/59/2df159bfe2edbf711b162e1003d5c7bc.jpg")!, index: 0),
        Story(title: "Two", image: URL(string: "https://image.winudf.com/v2/image/bWUud2FsbHBhcGEubmF0dXJlX3NjcmVlbl8xXzE1MzIzNzgxNThfMDE3/screen-1.jpg?fakeurl=1&type=.jpg")!, index: 1),
        Story(title: "Third", image: URL(string: "https://freeterdream.files.wordpress.com/2014/10/img_0846.jpg")!, index: 2)
    ]
}
