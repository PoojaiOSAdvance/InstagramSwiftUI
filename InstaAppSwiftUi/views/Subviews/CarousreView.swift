//
//  CarousreView.swift
//  InstaAppSwiftUi
//
//  Created by Pooja Raghuwanshi on 28/03/23.
//

import SwiftUI

struct CarousreView: View {
    @State var selection : Int = 0
    @State var timerAdded : Bool = false
    @ObservedObject var postArrayObj  :PostArrayObject

    var maxCount = 6
    var body: some View {
        TabView(selection: $selection ,content: {
            
            ForEach(0..<maxCount,id: \.self) { index in
              
                PostView(post: postArrayObj.dataArray[index], addHeartAnimationToView: false, showHeaderAndFooter: false,isAnimationaTabView: true).tag(index)
            }

        })
        .tabViewStyle(PageTabViewStyle())
        .frame(height: 300)
        .animation(.default)
        .onAppear(perform:{
            if !timerAdded{
                addTimer()
            }
        })
    }
    //MARK: FUNCTIONS
    func addTimer(){
     
        timerAdded = true
        
        let timer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { timer in
       
            if postArrayObj.dataArray.count != 0{
               
                if selection == (maxCount - 1) {
                    selection = 1
                }
                else{
                    selection += 1
                }
            }
        }
        timer.fire()
    }
}

struct CarousreView_Previews: PreviewProvider {
    static var previews: some View {
        CarousreView(postArrayObj: PostArrayObject(shuffled: false)).previewLayout(.sizeThatFits)

    }
}
