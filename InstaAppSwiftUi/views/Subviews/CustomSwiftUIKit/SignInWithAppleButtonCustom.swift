//
//  SignInWithAppleButtonCustom.swift
//  InstaAppSwiftUi
//
//  Created by Pooja Raghuwanshi on 30/03/23.
//

import Foundation
import SwiftUI
import AuthenticationServices

struct SignInWithAppleButtonCustom : UIViewRepresentable{
    
    func makeUIView(context: Context) -> ASAuthorizationAppleIDButton {
        return ASAuthorizationAppleIDButton(authorizationButtonType: .default, authorizationButtonStyle: .black)
    }
    func updateUIView(_ uiView: ASAuthorizationAppleIDButton, context: Context) {
        print("")
    }
}
