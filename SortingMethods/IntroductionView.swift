//
//  IntroductionView.swift
//  SortingMethods
//
//  Created by Hung-Chun Tsai on 2021-06-02.
//

import SwiftUI

struct IntroductionView: View {
    var body: some View {
        Webview(url: URL(string: "https://google.com")!)
    }
}

struct IntroductionView_Previews: PreviewProvider {
    static var previews: some View {
        IntroductionView()
    }
}
