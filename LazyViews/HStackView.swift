//
//  HStackView.swift
//  LazyViews
//
//  Created by 帝云科技 on 2020/11/5.
//

import SwiftUI

struct HStackView: View {
    
    var body: some View {
        VStack {
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

struct HStackView_Previews: PreviewProvider {
    static var previews: some View {
        HStackView()
    }
}
