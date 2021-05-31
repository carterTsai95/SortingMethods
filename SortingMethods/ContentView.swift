//
//  ContentView.swift
//  SortingMethods
//
//  Created by Hung-Chun Tsai on 2021-05-29.
//

import SwiftUI

struct ContentView: View {
    
    @State var rectsData = [RectData]()
    @State var sortingSelection: SortType = BubbleSort()
    @State var swapDuration: Double = 0
    @State var numOfObjects: Double = 100
    @State var isSorting = false
    
    let maxNumOfObjects: Double = 800
    
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
        SimpleSelectionSort(),
        InsertSort(),
        ShellSort(),
        HeapSort(),
        QuickSort()
    ]
    
    
    var body: some View {
        
        VStack(alignment: .leading) {
                Text("Time Complexity: \(sortingSelection.timeComplexity)")
                    .bold()
                    .padding()
                
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
        
        VStack(spacing: 10) {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(sortingTypes, id: \.name, content: sortTypeButton)
                }
                .padding(.horizontal)
            }
            
            
            
            HStack(spacing: 20) {
                VStack(spacing: 0) {
                    Text("Items: \(Int(numOfObjects))")
                    Slider(value: Binding(get: {
                        numOfObjects
                    }, set: { value in
                        numOfObjects = Double(Int(value))
                        generateRects()
                    }), in: 5 ... maxNumOfObjects)
                    .accentColor(myAccentColor)
                }
                
                VStack(spacing: 0) {
                    Text("Swap Duration")
                    Slider(value: $swapDuration, in: 0 ... 0.5)
                        .accentColor(myAccentColor)
                }
                
                
            }
            .padding(.horizontal)
            HStack {
                Button {
                    if isSorting {
                        stopButtonPressed()
                    } else {
                        sortButtonPressed()
                    }
                } label: {
                    Text(isSorting ? "Stop" : "Sort")
                        .frame(width: 35, height: 35, alignment: .center)
                         .padding()
                         .overlay(
                             Circle()
                             .stroke(Color.orange, lineWidth: 4)
                             .padding(6)
                         )
                        .background(isSorting ? Color(.red).opacity(0.7) : myAccentColor
)
                        
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
        .padding(.top, 10)
        .padding(.bottom, 0)
        
        
    }
    
    func sortTypeButton(sortType: SortType) -> some View {
        Button {
            generateRects()
            sortingSelection = sortType
        } label: {
            Text(sortType.name)
                .padding(.vertical, 12)
                .padding(.horizontal, 15)
                .foregroundColor(sortType.name == sortingSelection.name ? .white : Color.black.opacity(0.6))
                .background(sortType.name == sortingSelection.name ? myAccentColor : myAccentColor.opacity(0.25))
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
