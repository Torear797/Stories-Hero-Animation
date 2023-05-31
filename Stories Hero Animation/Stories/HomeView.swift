//
//  HomeView.swift
//  Stories Hero Animation
//
//  Created by Torear797 on 19.04.2023.
//

import SwiftUI

struct HomeView: View {
    
    @Namespace var storiesHeroAnimation
    
    @StateObject var storiesViewerViewModel = StoriesViewerViewModel()
    
    var body: some View {
        mainView
            .overlay {
                if storiesViewerViewModel.isShowViewer {
                    StoriesViewer(animation: storiesHeroAnimation)
                        .environmentObject(storiesViewerViewModel)
                }
            }
    }
    
    private var mainView: some View {
        VStack {
            StoriesList(animation: storiesHeroAnimation)
                .environmentObject(storiesViewerViewModel)
                .padding(.top, 10)
            
            Text("Home View")
            
            Spacer()
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
