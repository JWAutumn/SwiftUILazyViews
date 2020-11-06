//
//  AsyncButton.swift
//  LazyViews
//
//  Created by 帝云科技 on 2020/11/5.
//

import SwiftUI

struct AsyncButton<Content: View>: View {
    
    var isComplete: Bool
    let action: ()->()
    let content: Content
    
    @State private var inProgress: Bool
    
    init(isComplete: Bool, action: @escaping ()->(), @ViewBuilder label: ()->Content) {
        self.action = action
        self.isComplete = isComplete
        self.content = label()
        self._inProgress = State.init(initialValue: false)
    }
    
    var body: some View {
        Button(action: {
            if !inProgress { action() }
            withAnimation(Animation.easeInOut(duration: 0.4)) {
                inProgress = true
            }

        }, label: {
            VStack(alignment: .trailing) {
                if inProgress && !isComplete {
                    ProgressView()
                        .foregroundColor(.white)
                } else if isComplete {
                    Image(systemName: "checkmark")
                        .resizable()
                        .frame(width: 15, height: 15, alignment: .center)
                        .foregroundColor(.white)
                } else {
                    content
                }
            }
            .frame(maxWidth: isComplete || inProgress ? 50 : .infinity, maxHeight: isComplete  || inProgress ? 50 : nil, alignment: .center)
            .padding(.vertical, isComplete  || inProgress ? 0 : 12)
            .foregroundColor(.white)
            .background(Color.green)
            .cornerRadius(isComplete || inProgress ? 25 : 8)
            .font(Font.body.weight(.semibold))
            .padding(.all, 20)
        })
    }
}

struct SubmitButton_Test: View {
    
    @State var complete: Bool = false
    @State var inProgress: Bool = false
    
    var body: some View {
        AsyncButton(isComplete: complete, action: {
            inProgress = true
            // Start Async Task (Download, Submit, etc)
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                withAnimation {
                    complete = true
                }
            }
        }) {
            Text(complete || inProgress ? "" : "Submit")
        }
    }
}

struct AsyncButton_Previews: PreviewProvider {
    static var previews: some View {
        SubmitButton_Test()
    }
}


