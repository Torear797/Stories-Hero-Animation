//
//  StoriesViewer.swift
//  Stories Hero Animation
//
//  Created by Torear797 on 17.04.2023.
//

import SwiftUI
import Kingfisher

struct StoriesViewer: View {
    
    let animation: Namespace.ID
    
    @EnvironmentObject var viewModel: StoriesViewerViewModel
    
    var body: some View {
        GeometryReader { proxy -> AnyView in
            viewModel.viewSize = proxy.size
            return AnyView(generateContent(proxy: proxy))
        }
        .ignoresSafeArea()
        .background(.black.opacity(viewModel.dragOffsetY > viewModel.inaccuracy ? 0 : 1))
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private func generateContent(proxy: GeometryProxy) -> some View {
        HStack(spacing: 0.0) {
            ForEach(viewModel.stories) { story in
                KFImage.url(story.image)
                    .resizable()
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .matchedGeometryEffect(
                        id: "story_\(story.index)_image",
                        in: animation
                    )
                    .frame(width: proxy.size.width, height: proxy.size.height)
                    .scaleEffect(viewModel.itemScaling(story), anchor: .center)
                    .offset(x: viewModel.itemOffset(story))
                    .opacity(viewModel.itemOpacity(story))
            }
        }
        .frame(
            width: proxy.size.width,
            height: proxy.size.height,
            alignment: .leading
        )
        .offset(x: viewModel.offset)
        .scaleEffect(viewModel.viewerScaling())
        .gesture(dragGesture)
        .animation(.default, value: viewModel.offset)
    }
    
    private func closeViewer() {
        withAnimation() {
            viewModel.closeViewer()
        }
    }
    
    // MARK: - Drag Gesture
    
    var dragGesture: some Gesture {
        DragGesture()
            .onChanged(dragChanged)
            .onEnded(dragEnded)
    }
    
    private func dragChanged(_ value: DragGesture.Value) {
        guard viewModel.isShowViewer else { return }
        
        // Смещение по Y для закрытия сторис
        let offsetY = value.translation.height
        
        // Жест перелистывания сторис
        var offsetX: CGFloat = viewModel.itemWidth
        if value.translation.width > 0 {
            offsetX = min(offsetX, value.translation.width)
        } else {
            offsetX = max(-offsetX, value.translation.width)
        }
        
        // Если есть смещение по Y, обрабатываем его
        if viewModel.gestorStatus != .hLock,
           offsetY > viewModel.inaccuracy
        {
            
            if offsetY > viewModel.minOffsetForClose {
                closeViewer()
            }
            
            viewModel.dragOffsetY = offsetY
            viewModel.gestorStatus = .vLock
            
            return
        }
        
        // Обработка свайпа
        if viewModel.gestorStatus != .vLock,
           abs(value.translation.width) > viewModel.inaccuracy
        {
            viewModel.dragOffsetX = offsetX
            viewModel.gestorStatus = .hLock
        }
    }
    
    private func dragEnded(_ value: DragGesture.Value) {
        guard viewModel.isShowViewer else { return }
        
        viewModel.dragOffsetX = .zero
        viewModel.dragOffsetY = .zero
        
        viewModel.gestorStatus = .free
        
        /// Определяет необходимый offset для смены слайда
        let dragThreshold: CGFloat = 10
        
        var activeIndex = viewModel.selection
        if value.translation.width > dragThreshold {
            activeIndex -= 1
        }
        if value.translation.width < -dragThreshold {
            activeIndex += 1
        }
        viewModel.selection = max(0, min(activeIndex, viewModel.stories.count - 1))
    }
}
