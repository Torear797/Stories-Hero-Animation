//
//  StoriesList.swift
//  Stories Hero Animation
//
//  Created by Torear797 on 18.04.2023.
//

import SwiftUI
import Kingfisher

struct StoriesList: View {
    
    let animation: Namespace.ID
    
    @StateObject var viewModel = StoriesListViewModel()
    
    @EnvironmentObject var storiesViewerViewModel: StoriesViewerViewModel
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(viewModel.stories) { story in
                    if !storiesViewerViewModel.isShowViewer ||
                        storiesViewerViewModel.selection != story.index {
                        createStoryItem(story)
                    } else {
                        Color.clear
                    }
                }
            }
            .padding(.horizontal, 16)
        }
        .frame(maxWidth: .infinity)
    }
    
    private func createStoryItem(_ story: Story) -> some View {
        Button {
            storiesViewerViewModel.prepareViewer(
                stories: viewModel.stories,
                selectedIndex: story.index
            )
            
            withAnimation(.easeIn) {
                storiesViewerViewModel.showViewer()
            }
        } label: {
            VStack(alignment: .leading, spacing: 6) {
                KFImage.url(story.image)
                    .resizable()
                    .overlay(
                         RoundedRectangle(cornerRadius: 5)
                             .stroke(.blue, lineWidth: 3)
                     )
                    .clipShape(RoundedRectangle(cornerRadius: 5))
                    .if(!storiesViewerViewModel.isShowViewer && storiesViewerViewModel.selection == story.index) { view in
                        view.matchedGeometryEffect(
                            id: "story_\(story.index)_image",
                            in: animation
                        )
                    } else: { $0 }
                    .frame(width: 60, height: 84)

                Text(story.title)
                    .foregroundColor(.black)
                    .lineLimit(1)
                    .frame(maxWidth: 60)
            }
            .frame(width: 60)
        }
        .buttonStyle(ScaleButtonStyle())
    }
}
