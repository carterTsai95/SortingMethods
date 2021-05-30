//
//  ContentView.swift
//  SortingMethods
//
//  Created by Hung-Chun Tsai on 2021-05-29.
//

import SwiftUI

struct ContentView: View {
    
    @State var numOfObjects: Double = 200
    let maxNumOfObjects: Double = 800
    @State var isSorting = false
    @State var rectsData = [RectData]()
    
    @State var sortingSelection: SortType = BubbleSort()
        
    @State var swapDuration: Double = 0
    var isSorted: Bool {
        for i in 1 ..< rectsData.count {
            if rectsData[i] < rectsData[i-1] {
                return false
            }
        }
        return true
    }
    
    
    let sortingTypes: [SortType] = [
        BubbleSort(),
//        SimpleSelectionSort(),
        InsertSort(),
        ShellSort(),
//        HeapSort(),
//        MergingSort(),
//        QuickSort()
    ]
    
    let bgColor = Color(hue: 0.277, saturation: 0.413, brightness: 0.875)
    let accentColor = Color(hue: 0.281, saturation: 0.605, brightness: 0.655)
    
    var body: some View {
        VStack(spacing: 0) {
            GeometryReader { geo in
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(minimum: 0.001), spacing: 0), count: rectsData.count), alignment: .center, spacing: 0) {
                    ForEach(rectsData) { data in
                        HStack(spacing: 0) {
                            Rectangle()
                                .frame(height: geo.size.height * data.value)
                                .foregroundColor(Color(hue: Double(data.value), saturation: 1, brightness: 1))
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
                    }
                    .frame(height: geo.size.height)
                    .animation(Animation.easeInOut(duration: 0.1))
                }
            }
            
            ZStack {
                controlPanelView
            }
            
        }
        .onAppear() {
            generateRects()
        }
    }
    
    func generateRects() {
        isSorting = false
        rectsData.removeAll()
        for _ in 0 ..< Int(numOfObjects) {
            let height: CGFloat = CGFloat.random(in: 0 ... 1)
            rectsData.append(RectData(height: height))
        }
    }
    
    
    /// MARK: -  ControlPanel
    
    var controlPanelView: some View {
        VStack(spacing: 0) {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(sortingTypes, id: \.name, content: getButton)
                }
                .padding(.horizontal)
            }
            
            Spacer().frame(height: 30)
            
            VStack(spacing: 20) {
                VStack(spacing: 0) {
                    Text("Items: \(Int(numOfObjects))")
                        .bold()
                    Slider(value: Binding(get: {
                        numOfObjects
                    }, set: { value in
                        numOfObjects = Double(Int(value))
                        generateRects()
                    }), in: 5 ... maxNumOfObjects)
                    .accentColor(accentColor)
                }
                
//                VStack(spacing: 0) {
//                    Text("Swap Duration")
//                        .bold()
//                    Slider(value: $swapDuration, in: 0 ... 0.5)
//                        .accentColor(accentColor)
//                }
                
                HStack {
                    Button {
                        if isSorting {
                            stopButtonPressed()
                        } else {
                            sortButtonPressed()
                        }
                    } label: {
                        Text(isSorting ? "Stop" : "Sort")
                            .bold()
                            .padding()
                            .font(.system(size: 20))
                            .frame(maxWidth: .infinity)
                            .foregroundColor(.white)
                            .background(isSorting ? Color(.red).opacity(0.7) : accentColor)
                            .cornerRadius(10)
                    }
                    
                    Button {
                        generateRects()
                    } label: {
                        Image(systemName: "arrow.clockwise")
                            .font(.system(size: 20, weight: .bold))
                            .padding()
                            .foregroundColor(.white)
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                }
                .padding(.top, 16)
            }
            .padding(.horizontal)
        }
        .padding(.top, 30)
        .padding(.bottom, 0)
        .background(
            RoundedRectangle(cornerRadius: 13)
                .foregroundColor(.white)
                .shadow(color: Color.black.opacity(0.1), radius: 5, y: -10)
                .ignoresSafeArea(.all)
        )
        
    }
    
    func getButton(sortType: SortType) -> some View {
        Button {
            sortingSelection = sortType
        } label: {
            Text(sortType.name)
                .bold()
                .padding()
                .foregroundColor(sortType.name == sortingSelection.name ? .white : Color.black.opacity(0.6))
                .background(sortType.name == sortingSelection.name ? accentColor : accentColor.opacity(0.25))
                .cornerRadius(10)
        }
    }

    func sortButtonPressed() {
        if isSorted {
            generateRects()
        }
        sort()
    }
    
    func stopButtonPressed() {
        isSorting = false
    }
    
    func sort() {
        isSorting = true
        let swapsArr = sortingSelection.sort(items: rectsData)
        displaySwaps(swapsArray: swapsArr)
    }
    
    func displaySwaps(swapsArray: [SwapData]) {
        var tmpSwapsArray = swapsArray
        if let swapData = swapsArray.first {
            DispatchQueue.main.asyncAfter(deadline: .now() + swapDuration) {
                if isSorting == false { return }
                rectsData.swapAt(swapData.fromIndex, swapData.toIndex)
                tmpSwapsArray.removeFirst()
                displaySwaps(swapsArray: tmpSwapsArray)
            }
        }
        else {
            isSorting = false
        }
    }
    
    
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
