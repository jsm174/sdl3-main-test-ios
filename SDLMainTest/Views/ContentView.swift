//
//  ContentView.swift
//  SDLMainTest
//
//  Created by Jason Millard on 7/3/25.
//

import SwiftUI

struct ContentView: View {
    let options = [
        "Option 1: Settings",
        "Option 2: Profile",
        "Option 3: Help",
        "Option 4: About",
        "Option 5: Exit"
    ]
    
    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading, spacing: 10) {
                    Text("Hello, World!")
                        .font(.title)
                        .padding(8)
                        .background(Color.black.opacity(0.7))
                        .foregroundColor(.white)
                        .cornerRadius(8)
                    
                    ForEach(options, id: \.self) { option in
                        Button(action: {
                            print("Selected: \(option)")
                        }) {
                            Text(option)
                                .padding(8)
                                .background(Color.black.opacity(0.6))
                                .foregroundColor(.white)
                                .cornerRadius(5)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                    
                    Button("Back to SDL View") {
                        // This view is deprecated - using new RootAppView architecture
                        print("Old ContentView - use RootAppView instead")
                    }
                    .padding(8)
                    .background(Color.blue.opacity(0.8))
                    .foregroundColor(.white)
                    .cornerRadius(8)
                }
                .padding()
                
                Spacer()
            }
            
            Spacer()
        }
    }
}

#Preview {
    ContentView()
}
