//
//  LazyVGridView.swift
//  LazyViews
//
//  Created by 帝云科技 on 2020/11/5.
//

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

struct LazyVGridView_Previews: PreviewProvider {
    static var previews: some View {
        LazyVGridView()
    }
}


extension Color {
    static var random: Color {
        Color(red: Double(arc4random_uniform(256)) / 255.0,
              green: Double(arc4random_uniform(256)) / 255.0,
              blue: Double(arc4random_uniform(256)) / 255.0)
    }
}
