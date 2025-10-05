import SwiftUI

struct TutorialView : View {
    @AppStorage("tutorialCompleted") var tutorialCompleted = false
    @Environment(\.dismiss) private var dismiss
    @State private var currentPage = 0
    @State private var pagesCount = 5
    @State private var showSkipButton = true
    @State private var showDoneButton = false
    
    
    
    var body: some View {
        NavigationStack {
            VStack {
                TabView(selection: $currentPage) {
                    
                    TutorialPage(title: "Welcome to Oardio", description: "Use your QardioARM Blood Pressure Monitor without their servers.", imageName: "fuelStation").tag(0)
                    SetUpHealthKitView().tag(1)
                    TutorialPage(title: "App Walkthrough", description: "This is your blood pressure reading app. Connect your QardioArm Blood Pressure Monitor by using the connect on the bottom left if it doesnt show up.", imageName: "ConnectToQardio").tag(2)
                    TutorialPage(title: "App Walkthrough", description: "Use the Guest Mode toggle to take a reading without saving it to Apple Health.", imageName: "GuestMode").tag(3)
                    TutorialPage(title: "App Walkthrough", description: "Tap Get Reading to request a blood pressure reading.", imageName: "GetReading").tag(4)
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                HStack {
                    if showSkipButton {
                        Button("Skip") {
                            tutorialCompleted.toggle()
                        }
                        .padding()
                    }
                    
                    Spacer()
                    
                    if currentPage < pagesCount - 1 {
                        Button("Next") {
                            currentPage += 1
                        }
                        .padding()
                    } else {
                        Button("Done") {
                            tutorialCompleted = true
                            dismiss()
                        }
                        .padding()
                    }
                }
            }
            .padding()
        }
    }
}

#Preview {
    TutorialView()
}
