//
//  UtilityViews.swift
//  EmojiArt
//
//  Created by CS193p Instructor on 4/26/21.
//  Copyright © 2021 Stanford University. All rights reserved.
//

import SwiftUI

// 用于将RGBA色彩转换为Color预置色彩
struct ColorUtils {
    static let colorMap: [RGBAColor: Color] = [
        RGBAColor(red: 0, green: 0, blue: 0, alpha: 1): .black,
        RGBAColor(red: 0, green: 0, blue: 1, alpha: 1): .blue,
        RGBAColor(red: 0.6, green: 0.4, blue: 0.2, alpha: 1): .brown,
        RGBAColor(red: 0, green: 1, blue: 1, alpha: 1): .cyan,
        RGBAColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1): .gray,
        RGBAColor(red: 0, green: 1, blue: 0, alpha: 1): .green,
        RGBAColor(red: 0.294, green: 0, blue: 0.51, alpha: 1): .indigo,
        RGBAColor(red: 0.596, green: 1.00, blue: 0.596, alpha: 1): .mint,
        RGBAColor(red: 1, green: 0.647, blue: 0, alpha: 1): .orange,
        RGBAColor(red: 1.00, green: 0.753, blue: 0.796, alpha: 1): .pink,
        RGBAColor(red: 0.502, green: 0.000, blue: 0.502, alpha: 1): .purple,
        RGBAColor(red: 1, green: 0, blue: 0, alpha: 1): .red,
        RGBAColor(red: 0, green: 128, blue: 128, alpha: 1): .teal,
        RGBAColor(red: 1, green: 1, blue: 0, alpha: 1): .yellow
    ]
}

// syntactic sure to be able to pass an optional UIImage to Image
// (normally it would only take a non-optional UIImage)
// 接受可选的UIImage，如果不为空则显示，否则不显示

struct OptionalImage: View {
    var uiImage: UIImage?

    var body: some View {
        if uiImage != nil {
            Image(uiImage: uiImage!)
        }
    }
}

// syntactic sugar
// lots of times we want a simple button
// with just text or a label or a systemImage
// but we want the action it performs to be animated
// (i.e. withAnimation)
// this just makes it easy to create such a button
// and thus cleans up our code

struct AnimatedActionButton: View {
    var title: String? = nil
    var systemImage: String? = nil
    let action: () -> Void

    var body: some View {
        Button {
            withAnimation {
                action()
            }
        } label: {
            if title != nil && systemImage != nil {
                Label(title!, systemImage: systemImage!)
            } else if title != nil {
                Text(title!)
            } else if systemImage != nil {
                Image(systemName: systemImage!)
            }
        }
    }
}

// simple struct to make it easier to show configurable Alerts
// just an Identifiable struct that can create an Alert on demand
// use .alert(item: $alertToShow) { theIdentifiableAlert in ... }
// where alertToShow is a Binding<IdentifiableAlert>?
// then any time you want to show an alert
// just set alertToShow = IdentifiableAlert(id: "my alert") { Alert(title: ...) }
// of course, the string identifier has to be unique for all your different kinds of alerts

struct IdentifiableAlert: Identifiable {
    var id: String
    var alert: () -> Alert
}
