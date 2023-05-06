//
//  NavigationPush.swift
//  Sandbox 2
//
//  Created by Turner Hamilton on 5/5/23.
//

import Foundation
import SwiftUI

struct NavigationPushButton<Label: View, Destination: View>: ViewModifier {
    let destination: Destination
    let label: () -> Label
    
    @State private var isActive: Bool = false
    
    func body(content: Content) -> some View {
        content
            .overlay(
                Button(action: {
                    isActive = true
                }, label: {
                    label()
                })
                .hidden()
            )
            .background(
                NavigationLink(destination: destination, isActive: $isActive) {
                    EmptyView()
                }
                .hidden()
            )
    }
}

extension View {
    func navigationPush<Label: View, Destination: View>(destination: Destination, @ViewBuilder label: @escaping () -> Label) -> some View {
        modifier(NavigationPushButton(destination: destination, label: label))
    }
}
