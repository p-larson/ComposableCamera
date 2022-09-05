//
//  ActionButton.swift
//  ComposableCamera
//
//  Created by Peter Larson on 9/4/22.
//

import SwiftUI

struct ActionButton: View {
    let title: String
    
    var body: some View {
        Text(title)
            .textCase(.uppercase)
            .font(.system(size: 12, weight: .semibold))
            .foregroundColor(.black)
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            .background(
                Capsule(style: .circular)
                    .foregroundColor(.white)
            )
    }
}

struct ActionButton_Previews: PreviewProvider {
    static var previews: some View {
        ActionButton(title: "Download")
    }
}
