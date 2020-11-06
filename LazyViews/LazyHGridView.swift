//
//  LazyHGridView.swift
//  LazyViews
//
//  Created by 帝云科技 on 2020/11/5.
//

import SwiftUI

struct LazyHGridView: View {
    var body: some View {
        ScrollView {
            LazyVStack {
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHGrid(rows: [GridItem(.flexible())]) {
                        cells()
                            .frame(width: 100)
                    }
                }
                .frame(height: 100)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHGrid(rows: [GridItem(.flexible()), GridItem(.flexible())]) {
                        cells()
                            .frame(width: 150)
                    }
                }
                .frame(height: 200)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHGrid(rows: [GridItem(.flexible()), GridItem(.fixed(40))]) {
                        cells()
                            .frame(width: 200)
                    }
                }
                .frame(height: 200)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHGrid(rows: [GridItem(.flexible())]) {
                        cells()
                            .frame(width: 250)
                    }
                }
                .frame(height: 150)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHGrid(rows: [GridItem(.flexible())]) {
                        cells()
                            .frame(width: 50)
                    }
                }
                .frame(height: 150)
            }
            .padding(.horizontal)
        }
    }
    
    private func cells() -> some View {
        ForEach(0...40, id: \.self) { _ in
            Color.random
                .cornerRadius(10)
        }
    }
}

struct LazyHGridView_Previews: PreviewProvider {
    static var previews: some View {
        LazyHGridView()
    }
}
