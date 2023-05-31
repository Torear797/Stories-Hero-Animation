//
//  StoriesViewerViewModel.swift
//  Stories Hero Animation
//
//  Created by Torear797 on 17.04.2023.
//

import Foundation

struct Story: Identifiable, Hashable {
    let id = UUID()
    let title: String
    let image: URL
    let index: Int
}

final class StoriesViewerViewModel: ObservableObject {
    
    /// Индекс текущего элемента
    @Published var selection: Int = 0
    
    /// Offset по X
    @Published var dragOffsetX: CGFloat = .zero
    
    /// Offset по Y
    @Published var dragOffsetY: CGFloat = .zero
    
    @Published var isShowViewer = false
    
    @Published var stories: [Story] = []
    
    /// Минимальный scale при свайпе
    private let minScaling = 0.9
    
    /// Минимальная прозрачность при свайпе
    private let minOpacity = 0.3
    
    /// Если началось действие (свайп влево/вправо или вверх/вниз
    /// Необходимо заблокирвоать жест
    var gestorStatus: GestorStatus = .free
    
    enum GestorStatus {
        case hLock, vLock, free
    }
    
    /// Минимальное смещение по Y, для закрытия Viewer-а
    let minOffsetForClose: CGFloat = 150
    
    let inaccuracy: CGFloat = 50
    
    /// Размер view.
    var viewSize: CGSize = .zero
    
    /// Ширина элемента
    var itemWidth: CGFloat {
        viewSize.width
    }
    
    /// Высота элемента
    var itemHeight: CGFloat {
        viewSize.height
    }
    
    func itemScaling(_ item: Story) -> CGFloat {
        guard selection < stories.count else { return 1 }
        
        if dragOffsetX == 0 {
            return item.index < selection ? minScaling : 1
        }
        
        // Если < 0 , то свайпаем вправо
        if dragOffsetX < 0  {
            if item.index == selection {
                return 1 + (dragOffsetX / viewSize.width) * 0.05
            }
            
            return 1
        } else {
            if selection == item.index {
                return 1
            }
            
            if item.index < selection  {
               return minScaling + (dragOffsetX / viewSize.width) * 0.05
           }
            
            return 1
        }
    }
    
    func itemOffset(_ item: Story) -> CGFloat {
        
        if dragOffsetX < 0  {
            if selection != stories.count - 1, item == stories[selection + 1] {
                return dragOffsetX * 0.8
            }
        } else {
            if selection != 0, item == stories[selection] {
                return dragOffsetX * 0.8
            }
            
            if selection > 0, item == stories[selection - 1] {
                return itemWidth
            }
        }
        
        return 0
    }
    
    func itemOpacity(_ item: Story) -> CGFloat {
        
        // если в данный момент происходит свайп закрытия, то скрываем
        // все сторис кроме текущего 
        if dragOffsetY > inaccuracy, item.index != selection {
            return 0
        }
        
        if dragOffsetX == 0 {
            return item.index != selection ? 0 : 1
        }
        
        if dragOffsetX < 0, item.index == selection  {
            return 1 + (dragOffsetX / viewSize.width) * 0.6
        } else if selection > 0, item.index == selection - 1 {
            return minOpacity + (dragOffsetX / viewSize.width) * 0.6
        }
        
        return 1
    }
    
    // MARK: - Offset Method
    
    var offset: CGFloat {
        -(CGFloat(selection) * itemWidth)
    }
    
    // MARK: Show / Close Stories Viewer
    
    /// Определяет Scale всего viewer-а
    /// - Returns: scale от 0 до 1
    func viewerScaling() -> CGFloat {
        guard dragOffsetY > inaccuracy else { return 1 }
        
        return 1 - ((dragOffsetY - inaccuracy) / viewSize.height) * 0.5
    }
    
    /// Подгатавливает данные для viewer-a
    /// - Parameters:
    ///   - stories: stories
    ///   - selectedIndex: selectedIndex
    func prepareViewer(stories: [Story], selectedIndex: Int) {
        resetViewer()
        self.stories = stories
        self.selection = selectedIndex
    }

    func showViewer() {
        isShowViewer = true
    }
    
    /// Закрывает viewer
    func closeViewer() {
        isShowViewer = false
    }
    
    /// Сбрасывает данные viewer-a
    private func resetViewer() {
        stories = []
        dragOffsetX = .zero
        dragOffsetY = .zero
        gestorStatus = .free
    }
    
}
