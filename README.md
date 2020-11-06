SwiftUI 2 新增四个懒加载的 View：
`LazyHStack`、`LazyVStack`、`LazyHGrid`、`LazyVGrid`
来了解下他们的使用方式

## LazyStack
`LazyHStack`、 `LazyVStack` 跟 `HStack`、`VStack` 基本类似，前者相当于懒加载版的后者。下面详细对比一下

### LazyHStack

**初始化：**

```swift
public init(alignment: VerticalAlignment = .center,
            spacing: CGFloat? = nil,
            pinnedViews: PinnedScrollableViews = .init(),
            @ViewBuilder content: () -> Content)
```

对比一下 `HStack`：

```swift
public init(alignment: VerticalAlignment = .center,
            spacing: CGFloat? = nil,
            @ViewBuilder content: () -> Content)
```

从初始化上可以看的出来，`LazyHStack` 比 `HStack` 多了一个参数 `PinnedScrollableViews`。
我们点进去看下：

```swift
public struct PinnedScrollableViews : OptionSet {
    /// ...

    /// The header view of each `Section` will be pinned.
    public static let sectionHeaders: PinnedScrollableViews

    /// The footer view of each `Section` will be pinned.
    public static let sectionFooters: PinnedScrollableViews

    /// ...
}
```

看得出来，`PinnedScrollableViews` 这个结构体是为了固定 header 和 footer 使用的。这意味着 `LazyHStack` 比较适用于 `ScrollView` 内。我们来测试一下：
```swift
import SwiftUI

struct HStackView: View {
    
    var body: some View {
        VStack {
            ScrollView(.horizontal) {
                LazyHStack(pinnedViews: [.sectionHeaders, .sectionFooters]) {
                    Section(header: Color.red, footer: Color.yellow) {
                        ForEach(1...10, id: \.self) { count in
                            Text("count \(count)")
                        }
                    }
                }
            }
        }
    }
}
```
效果：
<img src='https://ww1.sinaimg.cn/large/007xerzXly1gkffds0x4zg30gs0y2nij.gif' width='50%'>

类似于 `UITableView.Style` 的 `plain` 属性。

不过，`LazyHStack` 相对于 `HStack` 就多了这点功能？就这？
显然是不可能的，毕竟这个 `Lazy` 还没表现出来呢，往下看

**懒加载：**
延迟加载。啥时候用到了啥时候加载。优化用户体验

对比下 `LazyHStack` 和 `HStack` 在  `ScrollView` 中的效果
```swift
import SwiftUI

struct HStackView: View {
    
    var body: some View {
        VStack {
            // ScrollView + LazyHStack
            ScrollView(.horizontal) {
                LazyHStack {
                    ForEach(1...10, id: \.self) { count in
                        Text("Count \(count)")
                            .onAppear {
                                print("LazyHStack count: \(count)")
                            }
                    }
                }
            }
            .frame(height: 100)
            .background(Color.green)
            
            Spacer().frame(height: 100)
            
            // ScrollView + HStack
            ScrollView(.horizontal) {
                HStack {
                    ForEach(1...10, id: \.self) { count in
                        Text("Count \(count)")
                            .onAppear {
                                print("HStack count: \(count)")
                            }
                            .frame(height: 100)
                    }
                }
            }
            .frame(height: 100)
            .background(Color.blue)
        }
    }
}
```

看下运行结果 ↓

