//
//  IntroductionView.swift
//  SortingMethods
//
//  Created by Hung-Chun Tsai on 2021-06-02.
//

import SwiftUI

struct IntroductionView: View {
    
    @State var webAddress: String
    @Environment(\.presentationMode) var presentation
    
    
    var body: some View {
        NavigationView {
            Webview(url: (URL(string: webAddress) ?? URL(string: "https://google.com"))! )
                .navigationBarHidden(true)
        }
        
    }
}

struct IntroductionView_Previews: PreviewProvider {
    static var previews: some View {
        IntroductionView(webAddress: "https://en.wikipedia.org/wiki/Heapsort")
    }
}
