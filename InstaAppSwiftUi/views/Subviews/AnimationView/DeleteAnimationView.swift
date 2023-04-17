//
//  LikeAnimationView.swift
//  InstaAppSwiftUi
//
//  Created by Pooja Raghuwanshi on 31/03/23.
//

import SwiftUI

struct DeleteAnimationView: View {
    @Binding var animate : Bool
    var body: some View {
        ZStack{
            Image(systemName: "trash.circle.fill")
                .foregroundColor(.red.opacity(0.3))
                .font(.system(size: 200))
                .opacity(animate ? 1.0 : 0.0)
                .scaleEffect(animate ? 1.0 : 0.3)
            Text("Comment deleted").foregroundColor(.red).font(.caption)
        }
        .animation(Animation.easeInOut(duration: 0.5))
    }
}

struct DeleteAnimationView_Previews: PreviewProvider {
    @State static var  animate : Bool = false
    @State static var  dissLike : Bool = false
    static var previews: some View {
        LikeAnimationView(animate: $animate, dissLike: $dissLike)
            .previewLayout(.sizeThatFits)
    }
}