![`LazyHStack` 和 `HStack` 的区别](https://ww1.sinaimg.cn/large/007xerzXly1gkffdqeoyrg32641e6b2j.gif)

果然，懒加载，永远滴神 ~
通过懒加载，不需要初始化全部子控件。在数据较多的时候，是个很好地体验

### LazyVStack
同 `LazyHStack` 类似，只是横向和纵向排列的区别。
在 iOS 14 中，几乎可以用 `ScrollView + LazyVStack` 替代 `List` 来实现列表的高度自定义。

![`ScrollView` + `LazyVStack` 与 `List`](https://ww1.sinaimg.cn/large/007xerzXly1gkffbmjbxej325u1e8gq8.jpg)



## LazyGrid

iOS 13 中，SwiftUI 中并没有关于网格的组件。
当然这并不能难住优秀的开发者们，众多好用的轮子应运而生，比如：[QGrid](https://github.com/Q-Mobile/QGrid)、[WaterfallGrid](https://github.com/paololeonardi/WaterfallGrid)、[GridView](https://github.com/KyoheiG3/GridView) 等

随着 iOS 14 的发布，SwiftUI 2 也带来了新的网格组件：`LazyHGrid` 和 `LazyVGrid`，给我们提供了更多的使用选择

### GridItem
无论是使用 `LazyHGrid` 还是 `LazyVGrid`，都会用到 `GridItem`，我们先来这个 `GridItem` 是干什么用的：

文档描述：
> A description of a single grid item, such as a row or a column.
 You use `GridItem` instances to configure the layout of items in ``LazyHGrid`` and ``LazyVGrid`` views. Each grid item specifies layou properties like spacing and alignment, which the grid view uses to size and position all items in a given column or row.

一句话描述就是：配置 `LazyHGrid` 或 `LazyVGrid` 中每个网格的布局，包括大小、间距、对齐方式。
间距和对齐方式就不用多描述了。尺寸需要特别强调一下：

```swift
public enum Size {

    /// A single item with the specified fixed size.
    case fixed(CGFloat)

    /// A single flexible item.
    ///
    /// The size of this item is the size of the grid with spacing and
    /// inflexible items removed, divided by the number of flexible items,
    /// clamped to the provided bounds.
    case flexible(minimum: CGFloat = 10, maximum: CGFloat = .infinity)

    /// Multiple items in the space of a single flexible item.
    ///
    /// This size case places one or more items into the space assigned to
    /// a single `flexible` item, using the provided bounds and
    /// spacing to decide exactly how many items fit. This approach prefers
    /// to insert as many items of the `minimum` size as possible
    /// but lets them increase to the `maximum` size.
    case adaptive(minimum: CGFloat, maximum: CGFloat = .infinity)
}
```
> 根据自己的理解，简单描述下：
> `fixed`：固定尺寸。
> 
> `flexible`：灵活自适应尺寸。根据父类 `Grid` 的尺寸、每行（列）的数量、间距以及同行（列）的其他 `Item` 的尺寸来灵活分配自己的尺寸。可以设定尺寸的最值。
> 
> `adaptive`：尽肯能多显示的自适应。根据父类 `Grid` 的尺寸、间距以及同行（列）的其他 `Item` 的尺寸来展示出最多的自身最小值的`Item`
>
> 有些不太描述。还是通过代码和效果图来理解吧

### LazyVGrid

**初始化：**
```swift
public init(columns: [GridItem],
            alignment: HorizontalAlignment = .center,
            spacing: CGFloat? = nil,
            pinnedViews: PinnedScrollableViews = .init(),
            @ViewBuilder content: () -> Content)
```
比 `LazyVStack` 多了一个属性：`columns: [GridItem]`，这个就是配置 `Item` 的属性了。

通过下面的代码：

```swift
import SwiftUI

let natures = ["flame", "bolt", "bolt.slash", "ant", "hare", "tortoise"]

enum SizeStyle: String, CaseIterable, Identifiable {
    
    case fixed, flexible, adaptive
    
    var id: String {
        self.rawValue
    }
    
    var tag: Int {
        switch self {
        case .fixed: return 0
        case .flexible: return 1
        case .adaptive: return 2
        }
    }
    
    var columns: [GridItem] {
        switch self {
        case .fixed:
            return Array(repeating: .init(.fixed(60)), count: 4)
        case .flexible:
            return Array(repeating: .init(.flexible()), count: 3)
        case .adaptive:
            return [.init(.adaptive(minimum: 50))]
        }
    }
}

struct LazyVGridView: View {
    
    @State var selection = SizeStyle.fixed
    
    var body: some View {
        VStack {
            segmentView()
            ScrollView {
                LazyVGrid(columns: selection.columns, spacing: 10) {
                    ForEach(0...100, id: \.self) {
                        image(natures[$0 % natures.count])
                    }
                }
            }
        }
    }
    
    private func segmentView() -> some View {
        Picker("GridItem", selection: $selection) {
            ForEach(SizeStyle.allCases) {
                Text($0.rawValue).tag($0)
            }
        }
        .pickerStyle(SegmentedPickerStyle())
    }
    
    private func image(_ name: String) -> some View {
        let color = Color.random
        return Image(systemName: name)
            .font(.title)
            .frame(maxWidth: .infinity, minHeight: 100, maxHeight: .infinity)
            .foregroundColor(color)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(color)
            )
    }
}
```
生成预览效果图：
![效果图](https://ww1.sinaimg.cn/large/007xerzXly1gkffzbqcotj32p81vowr1.jpg)

针对 `GridItem` 配置的核心代码如下：
```swift
var columns: [GridItem] {
    switch self {
    case .fixed:
        return Array(repeating: .init(.fixed(60)), count: 4)
    case .flexible:
        return Array(repeating: .init(.flexible()), count: 3)
    case .adaptive:
        return [.init(.adaptive(minimum: 50))]
    }
}
```
`fixed`：固定 `Item` 宽度为 60，每行数量 4 个；
`flexible`：自适应每行数量 3 个的宽度，当然还有间距；
`adaptive`：根据每个 `Item` 的最小值 50，自适应显示每行最多的 `Item`。

上面只是最基础的展示，你也可以根据需求，组合不同的 `GridItem.Size` 来实现高度定制化。

### LazyHGrid
学会用 `LazyVGrid` 之后，也就相当于会了 `LazyHGrid`，区别只是横向和纵向的问题。




## 总结
通过上面四种组件的初始化方法来看，它们都比较适用于滚动视图当中；`LazyHGrid` 与 `LazyVGrid` 更是解决了 SwiftUI 没有网格组件的痛点。虽然相较于 `UIKit` 中 `UICollectionView` 的各种定制化来说还差点火候，但是基于 SwiftUI 目前已有的组件，开发者们还是会造出非常好的轮子出来。

> 参考：
> 
> - [LazyHStack、LazyVStack、LazyHGrid、LazyVGrid-使用手册](http://keisme.cn/LazyHStack、LazyVStack、LazyHGrid、LazyVGrid-使用手册.html)
> - [Impossible Grids with SwiftUI](https://swiftui-lab.com/impossible-grids/)

