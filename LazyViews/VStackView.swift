//
//  VStackView.swift
//  LazyViews
//
//  Created by 帝云科技 on 2020/11/5.
//

import SwiftUI

struct VStackView: View {
    var body: some View {
        
        HStack {
            ScrollView {
                LazyVStack {
                    ForEach(1...50, id: \.self) { count in
                        VStack {
                            Text("Count \(count)")
                            Divider().padding(.leading)
                        }
                    }
                }
            }
            .background(Color.green)
            
            List {
                ForEach(1...50, id: \.self) { count in
                    Text("Count \(count)")
                }
                .listRowBackground(Color.clear)
            }
            .background(Color.blue)
            .onAppear {
                UITableView.appearance().backgroundColor = .clear
                UITableViewCell.appearance().backgroundColor = .clear
            }
        }
        .edgesIgnoringSafeArea(.all)
    }
}

struct VStackView_Previews: PreviewProvider {
    static var previews: some View {
        VStackView()
    }
}
