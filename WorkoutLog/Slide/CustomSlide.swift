//
//  CustomSlide.swift
//  WorkoutLog
//
//  Created by Kristian Kullmann on 22.03.20.
//  Copyright © 2020 Kristian Kullmann. All rights reserved.
//

import SwiftUI

struct CustomSlide: View {
    @State var totalClicked: Int = 0
    
    var body: some View {
        VStack {
            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            Button(action: {self.totalClicked = self.totalClicked + 1}) {
            Text("Increment Total")
            }
        }

    }
}

struct CustomSlide_Previews: PreviewProvider {
    static var previews: some View {
        CustomSlide()
    }
}
