//
//  SignupView.swift
//  InstaAppSwiftUi
//
//  Created by Pooja Raghuwanshi on 30/03/23.
//

import SwiftUI

struct SignupView: View {
    @State var showOnboarding : Bool = false
    var body: some View {
        VStack(alignment: .center,spacing: 20, content: {
            Spacer()
            Image(String.logoTransparent)
                .resizable().scaledToFit()
                .frame(width: 100,height: 100,alignment: .center)
            Text("You are not signed in!🥹")
                .font(.largeTitle)
                .fontWeight(.bold)
                .lineLimit(1)
                .minimumScaleFactor(0.5)
                .foregroundColor(Color.MyTheme.purpleColor)
            Text("Click the button below to create an account and join the fun!")
                .font(.headline)
                .fontWeight(.medium)
                .multilineTextAlignment(.center)
                .foregroundColor(Color.MyTheme.purpleColor)
                
            Button(action: {
                showOnboarding.toggle()
                
            }, label: {
                Text("Sign in / Sign up".uppercased())
                    .font(.headline)
                    .fontWeight(.bold)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .frame(height: 60)
                    .background(Color.MyTheme.purpleColor)
                    .cornerRadius(12)
                    .shadow(radius: 12)
            })
            .accentColor(Color.MyTheme.yellowColor)
         
            Spacer()
            Spacer()

        }).padding(.all,40)
            .background(Color.MyTheme.yellowColor)
            .edgesIgnoringSafeArea(.all)
            .fullScreenCover(isPresented: $showOnboarding, content:{
                OnboardingView()
            })
    }
}

struct SignupView_Previews: PreviewProvider {
    static var previews: some View {
        SignupView()
            .colorScheme(.dark)
    }
}
