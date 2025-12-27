import SwiftUI

// Custom styled wrapper around a SwiftUI `Form`
struct AForm<Content: View>: View {
    let content: Content
    @AppStorage("themes") var themeSelect = "Default"
    @Environment(\.colorScheme) var colorScheme
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        if themeSelect == "Default"{
            if colorScheme == .light{
                Form {
                    content
                }
                .background(Color(hex: "f2f2f7"))
                .scrollContentBackground(.hidden)
            }else{
                Form {
                    content
                }
                .scrollContentBackground(.hidden)
            }
        }else{
            Form {
                content
            }
            .background(
                .linearGradient(
                    colors: getTheme(themeSelect).mainColor,
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            .scrollContentBackground(.hidden)
        }
    }
}





