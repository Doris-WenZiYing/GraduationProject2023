//
//  RootView.swift
//  GraduationProject2023
//
//  Created by Doris Wen on 2024/2/5.
//

import SwiftUI

struct RootView: View {

    @State var selectedTab = "Home"
    @StateObject var vm = CameraViewModel()

    var body: some View {
        TabView(selection: $selectedTab) {
            ContentView()
                .tag("Content")
                .tabItem {
                    Image(systemName: "house")
                    Text("Home")
                }

            ScanView(viewModel: vm)
                .tag("Camera")
                .tabItem {
                    Image(systemName: "camera")
                    Text("Scan")
                }
        }
    }
}

#Preview {
    RootView()
}
